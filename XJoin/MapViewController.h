//
//  MapViewController.h
//  XJoin
//
//  Created by shadow on 14-8-26.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "XJoinDefine.h"
typedef NS_ENUM (NSUInteger, MapViewControllerType) {
	MapViewControllerTypeQuickLook,
	MapViewControllerTypeEdit,
};
@class RoundButton, LocationEntity;
@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, weak) id <BackPassViewControllerDelegate> passedDelegate;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet RoundButton *locationBtn;
@property (weak, nonatomic) IBOutlet RoundButton *layerBtn;
@property (weak, nonatomic) IBOutlet RoundButton *routeBtn;
@property (weak, nonatomic) IBOutlet RoundButton *annotationBtn;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) LocationEntity *location;
@property (nonatomic, assign) MapViewControllerType type;

@end


@interface AnnotationView : MKAnnotationView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@interface Annotation : NSObject <MKAnnotation>
@property (nonatomic, assign) MKCoordinateRegion region;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
+ (Annotation *)annotationWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title;

@end
