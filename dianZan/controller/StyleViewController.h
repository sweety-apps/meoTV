//
//  StyleViewController.h
//  dianZan
//
//  Created by NPHD on 14-5-30.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StyleViewControllerDelegate <NSObject>
- (void) onHideStyleView;
- (void) onShowStyleView;
- (void) onDragStyleView:(UIPanGestureRecognizer*) rec;
@end

@interface StyleViewController : UIViewController <UIGestureRecognizerDelegate> {
    int _beginDrag;
    id  _delegate;
}

- (void) setDelegate:(id) delegate;

@end
