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
//#import "MyView.h"
//#import "ACEDrawingView.h"
#define kLoginUserName @"a"
#define kConnectUserName @"zhao"
#import "KSDCanvas.h"
#define SYSTEMFONT(x) [UIFont systemFontOfSize:(x)]
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
    DownloadEmotion *downLoadEmotion;
    PhotoStackView *photoStackView;
    
    int picSize;
    NSMutableArray *_photos;
    KSDCanvas *drawView;
    
    CGPoint lastReceivePoint;
    
}
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
    currentPoint = CGPointZero;
    othersidePoint = CGPointZero;
    lastPoint = CGPointZero;
    lastTime = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMsg:) name:kReceiveTextMsg object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMoveEnd:) name:kReceiveMoveEnd object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEmotion:) name:kReceiveEmotionMsg object:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 60, 60, 60);
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
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
    picSize = 80;
//    photoStackView = [[PhotoStackView alloc]initWithFrame:CGRectMake(0, 0, picSize, picSize)];
//    photoStackView.dataSource = self;
//    photoStackView.delegate = self;
//    photoStackView.center = self.view.center;
//    [self.view addSubview:photoStackView];
    
    downLoadEmotion = [[DownloadEmotion alloc]init];
    
//    [[KLDDatabase sharedInstance] createDbWithName:[Common sharedInstance].username complete:^(NSString *path, BOOL isDbExist) {
//        NSLog(@"xxx");
//    }];
    
    [[KLDDatabase sharedInstance] createDatabaseAndTables:[Common sharedInstance].username :^{
        NSLog(@"数据库检查完毕");
    }];
    
    
    drawView=[[KSDCanvas alloc]initWithFrame:CGRectMake(0, 200, 320, 300)];
    [drawView setBackgroundColor:RGBCOLOR(101, 129, 90)];
    ViewController __weak *tmp = self;
    [drawView setMoveing:^(CGPoint point) {
        BaseMesage *message = [tmp createMsgWithTo:kConnectUserName from:@"" content:[NSString stringWithFormat:@"%f-%f",point.x,point.y] type:MessageText];
        [tmp shock];
        [[XMPPClient sharedInstance] sendMsg:message];
    }];
    [self.view addSubview:drawView];
    [self.view sendSubviewToBack:drawView];
    [self performSelector:@selector(clear) withObject:nil afterDelay:20];
}
- (void)clear
{
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
//            if(!view)
//            {
//                view = [[UIImageView alloc]initWithFrame:CGRectMake(kZero, kZero, 32, 32)];
//                view.image = [UIImage imageNamed:@"fingerprint"];
//                [self.view addSubview:view];
//            }
//           // [UIView animateWithDuration:0.1 animations:^{
//                 view.center = CGPointMake(x, y);
//           // } completion:nil];
//            if(i < 3)
//            {
//                [drawView receivePoint:CGPointMake(x, y)];
//                i++;
//            }else
//            {
//                i = 0;
            CGPoint rpoint = CGPointMake(x, y);
           // [drawView receivePoint:rpoint];
            othersidePoint = view.center;
            UIView *aview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
            aview.center = rpoint;
            aview.backgroundColor = [UIColor redColor];
            [drawView addSubview:aview];
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
        
        _photos = [[NSMutableArray alloc]init];
//        _photos = [NSArray arrayWithObjects:
//                   [UIImage imageNamed:@"photo1.jpg"],
//                   [UIImage imageNamed:@"photo2.jpg"],
//                   [UIImage imageNamed:@"photo3.jpg"],
//                   [UIImage imageNamed:@"photo4.jpg"],
//                   [UIImage imageNamed:@"photo5.jpg"],
//                   nil];
        
    }
    return _photos;
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
        if(/*offsetx >= kNotSendSquire && offsety >= kNotSendSquire && (([[NSDate date] timeIntervalSince1970]-lastTime)*1000>kSendMsgInterval || lastTime == 0)*/YES)
        {
           
            lastPoint = point;
            BaseMesage *message = [self createMsgWithTo:kConnectUserName from:@"" content:[NSString stringWithFormat:@"%f-%f",point.x,point.y] type:MessageText];
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
//    picSize = 200;
//    [UIView animateWithDuration:0.5 animations:^{
//        CGPoint center = photoStackView.center;
//        photoStackView.center = center;
//        CGRect frame = photoStackView.frame;
//        frame.size.height = picSize;
//        frame.size.width = picSize;
//        photoStackView.frame = frame;
//        
//    } completion:^(BOOL finished) {
//        [photoStackView reloadData];
//    }];
    
    
}
//增加一个图片
/*
 NSMutableArray *photosMutable = [self.photos mutableCopy];
 [photosMutable addObject:[UIImage imageNamed:@"photo6.jpg"]];
 self.photos = photosMutable;
 [self.photoStack reloadData];
 */
@end
