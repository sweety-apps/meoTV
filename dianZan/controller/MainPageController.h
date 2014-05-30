//
//  MainPageController.h
//  dianZan
//
//  Created by NPHD on 14-5-27.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"
#import "StyleViewController.h"

@interface MainPageController : UIViewController <UIGestureRecognizerDelegate, StyleViewControllerDelegate> {
    ContentViewController* _firstContent;
    ContentViewController* _secondContent;
    ContentViewController* _thirdContent;
    
    int                    _curIndex;
    
    NSTimeInterval         _beginDrag;
    
    BOOL                   _switchView;
    
    StyleViewController*   _styleView;
    
    BOOL                   _showStyle;
}

@property (nonatomic, retain) IBOutlet UIView* _contentView;

-(IBAction) onClickStyle:(id)sender;

@end
