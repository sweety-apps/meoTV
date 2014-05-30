//
//  GifController.m
//  dianZan
//
//  Created by NPHD on 14-5-29.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "GifController.h"

@interface GifController ()

@end

@implementation GifController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->_imageView = nil;
        self->_filePath = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _imageView = [[SCGIFImageView alloc] initWithFrame:self.view.frame];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:_imageView];
    
    NSData* imageData = [NSData dataWithContentsOfFile:_filePath];
    [_imageView setData:imageData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if ( _filePath != nil ) {
        [_filePath release];
        _filePath = nil;
    }
    if ( _imageView != nil ) {
        [_imageView release];
        _imageView = nil;
    }
    [super dealloc];
}

- (UIView*) getView {
    return self.view;
}

- (void) setFilePath:(NSString*) filePath {
    _filePath = [filePath copy];
}

@end
