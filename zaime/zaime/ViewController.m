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
#import "Common.h"
#import "KLDDatabase.h"
#import "EmotionBoard.h"
#define kLoginUserName @"zhao"
#define kConnectUserName @"a"
#import "KSDCanvas.h"
#define SYSTEMFONT(x) [UIFont systemFontOfSize:(x)]
#import "DRNRealTimeBlurView.h"
#import "MyView.h"
@interface ViewController ()
{
    UIImageView *view ;
   
    NSTimer *compare;
   
    NSProgress *progress;
    APAddressBook *addressBook;
    YLProgressBar *_progressBar;
    DownloadEmotion *downLoadEmotion;
    PhotoStackView *photoStackView;
    
    int picSize;
    NSMutableArray *_photos;
    MyView *drawView;
    
    CGPoint lastReceivePoint;
    EmotionBoard *board;
    
}
@property(nonatomic,assign) NSTimeInterval lastTime;
@property(nonatomic,assign) CGPoint currentPoint;
@property(nonatomic,assign) CGPoint othersidePoint;
@end

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    lastReceivePoint = CGPointMake(-1, -1);
    
    //UIPanGestureRecognizer *swipe = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    //[self.view addGestureRecognizer:swipe];
    [[XMPPClient sharedInstance] setupStream];
    [[XMPPClient sharedInstance] connectWithAccount:kLoginUserName pwd:@"123321"];
   // [[XMPPClient sharedInstance] registerWithAccount:@"xf" password:@"123321"];
    [Common sharedInstance].username = kLoginUserName;
    self.currentPoint = CGPointZero;
    self.othersidePoint = CGPointZero;
    self.lastTime = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMsg:) name:kReceiveTextMsg object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMoveEnd:) name:kReceiveMoveEnd object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEmotion:) name:kReceiveEmotionMsg object:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 60, 60, 60);
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
   // [self.view addSubview:btn];
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
    photoStackView = [[PhotoStackView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    photoStackView.dataSource = self;
    photoStackView.delegate = self;
    photoStackView.center = CGPointMake(40, 40);
   // [self.view addSubview:photoStackView];
    
    downLoadEmotion = [[DownloadEmotion alloc]init];
    
//    [[KLDDatabase sharedInstance] createDbWithName:[Common sharedInstance].username complete:^(NSString *path, BOOL isDbExist) {
//        NSLog(@"xxx");
//    }];
    
    [[KLDDatabase sharedInstance] createDatabaseAndTables:[Common sharedInstance].username :^{
        NSLog(@"数据库检查完毕");
    }];
    
    drawView=[[MyView alloc]initWithFrame:CGRectMake(0, 100, 320, 300)];
    drawView.alpha = 0.8;
    [drawView setBackgroundColor:RGBCOLOR(30, 114, 153)];
    ViewController __weak *tmp = self;
//    [drawView setMoveing:^(CGPoint point) {
//        tmp.currentPoint = point;
//        if(YES)
//        {
//            BaseMesage *message = [tmp createMsgWithTo:kConnectUserName from:@"" content:[NSString stringWithFormat:@"%f-%f",point.x,point.y] type:MessageText];
//            [tmp shock];
//            [[XMPPClient sharedInstance] sendMsg:message];
//        }
//        tmp.lastTime = [[NSDate date] timeIntervalSince1970];
//        
//    }];
    [drawView setMovingAction:^(CGPoint point) {
        tmp.currentPoint = point;
        if(YES)
        {
            BaseMesage *message = [tmp createMsgWithTo:kConnectUserName from:@"" content:[NSString stringWithFormat:@"%f-%f",point.x,point.y] type:MessageText];
            [tmp shock];
            [[XMPPClient sharedInstance] sendMsg:message];
        }
        tmp.lastTime = [[NSDate date] timeIntervalSince1970];
    }];
    drawView.center = self.view.center;
    [self.view addSubview:drawView];
    [self.view addSubview:photoStackView];
    [self.view sendSubviewToBack:drawView];
}
/*- (void)showHideLoop
{
    
    //show aniamtion
    [UIView animateWithDuration:1 animations:^{
        dr.alpha = 1.f;
    } completion:^(BOOL finished) {
        
        //After 10seconds it hides the view
        double delayInSeconds = 10.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            //hide animation
            [UIView animateWithDuration:1 animations:^{
                dr.alpha = 0.f;
            } completion:^(BOOL finished) {
                
                //recursively call showHideLoop
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self showHideLoop];
                });
            }];
        });
    }];
}
 */
- (void)clear
{
    self.othersidePoint = CGPointZero;
    self.currentPoint = CGPointZero;
    [UIView animateWithDuration:2 animations:^{
        for (UIView *sub in drawView.subviews)
        {
            sub.alpha = 0;
        }
    } completion:^(BOOL finished) {
        for (UIView *sub in drawView.subviews)
        {
            [sub removeFromSuperview];
        }
    }];
}
-(void)btnAction:(id)sender{
    board = [[EmotionBoard alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
    [self.view addSubview:board];
    [board show];
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
- (void)sendEmotion
{
    BaseMesage *message = [self createMsgWithTo:kConnectUserName from:kLoginUserName content:@"http://www.gifaaa.com/content/uploadfile/201404/a9351397662960.gif" type:MessageEmotion];
   [[XMPPClient sharedInstance] sendMsg:message];
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
    [[AFAppDotNetAPIClient sharedClient] POST:kSendMsg parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"推送",@"content",kConnectUserName,@"to", nil] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"%@",error);
    }];
    
    [[AFAppDotNetAPIClient sharedClient] POST:@"" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        /*
           [formData appendPartWithFileData :imageData name:@"1" fileName:@"1.png" mimeType:@"image/jpeg"];
         */
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

    }];
   
}
- (void)shock
{
    if((self.othersidePoint.x == kZero && self.othersidePoint.y == kZero) || (self.currentPoint.y == kZero && self.currentPoint.x == kZero)) return;
    int offsetx = self.currentPoint.x-self.othersidePoint.x;
    int offsety = self.currentPoint.y-self.othersidePoint.y;
    if(offsetx <= kZero) offsetx = -offsetx;
    if(offsety <= kZero) offsety = -offsety;
    if(offsetx< 32 && offsety < 32)
    {
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }
}
- (void)receiveEmotion:(NSNotification*)noti
{
    NSString *emotion = [noti object];
    [downLoadEmotion downloadWithURLS:[NSArray arrayWithObject:emotion] :^(UIImage *image, NSString *url) {
        
        
//        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
//        [self.view addSubview:imageView];
        [_photos addObject:image];
        [photoStackView reloadData];
    }];
}
- (void)receiveMsg:(NSNotification*)noti
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kZero), ^{
        NSString *body = [noti object];
        NSArray *points = [body componentsSeparatedByString:@"-"];
        float x = [[points objectAtIndex:0] floatValue];
        float y = [[points objectAtIndex:1] floatValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            CGPoint rpoint = CGPointMake(x, y);
            [drawView addPoint:rpoint];
            self.othersidePoint = rpoint;
            [self shock];
        });
        
    });
    
}
- (void)receiveMoveEnd :(NSNotification*)noti
{
}
- (BaseMesage*)createMsgWithTo :(NSString*)to from:(NSString*)from content:(NSString*)content type:(MessageType)type
{
    BaseMesage *message = [[BaseMesage alloc]init];
    message.msgContent = content;
    message.type = type;
    message.sendDate = [NSDate date];
    message.to = to;
    message.from = from;
    return message;
}
-(NSArray *)photos {
    if(!_photos) {
        
       // _photos = [[NSMutableArray alloc]init];
        _photos = [NSMutableArray arrayWithObjects:
                   [UIImage imageNamed:@"photo1.jpg"],
                   [UIImage imageNamed:@"photo2.jpg"],
                   [UIImage imageNamed:@"photo3.jpg"],
                   [UIImage imageNamed:@"photo4.jpg"],
                   [UIImage imageNamed:@"photo5.jpg"],
                   nil];
        
    }
    return _photos;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 照片浏览的datasource
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (NSUInteger)numberOfPhotosInPhotoStackView:(PhotoStackView *)photoStack
{
    return [[self photos] count];
}
- (UIImage *)photoStackView:(PhotoStackView *)photoStack photoForIndex:(NSUInteger)index
{
   return  [[self photos] objectAtIndex:index];
}
// - (CGSize)photoStackView:(PhotoStackView *)photoStack photoSizeForIndex:(NSUInteger)index
//{
//    return CGSizeMake(picSize, picSize);
//}
#pragma mark - 照片浏览的委托
-(void)photoStackView:(PhotoStackView *)aphotoStackView didSelectPhotoAtIndex:(NSUInteger)index
{
//    UIImage *image = [_photos objectAtIndex:index];
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
//    [self.view addSubview:imageView];
//    [UIView animateWithDuration:1.f animations:^{
//        imageView.center = self.view.center;
//    } completion:nil];
}
//增加一个图片
/*
 NSMutableArray *photosMutable = [self.photos mutableCopy];
 [photosMutable addObject:[UIImage imageNamed:@"photo6.jpg"]];
 self.photos = photosMutable;
 [self.photoStack reloadData];
 */
@end
