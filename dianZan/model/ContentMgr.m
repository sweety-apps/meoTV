//
//  ContentMgr.m
//  dianZan
//
//  Created by NPHD on 14-5-28.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "ContentMgr.h"
#import "Content.h"

@implementation ContentMgr

static ContentMgr* sSharedInstance = nil;

+ (ContentMgr*) sharedInstance {
    if ( sSharedInstance == nil ) {
        sSharedInstance = [[ContentMgr alloc] init];
    }
    return sSharedInstance;
}

- (id) init {
    self = [super init];
    
    NSString* cache = [NSHomeDirectory() stringByAppendingString:@"/cache"];
    [[NSFileManager defaultManager] createDirectoryAtPath:cache withIntermediateDirectories:NO attributes:nil error:nil];
    
    _contentArray = [[NSMutableArray alloc] init];
    
    [self test];
    
    return self;
}

-  (void)dealloc {
    if ( _contentArray != nil ) {
        [_contentArray release];
        _contentArray = nil;
    }
    
    [super dealloc];
}

- (void) test {
    for ( int i = 0; i < 4; i ++ ) {
        Content* content = [[[Content alloc] init] autorelease];
        
        content.cid = i + 1;
        content.title = [NSString stringWithFormat:@"title %d", i];
        
        if ( i == 0 ) {
            content.url = @"http://www.getwangcai.com/app/beta_ver/test/1.jpg";
            content.cType = ContentTypeImage;
        } else if ( i == 1 ) {
            content.url = @"http://www.getwangcai.com/app/beta_ver/test/2.gif";
            content.cType = ContentTypeGif;
        } else if ( i == 2 ) {
            content.url = @"http://www.getwangcai.com/app/beta_ver/test/3.jpg";
            content.cType = ContentTypeImage;
        } else if ( i == 3 ) {
            content.url = @"http://www.getwangcai.com/app/beta_ver/test/4.jpg";
            content.cType = ContentTypeImage;
        }
 
        [_contentArray addObject:content];
    }
}

- (int) getCount {
    return [_contentArray count];
}

- (Content*) getContent:(int) index {
    if ( index >= [_contentArray count] || index < 0 ) {
        return nil;
    }
    
    return [_contentArray objectAtIndex:index];
}

@end
