//
//  KSDFingerDistance.m
//  zaime
//
//  Created by 1528 MAC on 14-9-3.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "KSDFingerDistance.h"

@implementation KSDFingerDistance

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
        self.text.backgroundColor = [UIColor clearColor];
        self.text.textAlignment = NSTextAlignmentCenter;
        self.text.font = [UIFont systemFontOfSize:22];
        CGPoint textCenter = CGPointMake(self.center.x, 20);
        
        self.text.center = textCenter;
        self.text.text = @"指尖的距离";
        self.text.alpha = 0.f;
        self.text.textColor = RGBCOLOR(53, 55, 65);
        [self addSubview:self.text];
        
        
        self.diatance = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 80)];
        self.diatance.backgroundColor = [UIColor clearColor];
        self.diatance.textAlignment = NSTextAlignmentCenter;
        self.diatance.text = @"6.1";
        self.diatance.font = [UIFont boldSystemFontOfSize:80];
        self.diatance.alpha = 0.f;
        self.diatance.textColor = RGBCOLOR(53, 55, 65);
        CGPoint diatanceCenter = CGPointMake(self.center.x+2, 100);
        
        self.diatance.center = diatanceCenter;
        
        [self addSubview:self.diatance];
        
        
        
    }
    return self;
}


@end
