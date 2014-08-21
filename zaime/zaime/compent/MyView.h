//
//  MyView.h
//  zaime
//
//  Created by 1528 MAC on 14-8-14.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^KSDMovingAction)(CGPoint point);
@interface MyView : UIView
{
    KSDMovingAction moving;
    CGPoint lastReceivePoint;
}
// get point  in view
-(void)addPA:(CGPoint)nPoint;
-(void)addLA;
-(void)revocation;
-(void)refrom;
-(void)clear;
-(void)setLineColor:(NSInteger)color;
-(void)setlineWidth:(NSInteger)width;

- (void)setMovingAction :(KSDMovingAction)action;
- (void)addPoint:(CGPoint)point;
@end
