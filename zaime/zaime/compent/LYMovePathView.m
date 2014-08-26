//
//  LYMovePathView.m
//  TestAnimation
//
//  Created by Liuyu on 14-6-19.
//  Copyright (c) 2014年 Liuyu. All rights reserved.
//

#import "LYMovePathView.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation LYMovePathView

+ (Class)layerClass
{
    return [CAEmitterLayer class];
}
- (void)backgroundTimerDidFire
{
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    if(current-lastInvoke >= 2)
    {
        dispatch_async(dispatch_get_main_queue(), ^{

            CGPoint point = CGPointMake(-100, -100);
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, point.x, point.y);
            CGPathAddCurveToPoint(path, NULL, point.x, point.y, point.x, point.y, point.x, point.y);
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"emitterPosition"];
            animation.path = path;
            animation.duration = 4;
            animation.repeatCount = MAXFLOAT;
            [self.layer addAnimation:animation forKey:@"zhao"];
            [self performSelector:@selector(removeAnimation) withObject:nil afterDelay:1];
        });
    }
}
- (void)removeAnimation
{
    CAEmitterLayer *emitterLayer = (CAEmitterLayer *)self.layer;
    emitterLayer.emitterCells = nil;
    [self.layer removeAnimationForKey:@"zhao"];
}
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
}

- (CAEmitterCell *)productEmitterCellWithContents:(id)contents
{
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.birthRate = 120;       // 每秒产生粒子数
    cell.lifetime = 1;          // 每个粒子的生命周期
    cell.lifetimeRange = 0.3;
    cell.contents = contents;   // cell内容，一般是一个CGImage
    cell.color = [[UIColor lightGrayColor] CGColor];
    cell.velocity = 50;         // 粒子的发射方向
    cell.emissionLongitude = M_PI*2;
    cell.emissionRange = M_PI*2;
    cell.velocityRange = 10;
    cell.spin = 10;
    
    return cell;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CAEmitterLayer *emitterLayer = (CAEmitterLayer *)self.layer;
    if(emitterLayer.emitterCells == nil)
    {
        [self animationEmitter:[[touches anyObject] locationInView:self]];
    }
    
    CGPoint point = CGPointMake(-100, -100);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    CGPathAddCurveToPoint(path, NULL, point.x, point.y, point.x, point.y, point.x, point.y);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"emitterPosition"];
    animation.path = path;
    animation.duration = 4;
    animation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:animation forKey:@"zhao"];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    lastInvoke = [[NSDate date] timeIntervalSince1970];
    [self.layer removeAllAnimations];
    CGPoint point = [[touches anyObject] locationInView:self];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    CGPathAddCurveToPoint(path, NULL, point.x, point.y, point.x, point.y, point.x, point.y);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"emitterPosition"];
    animation.path = path;
    animation.duration = 4;
    animation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:animation forKey:@"zhao"];
}

@end
