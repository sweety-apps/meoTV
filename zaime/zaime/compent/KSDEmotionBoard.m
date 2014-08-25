//
//  EmotionBoard.m
//  zaime
//
//  Created by 1528 MAC on 14-8-20.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "KSDEmotionBoard.h"

@implementation KSDEmotionBoard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.7;
    }
    return self;
}

- (void)show
{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @0.;
    opacityAnimation.toValue = @1.;
    opacityAnimation.duration = 0.5f;
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    CATransform3D startingScale = CATransform3DScale(self.layer.transform, 0, 0, 0);
    CATransform3D overshootScale = CATransform3DScale(self.layer.transform, 1.05, 1.05, 1.0);
    CATransform3D undershootScale = CATransform3DScale(self.layer.transform, 0.98, 0.98, 1.0);
    CATransform3D endingScale = self.layer.transform;
    
    NSMutableArray *scaleValues = [NSMutableArray arrayWithObject:[NSValue valueWithCATransform3D:startingScale]];
    NSMutableArray *keyTimes = [NSMutableArray arrayWithObject:@0.0f];
    NSMutableArray *timingFunctions = [NSMutableArray arrayWithObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    if (YES) {
        [scaleValues addObjectsFromArray:@[[NSValue valueWithCATransform3D:overshootScale], [NSValue valueWithCATransform3D:undershootScale]]];
        [keyTimes addObjectsFromArray:@[@0.5f, @0.85f]];
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    }
    
    [scaleValues addObject:[NSValue valueWithCATransform3D:endingScale]];
    [keyTimes addObject:@1.0f];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    scaleAnimation.values = scaleValues;
    scaleAnimation.keyTimes = keyTimes;
    scaleAnimation.timingFunctions = timingFunctions;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    animationGroup.duration = 0.5f;
    
    [self.layer addAnimation:animationGroup forKey:nil];
}

@end
