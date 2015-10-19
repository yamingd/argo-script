//
//  AppConfig.h
//  _project_
//
//  Created by Yaming on 10/4/15.
//  Copyright © 2015 _company_.com. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h

#define kListPageSize 20
#define kAppName @"_project_"

#define kAesSeed @"_project_"

#define kQQKey @""
#define kQQSecret @""

#define kWxKey @""
#define kWxSecret @""

#define kTongJiKey @""
#define kTongJiSecret @""


#ifdef DEBUG

#define kAppCookieId @"x-auth"
#define kAppCookieSalt @"_project_secret_dev_"
#define kAppAPIBaseUrl @"http://localhost:8080/m"
#define kAppAPNSEnable NO
#define kIMServerIP @""
#define kIMServerPort 9080

#endif

#ifdef TEST

#define kAppCookieId @"x-auth"
#define kAppCookieSalt @"_project_secret_test_"
#define kAppAPIBaseUrl @"http://localhost:8080/m"
#define kAppAPNSEnable NO
#define kIMServerIP @""
#define kIMServerPort 9080

#endif

#ifdef RELEASE

#define kAppCookieId @"x-auth"
#define kAppCookieSalt @"_project_secret_prod_"
#define kAppAPIBaseUrl @"http://localhost:8080/m"
#define kAppAPNSEnable NO
#define kIMServerIP @""
#define kIMServerPort 9080

#endif

#endif /* AppConfig_h */
