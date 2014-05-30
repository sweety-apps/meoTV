//
//  UIMovieViewCell.h
//  Test
//
//  Created by NPHD on 14-4-28.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSMovieMgr.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface UIMovieViewCell : UITableViewCell {
    MovieInfo* mInfo;
    UIImageView*   movieImage;
    UIView*        movieBkgView;
}

- (void) setMovieInfo:(MovieInfo*) info;

- (void) play;
- (void) stop;

@end
