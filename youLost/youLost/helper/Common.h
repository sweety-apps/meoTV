//
//  Common.h
//  youLost
//
//  Created by 1528 MAC on 14-9-8.
//  Copyright (c) 2014年 ksd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface Common : NSObject
@property(nonatomic,strong) User *user;
@property(nonatomic,strong) NSString *token;
+ (instancetype)sharedInstance;
@end
