//
//  KSDCanvas.m
//  zaime
//
//  Created by 1528 MAC on 14-8-19.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "KSDCanvas.h"
#import "MSWeakTimer.h"
#import "UIView+PartialRoundedCorner.h"

@interface KSDCanvas()

@property (strong, nonatomic) MSWeakTimer *backgroundTimer;
@property (strong, nonatomic) dispatch_queue_t privateQueue;

@end

@implementation KSDCanvas

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.privateQueue = dispatch_queue_create("com.mindsnacks.private_queue", DISPATCH_QUEUE_CONCURRENT);
        
        self.backgroundTimer = [MSWeakTimer scheduledTimerWithTimeInterval:5
                                                                    target:self
                                                                  selector:@selector(backgroundTimerDidFire)
                                                                  userInfo:nil
                                                                   repeats:YES
                                                             dispatchQueue:self.privateQueue];
        lastInvoke = [[NSDate date] timeIntervalSince1970];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
        data = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)backgroundTimerDidFire
{
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    if(current-lastInvoke >= 10)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clear];
        });
    }
}
- (void)setMoveing:(MovingAction)action
{
    moving = action;
}
- (void)addLine :(CGPoint)point
{
    lastInvoke = [[NSDate date] timeIntervalSince1970];
    UIView *aview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    aview.center = point;
    aview.backgroundColor = RGBCOLOR(207, 213, 217);
    aview.alpha = 0.6;
    [self addSubview:aview];
    [data addObject:aview];
   // [self setNeedsDisplay];
}
/*- (void)drawRect:(CGRect)rect
{
    //获取当前上下文，
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 10.0f);
    //线条拐角样式，设置为平滑
    CGContextSetLineJoin(context,kCGLineJoinRound);
    //线条开始样式，设置为平滑
    CGContextSetLineCap(context, kCGLineJoinRound);

    //画当前的线
    if ([points count]>0)
    {
        CGContextBeginPath(context);
        CGPoint myStartPoint=CGPointFromString([points objectAtIndex:0]);
        CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
        
//        for (int j=0; j<[points count]-1; j++)
//        {
//            CGPoint myEndPoint=CGPointFromString([points objectAtIndex:j+1]);
//            CGContextAddRect(context,CGRectMake(myEndPoint.x, myEndPoint.y, 10, 10));
//            CGContextFillPath(context);
//        }
        for (int j=0; j<[points count]-1; j++)
        {
            CGPoint myEndPoint=CGPointFromString([points objectAtIndex:j+1]);
            //--------------------------------------------------------
            // CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
           // CGContextAddEllipseInRect(context,CGRectMake(myEndPoint.x, myEndPoint.y, 10, 10));
            //--------------------------------------------------------
             CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
           // CGContextFillPath(context);
        }
        CGContextSetStrokeColorWithColor(context,[UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 10);
        CGContextStrokePath(context);
    }
    
    
}
 */
- (void)tap :(UITapGestureRecognizer*)tapGes
{
   
//	CGPoint point = [tapGes locationInView:self];
//    UIView *aview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//    aview.center = point;
//    aview.backgroundColor =  RGBCOLOR(207, 213, 217);
//    aview.alpha = 0.6;
//    [aview setCornerRadius:10 direction:UIViewPartialRoundedCornerDirectionAll];
//    [self addSubview:aview];
//    if(moving)
//    {
//        moving(point);
//    }
//    [data addObject:aview];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch=[touches anyObject];
	CGPoint point =[touch locationInView:self];
    
    if(moving)
    {
        moving(point);
    }
    [self addLine:point];
   
}
- (void)addPoint:(CGPoint)point
{
    [self addLine:point];
}
- (void)hideView :(UIView*)sub
{
    [UIView animateWithDuration:0.01 animations:^{
        sub.alpha = 0;
    } completion:^(BOOL finished) {
        [sub removeFromSuperview];
        [data removeObject:sub];
        
    }];
    
}
- (void)clear
{
    
        int i = 1;
        for (UIView *sub in data)
        {
            [self performSelector:@selector(hideView:) withObject:sub afterDelay:0.01*i];
            i++;
        }
        [UIView animateWithDuration:data.count*0.01 animations:^{
            for (UIView *sub in data)
            {
            
                sub.alpha = 0;
            
            }
        } completion:nil];

    
    
}
- (void)dealloc
{
    [self.backgroundTimer invalidate];
}
@end
