//
//  ImageFilterProcessViewController.h
//  MeiJiaLove
//
//  Created by Wu.weibin on 13-7-9.
//  Copyright (c) 2013年 Wu.weibin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ImageFitlerProcessDelegate;
@interface ImageFilterProcessViewController : UIViewController <UIGestureRecognizerDelegate>
{
	UIImageView *rootImageView;
	UIScrollView *scrollerView;
	UIImage *currentImage;
	id <ImageFitlerProcessDelegate> delegate;
}
@property (nonatomic, assign) id <ImageFitlerProcessDelegate> delegate;
@property (nonatomic, retain) UIImage *currentImage;
@property (nonatomic, assign) UIImageView *currentImageView;
@property (nonatomic, assign) UILabel *currentLabel;
@end

@protocol ImageFitlerProcessDelegate <NSObject>

- (void)imageFitlerProcessDone:(UIImage *)image;
@end
