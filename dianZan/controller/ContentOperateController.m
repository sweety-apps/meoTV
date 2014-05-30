//
//  ContentOperateController.m
//  dianZan
//
//  Created by NPHD on 14-5-29.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "ContentOperateController.h"

@interface ContentOperateController ()

@end

@implementation ContentOperateController
@synthesize _btnZan;
@synthesize _imageZan;
@synthesize _viewZan;
@synthesize _viewCoin;
@synthesize _labelZan;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->_nCount = 0;
        self->_content = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickZan:(id)sender {
    [self playZanUpAni];
    
    [self playMusic:@"coin.mp3"];
    
    if ( (_nCount+1) == 32 ) {
        [self playMusic:@"32zan.mp3"];
    }
    [self setZanCount:(_nCount+1)];
}

- (void) setZanCount:(int) nCount {
    _nCount = nCount;
    
    NSString* text = [NSString stringWithFormat:@"%d个赞", _nCount];
    [_labelZan setText:text];
}

- (void) setContent:(Content*) content {
    if ( self->_content != nil ) {
        [self->_content release];
    }
    
    if ( content == nil ) {
        self->_content = nil;
    } else {
        self->_content = [content retain];
    }
    
    [self setZanCount:0];
}

- (void) playZanUpAni {
    [_imageZan stopAnimating];
    
    NSMutableArray* imageArray = [NSMutableArray array];
    
    UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"zan"]];
    [imageArray addObject:image];
    
    image = [UIImage imageNamed:[NSString stringWithFormat:@"zan2"]];
    [imageArray addObject:image];
    
    image = [UIImage imageNamed:[NSString stringWithFormat:@"zan3"]];
    [imageArray addObject:image];
    
    _imageZan.animationImages = imageArray;
    _imageZan.animationDuration = 0.1;
    _imageZan.animationRepeatCount = 1;
    
    [_imageZan startAnimating];
    
    [NSTimer scheduledTimerWithTimeInterval:_imageZan.animationDuration
                                target:self
                                selector:@selector(onFrameAnimationFinished:)
                                userInfo:@"up"
                                repeats:NO];
}

- (void)viewZanDown {
    [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect tmp = _viewZan.frame;
                         tmp.origin.y = 110;
                         [_viewZan setFrame:tmp];
                     }
     
                     completion:^(BOOL finished){
                         if (finished){
                         }
                     }
     ];
}

- (void)onFrameAnimationFinished:(NSTimer *)timer{
    [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect tmp = _viewZan.frame;
                         tmp.origin.y = 105;
                         [_viewZan setFrame:tmp];
                     }
     
                     completion:^(BOOL finished){
                         if (finished){
                             [self viewZanDown];
                         }
                     }
     ];
    
    [self playCoinAni];
}

- (void) playMusic:(NSString*) filePath {
    
    NSString* file = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filePath];
    
    NSData* data = [NSData dataWithContentsOfFile:file];
    
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithData:data error:nil];
    player.delegate = self;
    //触发play事件的时候会将mp3文件加载到内存中，然后再播放，所以开始的时候可能按按钮的时候会卡，所以需要prepare
    [player prepareToPlay];
    [player play];
}

- (void) playCoinAni {
    UIImageView* imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 125)] autorelease];
    
    [_viewCoin addSubview:imageView];
    
    NSMutableArray* imageArray = [NSMutableArray array];
    UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"coin1"]];
    [imageArray addObject:image];
    image = [UIImage imageNamed:[NSString stringWithFormat:@"coin2"]];
    [imageArray addObject:image];
    image = [UIImage imageNamed:[NSString stringWithFormat:@"coin3"]];
    [imageArray addObject:image];
    image = [UIImage imageNamed:[NSString stringWithFormat:@"coin4"]];
    [imageArray addObject:image];
    
    imageView.animationImages = imageArray;
    imageView.animationDuration = 0.2;
    imageView.animationRepeatCount = 1;
    
    [imageView startAnimating];

    [NSTimer scheduledTimerWithTimeInterval:imageView.animationDuration
                                     target:self
                                   selector:@selector(onCoinAnimationFinished:)
                                   userInfo:imageView
                                    repeats:NO];
}

- (void)onCoinAnimationFinished:(NSTimer *)timer{
    UIImageView* imageView = (UIImageView*)[timer userInfo];
    
    [imageView removeFromSuperview];
}

/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    player.delegate = nil;
    [player release];
}

@end
