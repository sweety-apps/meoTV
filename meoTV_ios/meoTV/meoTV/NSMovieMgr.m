//
//  NSMovieMgr.m
//  Test
//
//  Created by NPHD on 14-4-28.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "NSMovieMgr.h"
#import "NSMovieCache.h"

@implementation NSMovieMgr

static NSMovieMgr* _sharedInstance = nil;

+(id) sharedInstance {
    if ( _sharedInstance == nil ) {
        _sharedInstance = [[NSMovieMgr alloc]init];
    }
    return _sharedInstance;
}

- (id) init {
    [super init];
    
    movieArray = [[NSMutableArray alloc] init];
    
    for ( int i = 1; i < 18; i ++ ) {
        MovieInfo* info = [[[MovieInfo alloc] init] autorelease];
        
        info.url = [NSString stringWithFormat:@"http://192.168.2.9/%d.mp4", i];
        info.mid = [NSNumber numberWithInt:i];
        info.thumb = nil;
        info.time = 0;
        
        [info createThumbImageFromFile:0];

        [movieArray addObject:info];
    }
    
    return self;
}

-(int) getCount {
    return [movieArray count];
}

-(id) getMovieInfo:(int) nindex {
    return [movieArray objectAtIndex:nindex];
}

@end
