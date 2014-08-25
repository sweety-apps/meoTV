//
//  shotScreenModel.h
//  zaime
//
//  Created by 1528 MAC on 14-8-14.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol passImageDelegate <NSObject>

-(void)passImage:(UIImage *)image;

@end

@interface KSDShotScreen : NSObject
@property (weak,nonatomic)id<passImageDelegate>delegate;
+ (instancetype)sharedInstance;
-(UIImage*)captureView:(UIView *)theView frame:(CGRect)fra;
@end
