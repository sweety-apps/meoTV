//
//  MyView.m
//  zaime
//
//  Created by 1528 MAC on 14-8-14.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "KSDDrawView.h"
#import "MSWeakTimer.h"
@interface KSDDrawView()
{
     NSTimeInterval lastInvoke;
    CGFloat alaph;
}
@property (strong, nonatomic) MSWeakTimer *backgroundTimer;
@property (strong, nonatomic) MSWeakTimer *clearTimer;
@property (strong, nonatomic) dispatch_queue_t privateQueue;

@end
@implementation KSDDrawView
static float lineWidthArray[4] = {10.0,20.0,30.0,40.0};
- (id)init
{
    self = [super init];
    if (self) {
     
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        WidthArray=[[NSMutableArray alloc]init];
        deleWidthArray=[[NSMutableArray alloc]init];
        pointArray=[[NSMutableArray alloc]init];
        receivePointArray = [[NSMutableArray alloc]init];
        lineArray=[[NSMutableArray alloc]init];
        deleArray=[[NSMutableArray alloc]init];
        colorArray=[[NSMutableArray alloc]init];
        colors = [[NSMutableArray alloc]initWithObjects:[UIColor blackColor],[UIColor greenColor],[UIColor blueColor],[UIColor redColor],[UIColor whiteColor], nil];
        deleColorArray=[[NSMutableArray alloc]init];
        colorCount=0;
        widthCount=0;
        lastReceivePoint = CGPointMake(-1, -1);
        
        self.privateQueue = dispatch_queue_create("com.mindsnacks.private_queue", DISPATCH_QUEUE_CONCURRENT);
        
        self.backgroundTimer = [MSWeakTimer scheduledTimerWithTimeInterval:5
                                                                    target:self
                                                                  selector:@selector(backgroundTimerDidFire)
                                                                  userInfo:nil
                                                                   repeats:YES
                                                             dispatchQueue:self.privateQueue];
        alaph = 1.f;
    }
    return self;
}
- (void)backgroundTimerDidFire
{
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    if(current-lastInvoke >= 10)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.clearTimer = [MSWeakTimer scheduledTimerWithTimeInterval:0.2
                                                                   target:self
                                                                 selector:@selector(fade)
                                                                 userInfo:nil
                                                                  repeats:YES
                                                            dispatchQueue:self.privateQueue];
        });
    }
}
- (void)fade
{
    MAIN(^{
        alaph -= 0.2;
        if(alaph < 0)
        {
            alaph = 1.f;
            [self.clearTimer invalidate];
            self.clearTimer = nil;
            [self clear];
        }
        NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
        if(current-lastInvoke < 10)
        {
            alaph = 1.f;
            [self.clearTimer invalidate];
            self.clearTimer = nil;
        }
        [self setNeedsDisplay];
       
    });
}
//给界面按钮操作时获取tag值作为width的计数。来确定宽度，颜色同理
-(void)setlineWidth:(PenWidthType)type
{
    widthCount = type;
}
- (void)setMovingAction:(KSDMovingAction)action
{
    moving = action;
}
- (void)addPoint:(CGPoint)point
{
    lastInvoke = [[NSDate date] timeIntervalSince1970];
    MAIN(^{
        if(lastReceivePoint.x != -1&&(fabs(lastReceivePoint.x - point.x)*fabs(lastReceivePoint.x - point.x) + fabs(lastReceivePoint.y - point.y)*fabs(lastReceivePoint.y - point.y) > 25))
        {
            
            [self addLA];
        }
        lastReceivePoint = point;
        NSString *sPoint=NSStringFromCGPoint(point);
        [receivePointArray addObject:sPoint];
        [self setNeedsDisplay];
        
    });
}
-(void)setLineColor:(ColorType)type
{
    colorCount = type;
}
- (void)drawLine :(NSArray*)source :(NSInteger)width :(UIColor*)color :(CGContextRef)context
{
    CGContextBeginPath(context);
    CGContextSetAlpha(context,alaph);
    CGPoint myStartPoint=CGPointFromString([source objectAtIndex:0]);
    CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
    
    for (int j=0; j<[source count]-1; j++)
    {
        CGPoint myEndPoint=CGPointFromString([source objectAtIndex:j+1]);
        CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
    }
    CGContextSetStrokeColorWithColor(context,color.CGColor);
    CGContextSetLineWidth(context, width);
    CGContextStrokePath(context);
    
}
- (void)reDrawHistory :(CGContextRef)context
{
    if ([lineArray count]>0)
    {
        for (int i=0; i<[lineArray count]; i++)
        {
            NSArray * array=[NSArray arrayWithArray:[lineArray objectAtIndex:i]];
            if ([array count]>0)
            {
                [self drawLine:array :lineWidthArray[widthCount] :colors[colorCount] :context];
            }
        }
    }
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, lineWidthArray[widthCount]);
    CGContextSetLineJoin(context,kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    [self reDrawHistory:context];

    if ([pointArray count]>0)
    {
        [self drawLine :pointArray:lineWidthArray[widthCount] :colors[colorCount] :context];
    }
    
    if ([receivePointArray count]>0)
    {
        [self drawLine:receivePointArray:lineWidthArray[widthCount] :colors[colorCount] :context];
    }

     
}
//在touch结束前将获取到的点，放到pointArray里
-(void)addPA:(CGPoint)nPoint{
    NSString *sPoint=NSStringFromCGPoint(nPoint);
    [pointArray addObject:sPoint];
}
//在touchend时，将已经绘制的线条的颜色，宽度，线条线路保存到数组里
-(void)addLA{
    NSNumber *wid=[[NSNumber alloc]initWithInt:lineWidthArray[widthCount]];
    [colorArray addObject:[colors objectAtIndex:colorCount]];
    [WidthArray addObject:wid];
    NSArray *array=[NSArray arrayWithArray:pointArray];
    [lineArray addObject:array];
    
    NSArray *array1 = [NSArray arrayWithArray:receivePointArray];
    [lineArray addObject:array1];
    
    pointArray=[[NSMutableArray alloc]init];
    receivePointArray = [[NSMutableArray alloc]init];
}

#pragma mark -
//手指开始触屏开始
static CGPoint MyBeganpoint;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{	
}
//手指移动时候发出
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    lastInvoke = [[NSDate date] timeIntervalSince1970];
    UITouch* touch=[touches anyObject];
	MyBeganpoint=[touch locationInView:self];
    NSString *sPoint=NSStringFromCGPoint(MyBeganpoint);
    [pointArray addObject:sPoint];
    [self setNeedsDisplay];
    if(moving)
    {
        moving(MyBeganpoint);
    }
}
//当手指离开屏幕时候
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
     [self addLA];
    NSLog(@"touches end");
}
//电话呼入等事件取消时候发出
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touches Canelled");
}
//撤销，将当前最后一条信息移动到删除数组里，方便恢复时调用
-(void)revocation{
    if ([lineArray count]) {
        [deleArray addObject:[lineArray lastObject]];
        [lineArray removeLastObject];
    }
    if ([colorArray count]) {
        [deleColorArray addObject:[colorArray lastObject]];
        [colorArray removeLastObject];
    }
    if ([WidthArray count]) {
        [deleWidthArray addObject:[WidthArray lastObject]];
        [WidthArray removeLastObject];
    }
    //界面重绘方法
    [self setNeedsDisplay];
}
//将删除线条数组里的信息，移动到当前数组，在主界面重绘
-(void)refrom{
    if ([deleArray count]) {
        [lineArray addObject:[deleArray lastObject]];
        [deleArray removeLastObject];
    }
    if ([deleColorArray count]) {
        [colorArray addObject:[deleColorArray lastObject]];
        [deleColorArray removeLastObject];
    }
    if ([deleWidthArray count]) {
        [WidthArray addObject:[deleWidthArray lastObject]];
        [deleWidthArray removeLastObject];
    }
    [self setNeedsDisplay];
     
}
-(void)clear{
    //移除所有信息并重绘
   [deleArray removeAllObjects];
    [deleColorArray removeAllObjects];
    colorCount=0;
    [colorArray removeAllObjects];
    [lineArray removeAllObjects];
    [pointArray removeAllObjects];
    [receivePointArray removeAllObjects];
    [deleWidthArray removeAllObjects];
    widthCount=0;
    [WidthArray removeAllObjects];
    [self setNeedsDisplay];
}
@end
