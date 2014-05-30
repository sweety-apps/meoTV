//
//  UIMovieViewCell.m
//  Test
//
//  Created by NPHD on 14-4-28.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "UIMovieViewCell.h"

@implementation UIMovieViewCell

static MPMoviePlayerController* sMoviePlayerController = nil;   //

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        mInfo = nil;
        
        UIView* rootView = [[[NSBundle mainBundle] loadNibNamed:@"UIMovieViewCell" owner:self options:nil] firstObject];
        
        [self.contentView addSubview:rootView];
        
        [rootView release];
        
        movieImage = (UIImageView*)[rootView viewWithTag:11];
        movieBkgView = (UIView*)[rootView viewWithTag:12];
    }
    return self;
}

- (void)dealloc {
    [movieImage release];
    if ( mInfo != nil ) {
        [mInfo release];
    }
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void) setMovieInfo:(MovieInfo*) info {
    if ( mInfo != nil ) {
        [mInfo release];
    }
    
    if ( mInfo != nil ) {
        // 解除绑定的事件
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ThumbChangedNotifcation" object:mInfo];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PlayingNotifcation" object:mInfo];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DownloadingNotifcation" object:mInfo];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"StopNotifcation" object:mInfo];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ContinueNotifcation" object:mInfo];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PauseNotifcation" object:mInfo];
    }
    
    mInfo = [info retain];
    
    [movieImage setImage:mInfo.thumb];  // 设置缩略图
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movieThumbnailComplete:) name:@"ThumbChangedNotifcation" object:mInfo];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PlayingNotifcation:) name:@"PlayingNotifcation" object:mInfo];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DownloadingNotifcation:) name:@"DownloadingNotifcation" object:mInfo];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(StopNotifcation:) name:@"StopNotifcation" object:mInfo];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ContinueNotifcation:) name:@"ContinueNotifcation" object:mInfo];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PauseNotifcation:) name:@"PauseNotifcation" object:mInfo];
    
    MPMoviePlayerController* pController = sMoviePlayerController;
    
    if ( mInfo.status == MovieInfoStatusPlaying ) {
        NSString* filePath = [mInfo getMovieFilePath];
        pController.contentURL = [NSURL fileURLWithPath:filePath];
        
        [pController setCurrentPlaybackTime:mInfo.time];
        [pController play];
        [filePath release];
        [movieBkgView addSubview:pController.view];
    } else {
        if ( [pController.view.superview isEqual:movieBkgView] ) {
            [pController.view removeFromSuperview];
        }
    }
}

-(void) StopNotifcation:(NSNotification*)notification {
    [self stop];
}

-(void) PlayingNotifcation:(NSNotification*)notification {
    [self play];
}

-(void) DownloadingNotifcation:(NSNotification*)notification {
    // 进入下载
}

-(void) movieThumbnailComplete:(NSNotification*)notification {
    [movieImage setImage:mInfo.thumb];  // 设置缩略图
}

- (void) play {
    sMoviePlayerController = [[MPMoviePlayerController alloc] init];

    for ( UIView* sub in sMoviePlayerController.view.subviews) {
        sub.backgroundColor = [UIColor clearColor];
    }
    
    [sMoviePlayerController.view setBackgroundColor:[UIColor clearColor]];
    
    
    [sMoviePlayerController.view setFrame:CGRectMake(0, 0, 300, 300)];
    
    [sMoviePlayerController setControlStyle:MPMovieControlModeDefault];
    sMoviePlayerController.repeatMode = MPMovieRepeatModeNone;
    [sMoviePlayerController setFullscreen:NO];
    [sMoviePlayerController setInitialPlaybackTime:mInfo.time];
    
    [sMoviePlayerController setCurrentPlaybackTime:mInfo.time];
    
    NSString* filePath = [mInfo getMovieFilePath];
    
    sMoviePlayerController.contentURL = [NSURL fileURLWithPath:filePath];
    
    [sMoviePlayerController play];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayerPlaybackFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:sMoviePlayerController];
    
    [filePath release];

    [movieBkgView addSubview:sMoviePlayerController.view];
}

- (void) stop {
    // 在当前时间点做截屏
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:sMoviePlayerController];
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayerPlaybackStateChanged:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:sMoviePlayerController];
    
    [sMoviePlayerController pause];

    [mInfo createThumbImageFromFile:sMoviePlayerController.currentPlaybackTime];
    [sMoviePlayerController.view removeFromSuperview];
    [movieImage setImage:mInfo.thumb];
    
    sMoviePlayerController = nil;
}

-(void) moviePlayerPlaybackFinish:(NSNotification*)notification {
    [sMoviePlayerController setInitialPlaybackTime:0];
    [sMoviePlayerController play];
}

-(void) ContinueNotifcation:(NSNotification*)notification {
    [sMoviePlayerController play];
}

-(void) PauseNotifcation:(NSNotification*)notification {
    [sMoviePlayerController pause];
}


/*
-(void) moviePlayerPlaybackStateChanged:(NSNotification*)notification {
    MPMoviePlayerController* player = (MPMoviePlayerController*) [notification object];
    
    if ( player.playbackState == MPMoviePlaybackStatePaused ) {
        [mInfo createThumbImageFromFile:player.currentPlaybackTime];
        [player.view removeFromSuperview];
        [movieImage setImage:mInfo.thumb];
    
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
    
        [player release];
        player = nil;
    }
}
*/
@end
