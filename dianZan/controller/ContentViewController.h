//
//  ContentViewController.h
//  dianZan
//
//  Created by NPHD on 14-5-27.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Content.h"
#import "ContentOperateController.h"

@interface ContentViewController : UIViewController {
    Content* _content;
    
    ContentOperateController* _operate;
    
    id _contentView;
}

- (void) setContent:(Content*) content;
- (Content*) getContent;

- (NSString*) getTitle;

@end
