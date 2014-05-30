//
//  MainPageController.m
//  dianZan
//
//  Created by NPHD on 14-5-27.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "MainPageController.h"
#import "Common.h"
#import "Content.h"
#import "ContentMgr.h"

@interface MainPageController ()

@end

@implementation MainPageController
@synthesize _contentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->_firstContent = nil;
        self->_secondContent = nil;
        self->_thirdContent = nil;
        self->_curIndex = -1;
        self->_switchView = NO;
        self->_styleView = nil;
        self->_showStyle = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [ContentMgr sharedInstance];
    
    // Do any additional setup after loading the view.
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_contentView setUserInteractionEnabled:YES];
    [_contentView addGestureRecognizer:panGesture];
    [panGesture setDelegate:self];
    [panGesture release];
    
    //
    UISwipeGestureRecognizer* swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [_contentView addGestureRecognizer:swipeGesture];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeGesture release];
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [_contentView addGestureRecognizer:swipeGesture];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeGesture release];
    
    _firstContent = [[ContentViewController alloc] initWithNibName:nil bundle:nil];
    _secondContent = [[ContentViewController alloc] initWithNibName:nil bundle:nil];
    _thirdContent = [[ContentViewController alloc] initWithNibName:nil bundle:nil];
    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-66);
    [_firstContent.view setFrame:rect];
    
    rect = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-66);
    [_secondContent.view setFrame:rect];
    
    rect = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT-66);
    [_thirdContent.view setFrame:rect];
    
    [self->_contentView addSubview:_firstContent.view];
    [self->_contentView addSubview:_secondContent.view];
    [self->_contentView addSubview:_thirdContent.view];
    
    ContentMgr* mgr = [ContentMgr sharedInstance];
    int nCount = [mgr getCount];
    
    if ( nCount == 1 ) {
        Content* content = [mgr getContent:0];
        
        [_secondContent setContent:content];
        _curIndex = 0;
    } else if ( nCount >= 2 ) {
        Content* content1 = [mgr getContent:0];
        Content* content2 = [mgr getContent:1];
        
        [_secondContent setContent:content1];
        [_thirdContent setContent:content2];
        
        _curIndex = 0;
    }
    
    _styleView = [[StyleViewController alloc] initWithNibName:nil bundle:nil];
    [_styleView setDelegate:self];
    [_styleView.view setFrame:CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_styleView.view];
    
    [_styleView.view setHidden:YES];
}

- (void)dealloc {
    [_firstContent release];
    [_secondContent release];
    [_thirdContent release];
    
    [_styleView release];
    
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) handleSwipeLeft : (UISwipeGestureRecognizer*) rec {
    if ( _switchView ) {
        return ;
    }
    
    [self selectTable:2];
}

- (void) handleSwipeRight : (UISwipeGestureRecognizer*) rec {
    if ( _switchView ) {
        return ;
    }
    
    [self selectTable:0];
}

- (void) handlePan : (UIPanGestureRecognizer*) rec {
    if ( _switchView ) {
        return ;
    }
    CGPoint point = [rec translationInView:_contentView];
    
    if ( rec.state == UIGestureRecognizerStateBegan ) {
        _beginDrag = [[NSDate date] timeIntervalSince1970];
    } else if ( rec.state == UIGestureRecognizerStateEnded ) {
        // 判断离哪个tab最近
        CGRect rect = _contentView.frame;
        CGFloat x = rect.origin.x;
        
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        if ( now - _beginDrag < 0.5 ) { // 500ms内的拖动，变化大于20像素就切换
            if ( x < -(SCREEN_WIDTH+10) ) {
                // 显示tab1
                [self selectTable:2];
            } else if ( x > -(SCREEN_WIDTH-10) ) {
                [self selectTable:0];
            } else {
                [self selectTable:1];
            }
        } else {    //500ms外的，只有超过了50%才切换
            if ( x > - (SCREEN_WIDTH/2) ) {
                // 显示tab1
                [self selectTable:0];
            } else if ( x <= -(SCREEN_WIDTH/2) && x > -(SCREEN_WIDTH*3/2) ) {
                // 显示tab2
                [self selectTable:1];
            } else if ( x <= -(SCREEN_WIDTH*3/2) ) {
                // 显示tab3
                [self selectTable:2];
            }
        }
    } else {
        CGRect rect = _contentView.frame;
        rect.origin.x += point.x;

        if ( rect.origin.x > -SCREEN_WIDTH && [_firstContent getContent] == nil ) {
            rect.origin.x = -SCREEN_WIDTH;
        } else if ( rect.origin.x < -SCREEN_WIDTH && [_thirdContent getContent] == nil ) {
            rect.origin.x = -SCREEN_WIDTH;
        }
        
        if ( rect.origin.x > 0 ) {
            rect.origin.x = 0;
        } else if ( rect.origin.x < -2*SCREEN_WIDTH ) {
            rect.origin.x = -2*SCREEN_WIDTH;
        }
        
        _contentView.frame = rect;
        [rec setTranslation:CGPointMake(0, 0) inView:_contentView];
    }
    
    NSLog(@"%f, %f, pt = %f", point.x, point.y, _contentView.frame.origin.x);
}

- (void) selectTable:(int) index {
    int nDestPos = 0;
    if ( index == 0 ) {
        nDestPos = 0;
    } else if ( index == 1 ) {
        nDestPos = -SCREEN_WIDTH;
    } else {
        nDestPos = -SCREEN_WIDTH*2;
    }
    
    if ( nDestPos == _contentView.frame.origin.x ) {
        return ;
    }
    
    CGRect rect = _contentView.frame;
    
    float fTime = 0.1; // 总共0.2s移动到指定的位置
    float pos = fabsf(nDestPos - rect.origin.x);
    fTime = fTime * pos / (SCREEN_WIDTH/2);
    if ( fTime > 0.1 ) {
        fTime = 0.1;
    }
   
    _switchView = YES;
    
    [UIView animateWithDuration:fTime delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect tmp = _contentView.frame;
                         tmp.origin.x = nDestPos;
                         [_contentView setFrame:tmp];
                     }
     
                     completion:^(BOOL finished){
                         if (finished){
                             _switchView = NO;
                             // 把当前显示的项作为第2个
                             [self changeView];
                         }
                     }
     ];
}

- (void) changeView {
    float pos = _contentView.frame.origin.x;
    BOOL bChange = NO;
    if ( pos == 0 ) {
        // 当前显示的是第一项
        ContentViewController* tmp = _thirdContent; // 第三项移动到第一的位置，第1和2往后移动一个，重新加载第1项的数据
        _thirdContent = _secondContent;
        _secondContent = _firstContent;
        _firstContent = tmp;    // 重新加载数据
        
        _curIndex -= 1;
        
        Content* content = [[ContentMgr sharedInstance] getContent:(_curIndex-1)];
        [_firstContent setContent:content];
        
        bChange = YES;
    } else if ( pos == -SCREEN_WIDTH*2 ) {
        // 当前显示的是第三项
        ContentViewController* tmp = _firstContent; // 第1项移动到第3的位置，第2和3往前移动一个，重新加载第3项的数据
        _firstContent = _secondContent;
        _secondContent = _thirdContent;
        _thirdContent = tmp;    // 重新加载数据
        
        _curIndex += 1;
        
        Content* content = [[ContentMgr sharedInstance] getContent:(_curIndex+1)];
        [_thirdContent setContent:content];
        bChange = YES;
    }
    
    if ( bChange ) {
        CGRect rx = _firstContent.view.frame;
        rx.origin.x = 0;
        [_firstContent.view setFrame:rx];
    
        rx.origin.x = SCREEN_WIDTH;
        [_secondContent.view setFrame:rx];
    
        rx.origin.x = SCREEN_WIDTH*2;
        [_thirdContent.view setFrame:rx];
    
        rx = _contentView.frame;
        rx.origin.x = -SCREEN_WIDTH;
        [_contentView setFrame:rx];
    }
}

-(IBAction) onClickStyle:(id)sender {
    [self showStyle];
}

- (void) showStyle {
    [_styleView.view setHidden:NO];
    
    int nPos = -_styleView.view.frame.origin.x;
    double time = nPos / _styleView.view.frame.size.width * 0.3;
    
    _showStyle = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                        [_styleView.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                        [_contentView setAlpha:0.5];
                     }
     
                     completion:^(BOOL finished){
                         if (finished){
                         }
                     }
     ];
}

- (void) hideStyle {
    int nPos = SCREEN_WIDTH+_styleView.view.frame.origin.x;
    double time = nPos / _styleView.view.frame.size.width * 0.3;
    
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [_styleView.view setFrame:CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                         [_contentView setAlpha:1];
                     }
     
                     completion:^(BOOL finished){
                         if (finished){
                             [_styleView.view setHidden:YES];
                             _showStyle = NO;
                             [self setNeedsStatusBarAppearanceUpdate];
                         }
                     }
     ];
}

- (BOOL)prefersStatusBarHidden {
    if ( _showStyle ) {
        return YES;
    }
    return NO;
}

- (void) onHideStyleView {
    [self hideStyle];
}
- (void) onShowStyleView {
    [self showStyle];
}
- (void) onDragStyleView:(UIPanGestureRecognizer*) rec {
    double alpha = -_styleView.view.frame.origin.x / _styleView.view.frame.size.width * 0.5 + 0.5;
    [_contentView setAlpha:alpha];
}
@end
