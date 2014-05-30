//
//  StyleViewController.m
//  dianZan
//
//  Created by NPHD on 14-5-30.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "StyleViewController.h"
#import "Common.h"

@interface StyleViewController ()

@end

@implementation StyleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->_beginDrag = 0;
        self->_delegate = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Do any additional setup after loading the view.
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:panGesture];
    [panGesture setDelegate:self];
    [panGesture release];
    
    //
    UISwipeGestureRecognizer* swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [self.view addGestureRecognizer:swipeGesture];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeGesture release];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setDelegate:(id) delegate {
    _delegate = delegate;
}

- (void) handleSwipeLeft : (UISwipeGestureRecognizer*) rec {
    // 隐藏
    [_delegate onHideStyleView];
}

- (void) handlePan : (UIPanGestureRecognizer*) rec {
    CGPoint point = [rec translationInView:self.view];
    
    if ( rec.state == UIGestureRecognizerStateBegan ) {
        _beginDrag = [[NSDate date] timeIntervalSince1970];
    } else if ( rec.state == UIGestureRecognizerStateEnded ) {
        // 判断离哪个tab最近
        CGRect rect = self.view.frame;
        CGFloat x = rect.origin.x;
        
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        if ( now - _beginDrag < 0.5 ) { // 500ms内的拖动，变化大于20像素就切换
            if ( x < -10 ) {
                [_delegate onHideStyleView];
            } else {
                [_delegate onShowStyleView];
            }
        } else {    //500ms外的，只有超过了50%才切换
            if ( x < - (SCREEN_WIDTH/2) ) {
                [_delegate onHideStyleView];
            } else {
                [_delegate onShowStyleView];
            }
        }
    } else {
        CGRect rect = self.view.frame;
        rect.origin.x += point.x;
        
        if ( rect.origin.x > 0 ) {
            rect.origin.x = 0;
        } else if ( rect.origin.x < -SCREEN_WIDTH ) {
            rect.origin.x = -SCREEN_WIDTH;
        }
        
        if ( rect.origin.x > 0 ) {
            rect.origin.x = 0;
        } else if ( rect.origin.x < -2*SCREEN_WIDTH ) {
            rect.origin.x = -2*SCREEN_WIDTH;
        }
        
        self.view.frame = rect;
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
        
        [_delegate onDragStyleView:rec];
    }
}

@end
