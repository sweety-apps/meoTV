//
//  WebImageView.m
//  meoTV
//
//  Created by NPHD on 14-5-6.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "WebImageView.h"

@implementation ImageViewCache

- (void)dealloc {
    if ( self._connect != nil ) {
        [self._connect release];
        self._connect = nil;
    }
    
    if ( self._mutdata != nil ) {
        [self._mutdata release];
        self._mutdata = nil;
    }
    
    if ( self._imageFile != nil ) {
        [self._imageFile release];
        self._imageFile = nil;
    }
    
    [super dealloc];
}

@end

@implementation UIImageView (WebImageView)

NSMutableDictionary* _sMutDictionary = nil;

- (void) cancelLoadImage {
    if ( _sMutDictionary == nil ) {
        return ;
    }
    
    NSString* key = [NSString stringWithFormat:@"%d", (int)self];
    ImageViewCache* cache = (ImageViewCache*)[_sMutDictionary valueForKey:key];
    if ( cache != nil ) {
        [cache._connect cancel];
    }
    
    [_sMutDictionary removeObjectForKey:key];
}

- (void) setImageWithURL:(NSString*) url cacheFile:(NSString*) fileName forever:(BOOL) fe {
    // 先判断本地是否有对应的图片
    [self cancelLoadImage];
    
    NSString* filePath = nil;

    if ( fe ) {
        filePath = [NSString stringWithFormat:@"forever_%@", fileName];
    } else {
        filePath = [NSString stringWithFormat:@"cache_%@", fileName];
    }
    
    NSString* imageCache = [NSHomeDirectory() stringByAppendingString:@"/cacheImage"];
    [[NSFileManager defaultManager] createDirectoryAtPath:imageCache withIntermediateDirectories:YES attributes:nil error:nil];
    
    imageCache = [NSString stringWithFormat:@"%@/%@", imageCache, filePath];
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:imageCache isDirectory:NO] ) {
        UIImage* image = [[UIImage alloc] initWithContentsOfFile:imageCache];
        [self setImage:image];
        [image release];
    } else {
        // 把文件下载到本地
        ImageViewCache* cache = [[[ImageViewCache alloc] init] autorelease];
        cache._imageFile = [imageCache copy];
        
        [self request:url cache:cache];
    }
}

-(void) request:(NSString*) url cache:(ImageViewCache*) cache {
    NSURL* nsurl = [NSURL URLWithString:url];
    NSURLRequest* request = [NSURLRequest requestWithURL:nsurl];
    
    cache._mutdata = [[NSMutableData alloc] init];
    
    cache._connect = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    NSString* key = [NSString stringWithFormat:@"%d", (int)self];
    
    if ( _sMutDictionary == nil ) {
        _sMutDictionary = [[NSMutableDictionary alloc] init];
    }
    [_sMutDictionary setObject:cache forKey:key];
}

- (void)dealloc {
    [self cancelLoadImage];
    [super dealloc];
}

- (void) connection:(NSURLConnection*) connection didReceiveResponse:(NSURLResponse *)response {
    NSString* key = [NSString stringWithFormat:@"%d", (int)self];
    ImageViewCache* cache = (ImageViewCache*)[_sMutDictionary valueForKey:key];
    
    [cache._mutdata setLength:0];
}

- (void) connection:(NSURLConnection*) connection didReceiveData:(NSData *)data {
    NSString* key = [NSString stringWithFormat:@"%d", (int)self];
    ImageViewCache* cache = (ImageViewCache*)[_sMutDictionary valueForKey:key];
    
    [cache._mutdata appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // 接收失败,下载文件失败了，这里可以显示一个默认的失败图
    [self cancelLoadImage];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // 下载成功
    NSString* key = [NSString stringWithFormat:@"%d", (int)self];
    ImageViewCache* cache = (ImageViewCache*)[_sMutDictionary valueForKey:key];
    
    UIImage* image = [[UIImage alloc] initWithData:cache._mutdata];
    [self setImage:image];
    [image release];
    
    [cache._mutdata writeToFile:cache._imageFile atomically:YES];
    [self cancelLoadImage];
}


@end
