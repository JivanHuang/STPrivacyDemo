//
//  STPrivacySettingModel.h
//  HTSJ
//
//  Created by Jivan on 2020/5/20.
//  Copyright © 2020 北京红云融通技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STPrivacyAuthorizationTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface STPrivacySettingModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSString *subTitle;
@property (nonatomic,assign) STAuthorizationStatus status;
@property (nonatomic,assign) STPrivacyType type;
@property (nonatomic,strong) NSString *pageUrl;
@end

NS_ASSUME_NONNULL_END
