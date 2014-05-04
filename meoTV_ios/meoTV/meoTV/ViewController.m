//
//  ViewController.m
//  meoTV
//
//  Created by NPHD on 14-5-4.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect rect = self.view.frame;
    
    self.tableController = [[TableViewController alloc] init];
    
    [self.tableController.view setFrame:CGRectMake(rect.origin.x, 20, rect.size.width, rect.size.height - 20)];
    
    [self.view addSubview:self.tableController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [self.tableController release];
    [super dealloc];
}
@end
