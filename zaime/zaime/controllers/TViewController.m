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
#import "ACEDrawingView.h"
#import "KSDFingerDistance.h"
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
    
    CGPoint lastReceivePoint;
    NSDictionary *_actionMapping;
   
    
    KSDSelectColor *select;
    
    BOOL isAppera;
    
    UIButton *selectColour;
    UIButton *creamer;
    UIButton *otherAvatar;
    UIButton *myAvatar;
    
    KSDPhoto *photo;
    WCGalleryView *galleryView;
    
    
   
    
    
}
@property(strong,nonatomic) MSWeakTimer *siwtchView;
@property(strong,nonatomic) dispatch_queue_t privateQueue;
@property(nonatomic,assign) NSTimeInterval lastTime;
@property(nonatomic,strong) NSMutableArray *photos;
@property(nonatomic,strong) ACEDrawingView *drawView;
@property(nonatomic,strong) KSDMovePathView *aview;
@property(nonatomic,strong) UIView *backgroundView;
@property(nonatomic,strong) KSDFingerDistance *distance;
@property(nonatomic,assign) CGPoint myPos;
@property(nonatomic,assign) CGPoint otherPos;
@property (strong, nonatomic) MSWeakTimer *clearSelf;
@end

@implementation TViewController

- (void)clearAnimation
{
    [self.aview.layer removeAllAnimations];
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
    self.myPos = CGPointMake(-1, -1);
     self.otherPos = CGPointMake(-1, -1);
    self.privateQueue = dispatch_queue_create("distanceclear", DISPATCH_QUEUE_CONCURRENT);
     TViewController __weak *tmpself = self;
    KSDLiveBlurView *bg = [[KSDLiveBlurView alloc] initWithFrame: self.view.bounds];
    
    bg.originalImage = [UIImage imageNamed:@"bg.png"];
    bg.isGlassEffectOn = YES;
    [self.view addSubview:bg];
    
   
    
    
    self.backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.backgroundView];
    
    
    galleryView      = [[WCGalleryView alloc] initWithImages:[NSArray array] degress:[NSMutableArray array] frame:CGRectMake(-100, -100, 200.0f, 200.0f)];
    galleryView.backgroundColor     = [UIColor clearColor];
    galleryView.borderColor         = [UIColor whiteColor];
    galleryView.borderWidth         = 10.0f;
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
    [self.backgroundView addSubview:galleryView];
    self.photos = [[NSMutableArray alloc]initWithCapacity:10];
    
    
    
    
   
    
    downLoadEmotion = [[KSDDownloadEmotion alloc]init];
    [downLoadEmotion downloadWithURLS:[NSArray arrayWithObjects:@"http://d.hiphotos.baidu.com/image/pic/item/5ab5c9ea15ce36d39e65badb38f33a87e850b1f3.jpg",@"http://e.hiphotos.baidu.com/image/pic/item/2cf5e0fe9925bc31d0f338735cdf8db1ca1370aa.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/a686c9177f3e670966ec7c1439c79f3df9dc5568.jpg",nil] :^(UIImage *image, NSString *url) {
        KSDPhoto *p = [[KSDPhoto alloc]init];
        p.url = url;
        [self.photos addObject:p];
        [galleryView addImage:image animated:NO];
    }];
   // [self performSelector:@selector(test) withObject:nil afterDelay:10.f];
   
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
    
    self.aview = [[KSDMovePathView alloc]initWithFrame:CGRectMake(0, otherAvatar.frame.size.height+30, SCREENWIDTH, SCREENHEIGHT-30-otherAvatar.frame.size.height-myAvatar.frame.size.height-30)];
    [self.aview setMoving:^(CGPoint point) {
        tmpself.myPos = point;
        BaseMesage *message = [tmpself createMsgWithTo:kConnectUserName from:kLoginUserName content:[NSString stringWithFormat:@"%f-%f",point.x,point.y] type:MessageText];
        [[KSDXMPPClient sharedInstance] sendMsg:message];
        
        
        BACK((^{
            NSString *t = [NSString stringWithFormat:@"%d",(int)sqrt((tmpself.myPos.x-tmpself.otherPos.x)*(tmpself.myPos.x-tmpself.otherPos.x)+(tmpself.myPos.y-tmpself.otherPos.y)*(tmpself.myPos.y-tmpself.otherPos.y))];
            if(t.length == 0)
            {
                t = @"错误";
            }
            MAIN(^{
                
                tmpself.distance.diatance.text = t;
            });
            
        }));
    }];
    [self.aview setMeet:^(CGPoint point) {
        // AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }];
    [self.aview setEnd:^(CGPoint point) {

    }];
    
    self.drawView = [[ACEDrawingView alloc]initWithFrame:CGRectMake(0, otherAvatar.frame.size.height+30, SCREENWIDTH, SCREENHEIGHT-30-otherAvatar.frame.size.height-myAvatar.frame.size.height-30)];
    [self.backgroundView addSubview:self.aview];
    
    
    
    
    
    
    
}
- (void)switchViewAction
{
    MAIN(^{
        [self.siwtchView invalidate];
        self.siwtchView = nil;
        [UIView animateWithDuration:1.f animations:^{
            self.distance.text.alpha = 0;
            self.distance.diatance.alpha = 0;
            
        } completion:^(BOOL finished){
            [self.distance removeFromSuperview];
            self.distance = nil;
        }];
    });
    
}
- (void)addMyAvatar
{
    myAvatar = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *selfAvatar = [UIImage imageNamed:@"selfNotLogin"];
    [myAvatar setImage:selfAvatar forState:UIControlStateNormal];
    myAvatar.frame = CGRectMake(0, 0, selfAvatar.size.width/2.f, selfAvatar.size.height/2.f);
    myAvatar.center = CGPointMake(SCREENWIDTH/2.f, SCREENHEIGHT-30-selfAvatar.size.height/4.f);
    [self.backgroundView addSubview:myAvatar];
}
- (void)addOtherAvatar
{
    otherAvatar = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *otherAvatarImage = [UIImage imageNamed:@"otherNotLogin"];
    [otherAvatar setImage:otherAvatarImage forState:UIControlStateNormal];
    otherAvatar.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-otherAvatarImage.size.width/2.f)/2.f, 30, otherAvatarImage.size.width/2.f, otherAvatarImage.size.height/2.f);
    [self.backgroundView addSubview:otherAvatar];
}
- (void)hide:(UIButton*)sender
{
    isAppera = NO;
    [select removeSubView];
    UIImage *four = [UIImage imageNamed:@"0"];
    select.animationImages=[NSArray arrayWithObjects:
                             [UIImage imageNamed:@"4"],
                             [UIImage imageNamed:@"3"],
                             [UIImage imageNamed:@"2"],
                             [UIImage imageNamed:@"1"],
                             [UIImage imageNamed:@"0"],
                             nil ];
    select.animationDuration=0.2;
    [select setImage:four];
    [select setAnimationRepeatCount:1];
    [select startAnimating];
  //  [self.view bringSubviewToFront:galleryView];
    [select performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];

}
- (void)show:(UIButton*)sender
{
    isAppera = YES;
    [self.backgroundView bringSubviewToFront:selectColour];
    UIImage *four = [UIImage imageNamed:@"4"];
    NSLog(@"show->%f",four.size.width);
    TViewController __weak *tmp = self;
    if(!select)
    {

       
        select =[[KSDSelectColor alloc] initWithFrame:CGRectMake(29, SCREENHEIGHT-30-four.size.height/2.f, four.size.width/2.f, four.size.height/2.f)];
        CGPoint center = select.center;
        center.x = sender.center.x;
        select.center = center;
        [select setSelectColor:^(UIColor *color) {
            if(tmp.drawView.superview == nil)
            {
                
                [tmp.backgroundView insertSubview:tmp.drawView belowSubview:tmp.aview];
                [tmp.aview removeFromSuperview];
            }
            [tmp hide:nil];
            tmp.drawView.lineColor = color;
           
        }];
        
    }
    [self.backgroundView insertSubview:select belowSubview:selectColour];
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
    [select performSelector:@selector(addButton) withObject:nil afterDelay:0.3f];
  
}

- (void)drawing:(UIButton*)sender
{
    if(isAppera)
    {
        [self hide:sender];
        
    }else
    {
        [self show:sender];
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
    
    [self.backgroundView addSubview:creamer];
    
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
    [self.backgroundView addSubview:selectColour];
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
            self.otherPos = rpoint;
            [self.aview addPoint:rpoint];
            if(!self.distance)
            {
                self.distance = [[KSDFingerDistance alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
                self.distance.center = self.view.center;
                [UIView animateWithDuration:1.5 animations:^{
                    self.distance.text.alpha = 1.f;
                    self.distance.diatance.alpha = 1.f;
                    [self.view insertSubview:self.distance belowSubview:self.backgroundView];
                    
                } completion:nil];
            }
            BACK((^{
                NSString *t = [NSString stringWithFormat:@"%d",(int)sqrt((self.myPos.x-self.otherPos.x)*(self.myPos.x-self.otherPos.x)+(self.myPos.y-self.otherPos.y)*(self.myPos.y-self.otherPos.y))];
                if(t.length == 0)
                {
                    t = @"错误";
                }
                MAIN(^{
                
                    self.distance.diatance.text = t;
                });
            
            }));
          
            [self.siwtchView invalidate];
            self.siwtchView = nil;
            self.siwtchView = [MSWeakTimer scheduledTimerWithTimeInterval:3
                                                                   target:self
                                                                 selector:@selector(switchViewAction)
                                                                 userInfo:nil
                                                                  repeats:YES
                                                            dispatchQueue:self.privateQueue];;
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
    [UIImageJPEGRepresentation(image, 1.f) writeToFile:filePath atomically:YES];
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
