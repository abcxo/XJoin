#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



#define SCREEN_MAX [[CommonOrientationInfo sharedInstance] screenMax]
#define SCREEN_HEIGHT [[CommonOrientationInfo sharedInstance] screenHeight]
#define SCREEN_WIDTH [[CommonOrientationInfo sharedInstance] screenWidth]
#define NAV_HEIGHT [[CommonOrientationInfo sharedInstance] getNavigationBarHeight]
#define TOOLBAR_HEIGHT NAV_HEIGHT
#define STATUS_HEIGHT [[CommonOrientationInfo sharedInstance] getStatusBarHeight]
#define TABBAR_HEIGHT [[CommonOrientationInfo sharedInstance] getTabBarHeight]
#define IS_LONG_SCREEN [[CommonOrientationInfo sharedInstance] isLongScreen]


#define VERTICAL_SCREEN_HEIGHT [[CommonOrientationInfo sharedInstance] verticalScreenHeight]
#define VERTICAL_SCREEN_WIDTH  [[CommonOrientationInfo sharedInstance] verticalScreenWidth]
#define VERTICAL_CONTROLL_HEIGHT [[CommonOrientationInfo sharedInstance] getVerticalControllerHeight]
#define VERTICAL_VIEW_HEIGHT [[CommonOrientationInfo sharedInstance] getVerticalViewHeight]
#define VERTICAL_NAV_HEIGHT [[CommonOrientationInfo sharedInstance] getVerticalNavigationBarHeight]
#define VERTICAL_STATUS_HEIGHT [[CommonOrientationInfo sharedInstance] getVerticalStatusBarHeight]
#define IS_LANDSCAPE UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)

@interface CommonOrientationInfo : NSObject
@property (nonatomic, assign) NSInteger screenWidth;
@property (nonatomic, assign) NSInteger screenHeight;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@property (nonatomic, assign) BOOL isKeyboardShown;
@property (nonatomic, assign) CGRect keyboardBeginInfo;
@property (nonatomic, assign) CGRect keyboardEndInfo;
@property (nonatomic, assign) UIInterfaceOrientation nextOrientaion;

- (UIInterfaceOrientation)getOrientation;
- (void)update;
- (BOOL)isInfoValid;
- (NSInteger)getStatusBarHeight;
- (NSInteger)getTabBarHeight;
- (NSInteger)getNavigationBarHeight;
- (NSInteger)getKeyboardHeight;
- (NSInteger)getOffsetHeight;
- (NSInteger)getDeleteHeight;
- (BOOL)isLongScreen;
- (NSInteger)screenMax;

- (NSInteger)getVerticalViewHeight;
- (NSInteger)getVerticalControllerHeight;
- (NSInteger)verticalScreenHeight;
- (NSInteger)verticalScreenWidth;
- (NSInteger)getVerticalStatusBarHeight;
- (NSInteger)getVerticalNavigationBarHeight;

@end
