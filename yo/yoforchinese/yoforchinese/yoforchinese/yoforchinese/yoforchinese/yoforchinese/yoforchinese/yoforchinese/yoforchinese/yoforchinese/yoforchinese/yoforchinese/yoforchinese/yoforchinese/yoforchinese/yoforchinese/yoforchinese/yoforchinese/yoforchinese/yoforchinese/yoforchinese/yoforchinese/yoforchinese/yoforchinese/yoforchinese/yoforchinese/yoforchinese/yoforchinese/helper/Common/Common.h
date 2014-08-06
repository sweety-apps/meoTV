//
//  Common.h
//  yoforchinese
//
//  Created by NPHD on 14-8-4.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

+ (instancetype)sharedInstance;
@property(nonatomic,strong) NSString *login;
@property(nonatomic,strong) NSString *nickname;
@end
