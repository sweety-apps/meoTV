//
//  TableViewController.h
//  meoTV
//
//  Created by NPHD on 14-5-4.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryViewController.h"
#import "MainViewController.h"
#import "TopViewController.h"

@interface TableViewController : UIViewController<UIGestureRecognizerDelegate> {
    int nCurSelect;
}

@property (nonatomic,retain) IBOutlet UIView* bkgView;
@property (nonatomic,retain) CategoryViewController* categoryController;
@property (nonatomic,retain) MainViewController* mainController;
@property (nonatomic,retain) TopViewController* topController;

-(IBAction) onClickCategory:(id)sender;
-(IBAction) onClickNew:(id)sender;
-(IBAction) onClickTop:(id)sender;

@end
