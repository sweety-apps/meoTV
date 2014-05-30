//
//  MovieInfo.m
//  Test
//
//  Created by NPHD on 14-4-29.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "MovieInfo.h"
#import "NSMovieCache.h"

@implementation MovieInfo

- (id) init {
    [super init];
    
    self.url = nil;
    self.mid = nil;
    self.thumb = nil;
    self.time = 0;
    self.status = MovieInfoStatusNotFile;
    self.status = MovieInfoStatusDownloaded;    //
    return self;
}

- (void)dealloc {
    if ( self.url != nil ) {
        [self.url release];
    }
    
    if ( self.mid != nil ) {
        [self.mid release];
    }
    
    if ( self.thumb != nil ) {
        [self.thumb release];
    }

    [super dealloc];
}

-(void) createThumbImageFromFile:(NSTimeInterval) time {
    // 创建一个视频的截图
    NSString* movieCache = [NSHomeDirectory() stringByAppendingString:@"moviecache"];
    
    movieCache = [NSString stringWithFormat:@"/%@/cache_%@.mp4", movieCache, self.mid];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:movieCache isDirectory:NO] ) {
        self.status = MovieInfoStatusNotFile;
        return ;
    }
    
    self.status = MovieInfoStatusDownloaded;
    UIImage* image = [self getMovieThumbnail:self.mid url:movieCache time:time];
    
    if ( self.thumb != nil ) {
        [self.thumb release];
    }
    self.thumb = [image copy];
}

-(UIImage*)getMovieThumbnail:(NSNumber*) nid url:(NSString *)linkStr time:(NSTimeInterval) t {
    self.time = t;
    
    NSURL *url = [NSURL fileURLWithPath:linkStr];
        
    AVURLAsset *asset = [[[AVURLAsset alloc] initWithURL:url options:nil] autorelease];
    AVAssetImageGenerator *generator = [[[AVAssetImageGenerator alloc] initWithAsset:asset] autorelease];
    generator.maximumSize = CGSizeMake(300, 300);
    
    NSError *error = nil;
    
    CMTime time = CMTimeMakeWithSeconds(t, generator.asset.duration.timescale);

    CGImageRef imgRef = [generator copyCGImageAtTime:time actualTime:NULL error:&error];
        
    if (error.description != nil)
        NSLog(@"Error: (thumbnailFromVideoAtPath:)%@", error.description);
        
    UIImage *image = [[[UIImage alloc] initWithCGImage:imgRef] autorelease];
    if ( image != nil ) {
        CFRelease(imgRef);
    }
    
    return image;
}

-(NSString*) getMovieFilePath {
    NSString* movieCache = [NSHomeDirectory() stringByAppendingString:@"moviecache"];
    
    movieCache = [NSString stringWithFormat:@"/%@/cache_%@.mp4", movieCache, self.mid];
    
    return [movieCache copy];
}

-(void) play {
    if ( self.status == MovieInfoStatusDownloaded || self.status == MovieInfoStatusStop ) {
        // 本地存在视频，播放
        self.status = MovieInfoStatusPlaying;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayingNotifcation" object:self];
    } else if ( self.status == MovieInfoStatusDownloading ) {
        // 视频下载中
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadingNotifcation" object:self];
    } else if ( self.status == MovieInfoStatusPause ) {
        self.status = MovieInfoStatusPlaying;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ContinueNotifcation" object:self];
    } else {
        // 开始下载视频
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadingNotifcation" object:self];
        self.status = MovieInfoStatusDownloading;
        
        [[NSMovieCache sharedInstance] requestMovie:self.mid url:self.url delegate:self];
    }
}

-(void) stop {
    if ( self.status == MovieInfoStatusPlaying ) {
        self.status = MovieInfoStatusStop;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StopNotifcation" object:self];
    }
}

-(void) pause {
    if ( self.status == MovieInfoStatusPlaying ) {
        self.status = MovieInfoStatusPause;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PauseNotifcation" object:self];
    }
}
@end
