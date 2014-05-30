//
//  UIMovieViewController.h
//  Test
//
//  Created by NPHD on 14-4-28.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieInfo.h"
#import "NSMovieMgr.h"

@interface UIMovieViewController : UITableViewController {
    NSTimer* timer;
    float    scrollPos;
    float    clickPos;
    MovieInfo*  curDisplay;
}

@end
