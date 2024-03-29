//
//  NaviItems.h
//  zaime
//
//  Created by 1528 MAC on 14-9-1.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#ifndef NaviTitleFont
#define NaviTitleFont [UIFont boldSystemFontOfSize:22]
#endif
#ifndef NaviTitleColor
#define NaviTitleColor [UIColor whiteColor]
#endif
#ifndef NaviRightBtnColor
#define NaviRightBtnColor [UIColor blackColor]
#endif
#ifndef NaviRightBtnFont
#define NaviRightBtnFont [UIFont systemFontOfSize:17]
#define IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#endif
@interface NaviItems : NSObject
//无事件传nil;
+(UIBarButtonItem*)naviLeftBtnWithImage:(UIImage*)image target:(id)target selector:(SEL)selector;
+(UIBarButtonItem*)naviRightBtnWithTitle:(NSString*)title target:(id)target selector:(SEL)selector;
+(UILabel*)naviTitleViewWithTitle:(NSString*)title target:(id)target selector:(SEL)selector;
+(UIBarButtonItem*)naviRightBtnWithImage:(UIImage *)image target:(id)target selector:(SEL)selector;
+(UIBarButtonItem*)naviLeftBtnWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;
@end
