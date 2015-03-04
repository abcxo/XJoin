//
//  CustomImagePickerController.h
//  MeiJiaLove
//
//  Created by Wu.weibin on 13-7-9.
//  Copyright (c) 2013年 Wu.weibin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomImagePickerControllerDelegate;

@interface CustomImagePickerController : UIImagePickerController
	<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
	id <CustomImagePickerControllerDelegate> _customDelegate;
}
@property (nonatomic) BOOL isSingle;
@property (nonatomic, assign) id <CustomImagePickerControllerDelegate> customDelegate;
@end

@protocol CustomImagePickerControllerDelegate <NSObject>
@optional
- (void)cameraPhoto:(UIImage *)image;
- (void)cancelCamera;
@required
- (void)pickedPhoto:(UIImage *)image;
@end
