//
//  TableViewController.m
//  meoTV
//
//  Created by NPHD on 14-5-4.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController
@synthesize bkgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        nCurSelect = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.bkgView setUserInteractionEnabled:YES];
    [self.bkgView addGestureRecognizer:panGesture];
    [panGesture setDelegate:self];
    [panGesture release];
    
    //
    UISwipeGestureRecognizer* swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [self.bkgView addGestureRecognizer:swipeGesture];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeGesture release];
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [self.bkgView addGestureRecognizer:swipeGesture];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeGesture release];
    
    // 内容背景
    CGRect rect = self.bkgView.frame;
    rect.size.height = self.bkgView.frame.size.height - 48;
    self.bkgView.frame = rect;
    
    // 创建分类
    self.categoryController = [[CategoryViewController alloc] init];
    [self.categoryController.view setFrame:CGRectMake(0, 0, 160, rect.size.height)];
    [self.bkgView addSubview:self.categoryController.view];
    
    // 最新视频
    self.mainController = [[MainViewController alloc] init];
    [self.mainController.view setFrame:CGRectMake(160, 0, 320, rect.size.height)];
    [self.bkgView addSubview:self.mainController.view];
    
    // 排行榜
    self.topController = [[TopViewController alloc] init];
    [self.topController.view setFrame:CGRectMake(480, 0, 320, rect.size.height)];
    [self.bkgView addSubview:self.topController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [self.topController release];
    [self.mainController release];
    [self.categoryController release];
    
    [super dealloc];
}

- (void) selectTable:(int) index {
    int nDestPos = 0;
    if ( index == 0 ) {
        nDestPos = 0;
    } else if ( index == 1 ) {
        nDestPos = -160;
    } else {
        nDestPos = -480;
    }
    
    if ( nDestPos == self.bkgView.frame.origin.x ) {
        return ;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    CGRect rect = self.bkgView.frame;
    
    float fTime = 0.2; // 总共0.2s移动到指定的位置
    float pos = fabsf(nDestPos - rect.origin.x);
    fTime = fTime * pos / 160;
    if ( fTime > 0.2 ) {
        fTime = 0.2;
    }
    [UIView setAnimationDuration:fTime];
    
    rect.origin.x = nDestPos;
    
    [self.bkgView setFrame:rect];
    
    [UIView commitAnimations];
    
    nCurSelect = index;
}

- (void) handleSwipeLeft : (UISwipeGestureRecognizer*) rec {
    if ( nCurSelect != 2 ) {
        [self selectTable:nCurSelect + 1];
    }
}

- (void) handleSwipeRight : (UISwipeGestureRecognizer*) rec {
    if ( nCurSelect != 0 ) {
        [self selectTable:nCurSelect - 1];
    }
}

- (void) handlePan : (UIPanGestureRecognizer*) rec {
    CGPoint point = [rec translationInView:self.bkgView];
    
    if ( rec.state == UIGestureRecognizerStateEnded ) {
        // 判断离哪个tab最近
        CGRect rect = self.bkgView.frame;
        CGFloat x = rect.origin.x;
        if ( x > - 80 ) {
            // 显示tab1
            [self selectTable:0];
        } else if ( x <= -80 && x > -320 ) {
            // 显示tab2
            [self selectTable:1];
        } else if ( x <= -320 ) {
            // 显示tab3
            [self selectTable:2];
        }
    } else {
        if ( point.x >= 1 || point.x <= -1 ) {
            CGRect rect = self.bkgView.frame;
            rect.origin.x += point.x;
            if ( rect.origin.x > 0) {
                rect.origin.x = 0;
            } else if ( rect.origin.x < 320 - rect.size.width ) {
                rect.origin.x = 320 - rect.size.width;
            }
        
            self.bkgView.frame = rect;
        
            [rec setTranslation:CGPointMake(0, 0) inView:self.bkgView];
        }
    }
    
    NSLog(@"%f, %f", point.x, point.y);
}

-(IBAction) onClickCategory:(id)sender {
    [self selectTable:0];
}

-(IBAction) onClickNew:(id)sender {
    [self selectTable:1];
}

-(IBAction) onClickTop:(id)sender {
    [self selectTable:2];
}

@end
