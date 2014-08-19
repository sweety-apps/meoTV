//
//  Common.h
//  zaime
//
//  Created by 1528 MAC on 14-8-14.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

@property(nonatomic,strong) NSString *username;


+ (instancetype)sharedInstance;
@end
