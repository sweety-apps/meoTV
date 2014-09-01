//
//  KSDPhoto.h
//  zaime
//
//  Created by 1528 MAC on 14-9-1.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STDbObject.h"

@interface KSDPhoto : STDbObject

@property (assign, nonatomic) int _id;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *fromuser;
@property (strong, nonatomic) NSData *image;
@property (strong, nonatomic) NSDate *birthday;


@end
