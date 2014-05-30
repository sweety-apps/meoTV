//
//  CategoryMgr.h
//  meoTV
//
//  Created by NPHD on 14-5-5.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CategoryMgrDelegate <NSObject>

- (void)categoryLoaded: (NSArray*) categoryArray tag:(NSArray*) tagArray;

@end

@interface CateInfo : NSObject {
    
}

@property (nonatomic,retain) NSString* imgUrl;
@property (nonatomic,retain) NSString* name;
@property (nonatomic,retain) NSNumber* cid;
@end

@interface CategoryMgr : NSObject {
    NSMutableArray* categoryArray;
    NSMutableArray* tagArray;
    
    id delegate;
}

+ (CategoryMgr*) sharedInstance;

- (void) requestCategoryList:(id) dele;

@end
