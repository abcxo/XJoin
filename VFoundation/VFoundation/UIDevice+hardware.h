//
//  UIDevice+hardware.h
//  QQMailApp0.9.1
//
//  Created by shadowxie on 4/9/13.
//
//



#import <UIKit/UIKit.h>

#define IFPGA_NAMESTRING                @"iFPGA"

#define IPHONE_1G_NAMESTRING            @"iPhone 1G"
#define IPHONE_3G_NAMESTRING            @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING           @"iPhone 3GS"
#define IPHONE_4_NAMESTRING             @"iPhone 4"
#define IPHONE_4S_NAMESTRING            @"iPhone 4S"
#define IPHONE_5_NAMESTRING             @"iPhone 5"
#define IPHONE_5C_NAMESTRING             @"iPhone 5C"
#define IPHONE_5S_NAMESTRING             @"iPhone 5S"
#define IPHONE_UNKNOWN_NAMESTRING       @"iPhone"

#define IPOD_1G_NAMESTRING              @"iPod touch 1G"
#define IPOD_2G_NAMESTRING              @"iPod touch 2G"
#define IPOD_3G_NAMESTRING              @"iPod touch 3G"
#define IPOD_4G_NAMESTRING              @"iPod touch 4G"
#define IPOD_5G_NAMESTRING              @"iPod touch 5G"
#define IPOD_UNKNOWN_NAMESTRING         @"iPod"

#define IPAD_1G_NAMESTRING              @"iPad 1G"
#define IPAD_2G_NAMESTRING              @"iPad 2G"
#define IPAD_3G_NAMESTRING              @"iPad 3G"
#define IPAD_4G_NAMESTRING              @"iPad 4G"
#define IPAD_UNKNOWN_NAMESTRING         @"iPad"

#define APPLETV_2G_NAMESTRING           @"Apple TV 2G"
#define APPLETV_3G_NAMESTRING           @"Apple TV 3G"
#define APPLETV_4G_NAMESTRING           @"Apple TV 4G"
#define APPLETV_UNKNOWN_NAMESTRING      @"Apple TV"

#define IOS_FAMILY_UNKNOWN_DEVICE       @"iOS device"

#define SIMULATOR_NAMESTRING            @"iPhone Simulator"
#define SIMULATOR_IPHONE_NAMESTRING     @"iPhone Simulator"
#define SIMULATOR_IPAD_NAMESTRING       @"iPad Simulator"
#define SIMULATOR_APPLETV_NAMESTRING    @"Apple TV Simulator" // :)

//iPhone 3G 以后各代的CPU型号和频率
#define IPHONE_3G_CPUTYPE               @"ARM11"
#define IPHONE_3G_CPUFREQUENCY          @"412MHz"
#define IPHONE_3GS_CPUTYPE              @"ARM Cortex A8"
#define IPHONE_3GS_CPUFREQUENCY         @"600MHz"
#define IPHONE_4_CPUTYPE                @"Apple A4"
#define IPHONE_4_CPUFREQUENCY           @"1GMHz"
#define IPHONE_4S_CPUTYPE               @"Apple A5 Double Core"
#define IPHONE_4S_CPUFREQUENCY          @"800MHz"

//iPod touch 4G 的CPU型号和频率
#define IPOD_4G_CPUTYPE                 @"Apple A4"
#define IPOD_4G_CPUFREQUENCY            @"800MHz"

#define IOS_CPUTYPE_UNKNOWN             @"Unknown CPU type"
#define IOS_CPUFREQUENCY_UNKNOWN        @"Unknown CPU frequency"

typedef enum {
	UIDeviceUnknown,

	UIDeviceSimulator,
	UIDeviceSimulatoriPhone,
	UIDeviceSimulatoriPad,
	UIDeviceSimulatorAppleTV,

	UIDevice1GiPhone,
	UIDevice3GiPhone,
	UIDevice3GSiPhone,
	UIDevice4iPhone,
	UIDevice4SiPhone,
	UIDevice5iPhone,
	UIDevice5CiPhone,
	UIDevice5SiPhone,

	UIDevice1GiPod,
	UIDevice2GiPod,
	UIDevice3GiPod,
	UIDevice4GiPod,
	UIDevice5GiPod,

	UIDevice1GiPad,
	UIDevice2GiPad,
	UIDevice3GiPad,
	UIDevice4GiPad,

	UIDeviceAppleTV2,
	UIDeviceAppleTV3,
	UIDeviceAppleTV4,

	UIDeviceUnknowniPhone,
	UIDeviceUnknowniPod,
	UIDeviceUnknowniPad,
	UIDeviceUnknownAppleTV,
	UIDeviceIFPGA,
} UIDevicePlatform;

typedef enum {
	UIDeviceFamilyiPhone,
	UIDeviceFamilyiPod,
	UIDeviceFamilyiPad,
	UIDeviceFamilyAppleTV,
	UIDeviceFamilyUnknown,
} UIDeviceFamily;

@interface UIDevice (hardware)

- (NSString *)platformString;       //平台信息
- (NSString *)modelString;          //平台类型
- (BOOL)isSimulator;
- (NSString *)cpuType;              //cpu型号
- (NSString *)cpuFrequency;         //cpu频率
- (NSUInteger)cpuCount;             //cpu核数
- (NSArray *)cpuUsage;                  //cpu利用率
- (NSString *)macAddress;
- (NSUInteger)totalMemoryBytes;     //获取手机内存总量,返回的是字节数
- (NSUInteger)freeMemoryBytes;      //获取手机可用内存,返回的是字节数

- (long long)freeDiskSpaceBytes;    //获取手机硬盘空闲空间,返回的是字节数
- (long long)totalDiskSpaceBytes;   //获取手机硬盘总空间,返回的是字节数

- (BOOL)isJailBreak;                //是否越狱

- (BOOL)bluetoothCheck;             //是否支持蓝牙

@end
