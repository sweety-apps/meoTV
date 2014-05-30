//
//  Content.m
//  dianZan
//
//  Created by NPHD on 14-5-28.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "Content.h"

@implementation Content

- (id) init {
    self = [super init];
    if ( self ) {
        self->_delegate = nil;
        self.title = nil;
        self.url = nil;
        self.cid = 0;
        self.cStatus = ContentStatusNone;
    }
    return self;
}

- (void)dealloc {
    if ( self.title != nil ) {
        [self.title release];
        self.title = nil;
    }
    if ( self.url != nil ) {
        [self.url release];
        self.url = nil;
    }
    
    if ( _delegate != nil ) {
        [_delegate release];
        _delegate = nil;
    }
    
    [super dealloc];
}

- (void) setDelegate:(id) delegate {
    if ( _delegate != nil ) {
        [_delegate release];
        _delegate = nil;
    }
    
    if ( delegate != nil ) {
        _delegate = [delegate retain];
    }
}

- (NSString*) getCachePath {
    NSString* cachePath = [NSHomeDirectory() stringByAppendingString:@"/cache"];
    
    switch ( _cType ) {
        case ContentTypeGif:
            cachePath = [NSString stringWithFormat:@"/%@/cache_%ld.gif", cachePath, _cid];
            break;
        case ContentTypeImage:
            cachePath = [NSString stringWithFormat:@"/%@/cache_%ld.jpg", cachePath, _cid];
            break;
        case ContentTypeMovie:
            cachePath = [NSString stringWithFormat:@"/%@/cache_%ld.mp4", cachePath, _cid];
            break;
        default:
            break;
    }
    return [[cachePath copy] autorelease];
}

- (NSString*) getContentPath {  // 获取内容所在的路径，如果内容不存在，则开始下载
    NSString* cacheFile = [self getCachePath];
    NSString* retPath = @"";
    
    if ( self.cStatus == ContentStatusNone ) {
        // 判断缓存文件是否存在
        if ( [[NSFileManager defaultManager] fileExistsAtPath:cacheFile isDirectory:NO] ) {
            self.cStatus = ContentStatusHasFile;
            retPath = cacheFile;
        } else {
            // 开始下载
            [self downloadFile];
        }
    } else if ( self.cStatus == ContentStatusDownloading ) {
        // 文件下载中
        // 下载中什么也不做
    } else if ( self.cStatus == ContentStatusDownloadFailed ) {
        // 下载失败，重新下载
        [self downloadFile];
    } else if ( self.cStatus == ContentStatusHasFile ) {
        retPath = cacheFile;
    }
    
    return retPath;
}

- (void) downloadFile {
    self.cStatus = ContentStatusDownloading;
    
    NSURL *url = [NSURL URLWithString:_url];
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    
    [self fire_event];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSData *responseData = [request responseData];

    NSString* path = [self getCachePath];
    [responseData writeToFile:path atomically:NO];
    
    self.cStatus = ContentStatusHasFile;
    
    [self fire_event];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    self.cStatus = ContentStatusDownloadFailed;
    
    [self fire_event];
}

- (void) fire_event {
    if ( _delegate != nil ) {
        [_delegate ContentStatusChanged:_cStatus];
    }
}

@end
