//
//  STPrivacyAuthorizationTool.h
//  STPrivacyDemo
//
//  Created by Jivan on 2020/5/25.
//  Copyright © 2020 Jivan. All rights reserved.
//

@import Foundation;
@import UIKit;
@import AssetsLibrary;
@import Photos;
@import Contacts;
@import CoreLocation;
@import AddressBook;
@import EventKit;

NS_ASSUME_NONNULL_BEGIN

/// STPrivacyType 授权类型
typedef NS_ENUM(NSUInteger, STPrivacyType){
    
    STPrivacyType_None                  = 0,
    STPrivacyType_LocationServices      = 1,    // 定位服务
    STPrivacyType_Contacts              = 2,    // 通讯录
    STPrivacyType_Photos                = 3,    // 照片
    STPrivacyType_Microphone            = 4,    // 麦克风
    STPrivacyType_Camera                = 5,    // 相机
    STPrivacyType_Calendars             = 6,    // 日历
    STPrivacyType_Reminders             = 7,    // 提醒事项
    
};
/// STAuthorizationStatus 权限状态，参考PHAuthorizationStatus等
typedef NS_ENUM(NSUInteger, STAuthorizationStatus){
    
    STAuthorizationStatus_NotDetermined,  // 用户从未进行过授权等处理，首次访问相应内容会提示用户进行授权
    STAuthorizationStatus_Restricted,     // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
    STAuthorizationStatus_Denied,         // 拒绝
    STAuthorizationStatus_Authorized,     // 已授权
    STAuthorizationStatus_NotSupport = 101,    // 硬件等不支持
    STAuthorizationStatus_LocationAlways = 201, //定位总是允许
    STAuthorizationStatus_LocationWhenInUse = 202, //定位使用时允许
    
};

///定义权限状态回调block
typedef void(^AccessForTypeResultBlock)(STAuthorizationStatus status, STPrivacyType type);

@interface STPrivacyAuthorizationTool : NSObject

/// 检查对应类型的权限
/// @param type  STPrivacyType
+ (STAuthorizationStatus)checkAuthorizationStatusForType:(STPrivacyType)type ;

/// 请求对应类型的权限 （定位需要使用独立方法）
/// @param type STPrivacyType
/// @param accessStatusCallBack  AccessForTypeResultBlock
+ (void)requestAccessForType:(STPrivacyType)type accessStatus:(AccessForTypeResultBlock)accessStatusCallBack;

/// 请求定位授权
/// @param accessStatusCallBack  AccessForTypeResultBlock
- (void)requestLocationAccessStatus:(AccessForTypeResultBlock)accessStatusCallBack;

/// 打开应用设置
+(void)openApplicationSetting ;

@end

NS_ASSUME_NONNULL_END
