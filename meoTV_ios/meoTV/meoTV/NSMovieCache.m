//
//  NSMovieCache.m
//  Test
//
//  Created by NPHD on 14-4-28.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "NSMovieCache.h"



@implementation MovieDownload

- (id) init {
    [super init];
    
    mutdata = nil;
    connect = nil;
    
    return self;
}

- (void)dealloc {
    [self.nid release];
    [self.url release];
    [self.delegates release];
    [self.filePath release];
    
    if ( mutdata != nil ) {
        [mutdata release];
    }
    
    if ( connect != nil ) {
        [connect release];
    }
    
    [super dealloc];
}

- (void) downloadFile {
    NSURL* url = [NSURL URLWithString:_url];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    mutdata = [[NSMutableData alloc] init];
    
    connect = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void) connection:(NSURLConnection*) connection didReceiveResponse:(NSURLResponse *)response {
    [mutdata setLength:0];
}

- (void) connection:(NSURLConnection*) connection didReceiveData:(NSData *)data {
    [mutdata appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // 接收失败
    [[NSMovieCache sharedInstance] fire_event:self suc:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // 下载成功
    [mutdata writeToFile:_filePath atomically:YES];
    
    [[NSMovieCache sharedInstance] fire_event:self suc:YES];
}

@end


@implementation NSMovieCache

static NSMovieCache* _sharedInstance = nil;

+(id) sharedInstance {
    if ( _sharedInstance == nil ) {
        _sharedInstance = [[NSMovieCache alloc]init];
        
        NSString* movieCache = [NSHomeDirectory() stringByAppendingString:@"moviecache"];
        [[NSFileManager defaultManager] createDirectoryAtPath:movieCache withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return _sharedInstance;
}

-(id) init {
    [super init];
    
    downloadArray = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)dealloc {
    [downloadArray release];
    [super dealloc];
}

-(NSString*) requestMovie:(NSNumber*) nid  url:(NSString*) url delegate:(id) delegate {
    // 返回视频的缓存路径
    NSString* movieCache = [NSHomeDirectory() stringByAppendingString:@"moviecache"];
    
    movieCache = [NSString stringWithFormat:@"/%@/cache_%@.mp4", movieCache, nid];
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:movieCache isDirectory:NO] ) {
        return movieCache;
    }
    
    MovieDownload* info = [self getMovieDownloadInfo:nid];
    if ( info == nil ) {
        // 创建一个下载任务
        info = [[MovieDownload alloc] init];
        info.nid = [nid copy];
        info.url = [url copy];
        info.delegates = [[NSMutableArray alloc] init];
        info.filePath = [movieCache copy];
        [info.delegates addObject:delegate];
        
        [downloadArray addObject:info];
        
        [info downloadFile];
    } else {
        // 下载任务已经存在
        [info.delegates addObject:info];
    }
    return nil;
}

-(MovieDownload*) getMovieDownloadInfo:(NSNumber*) nid {
    for ( int i = 0; i < [downloadArray count]; i ++ ) {
        MovieDownload* info = [downloadArray objectAtIndex:i];
        if ( [info.nid longLongValue] == [nid longLongValue] ) {
            return info;
        }
    }
    return nil;
}

-(void) fire_event:(MovieDownload*) info suc:(BOOL) suc {
    [downloadArray removeObject:info];
    
    for ( int i = 0; i < [info.delegates count]; i ++ ) {
        id dele = [info.delegates objectAtIndex:i];
        if ( dele != nil ) {
            //[dele downloadCompleted:info.nid url:info.url filePath:info.filePath suc:suc];
        }
    }
    
    [info release];
}

@end
