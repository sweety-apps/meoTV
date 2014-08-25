//
//  DownloadEmotion.h
//  zaime
//
//  Created by 1528 MAC on 14-8-13.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSDDownloadEmotion : NSObject
{
    NSMutableArray *results;
}
/**
 @brief 进行表情下载
 @param urls 表情地址集合
 @param progress 下载进度
 @param complete 美下载结束一个进行回调,results里面装的是image-url字典
 */
- (void)downloadWithURLS :(NSArray*)urlStrs :(void(^)(UIImage *image,NSString *url))complete;
@end
