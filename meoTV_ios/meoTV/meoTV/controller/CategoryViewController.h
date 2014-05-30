//
//  CategoryViewController.h
//  meoTV
//
//  Created by NPHD on 14-5-4.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryMgr.h"

@interface CategoryViewController : UIViewController<CategoryMgrDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSArray* categoryArray;
    NSArray* tagArray;
}

@property (retain, nonatomic) IBOutlet UITableView* categoryTable;

@end
