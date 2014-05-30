//
//  ContentView.h
//  dianZan
//
//  Created by NPHD on 14-5-29.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Content.h"

@protocol ContentViewInterface
- (void) setFilePath:(NSString*) filePath;
- (BOOL) isBigImage;        // 需要用大图模式显示
- (UIView*) getView;        // 获取视图

- (BOOL) isPlay;            // 只对视频有效
- (void) play;              // 只对视频有效
- (void) stop;              // 只对视频有效
@end

@interface ContentView : NSObject {
    
}

+ (id) loadContentFromPath:(NSString*) filePath Type:(enum ContentType) type;

@end
