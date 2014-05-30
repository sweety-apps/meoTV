//
//  Content.h
//  dianZan
//
//  Created by NPHD on 14-5-28.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

enum ContentType {
    ContentTypeGif = 0,
    ContentTypeImage = 1,
    ContentTypeMovie = 2
};

enum ContentStatus {
    ContentStatusNone  = 0, // 内容的下载状态。未知
    ContentStatusDownloading,    // 下载中
    ContentStatusDownloadFailed,    // 下载失败
    ContentStatusHasFile,    // 下载成功，文件已经存在本地
};

@protocol ContentDelegate <NSObject>
-(void) ContentStatusChanged : (enum ContentStatus) status;
@end

@interface Content : NSObject <ASIHTTPRequestDelegate> {
    id _delegate;
}

@property (nonatomic, retain) NSString* title;      // 标题
@property (nonatomic, retain) NSString* url;        // 内容对在的位置
@property enum                ContentType cType;    // 内容的类型
@property                     long      cid;        // 内容的id号
@property enum                ContentStatus cStatus;

- (void) setDelegate:(id) delegate;
- (NSString*) getContentPath;   // 获取内容所在的路径，如果内容不存在，则开始下载

@end
