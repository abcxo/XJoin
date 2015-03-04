//
//  UIButton+UIButtonVUIKit.m
//  VUIKit
//
//  Created by shadow on 14-8-11.
//  Copyright (c) 2014年 SJ. All rights reserved.
//

#import "UIButton+UIButtonVUIKit.h"
#import "VUIKit.h"

@implementation UIButton (UIButtonVUIKit)
- (void)setbackgroundImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholderImage {
	[self.backgroundImageView setImageWithURL:url placeholderImage:placeholderImage];
}

- (void)setbackgroundImage:(UIImage *)image {
	[self.backgroundImageView setImage:image];
}

- (void)setbackgroundImage:(UIImage *)image capInsets:(UIEdgeInsets)insets {
	UIImage *stretchableImage = nil;
	if (IOS_VERSION_LOW_6) {
		stretchableImage = [image resizableImageWithCapInsets:insets];
	}
	else {
		stretchableImage = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
	}
	[self.backgroundImageView removeFromSuperview];
	[self.backgroundImageView setImage:stretchableImage];
}

- (void)setText:(NSString *)text {
	[self setTitle:text forState:UIControlStateNormal];
	[self setTitle:text forState:UIControlStateSelected];
	[self setTitle:text forState:UIControlStateHighlighted];
	[self setTitle:text forState:UIControlStateDisabled];
}

- (void)setSizeToFitText:(NSString *)text {
	CGFloat width = [text sizeWithFont:self.titleLabel.font].width + 16;
	[self setFrameW:width];
	[self setText:text];
}

- (UIImageView *)backgroundImageView {
	UIImageView *result = (UIImageView *)[self viewWithTag:2000];
	if (!result) {
		result = [[UIImageView alloc] initWithFrame:self.bounds];
		result.tag = 2000;
		[self addSubview:result];
	}
	return result;
}

@end
