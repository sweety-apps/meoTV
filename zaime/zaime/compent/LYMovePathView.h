//
//  LYMovePathView.h
//  TestAnimation
//
//  Created by Liuyu on 14-6-19.
//  Copyright (c) 2014年 Liuyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSWeakTimer.h"
@interface LYMovePathView : UIView
{
    NSTimeInterval lastInvoke;
}
@property (strong, nonatomic) MSWeakTimer *backgroundTimer;
@property (strong, nonatomic) dispatch_queue_t privateQueue;

@end
