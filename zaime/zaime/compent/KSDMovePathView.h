//
//  KSDMovePathView.h
//  zaime
//
//  Created by 1528 MAC on 14-8-7.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSWeakTimer.h"

typedef void(^MovingAction)(CGPoint point);
@interface KSDMovePathView : UIView
{
    NSTimeInterval lastInvoke;
    MovingAction moving;
    MovingAction meet;
    MovingAction end;
    CGPoint myPoint;
    CGPoint otherPoint;
    BOOL isReceiving;
    BOOL isFirstReceiving;
}
@property (strong, nonatomic) MSWeakTimer *clearReceive;
@property (strong, nonatomic) MSWeakTimer *clearSelf;
@property (strong, nonatomic) dispatch_queue_t privateQueue;

- (void)addPoint :(CGPoint)point;
- (void)setMoving :(MovingAction)action;
- (void)setMeet :(MovingAction)action;
- (void)setEnd :(MovingAction)action;
@end
