//
//  DownloadEmotion.m
//  zaime
//
//  Created by 1528 MAC on 14-8-13.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "DownloadEmotion.h"
#import "SharedInstanceGCD.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation DownloadEmotion

SHARED_INSTANCE_GCD_USING_BLOCK(^{
    return [[self alloc]init];
})
- (id)init
{
    self = [super init];
    if(self)
    {
        results = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)downloadWithURLS :(NSArray*)urlStrs :(void(^)(NSDictionary *results))complete;
{
    [results removeAllObjects];
    for (NSString *url in urlStrs)
    {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if(complete)
            {
                NSDictionary *res = [NSDictionary dictionaryWithObjectsAndKeys:image,imageURL.absoluteString, nil];
                complete(res);
            }
        }];
       
    }
    
}
@end
