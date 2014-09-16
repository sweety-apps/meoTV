//
//  ContentItem.h
//  youLost
//
//  Created by 1528 MAC on 14-9-4.
//  Copyright (c) 2014年 ksd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ContentItem : NSObject

@property(nonatomic,strong) NSArray *images;
@property(nonatomic,strong) NSString *desc;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *avatarURLStr;
@property(nonatomic,strong) NSDate *createTime;
@property(nonatomic,assign) int up;
@property(nonatomic,assign) int down;
@end
