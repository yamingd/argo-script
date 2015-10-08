//
//  AppConfig.h
//  _project_
//
//  Created by Yaming on 10/4/15.
//  Copyright © 2015 _company_.com. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h

#ifdef DEBUG

#define kAppName @"_title_"
#define kAppCookieId @"x-auth"
#define kAppCookieSalt @"iOSBootstrapDemoSecret"
#define kAppAPIBaseUrl @"http://localhost:8080/m"
#define kAppAPNSEnable NO

#endif

#ifdef TEST

#define kAppName @"_title_"
#define kAppCookieId @"x-auth"
#define kAppCookieSalt @"iOSBootstrapDemoSecret"
#define kAppAPIBaseUrl @"http://localhost:8080/m"
#define kAppAPNSEnable NO

#endif

#ifdef RELEASE

#define kAppName @"_title_"
#define kAppCookieId @"x-auth"
#define kAppCookieSalt @"iOSBootstrapDemoSecret"
#define kAppAPIBaseUrl @"http://localhost:8080/m"
#define kAppAPNSEnable NO

#endif

#endif /* AppConfig_h */
