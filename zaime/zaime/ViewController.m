//
//  ViewController.m
//  zaime
//
//  Created by 1528 MAC on 14-8-7.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "ViewController.h"
#import "XMPPClient.h"
#import "BaseMesage.h"
#import "config.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()
{
    UIImageView *view ;
    CGPoint currentPoint;
    CGPoint othersidePoint;
    NSTimer *compare;
    CGPoint lastPoint;
    NSTimeInterval lastTime;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIPanGestureRecognizer *swipe = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.view addGestureRecognizer:swipe];
    [[XMPPClient sharedInstance] setupStream];
    [[XMPPClient sharedInstance] connectWithAccount:@"a" pwd:@"123321"];
    currentPoint = CGPointZero;
    othersidePoint = CGPointZero;
    lastPoint = CGPointZero;
    lastTime = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMsg:) name:kReceiveMsg object:nil];
    
    
}

- (void)shock
{
    if((othersidePoint.x == kZero && othersidePoint.y == kZero) || (currentPoint.y == kZero && currentPoint.x == kZero)) return;
    int offsetx = currentPoint.x-othersidePoint.x;
    int offsety = currentPoint.y-othersidePoint.y;
    if(offsetx <= kZero) offsetx = -offsetx;
    if(offsety <= kZero) offsety = -offsety;
    if(offsetx< 32 && offsety < 32)
    {
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }
}
- (void)receiveMsg:(NSNotification*)noti
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kZero), ^{
        NSString *body = [noti object];
        NSArray *points = [body componentsSeparatedByString:@"-"];
        float x = [[points objectAtIndex:0] floatValue];
        float y = [[points objectAtIndex:1] floatValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!view)
            {
                view = [[UIImageView alloc]initWithFrame:CGRectMake(kZero, kZero, 32, 32)];
                view.image = [UIImage imageNamed:@"fingerprint"];
                [self.view addSubview:view];
            }
            view.center = CGPointMake(x, y);
            othersidePoint = view.center;
            [self shock];
        });
        
    });
   
    
    
    
    
}
- (BaseMesage*)createMsgWithTo :(NSString*)to from:(NSString*)from content:(NSString*)content
{
    BaseMesage *message = [[BaseMesage alloc]init];
    message.msgContent = content;
    message.type = @"chat";
    message.sendDate = [NSDate date];
    message.conversationId = @"";
    message.to = to;
    message.from = from;
    message.isIncoming = NO;
    message.messageId = @"";
    message.status = MsgStatusSending;
    return message;
}
-(void)handleSwipeFrom:(UITapGestureRecognizer *)recognizer
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kZero), ^{
        
        
        CGPoint point = [recognizer locationInView:self.view];
       
        int offsetx = lastPoint.x - point.x;
        int offsety = lastPoint.y - point.y;
        offsety = abs(offsety);
        offsetx = abs(offsetx);
         currentPoint = point;
        if(offsetx >= kNotSendSquire && offsety >= kNotSendSquire && (([[NSDate date] timeIntervalSince1970]-lastTime)*1000>kSendMsgInterval || lastTime == 0))
        {
           
            lastPoint = point;
            BaseMesage *message = [self createMsgWithTo:@"zhao" from:@" " content:[NSString stringWithFormat:@"%f-%f",point.x,point.y]];
            [self shock];
            dispatch_async(dispatch_get_main_queue(), ^{
                lastTime = [[NSDate date] timeIntervalSince1970];
                [[XMPPClient sharedInstance] sendMsg:message];
            });
        }
        
    });
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
