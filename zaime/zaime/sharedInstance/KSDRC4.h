//
//  KSDRC4.h
//  zaime
//
//  Created by 1528 MAC on 14-9-7.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSDRC4 : NSObject
+ (instancetype)sharedInstance;
-(NSString*)ksdRC4:(NSString*)aInput key:(NSString*)aKey;
@end
