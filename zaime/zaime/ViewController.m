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
#import "AFAppDotNetAPIClient.h"
#import "APAddressBook.h"
#import "ContactListController.h"
#import "UIImageView+AFNetworking.h"
#import "APContact.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"
#import "YLProgressBar.h"
#import "DownloadEmotion.h"
@interface ViewController ()
{
    UIImageView *view ;
    CGPoint currentPoint;
    CGPoint othersidePoint;
    NSTimer *compare;
    CGPoint lastPoint;
    NSTimeInterval lastTime;
    NSProgress *progress;
    APAddressBook *addressBook;
    YLProgressBar *_progressBar;
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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 60);
    [btn addTarget:self action:@selector(showContactList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.backgroundColor  = [UIColor greenColor];
    [[AFAppDotNetAPIClient sharedClient] POST:kFetchFriendLists parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"18617149851",@"owner", nil] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    addressBook = [[APAddressBook alloc]init];
    addressBook.sortDescriptors = @[
                                    [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES],
                                    [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]
                                    ];
    addressBook.filterBlock = ^BOOL(APContact *contact)
    {
        return contact.phones.count > 0;
    };
//    _progressBar = [[YLProgressBar alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
//    _progressBar.type = YLProgressBarTypeFlat;
//    _progressBar.stripesColor = [UIColor blueColor];
//    [self.view addSubview:_progressBar];
//    NSArray *urls = @[@"http://www.gifaaa.com/content/uploadfile/201404/a9351397662960.gif",@"http://www.gifaaa.com/content/uploadfile/201404/6b811397701164.gif",@"http://www.gifaaa.com/content/uploadfile/201404/8de21397622162.gif"];
//    [[DownloadEmotion sharedInstance] downloadWithURLS:urls  :^(NSDictionary *results) {
//        static int i = 0;
//        i++;
//        [_progressBar setProgress:i/(float)[urls count] animated:YES];
//        for (NSString *key in [results keyEnumerator])
//        {
//            UIImage *image = [results objectForKey:key];
//            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
//            imageView.frame = CGRectMake((i-1)*80, 10, 80, 80);
//            [self.view addSubview:imageView];
//        }
//        if(i == urls.count)
//        {
//            i = 0;
//        }
//    }];
    
}
- (void)dispSendMsg :(NSArray*)results
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]) {
        
        controller.body = @"你好嘛？";
        
        NSMutableArray *phones = [[NSMutableArray alloc]init];
        for (APContact *ap in results)
        {
            [phones addObject:ap.phones[0]];
        }
        controller.recipients = phones;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)showContactList
{
    [addressBook loadContacts:^(NSArray *contacts, NSError *error) {
       if([APAddressBook access] == APAddressBookAccessGranted)
       {
           UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[[ContactListController alloc]initWithContacts:contacts style:UITableViewStylePlain :^(NSArray *results) {
               
               [self performSelector:@selector(dispSendMsg:) withObject:results afterDelay:0.5f];
           }]];
           [self presentViewController:navi animated:YES completion:nil];
       }
    }];
}
- (void)sendYo
{
    [[AFAppDotNetAPIClient sharedClient] POST:kSendMsg parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"推送",@"content",@"zhao",@"to", nil] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"%@",error);
    }];
   
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
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
