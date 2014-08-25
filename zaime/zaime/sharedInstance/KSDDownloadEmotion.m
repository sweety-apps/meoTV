//
//  DownloadEmotion.m
//  zaime
//
//  Created by 1528 MAC on 14-8-13.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "KSDDownloadEmotion.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation KSDDownloadEmotion

- (id)init
{
    self = [super init];
    if(self)
    {
        results = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)downloadWithURLS :(NSArray*)urlStrs :(void(^)(UIImage *image,NSString *url))complete;
{
    [results removeAllObjects];
    for (NSString *url in urlStrs)
    {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if(complete)
            {
                complete(image,imageURL.absoluteString);
            }
        }];
       
    }
    
}
@end
