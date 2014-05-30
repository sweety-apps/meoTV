//
//  ImageController.m
//  dianZan
//
//  Created by NPHD on 14-5-29.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "ImageController.h"

@interface ImageController ()

@end

@implementation ImageController
@synthesize _imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->_filePath = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_imageView setImage: [UIImage imageWithContentsOfFile:_filePath]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if ( _filePath != nil ) {
        [_filePath release];
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
