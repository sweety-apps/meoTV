//
//  NotificationCompent.m
//  yoforchinese
//
//  Created by NPHD on 14-8-4.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "NotificationCompent.h"

@implementation NotificationCompent

- (id)initWithMSg:(NSString *)amsg from:(NSString *)afrom
{
    self = [super initWithFrame:CGRectMake(0, -60, [[UIScreen mainScreen] bounds].size.width, 60)];
    if(self)
    {
        msg = amsg;
        from = afrom;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.7;
    }
    return self;
}

- (void)show
{
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(76, 25, 200, 21)];
    message.textColor = [UIColor whiteColor];
    message.text = msg;
    message.backgroundColor = [UIColor clearColor];
    [self addSubview:message];
    
//    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(76, 33, 182, 21)];
//    fromLabel.textColor = [UIColor whiteColor];
//    fromLabel.text = [@"FROM: " stringByAppendingString:from];
//    fromLabel.backgroundColor = [UIColor clearColor];
//    [self addSubview:fromLabel];
    
    UIView *icon = [[UIView alloc]initWithFrame:CGRectMake(12, 9, 45, 45)];
    icon.backgroundColor = [UIColor greenColor];
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 10;
    [self addSubview:icon];
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect frame = self.frame;
        frame.origin.y = 0;
        self.frame = frame;
        
    }completion:^(BOOL finished) {
        
    }];
}
- (void)hide
{
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect frame = self.frame;
        frame.origin.y = -60;
        self.frame = frame;
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
@end
