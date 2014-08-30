//
//  KSDMovePathView.m
//  zaime
//
//  Created by 1528 MAC on 14-8-7.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "KSDMovePathView.h"
#import <CoreGraphics/CoreGraphics.h>
#import "config.h"
@implementation KSDMovePathView

+ (Class)layerClass
{
    return [CAEmitterLayer class];
}
- (void)clearReceiveFire
{
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    if(current-lastInvoke >= 2 && isReceiving)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
                isReceiving = NO;
                otherPoint = CGPointZero;
                [self hideParticle:@"xf"];
        });
    }
    
}
- (void)clearSelfFire
{
    MAIN(^{
    [self removeAnimation];
    });
    
}
- (void)removeAnimation
{
    [self.layer removeAnimationForKey:@"zhao"];
}
- (void)receiveEnd
{
   
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.privateQueue = dispatch_queue_create("zhizhenxiaochu", DISPATCH_QUEUE_CONCURRENT);
        self.clearReceive = [MSWeakTimer scheduledTimerWithTimeInterval:1
                                                                 target:self
                                                               selector:@selector(clearReceiveFire)
                                                               userInfo:nil
                                                                repeats:YES
                                                          dispatchQueue:self.privateQueue];
       
        myPoint = CGPointZero;
        otherPoint = CGPointZero;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEnd) name:kReceiveMoveEnd object:nil];
    }
    return self;
}

- (void)animationEmitter :(CGPoint)point
{
    CAEmitterLayer *emitterLayer = (CAEmitterLayer *)self.layer;         
    emitterLayer.emitterPosition = point;    // 坐标
    emitterLayer.emitterSize = self.bounds.size;            // 粒子大小
    emitterLayer.renderMode = kCAEmitterLayerAdditive;      // 递增渲染模式
    emitterLayer.emitterMode = kCAEmitterLayerPoints;       // 粒子发射模式（面发射）
	emitterLayer.emitterShape = kCAEmitterLayerSphere;      // 粒子形状（球状）
    
    // 星星粒子
    CAEmitterCell *cell1 = [self productEmitterCellWithContents:(id)[[UIImage imageNamed:@"star"] CGImage]];
    cell1.scale = 0.3;
    cell1.scaleRange = 0.1;
    
    // 圆粒子
    CAEmitterCell *cell2 = [self productEmitterCellWithContents:(id)[[UIImage imageNamed:@"cycle"] CGImage]];
    cell2.scale = 0.05;
    cell2.scaleRange = 0.02;
    
    emitterLayer.emitterCells = @[cell1, cell2];
    NSLog(@"animationEmitter");
}

- (CAEmitterCell *)productEmitterCellWithContents:(id)contents
{
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.birthRate = 120;       // 每秒产生粒子数
    cell.lifetime = 01;          // 每个粒子的生命周期
    cell.lifetimeRange = 0.3;
    cell.contents = contents;   // cell内容，一般是一个CGImage
    cell.velocity = 50;         // 粒子的发射方向
    cell.emissionLongitude = M_PI*2;
    cell.emissionRange = M_PI*2;
    cell.velocityRange = 10;
    cell.spin = 10;
    
    return cell;
}
- (void)hideParticle :(NSString*)animationKey
{
    CGPoint point = CGPointMake(-100, -100);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    CGPathAddCurveToPoint(path, NULL, point.x, point.y, point.x, point.y, point.x, point.y);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"emitterPosition"];
    animation.path = path;
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:animation forKey:animationKey];
    CGPathRelease(path);
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.clearSelf invalidate];
    [self removeAnimation];
    [self animationEmitter:[[touches anyObject] locationInView:self]];
    [self hideParticle:@"zhao"];
}
- (void)setMoving:(MovingAction)action
{
    moving = action;
}
- (void)setMeet:(MovingAction)action
{
    meet = action;
}
- (void)setEnd:(MovingAction)action
{
    end = action;
}
- (BOOL)isMeet
{
    if((otherPoint.x == kZero && otherPoint.y == kZero) || (myPoint.y == kZero && myPoint.x == kZero)) return NO;
    int offsetx = myPoint.x-otherPoint.x;
    int offsety = otherPoint.y-myPoint.y;
    if(offsetx < kZero) offsetx = -offsetx;
    if(offsety < kZero) offsety = -offsety;
    if(offsetx*offsetx+offsety*offsety< kShockSize)
    {
        return YES;
    }
    return NO;
}
- (void)addPoint:(CGPoint)point
{
    otherPoint = point;
    CAEmitterLayer *emitterLayer = (CAEmitterLayer *)self.layer;
    if(emitterLayer.emitterCells == nil)
    {
        [self animationEmitter:point];
    }
    isReceiving = YES;
    lastInvoke = [[NSDate date] timeIntervalSince1970];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    CGPathAddCurveToPoint(path, NULL, point.x, point.y, point.x, point.y, point.x, point.y);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"emitterPosition"];
    animation.path = path;
    animation.duration = 4;
    [self.layer addAnimation:animation forKey:@"xf"];
   
    if([self isMeet])
    {
        if(meet)
        {
            meet(point);
        }
    }
    CGPathRelease(path);
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint point = [[touches anyObject] locationInView:self];
    myPoint = point;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    CGPathAddCurveToPoint(path, NULL, point.x, point.y, point.x, point.y, point.x, point.y);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"emitterPosition"];
    animation.path = path;
    animation.duration = 4;
    animation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:animation forKey:@"zhao"];
    if(moving)
    {
        moving(point);
    }
    if([self isMeet])
    {
        if(meet)
        {
            meet(point);
        }
    }
    CGPathRelease(path);
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
     myPoint = CGPointZero;
    KSDLog(@"touchesEnded");
    [self hideParticle :@"zhao"];
    self.clearSelf = [MSWeakTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(clearSelfFire)
                                                        userInfo:nil
                                                         repeats:YES
                                                   dispatchQueue:self.privateQueue];
    if(end)
    {
        end(myPoint);
    }
   
}

@end
