//
//  NSMovieMgr.h
//  Test
//
//  Created by NPHD on 14-4-28.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieInfo.h"

@interface NSMovieMgr : NSObject {
    NSMutableArray* movieArray;
}

+(id) sharedInstance;

-(int) getCount;
-(id) getMovieInfo:(int) nindex;

@end

