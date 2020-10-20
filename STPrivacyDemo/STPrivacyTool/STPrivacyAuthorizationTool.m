//
//  STPrivacyAuthorizationTool.m
//  STPrivacyDemo
//
//  Created by Jivan on 2020/5/25.
//  Copyright © 2020 Jivan. All rights reserved.
//

#import "STPrivacyAuthorizationTool.h"
#import "STPrivacyDefine.h"

@interface STPrivacyAuthorizationTool ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager         *locationManager;       // 定位
@property (nonatomic,copy) void (^kCLCallBackBlock)(CLAuthorizationStatus state);

@end

@implementation STPrivacyAuthorizationTool

#pragma mark - Public

+ (STAuthorizationStatus)checkAuthorizationStatusForType:(STPrivacyType)type{
    
    if (type == STPrivacyType_LocationServices) {
        return [STPrivacyAuthorizationTool checkLocationAuthorizationStatus];
    }
    if (type == STPrivacyType_Contacts) {
        return [STPrivacyAuthorizationTool checkContactsAuthorizationStatus];
    }
    if (type == STPrivacyType_Photos) {
        return [STPrivacyAuthorizationTool checkPhotosAuthorizationStatus];
    }
    if (type == STPrivacyType_Microphone) {
        return [STPrivacyAuthorizationTool checkMicrophoneAuthorizationStatus];
    }
    if (type == STPrivacyType_Camera) {
        return [STPrivacyAuthorizationTool checkCameraAuthorizationStatus];
    }
    if (type == STPrivacyType_Calendars) {
        return [STPrivacyAuthorizationTool checkCalendarsAuthorizationStatus];
    }
    if (type == STPrivacyType_Reminders) {
        return [STPrivacyAuthorizationTool checkRemindersAuthorizationStatus];
    }
    return STAuthorizationStatus_NotSupport;
}

+ (void)requestAccessForType:(STPrivacyType)type accessStatus:(AccessForTypeResultBlock)accessStatusCallBack{
    
    if (type == STPrivacyType_LocationServices) {
        //Mark:单独使用授权方法
    }
    if (type == STPrivacyType_Contacts) {
        [STPrivacyAuthorizationTool requestContactsWithAccessStatus:accessStatusCallBack];
    }
    if (type == STPrivacyType_Photos) {
        [STPrivacyAuthorizationTool requestPhotosWithAccessStatus:accessStatusCallBack];
    }
    if (type == STPrivacyType_Microphone) {
        [STPrivacyAuthorizationTool requestMicrophoneWithAccessStatus:accessStatusCallBack];
    }
    if (type == STPrivacyType_Camera) {
        [STPrivacyAuthorizationTool requestCameraWithAccessStatus:accessStatusCallBack];
    }
    if (type == STPrivacyType_Calendars) {
        [STPrivacyAuthorizationTool requestCalendarsWithAccessStatus:accessStatusCallBack];
    }
    if (type == STPrivacyType_Reminders) {
        [STPrivacyAuthorizationTool requestRemindersWithAccessStatus:accessStatusCallBack];
    }
}
+(void)openApplicationSetting{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
        
        if (_isiOS10_Or_Later_) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:nil completionHandler:nil];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
    
    
}
#pragma mark -  LocationServices

+ (STAuthorizationStatus)checkLocationAuthorizationStatus{
    BOOL isLocationServicesEnabled = [CLLocationManager locationServicesEnabled];
    if (isLocationServicesEnabled) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusAuthorizedAlways) {
            return STAuthorizationStatus_LocationAlways;
        }else if (status == kCLAuthorizationStatusAuthorizedWhenInUse){
            return STAuthorizationStatus_LocationWhenInUse;
        }else if (status == kCLAuthorizationStatusAuthorized){
            return STAuthorizationStatus_Authorized;
        }else{
            return status ;
        }
        
    }else{
        return STAuthorizationStatus_NotSupport;
    }
}
- (void)requestLocationAccessStatus:(AccessForTypeResultBlock)accessStatusCallBack{
    
    BOOL isLocationServicesEnabled = [CLLocationManager locationServicesEnabled];
    
    if (isLocationServicesEnabled) {
        if (accessStatusCallBack) {
            accessStatusCallBack(STAuthorizationStatus_NotSupport,STPrivacyType_LocationServices);
        }
    }else{
        STAuthorizationStatus status = [STPrivacyAuthorizationTool checkLocationAuthorizationStatus];
        if (status == STAuthorizationStatus_NotDetermined) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            [self.locationManager requestWhenInUseAuthorization];
            [self setKCLCallBackBlock:^(CLAuthorizationStatus state) {
                if (state == kCLAuthorizationStatusAuthorizedAlways) {
                    if (accessStatusCallBack) {
                        accessStatusCallBack(STAuthorizationStatus_LocationAlways,STPrivacyType_LocationServices);
                    }
                    
                }else if (state == kCLAuthorizationStatusAuthorizedWhenInUse){
                    if (accessStatusCallBack) {
                        accessStatusCallBack(STAuthorizationStatus_LocationWhenInUse,STPrivacyType_LocationServices);
                    }
                    
                }else if (state == kCLAuthorizationStatusAuthorized){
                    if (accessStatusCallBack) {
                        accessStatusCallBack(STAuthorizationStatus_Authorized,STPrivacyType_LocationServices);
                    }
                    
                }else{
                    if (accessStatusCallBack) {
                        accessStatusCallBack(state,STPrivacyType_LocationServices);
                    }
                }
            }];
        }else{
            if (accessStatusCallBack) {
                accessStatusCallBack(status,STPrivacyType_LocationServices);
            }
        }
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (self.kCLCallBackBlock) {
        self.kCLCallBackBlock(status);
    }
}

#pragma mark -  Contacts

+ (STAuthorizationStatus)checkContactsAuthorizationStatus{
    if (_isiOS9_Or_Later_) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        return status;
        
    }else{
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        return status;
    }
}
+ (void)requestContactsWithAccessStatus:(AccessForTypeResultBlock)accessStatusCallBack{
    
    STAuthorizationStatus status = [STPrivacyAuthorizationTool checkContactsAuthorizationStatus];
    if (status == STAuthorizationStatus_NotDetermined ) {
        if (_isiOS9_Or_Later_) {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            if (contactStore) {
                [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (error) {
                        if (accessStatusCallBack) {
                            accessStatusCallBack(STAuthorizationStatus_NotSupport,STPrivacyType_Contacts);
                        }
                    }else{
                        if (granted) {
                            if (accessStatusCallBack) {
                                accessStatusCallBack(STAuthorizationStatus_Authorized,STPrivacyType_Contacts);
                            }
                        }else{
                            if (accessStatusCallBack) {
                                accessStatusCallBack(STAuthorizationStatus_Denied,STPrivacyType_Contacts);
                            }
                        }
                    }
                }];
            }else{
                if (accessStatusCallBack) {
                    accessStatusCallBack(STAuthorizationStatus_NotSupport,STPrivacyType_Contacts);
                }
            }
        }else{
            __block ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
            if (addressBookRef == NULL) {
                if (accessStatusCallBack) {
                    accessStatusCallBack(STAuthorizationStatus_NotSupport,STPrivacyType_Contacts);
                }
            }
            
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    if (accessStatusCallBack) {
                        accessStatusCallBack(STAuthorizationStatus_Authorized,STPrivacyType_Contacts);
                    }
                }else{
                    if (accessStatusCallBack) {
                        accessStatusCallBack(STAuthorizationStatus_Denied,STPrivacyType_Contacts);
                    }
                }
                if (addressBookRef) {
                    CFRelease(addressBookRef);
                    addressBookRef = NULL;
                }
            });
        }
    }else{
        if (accessStatusCallBack) {
            accessStatusCallBack(status,STPrivacyType_Contacts);
        }
    }
}

#pragma mark -  Photos

+ (STAuthorizationStatus)checkPhotosAuthorizationStatus{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        if (_isiOS8_Or_Later_) {
            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            return status;
        }else{
            ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
            return status;
        }
    }else{
        return STAuthorizationStatus_NotSupport;
    }
}
+ (void)requestPhotosWithAccessStatus:(AccessForTypeResultBlock)accessStatusCallBack{
    
    STAuthorizationStatus status = [STPrivacyAuthorizationTool checkPhotosAuthorizationStatus];
    if (status == STAuthorizationStatus_NotDetermined) {
        if (_isiOS8_Or_Later_) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (accessStatusCallBack) {
                    accessStatusCallBack(status,STPrivacyType_Photos);
                }
            }];
            
        }else{
            
            // 当某些情况下，ALAuthorizationStatus 为 ALAuthorizationStatusNotDetermined的时候，无法弹出系统首次使用的收取alertView，系统设置中也没有相册的设置，此时将无法使用，所以做以下操作，弹出系统首次使用的授权alertView
            __block BOOL isShow = YES;
            ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
            [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if (isShow) {
                    if (accessStatusCallBack) {
                        accessStatusCallBack(STAuthorizationStatus_Authorized,STPrivacyType_Photos);
                    }
                    isShow = NO;
                }
            } failureBlock:^(NSError *error) {
                if (accessStatusCallBack) {
                    accessStatusCallBack(STAuthorizationStatus_Denied,STPrivacyType_Photos);
                }
            }];
        }
    }else{
        if (accessStatusCallBack) {
            accessStatusCallBack(status,STPrivacyType_Photos);
        }
    }
}
#pragma mark -  Microphone

+ (STAuthorizationStatus)checkMicrophoneAuthorizationStatus{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    return status;
}
+ (void)requestMicrophoneWithAccessStatus:(AccessForTypeResultBlock)accessStatusCallBack{
    
    STAuthorizationStatus status = [STPrivacyAuthorizationTool checkMicrophoneAuthorizationStatus];
    if (status == STAuthorizationStatus_NotDetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                if (accessStatusCallBack) {
                    accessStatusCallBack(STAuthorizationStatus_Authorized,STPrivacyType_Microphone);
                }
                
            }else{
                if (accessStatusCallBack) {
                    accessStatusCallBack(STAuthorizationStatus_Denied,STPrivacyType_Microphone);
                }
            }
        }];
    }else{
        if (accessStatusCallBack) {
            accessStatusCallBack(status,STPrivacyType_Microphone);
        }
    }
}
#pragma mark -  Camera

+ (STAuthorizationStatus)checkCameraAuthorizationStatus{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        return status;
    }else{
        return STAuthorizationStatus_NotSupport;
    }
}
+ (void)requestCameraWithAccessStatus:(AccessForTypeResultBlock)accessStatusCallBack{
    
    STAuthorizationStatus status = [STPrivacyAuthorizationTool checkCameraAuthorizationStatus];
    if (status == STAuthorizationStatus_NotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                if (accessStatusCallBack) {
                    accessStatusCallBack(STAuthorizationStatus_Authorized,STPrivacyType_Camera);
                }
            }else{
                
                if (accessStatusCallBack) {
                    accessStatusCallBack(STAuthorizationStatus_Denied,STPrivacyType_Camera);
                }
            }
        }];
    }else{
        if (accessStatusCallBack) {
            accessStatusCallBack(status,STPrivacyType_Camera);
        }
    }
}
#pragma mark -  Calendars

+ (STAuthorizationStatus)checkCalendarsAuthorizationStatus{
    
    EKEventStore *store = [[EKEventStore alloc] init];
    if (store == NULL) {
        return STAuthorizationStatus_NotSupport ;
    }else{
        EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
        return status;
    }
    
}

+ (void)requestCalendarsWithAccessStatus:(AccessForTypeResultBlock)accessStatusCallBack{
    
    STAuthorizationStatus status = [STPrivacyAuthorizationTool checkCalendarsAuthorizationStatus];
    if (status == STAuthorizationStatus_NotDetermined) {
        EKEventStore *store = [[EKEventStore alloc] init];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            if (error) {
                if (accessStatusCallBack) {
                    accessStatusCallBack(STAuthorizationStatus_Denied,STPrivacyType_Calendars);
                }
            }else{
                if (granted) {
                    if (accessStatusCallBack) {
                        accessStatusCallBack(STAuthorizationStatus_Authorized,STPrivacyType_Calendars);
                    }
                }else{
                    if (accessStatusCallBack) {
                        accessStatusCallBack(STAuthorizationStatus_Denied,STPrivacyType_Calendars);
                    }
                }
                
            }
            
        }];
    }else{
        if (accessStatusCallBack) {
            accessStatusCallBack(status,STPrivacyType_Calendars);
        }
    }
    
}

#pragma mark -  Reminders

+ (STAuthorizationStatus)checkRemindersAuthorizationStatus{
    
    EKEventStore *store = [[EKEventStore alloc] init];
    if (store == NULL) {
        return STAuthorizationStatus_NotSupport ;
    }else{
        EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
        return status;
    }
    
}

+ (void)requestRemindersWithAccessStatus:(AccessForTypeResultBlock)accessStatusCallBack{
    
    STAuthorizationStatus status = [STPrivacyAuthorizationTool checkRemindersAuthorizationStatus];
    if (status == STAuthorizationStatus_NotDetermined) {
        EKEventStore *store = [[EKEventStore alloc] init];
        [store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
            if (error) {
                if (accessStatusCallBack) {
                    accessStatusCallBack(STAuthorizationStatus_Denied,STPrivacyType_Reminders);
                }
            }else{
                if (granted) {
                    if (accessStatusCallBack) {
                        accessStatusCallBack(STAuthorizationStatus_Authorized,STPrivacyType_Reminders);
                    }
                }else{
                    if (accessStatusCallBack) {
                        accessStatusCallBack(STAuthorizationStatus_Denied,STPrivacyType_Reminders);
                    }
                }
                
            }
            
        }];
    }else{
        if (accessStatusCallBack) {
            accessStatusCallBack(status,STPrivacyType_Reminders);
        }
    }
    
}


@end
