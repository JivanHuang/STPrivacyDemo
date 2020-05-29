//
//  STPrivacyDefine.h
//  STPrivacyDemo
//
//  Created by Jivan on 2020/5/25.
//  Copyright © 2020 Jivan. All rights reserved.
//

#ifndef STPrivacyDefine_h
#define STPrivacyDefine_h

#define _isiOS7_          (([UIDevice currentDevice].systemVersion.floatValue >= 7.0f && [UIDevice currentDevice].systemVersion.floatValue < 8.0) ? YES : NO)
#define _isiOS7_Or_Later_ (([UIDevice currentDevice].systemVersion.floatValue >= 7.0f) ? YES : NO)
#define _isiOS8_          (([UIDevice currentDevice].systemVersion.floatValue >= 8.0f && [UIDevice currentDevice].systemVersion.floatValue < 9.0f) ? YES : NO)
#define _isiOS8_Or_Later_ (([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) ? YES : NO)
#define _isiOS9_          (([UIDevice currentDevice].systemVersion.floatValue >= 9.0f && [UIDevice currentDevice].systemVersion.floatValue < 10.0f) ? YES : NO)
#define _isiOS9_Or_Later_ (([UIDevice currentDevice].systemVersion.floatValue >= 9.0f) ? YES : NO)
#define _isiOS10_          (([UIDevice currentDevice].systemVersion.floatValue >= 10.0f && [UIDevice currentDevice].systemVersion.floatValue < 11.0f) ? YES : NO)
#define _isiOS10_Or_Later_ (([UIDevice currentDevice].systemVersion.floatValue >= 10.0f) ? YES : NO)


#endif /* STPrivacyDefine_h */
