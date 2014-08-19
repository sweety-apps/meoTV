//
//  KSDCanvas.m
//  zaime
//
//  Created by 1528 MAC on 14-8-19.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "KSDCanvas.h"

@implementation KSDCanvas

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setMoveing:(MovingAction)action
{
    moving = action;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch=[touches anyObject];
	CGPoint point =[touch locationInView:self];
    if(moving)
    {
        moving(point);
    }
    
    UIView *aview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    aview.center = point;
    aview.backgroundColor = [UIColor redColor];
    [self addSubview:aview];
}
@end
