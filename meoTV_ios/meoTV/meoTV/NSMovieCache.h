//
//  NSMovieCache.h
//  Test
//
//  Created by NPHD on 14-4-28.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NSMovieCacheDelegate <NSObject>
-(void) downloadCompleted : (NSNumber*) nid url:(NSString*)url filePath:(NSString*)filePath suc:(BOOL) suc;
@end

@interface MovieDownload : NSObject<NSURLConnectionDataDelegate> {
    NSMutableData* mutdata;
    NSURLConnection* connect;
}

@property (nonatomic,retain) NSNumber* nid;
@property (nonatomic,retain) NSString* url;
@property (nonatomic,retain) NSMutableArray* delegates;
@property (nonatomic,retain) NSString* filePath;
@property (nonatomic,retain) NSObject* userObj;

- (void) downloadFile;
@end





@interface NSMovieCache : NSObject {
    NSMutableArray* downloadArray;
}

+(id) sharedInstance;

-(NSString*) requestMovie:(NSNumber*) nid  url:(NSString*) url delegate:(id) delegate;

-(void) fire_event:(MovieDownload*) info suc:(BOOL) suc;

@end
