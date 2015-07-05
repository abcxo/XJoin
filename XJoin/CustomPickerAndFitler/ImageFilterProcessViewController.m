//
//  ImageFilterProcessViewController.m
//  MeiJiaLove
//
//  Created by Wu.weibin on 13-7-9.
//  Copyright (c) 2013年 Wu.weibin. All rights reserved.
//

#import "ImageFilterProcessViewController.h"
#import "ImageUtil.h"
#import "ColorMatrix.h"
#import "IphoneScreen.h"
@interface ImageFilterProcessViewController ()

@end

@implementation ImageFilterProcessViewController
@synthesize currentImage = currentImage, delegate = delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (IBAction)backView:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)fitlerDone:(id)sender {
	[delegate imageFitlerProcessDone:rootImageView.image];
	[self dismissViewControllerAnimated:YES completion: ^{
	}];
}

- (void)handleNavLeft:(id)sender {
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)handleNavRight:(id)sender {
	[self fitlerDone:sender];
}


- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = NSLocalizedString(@"選擇圖片",nil);
	self.navigationController.navigationBarHidden = NO;
	[self.view setBackgroundColor:[UIColor blackColor]];
	rootImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    rootImageView.backgroundColor=[UIColor blackColor];
	rootImageView.contentMode = UIViewContentModeScaleAspectFit;
	rootImageView.image = currentImage;
	[self.view addSubview:rootImageView];
    CGRect frame = rootImageView.frame;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7) {
        frame.origin.y=-64;
        rootImageView.frame=frame;
    }


//	UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//	[leftBtn setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
//	[leftBtn setFrame:CGRectMake(10, 80, 34, 34)];
//	[leftBtn addTarget:self action:@selector(backView:) forControlEvents:UIControlEventTouchUpInside];
//	[self.view addSubview:leftBtn];
//
//	UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//	[rightBtn setImage:[UIImage imageNamed:@"camera_btn_ok.png"] forState:UIControlStateNormal];
//	[rightBtn setFrame:CGRectMake(270, 80, 34, 34)];
//	[rightBtn addTarget:self action:@selector(fitlerDone:) forControlEvents:UIControlEventTouchUpInside];
//	[self.view addSubview:rightBtn];

	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消",nil) style:UIBarButtonItemStylePlain target:self action:@selector(handleNavLeft:)];
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成",nil) style:UIBarButtonItemStylePlain target:self action:@selector(handleNavRight:)];
        self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
	NSArray *arr = [NSArray arrayWithObjects:NSLocalizedString(@"原圖",nil), NSLocalizedString(@"LOMO",nil), NSLocalizedString(@"黑白",nil), NSLocalizedString(@"復古",nil), NSLocalizedString(@"哥特",nil), NSLocalizedString(@"銳色",nil), NSLocalizedString(@"淡雅",nil), NSLocalizedString(@"酒紅",nil), NSLocalizedString(@"青檸",nil), NSLocalizedString(@"浪漫",nil), NSLocalizedString(@"光暈",nil), NSLocalizedString(@"藍調",nil), NSLocalizedString(@"夢幻",nil), NSLocalizedString(@"夜色",nil), nil];
	scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 64 - 80, 320, 80)];
	scrollerView.backgroundColor = [UIColor clearColor];
	scrollerView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	scrollerView.showsHorizontalScrollIndicator = NO;
	scrollerView.showsVerticalScrollIndicator = NO; //关闭纵向滚动条
	scrollerView.bounces = NO;

	float x = 0;
	for (int i = 0; i < 14; i++) {
		x = 10 + 51 * i;
		UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setImageStyle:)];
		recognizer.numberOfTouchesRequired = 1;
		recognizer.numberOfTapsRequired = 1;
		recognizer.delegate = self;

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 53, 40, 23)];
		[label setBackgroundColor:[UIColor clearColor]];
		[label setText:[arr objectAtIndex:i]];
		[label setTextAlignment:NSTextAlignmentCenter];
		[label setFont:[UIFont systemFontOfSize:13.0f]];
		[label setTextColor:[UIColor whiteColor]];
		[label setUserInteractionEnabled:YES];
		[label setTag:1000 + i];
		[label addGestureRecognizer:recognizer];

		[scrollerView addSubview:label];
		[label release];

		UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 10, 40, 43)];
		[bgImageView addGestureRecognizer:recognizer];
		[bgImageView setUserInteractionEnabled:YES];
		UIImage *bgImage = [self changeImage:i imageView:nil];
		bgImageView.image = bgImage;
		bgImageView.layer.borderWidth = 0.5;
		bgImageView.layer.borderColor = [UIColor grayColor].CGColor;
		bgImageView.tag = 2000 + i;
		bgImageView.contentMode = UIViewContentModeScaleAspectFill;
		bgImageView.clipsToBounds = YES;
		[scrollerView addSubview:bgImageView];

		[bgImageView release];

		[recognizer release];
	}
	scrollerView.contentSize = CGSizeMake(x + 55, 80);
	[self.view addSubview:scrollerView];



	// Do any additional setup after loading the view.
}

- (IBAction)setImageStyle:(UITapGestureRecognizer *)sender {
	int tag = 0;
	if ([sender.view isKindOfClass:[UILabel class]]) {
		self.currentLabel.textColor = [UIColor whiteColor];
		self.currentLabel = (UILabel *)sender.view;
		self.currentLabel.textColor = [UIColor orangeColor];
		self.currentImageView.layer.borderColor = [UIColor grayColor].CGColor;
		self.currentImageView = (UIImageView *)[scrollerView viewWithTag:sender.view.tag + 1000];
		self.currentImageView.layer.borderColor = [UIColor orangeColor].CGColor;
		tag = (int)sender.view.tag - 1000;
	}
	else if ([sender.view isKindOfClass:[UIImageView class]]) {
		self.currentLabel.textColor = [UIColor whiteColor];
		self.currentLabel = (UILabel *)[scrollerView viewWithTag:sender.view.tag - 1000];
		self.currentLabel.textColor = [UIColor orangeColor];
		self.currentImageView.layer.borderColor = [UIColor grayColor].CGColor;
		self.currentImageView = (UIImageView *)sender.view;
		self.currentImageView.layer.borderColor = [UIColor orangeColor].CGColor;
		tag = (int)sender.view.tag - 2000;
	}
	UIImage *image =   [self changeImage:tag imageView:nil];
	[rootImageView setImage:image];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (UIImage *)changeImage:(int)index imageView:(UIImageView *)imageView {
	UIImage *image = nil;
	switch (index) {
		case 0:
		{
			return currentImage;
		}
		break;

		case 1:
		{
			image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_lomo];
		}
		break;

		case 2:
		{
			image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_heibai];
		}
		break;

		case 3:
		{
			image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_huajiu];
		}
		break;

		case 4:
		{
			image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_gete];
		}
		break;

		case 5:
		{
			image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_ruise];
		}
		break;

		case 6:
		{
			image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_danya];
		}
		break;

		case 7:
		{
			image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_jiuhong];
		}
		break;

		case 8:
		{
			image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_qingning];
		}
		break;

		case 9:
		{
			image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_langman];
		}
		break;

		case 10:
		{
			image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_guangyun];
		}
		break;

		case 11:
		{
			image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_landiao];
		}
		break;

		case 12:
		{
			image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_menghuan];
		}
		break;

		case 13:
		{
			image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_yese];
		}
	}
	return image;
}

- (void)dealloc {
	[super dealloc];
	scrollerView = nil;
	rootImageView = nil;
	[currentImage release], currentImage  = nil;
}

@end
