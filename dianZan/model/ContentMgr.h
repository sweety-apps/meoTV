//
//  ContentMgr.h
//  dianZan
//
//  Created by NPHD on 14-5-28.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Content.h"

@interface ContentMgr : NSObject {
    NSMutableArray* _contentArray;
}

+ (ContentMgr*) sharedInstance;

- (int) getCount;
- (Content*) getContent:(int) index;

@end
