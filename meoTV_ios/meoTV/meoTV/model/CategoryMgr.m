//
//  CategoryMgr.m
//  meoTV
//
//  Created by NPHD on 14-5-5.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "CategoryMgr.h"

@implementation CateInfo

- (id) init {
    [super init];
    
    self.imgUrl = nil;
    self.name = nil;
    self.cid = nil;
    
    return self;
}

- (void) dealloc {
    if ( self.imgUrl != nil ) {
        [self.imgUrl release];
    }
    
    if ( self.name != nil ) {
        [self.name release];
    }
    
    if ( self.cid != nil ) {
        [self.cid release];
    }
    
    [super dealloc];
}
@end


@implementation CategoryMgr

static CategoryMgr* _sCateMgr = nil;

+ (CategoryMgr*) sharedInstance {
    if ( _sCateMgr == nil ) {
        _sCateMgr = [[CategoryMgr alloc] init];
    }
    
    return _sCateMgr;
}

- (id) init {
    [super init];
    
    categoryArray = [[NSMutableArray alloc] init];
    tagArray = [[NSMutableArray alloc] init];
    
    // 测试数据
    CateInfo* info = [[CateInfo alloc]init];
    info.imgUrl = @"http://img1.gtimg.com/visual_page/bd/11/32086.jpg";
    info.name = @"测试1";
    info.cid = [NSNumber numberWithInt:1];
    [categoryArray addObject:info];

    info = [[CateInfo alloc]init];
    info.imgUrl = @"http://img1.gtimg.com/visual_page/bd/11/32086.jpg";
    info.name = @"测试2";
    info.cid = [NSNumber numberWithInt:2];
    [categoryArray addObject:info];
    
    info = [[CateInfo alloc]init];
    info.imgUrl = @"http://img1.gtimg.com/visual_page/bd/11/32086.jpg";
    info.name = @"测试3";
    info.cid = [NSNumber numberWithInt:3];
    [categoryArray addObject:info];
    
    info = [[CateInfo alloc]init];
    info.imgUrl = @"http://img1.gtimg.com/visual_page/bd/11/32086.jpg";
    info.name = @"测试4";
    info.cid = [NSNumber numberWithInt:4];
    [categoryArray addObject:info];
    
    info = [[CateInfo alloc]init];
    info.imgUrl = @"http://img1.gtimg.com/visual_page/bd/11/32086.jpg";
    info.name = @"测试5";
    info.cid = [NSNumber numberWithInt:5];
    [categoryArray addObject:info];
    //
    
    return self;
}

- (void) dealloc {
    if ( categoryArray != nil ) {
        [categoryArray release];
    }
    
    if ( tagArray != nil ) {
        [tagArray release];
    }
    
    [super dealloc];
}

- (void) requestCategoryList:(id) dele {
    //
    delegate = dele;
    
    [delegate categoryLoaded:categoryArray tag:tagArray];
}

@end
