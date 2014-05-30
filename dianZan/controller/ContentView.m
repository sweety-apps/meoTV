//
//  ContentView.m
//  dianZan
//
//  Created by NPHD on 14-5-29.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "ContentView.h"
#import "ImageController.h"
#import "GifController.h"
#import "MovieController.h"

@interface ContentView ()

@end

@implementation ContentView

+ (id) loadContentFromPath:(NSString*) filePath Type:(enum ContentType) type {
    id ret = nil;
    if ( type == ContentTypeGif ) {
        ret = [[GifController alloc] initWithNibName:nil bundle:nil];
    } else if ( type == ContentTypeImage ) {
        ret = [[ImageController alloc] initWithNibName:nil bundle:nil];
    } else if ( type == ContentTypeMovie ) {
        ret = [[MovieController alloc] initWithNibName:nil bundle:nil];
    }
    
    [ret setFilePath:filePath];
    
    return ret;
}

@end
