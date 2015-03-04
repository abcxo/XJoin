//
//  UIButton+UIButtonVUIKit.h
//  VUIKit
//
//  Created by shadow on 14-8-11.
//  Copyright (c) 2014年 SJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UIButtonVUIKit)
- (void)setbackgroundImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholderImage;
- (void)setbackgroundImage:(UIImage *)image;
- (void)setbackgroundImage:(UIImage *)image capInsets:(UIEdgeInsets)insets;
- (void)setText:(NSString *)text;
- (void)setSizeToFitText:(NSString *)text;
- (UIImageView *)backgroundImageView;
@end
