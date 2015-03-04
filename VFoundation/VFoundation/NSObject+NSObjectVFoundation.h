//
//  NSObject+VFoundation.h
//  VFoundation
//
//  Created by shadow on 14-3-11.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, NSDataVType) {
	NSDataVTypeInteger = 1,
	NSDataVTypeReal,
	NSDataVTypeText,
	NSDataVTypeBlob,
	NSDataVTypeNull,
};


@interface NSProperty : NSObject
@property (nonatomic, strong) id propertyType;
@property (nonatomic, strong) Class propertyTypeClass;
@property (nonatomic, assign) NSDataVType type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) id value;
@property (nonatomic, strong) NSString *parentClass;

@end



@protocol NSDeepCopying <NSObject>
- (id)deepCopy;
@end
@protocol NSTransformCopying <NSObject>

- (id)transformCopy:(Class)classs;

@end



/**
 *  NSObject' category in VFoundation
 */
@interface NSObject (NSObjectVFoundation) <NSCoding, NSCopying, NSMutableCopying, NSDeepCopying, NSTransformCopying>

+ (instancetype)sharedInstance;
+ (instancetype)sharedInstance:(id)obj;
/**
 *  Return isEmpty
 *
 *  @return bool
 */
- (BOOL)isEmpty;
/**
 *  It is the best replacement of isEmpty that string does not include @"",[NSNull null],and nil
 *
 *  @return bool
 */
- (BOOL)isMeaningful;
- (NSString *)toJson;
+ (id)toObject:(NSDictionary *)json;
+ (id)toObjects:(NSArray *)json;

- (NSArray *)allProperties;
- (NSProperty *)primaryProperty;
- (NSProperty *)propertyForKey:(NSString *)str;
- (NSString *)className;


+ (NSArray *)allProperties;
+ (NSProperty *)primaryProperty;
+ (NSProperty *)propertyForKey:(NSString *)str;
+ (NSString *)className;
@end


@interface NSObject (NSObjectDataType)
- (id)objectType;
- (NSDataVType)dataVType;
+ (NSString *)dataVTypeToString:(NSDataVType)type;

@end
