//
//  ViewController.m
//  zaime
//
//  Created by 1528 MAC on 14-8-7.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "TViewController.h"
#import "KSDXMPPClient.h"
#import "BaseMesage.h"
#import "config.h"
#import <AVFoundation/AVFoundation.h>
#import "KSDAFClient.h"
#import "APAddressBook.h"
#import "ContactListController.h"
#import "UIImageView+AFNetworking.h"
#import "APContact.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"
#import "YLProgressBar.h"
#import "KSDDownloadEmotion.h"
#import "Common.h"
#import "KSDDatabase.h"
#import "KSDEmotionBoard.h"
#import "KSDLiveBlurView.h"
#import "KSDCanvas.h"
#import "KSDDrawView.h"
#import "KSDIMStatus.h"
#import "UIView+PartialRoundedCorner.h"
#import "BOSImageResizeOperation.h"
#import "KSDShotScreen.h"
#import "KSDImageResize.h"
#import "ACEViewController.h"
#import "DBCameraContainerViewController.h"
#import "TViewController.h"
#import "LYMovePathView.h"
#define kLoginUserName @"zhao"
#define kConnectUserName @"a"
typedef void (^TableRowBlock)();
@interface TViewController ()<DBCameraViewControllerDelegate>
{
    UIImageView *view ;
    
    NSTimer *compare;
    
    NSProgress *progress;
    APAddressBook *addressBook;
    YLProgressBar *_progressBar;
    KSDDownloadEmotion *downLoadEmotion;
    KSDPhotoStackView *photoStackView;
    
    int picSize;
    NSMutableArray *_photos;
    KSDDrawView *drawView;
    
    CGPoint lastReceivePoint;
    KSDEmotionBoard *board;
    NSDictionary *_actionMapping;
    
    
}
@property(nonatomic,assign) NSTimeInterval lastTime;
@property(nonatomic,assign) CGPoint currentPoint;
@property(nonatomic,assign) CGPoint othersidePoint;
@end

@implementation TViewController

- (void)loadView
{
    [super loadView];
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    lastReceivePoint = CGPointMake(-1, -1);
    
    //UIPanGestureRecognizer *swipe = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    //[self.view addGestureRecognizer:swipe];
    [[KSDXMPPClient sharedInstance] teardownStream];
    [[KSDXMPPClient sharedInstance] setupStream];
    [[KSDXMPPClient sharedInstance] connectWithAccount:kLoginUserName pwd:@"123321"];
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
    
    
    [[KSDAFClient sharedClient] POST:kFetchFriendLists parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"18617149851",@"owner", nil] success:^(NSURLSessionDataTask *task, id responseObject) {
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
    photoStackView = [[KSDPhotoStackView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    photoStackView.dataSource = self;
    photoStackView.delegate = self;
    photoStackView.center = CGPointMake(0, 0);
    // [self.view addSubview:photoStackView];
    
    downLoadEmotion = [[KSDDownloadEmotion alloc]init];
    
    
    [[KSDDatabase sharedInstance] createDatabaseAndTables:[Common sharedInstance].username :^{
        NSLog(@"数据库检查完毕");
    }];
    
    /* drawView=[[KSDDrawView alloc]initWithFrame:CGRectMake(0, 100, 320, 300)];
     drawView.alpha = 0.8;
     [drawView setBackgroundColor:[UIColor clearColor]];
     ViewController __weak *tmp = self;
     [drawView setMovingAction:^(CGPoint point) {
     tmp.currentPoint = point;
     if(YES)
     {
     BaseMesage *message = [tmp createMsgWithTo:kConnectUserName from:@"" content:[NSString stringWithFormat:@"%f-%f",point.x,point.y] type:MessageText];
     [tmp shock];
     [[KSDXMPPClient sharedInstance] sendMsg:message];
     }
     tmp.lastTime = [[NSDate date] timeIntervalSince1970];
     }];
     [drawView setClearHandler:^(CGPoint point) {
     tmp.currentPoint = CGPointZero;
     tmp.othersidePoint = CGPointZero;
     }];
     drawView.center = self.view.center;
     */
    photoStackView.center = CGPointMake(0, 0);
    KSDLiveBlurView *backgroundView = [[KSDLiveBlurView alloc] initWithFrame: self.view.bounds];
    
    backgroundView.originalImage = [UIImage imageNamed:@"bg1.jpg"];
    backgroundView.isGlassEffectOn = YES;
    backgroundView.alpha = 0.4f;
    
    
    [self.view addSubview:backgroundView];
    
    //  [self.view addSubview:drawView];
    [self.view addSubview:photoStackView];
    
    
    downLoadEmotion = [[KSDDownloadEmotion alloc]init];
    [downLoadEmotion downloadWithURLS:@[@"http://atp2.yokacdn.com/20130425/4e/4e0eddc85571a7dc09e77c440405d49a.jpg",@"http://f.hiphotos.bdimg.com/album/w%3D2048/sign=79e911c300e9390156028a3e4fd455e7/ca1349540923dd54537e0e8bd009b3de9d8248c7.jpg"] :^(UIImage *image, NSString *url) {
        
        if(!image) return ;
        
        CGSize dest = CGSizeZero;
        if(image.size.width > image.size.height)
        {
            dest.height = kAvatarSize;
            dest.width = image.size.width/(image.size.height/kAvatarSize);
        }else
        {
            dest.width = kAvatarSize;
            dest.height = image.size.height/(image.size.width/kAvatarSize);
        }
        [[KSDImageResize sharedInstance] resizeWithImage:image size:dest handler:^(UIImage *result) {
            UIImageView *tmpImgView = [[UIImageView alloc] initWithImage:result];
            UIImage *theImage= [[KSDShotScreen sharedInstance] captureView:tmpImgView frame:CGRectMake((tmpImgView.frame.size.width-kAvatarSize)/2.f,(tmpImgView.frame.size.height-kAvatarSize)/2.f, kAvatarSize, kAvatarSize)];// 切割尺寸
            UIImageView *_imgPic = [[UIImageView alloc]initWithImage:theImage];
            [_imgPic setCornerRadius:kAvatarSize/2.f direction:UIViewPartialRoundedCornerDirectionAll];
            [_imgPic setImage:theImage];
            CGRect frame = _imgPic.frame;
            if([url isEqualToString:@"http://f.hiphotos.bdimg.com/album/w%3D2048/sign=79e911c300e9390156028a3e4fd455e7/ca1349540923dd54537e0e8bd009b3de9d8248c7.jpg"])
            {
                frame.origin.y = [[UIScreen mainScreen] bounds].size.height-90;
            }else
            {
                frame.origin.y = 20;
            }
            frame.origin.x = (320-_imgPic.frame.size.width)/2.f;
            
            _imgPic.frame = frame;
            [self.view insertSubview:_imgPic belowSubview:photoStackView];
        }];
        
    }];
    [self addCreamer];
    [self addWater];
    LYMovePathView *aview = [[LYMovePathView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:aview];
}
- (void)drawing
{
    [self presentViewController:[[ACEViewController alloc]init] animated:YES completion:nil];
}
- (void)open
{
    DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    [cameraContainer setFullScreenMode];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraContainer];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)addCreamer
{
    UIButton *creamer = [UIButton buttonWithType:UIButtonTypeCustom];
    [creamer setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    creamer.frame = CGRectMake(0, 0, 60, 40);
    [creamer addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
    if([[UIScreen mainScreen] bounds].size.height == 568)
    {
        creamer.center = CGPointMake(260,510);
    }
    if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        creamer.center = CGPointMake(260,510-86);
    }
    
    [self.view addSubview:creamer];
    
}
- (void)addWater
{
    UIButton *creamer = [UIButton buttonWithType:UIButtonTypeCustom];
    [creamer setBackgroundImage:[UIImage imageNamed:@"drawing"] forState:UIControlStateNormal];
    creamer.frame = CGRectMake(0, 0, 40, 40);
    [creamer addTarget:self action:@selector(drawing) forControlEvents:UIControlEventTouchUpInside];
    if([[UIScreen mainScreen] bounds].size.height == 568)
    {
        creamer.center = CGPointMake(50,510);
    }
    if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        creamer.center = CGPointMake(50,510-86);
    }
    
    [self.view addSubview:creamer];
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
    board = [[KSDEmotionBoard alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
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
    [[KSDXMPPClient sharedInstance] sendMsg:message];
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
    [[KSDAFClient sharedClient] POST:kSendMsg parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"推送",@"content",kConnectUserName,@"to", nil] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    [[KSDAFClient sharedClient] POST:@"" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
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
    if(offsetx< kShockSize && offsety < kShockSize)
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
- (NSUInteger)numberOfPhotosInPhotoStackView:(KSDPhotoStackView *)photoStack
{
    return [[self photos] count];
}
- (UIImage *)photoStackView:(KSDPhotoStackView *)photoStack photoForIndex:(NSUInteger)index
{
    return  [[self photos] objectAtIndex:index];
}
// - (CGSize)photoStackView:(PhotoStackView *)photoStack photoSizeForIndex:(NSUInteger)index
//{
//    return CGSizeMake(picSize, picSize);
//}
#pragma mark - 照片浏览的委托
-(void)photoStackView:(KSDPhotoStackView *)aphotoStackView didSelectPhotoAtIndex:(NSUInteger)index
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
#pragma mark - DBCameraViewControllerDelegate

- (void) dismissCamera:(id)cameraViewController{
    [cameraViewController dismissViewControllerAnimated:YES completion:nil];
    [cameraViewController restoreFullScreenMode];
}

- (void) camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    
}
@end
