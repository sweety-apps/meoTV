//
//  MovieInfo.h
//  Test
//
//  Created by NPHD on 14-4-29.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
    MovieInfoStatusNotFile, // 视频文件不存在
    MovieInfoStatusDownloading, // 视频文件下载中
    MovieInfoStatusDownloadFailed,  // 视频下载失败
    MovieInfoStatusDownloaded,  // 视频下载完成，这个时候应该存在了截图
    MovieInfoStatusPlaying,     // 视频播放中
    MovieInfoStatusPause,       // 暂停
    MovieInfoStatusStop,     // 视频停止
} MovieInfoStatus;


@interface MovieInfo : NSObject {
}

@property (nonatomic,retain) NSString* url;
@property (nonatomic,retain) NSNumber* mid;
@property (nonatomic,retain) UIImage* thumb;     // 视频截图
@property NSTimeInterval time;          // 视频停止时播放到的时间
@property MovieInfoStatus status;

-(void) createThumbImageFromFile:(NSTimeInterval) time;

-(NSString*) getMovieFilePath;

-(void) play;
-(void) stop;
-(void) pause;
@end