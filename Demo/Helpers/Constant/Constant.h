//
//  Constant.h
//  Demo
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define APP_DELEGATE    ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define USER_DEFAULT    [NSUserDefaults standardUserDefaults]

#define IS_IPHONE   [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"]

#ifdef DEBUG
#   define DLOG(FORMAT, ...) printf("🔵%s[line %d]: %s🔵\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#   define ELOG(FORMAT, ...) printf("🔴%s[line %d]: %s🔴\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#   define DLOG(...)
#   define ELOG(...)
#endif

// API-------------------------------------------------------------------

#define API_LOGIN @"http://ndhapi.epm.vn/api/rest/login"
#define API_LOGIN_SESSION @"http://ndhapi.epm.vn/api/rest/loginsession"
#define API_LOGOUT @"http://ndhapi.epm.vn/api/rest/logout"
#define API_CHECK_STAFF @"http://ndhapi.epm.vn/api/rest/checkStaff"
#define API_UPLOAD_IMAGE @"http://test.epm.vn/upload/checkin"
#define API_CHECK_IN @"http://ndhapi.epm.vn/api/rest/checkin"
#define API_SUPPORT @"http://ndhapi.epm.vn/api/rest/msgtohai"
#define API_GET_AGENCYS @"http://ndhapi.epm.vn/api/rest/getagency"

#define PARAM_USER @"user"
#define PARAM_TOKEN @"token"
#define PARAM_EXTENSION @"extension"
#define PARAM_IMAGE @"image"
#define PARAM_COMMENT @"comment"
#define PARAM_LATITUDE @"latitude"
#define PARAM_LONGTITUDE @"longtitude"
#define PARAM_DATE @"date"
#define PARAM_CODE @"code"
#define PARAM_TYPE @"type"
#define PARAM_CONTENT @"content"

#define RESPONSE_ID @"id"
#define RESPONSE_MESSAGE @"msg"
#define RESPONSE_USER @"user"
#define RESPONSE_TOKEN @"token"
#define RESPONSE_FUNCTION @"function"
#define RESPONSE_ROLE @"Role"
#define RESPONSE_AVATAR @"avatar"
#define RESPONSE_SIGNATURE @"signature"
#define RESPONSE_STATUS @"status"
#define RESPONSE_AGENCY @"agency"

// PREFERENCE-------------------------------------------------------------------

#define PREF_USER @"user"
#define PREF_TOKEN @"token"
#define PREF_FUNCTION @"function"
#define PREF_ROLE @"role"


