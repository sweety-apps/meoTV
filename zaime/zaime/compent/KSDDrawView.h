//
//  MyView.h
//  zaime
//
//  Created by 1528 MAC on 14-8-14.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^KSDMovingAction)(CGPoint point);
typedef void(^KSDClearHandler)(CGPoint point);
typedef enum{
    BlackColour,
    GreenColour,
    BlueColor,
    RedColor
}ColorType;
typedef enum{
    PenWidthTen,
    PenWidthTwenty,
    PenWidthThirty,
    PenWidthForty
}PenWidthType;
@interface KSDDrawView : UIView
{
    KSDMovingAction moving;
    KSDClearHandler handler;
    CGPoint lastReceivePoint;
    ColorType colorCount;
    PenWidthType widthCount;
    
    //保存线条颜色
    NSMutableArray *colors;
    //画笔颜色
     NSMutableArray *colorArray;
    //保存被移除的线条颜色
    NSMutableArray *deleColorArray;
    //每次触摸结束前经过的点，形成线的点数组
    NSMutableArray *pointArray;
    NSMutableArray *receivePointArray;
    //每次触摸结束后的线数组
     NSMutableArray *lineArray;
    //删除的线的数组，方便重做时取出来
     NSMutableArray *deleArray;
    //线条宽度的数组
    
    //删除线条时删除的线条宽度储存的数组
    NSMutableArray *deleWidthArray;
    //正常存储的线条宽度的数组
    NSMutableArray *WidthArray;
}
// get point  in view
-(void)addPA:(CGPoint)nPoint;
-(void)addLA;
-(void)revocation;
-(void)refrom;
-(void)clear;
-(void)setLineColor:(ColorType)type;
-(void)setlineWidth:(PenWidthType)type;

- (void)setMovingAction :(KSDMovingAction)action;
- (void)setClearHandler :(KSDClearHandler)action;
- (void)addPoint:(CGPoint)point;
@end
