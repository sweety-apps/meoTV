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
#import "KSDMovePathView.h"
#import "DBCameraView.h"
#import "DBCameraViewController.h"
#import "DBCameraSegueViewController.h"
#import "KSDCamerBox.h"
#import "DBCameraCropView.h"
#import "UIImage+Transforms.h"
#import "KSDImageStack.h"
#import "WCGalleryView.h"
#import "ShowAllImageViewController.h"
#import "KSDPhoto.h"
#import "KSDSelectColor.h"
#define kLoginUserName @"a"
#define kConnectUserName @"zhao"
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
    NSDictionary *_actionMapping;
    KSDMovePathView *aview;
    
    KSDSelectColor *select;
    
    BOOL isAppera;
    
    UIButton *selectColour;
    UIButton *creamer;
    UIButton *otherAvatar;
    UIButton *myAvatar;
    
    KSDPhoto *photo;
    WCGalleryView *galleryView;
    
   
    
    
}
@property (strong, nonatomic) MSWeakTimer *backgroundTimer;
@property (strong, nonatomic) dispatch_queue_t privateQueue;
@property(nonatomic,assign) NSTimeInterval lastTime;
@property(nonatomic,strong)  NSMutableArray *photos;
@end

@implementation TViewController

- (void)clearAnimation
{
    [aview.layer removeAllAnimations];
}
- (void)loadView
{
    [super loadView];
}
- (void)test
{
    //[galleryView removeImageAtIndex:2 animated:NO];
    [galleryView addImage:[UIImage imageNamed:@"photo4.jpg"] animated:NO];
}
- (void)viewDidLoad
{
    KSDLog(@"viewDidLoad");
    [super viewDidLoad];
    self.photos = [[NSMutableArray alloc]initWithCapacity:10];
    
     TViewController __weak *tmpself = self;
    
    
    galleryView      = [[WCGalleryView alloc] initWithImages:[NSArray array] degress:[NSMutableArray array] frame:CGRectMake(-100, -100, 200.0f, 200.0f)];
    galleryView.backgroundColor     = [UIColor clearColor];
    galleryView.borderColor         = [UIColor whiteColor];
    galleryView.borderWidth         = 3.0f;
    galleryView.shadowColor         = [UIColor blackColor];
    galleryView.shadowOffset        = CGSizeMake(1.0f, 2.0f);
    galleryView.shadowOpacity       = 0.0f;
    galleryView.shadowRadius        = 2.0f;
    galleryView.stackRadiusOffset   = 9.0f;
    galleryView.animationDuration   = 0.3f;
    galleryView.stackRadiusDirection = WCGalleryStackRadiusRandom;
    galleryView.animationType        = WCGalleryAnimationFade;
    [galleryView setSelectAction:^(NSArray *images) {
        
        [tmpself presentViewController:[[UINavigationController alloc]initWithRootViewController:[[ShowAllImageViewController alloc]initWithPhoto:tmpself.photos]] animated:YES completion:nil];
        
    }];
    
    downLoadEmotion = [[KSDDownloadEmotion alloc]init];
    [downLoadEmotion downloadWithURLS:[NSArray arrayWithObjects:@"http://d.hiphotos.baidu.com/image/pic/item/5ab5c9ea15ce36d39e65badb38f33a87e850b1f3.jpg",@"http://e.hiphotos.baidu.com/image/pic/item/2cf5e0fe9925bc31d0f338735cdf8db1ca1370aa.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/a686c9177f3e670966ec7c1439c79f3df9dc5568.jpg",nil] :^(UIImage *image, NSString *url) {
        KSDPhoto *p = [[KSDPhoto alloc]init];
        p.url = url;
        [self.photos addObject:p];
        [galleryView addImage:image animated:NO];
    }];
   // [self performSelector:@selector(test) withObject:nil afterDelay:10.f];
    [self.view addSubview:galleryView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    lastReceivePoint = CGPointMake(-1, -1);
   
   
    [[KSDXMPPClient sharedInstance] teardownStream];
    [[KSDXMPPClient sharedInstance] setupStream];
    [[KSDXMPPClient sharedInstance] connectWithAccount:kLoginUserName pwd:@"123321"];
    // [[XMPPClient sharedInstance] registerWithAccount:@"xf" password:@"123321"];
    [Common sharedInstance].username = kLoginUserName;
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
   /* photoStackView = [[KSDPhotoStackView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    photoStackView.dataSource = self;
    photoStackView.delegate = self;
    photoStackView.center = CGPointMake(0, 0);
    
    downLoadEmotion = [[KSDDownloadEmotion alloc]init];
    
    
    [[KSDDatabase sharedInstance] createDatabaseAndTables:[Common sharedInstance].username :^{
        NSLog(@"数据库检查完毕");
    }];
    */
    
    photoStackView.center = CGPointMake(0, 0);
    
    KSDLiveBlurView *backgroundView = [[KSDLiveBlurView alloc] initWithFrame: self.view.bounds];
    
    backgroundView.originalImage = [UIImage imageNamed:@"bg.png"];
    backgroundView.isGlassEffectOn = YES;
    
    
    [self.view addSubview:backgroundView];
    
    //  [self.view addSubview:drawView];
    [self.view addSubview:photoStackView];
    
    
    
   /* downLoadEmotion = [[KSDDownloadEmotion alloc]init];
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
    
        }];
        
    }];
    */
    [self addOtherAvatar];
    [self addMyAvatar];
    [self addCreamer];
    [self addWater];
    
    aview = [[KSDMovePathView alloc]initWithFrame:CGRectMake(0, otherAvatar.frame.size.height+30, SCREENWIDTH, SCREENHEIGHT-30-otherAvatar.frame.size.height-myAvatar.frame.size.height-30)];
    [aview setMoving:^(CGPoint point) {
        BaseMesage *message = [tmpself createMsgWithTo:kConnectUserName from:kLoginUserName content:[NSString stringWithFormat:@"%f-%f",point.x,point.y] type:MessageText];
        [[KSDXMPPClient sharedInstance] sendMsg:message];
    }];
    [aview setMeet:^(CGPoint point) {
        // AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }];
    [aview setEnd:^(CGPoint point) {
        BaseMesage *message = [tmpself createMsgWithTo:kConnectUserName from:kLoginUserName content:[NSString stringWithFormat:@"%f-%f",point.x,point.y] type:MEssageMoveEnd];
        [[KSDXMPPClient sharedInstance] sendMsg:message];
    }];
    [self.view addSubview:aview];
    
    [self.view bringSubviewToFront:galleryView];
    
    
}
- (void)addMyAvatar
{
    myAvatar = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *selfAvatar = [UIImage imageNamed:@"selfNotLogin"];
    [myAvatar setImage:selfAvatar forState:UIControlStateNormal];
    myAvatar.frame = CGRectMake(0, 0, selfAvatar.size.width/2.f, selfAvatar.size.height/2.f);
    myAvatar.center = CGPointMake(SCREENWIDTH/2.f, SCREENHEIGHT-30-selfAvatar.size.height/4.f);
    [self.view addSubview:myAvatar];
}
- (void)addOtherAvatar
{
    otherAvatar = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *otherAvatarImage = [UIImage imageNamed:@"otherNotLogin"];
    [otherAvatar setImage:otherAvatarImage forState:UIControlStateNormal];
    otherAvatar.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-otherAvatarImage.size.width/2.f)/2.f, 30, otherAvatarImage.size.width/2.f, otherAvatarImage.size.height/2.f);
    [self.view addSubview:otherAvatar];
}

- (void)backgroundTimerDidFire
{
    MAIN((^{
        NSLog(@"backgroundTimerDidFire");
        static int i = 1;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",isAppera?i:5-i]];
        [select setImage:image];
        select.frame = CGRectMake(30, SCREENHEIGHT-30-image.size.height/2, image.size.width/2, image.size.height/2);
        [select setNeedsDisplay];
        i++;
        if(i == 5)
        {
            [self.backgroundTimer invalidate];
            self.privateQueue = nil;
            i = 0;
        }
    }));
    
}
- (void)hide:(UIButton*)sender
{
    UIImage *four = [UIImage imageNamed:@"0"];
    select.animationImages=[NSArray arrayWithObjects:
                             [UIImage imageNamed:@"4"],
                             [UIImage imageNamed:@"3"],
                             [UIImage imageNamed:@"2"],
                             [UIImage imageNamed:@"1"],
                             [UIImage imageNamed:@"0"],
                             nil ];
    select.animationDuration=0.3;
    [select setImage:four];
    [select setAnimationRepeatCount:1];
    [select startAnimating];
    [self.view bringSubviewToFront:galleryView];
    [select performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];

}
- (void)show:(UIButton*)sender
{
    [self.view bringSubviewToFront:selectColour];
    UIImage *four = [UIImage imageNamed:@"4"];
    NSLog(@"show->%f",four.size.width);
    if(!select)
    {

       
        select =[[KSDSelectColor alloc] initWithFrame:CGRectMake(29, SCREENHEIGHT-30-four.size.height/2.f, four.size.width/2.f, four.size.height/2.f)];
        CGPoint center = select.center;
        center.x = sender.center.x;
        select.center = center;
        
    }
    [self.view insertSubview:select belowSubview:selectColour];
    select.animationImages=[NSArray arrayWithObjects:
                             [UIImage imageNamed:@"0"],
                             [UIImage imageNamed:@"1"],
                             [UIImage imageNamed:@"2"],
                             [UIImage imageNamed:@"3"],
                             [UIImage imageNamed:@"4"],
                            nil ];
    select.animationDuration=0.3;
    [select setImage:four];
    [select setAnimationRepeatCount:1];
    [select startAnimating];
  
}
- (void)drawing:(UIButton*)sender
{
    if(isAppera)
    {
        [self hide:sender];
        isAppera = NO;
    }else
    {
        [self show:sender];
        isAppera = YES;
    }
 
}
- (void)open
{
    DBCameraViewController *cameraController = [DBCameraViewController initWithDelegate:self];
    //[cameraController setForceQuadCrop:YES];
    
    DBCameraContainerViewController *container = [[DBCameraContainerViewController alloc] initWithDelegate:self cameraSettingsBlock:^(DBCameraView *cameraView, id container) {
        NSLog(@"%f,%f",cameraView.topContainerBar.frame.size.height,cameraView.bottomContainerBar.frame.size.height);
        cameraView.gridButton.hidden = YES;
        cameraView.flashButton.hidden = YES;
        DBCameraCropView *_cropView = [[DBCameraCropView alloc] initWithFrame:(CGRect){ 0, ([[UIScreen mainScreen] bounds].size.height-320)/2.f, 320, 320 }];
        _cropView.cropRect = CGRectMake(0, 0, 320, 320);
        [cameraView addSubview:_cropView];
    }];

    [container setCameraViewController:cameraController];
    [container setFullScreenMode];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:container];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
    
}
- (void)addCreamer
{
    UIImage *image = [UIImage imageNamed:@"creamer"];
    creamer = [UIButton buttonWithType:UIButtonTypeCustom];
    [creamer setBackgroundImage:image forState:UIControlStateNormal];
    creamer.frame = CGRectMake(0, 0, image.size.width/2.f, image.size.height/2.f);
    [creamer addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
    creamer.center = CGPointMake(SCREENWIDTH/2.f+myAvatar.frame.size.width/2.f+(SCREENWIDTH/2.f-myAvatar.frame.size.width/2.f)/2.f,myAvatar.center.y);
    
    [self.view addSubview:creamer];
    
}
- (void)addWater
{
    selectColour = [UIButton buttonWithType:UIButtonTypeCustom];
     UIImage *image = [UIImage imageNamed:@"pen"];
    [selectColour setBackgroundImage:image forState:UIControlStateNormal];
    selectColour.frame = CGRectMake(0, 0, image.size.width/2.f, image.size.height/2.f);
    [selectColour addTarget:self action:@selector(drawing:) forControlEvents:UIControlEventTouchUpInside];
    selectColour.center = CGPointMake(myAvatar.frame.origin.x/2.f,myAvatar.center.y);
    KSDLog(@"%f,%f",myAvatar.frame.origin.x,myAvatar.center.x);
    [self.view addSubview:selectColour];
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
- (void)receiveEmotion:(NSNotification*)noti
{
    NSString *emotion = [noti object];
    [downLoadEmotion downloadWithURLS:[NSArray arrayWithObject:emotion] :^(UIImage *image, NSString *url) {
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
            [aview addPoint:rpoint];
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


#pragma mark - 相机委托
- (void) camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];   // 保存文件的名称
    BOOL result = [UIImageJPEGRepresentation(image, 1.f) writeToFile:filePath atomically:YES];
    KSDPhoto *pf = [[KSDPhoto alloc]init];
    pf.url = filePath;
    [self.photos insertObject:pf atIndex:0];
    [galleryView addImage:image animated:NO];
    [cameraViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void) dismissCamera:(id)cameraViewController
{
    [cameraViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
