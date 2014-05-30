//
//  ContentViewController.m
//  dianZan
//
//  Created by NPHD on 14-5-27.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "ContentViewController.h"
#import "Common.h"
#import "ContentView.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->_content = nil;
        self->_operate = nil;
        self->_contentView = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-66)];
    
    _operate = [[ContentOperateController alloc] initWithNibName:nil bundle:nil];
    [self.view addSubview:_operate.view];
    
    CGRect rect = _operate.view.frame;
    rect.origin.y = self.view.frame.size.height - rect.size.height;
    [_operate.view setFrame:rect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if ( _operate != nil ) {
        [_operate release];
        _operate = nil;
    }
    
    if ( _content != nil ) {
        [_content release];
        _content = nil;
    }
    
    [super dealloc];
}

- (NSString*) getTitle {
    if ( _content != nil ) {
        return _content.title;
    }
    return @"";
}

- (Content*) getContent {
    return _content;
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
    
    if ( _contentView != nil ) {
        [[_contentView getView] removeFromSuperview];
        [_contentView release];
        _contentView = nil;
    }
    
    NSString* contentPath = [self->_content getContentPath];
    if ( [contentPath length] != 0 ) {
        // 文件被成功加载了
        _contentView = [ContentView loadContentFromPath:contentPath Type:_content.cType];
        
        [self.view insertSubview:[_contentView getView] atIndex:0];
    }
    
    [_operate setContent:_content];
}

@end
