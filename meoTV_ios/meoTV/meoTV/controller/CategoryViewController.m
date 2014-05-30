//
//  CategoryViewController.m
//  meoTV
//
//  Created by NPHD on 14-5-4.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "CategoryViewController.h"
#import "WebImageView.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController
@synthesize categoryTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        categoryArray = nil;
        tagArray = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[CategoryMgr sharedInstance] requestCategoryList:self];
}

- (void) dealloc {
    if ( categoryArray != nil ) {
        [categoryArray release];
    }
    if ( tagArray != nil ) {
        [tagArray release];
    }
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)categoryLoaded: (NSArray*) catAry tag:(NSArray*) tagAry {
    if ( categoryArray != nil ) {
        [categoryArray release];
    }
    if ( tagArray != nil ) {
        [tagArray release];
    }
    
    categoryArray = [catAry retain];
    tagArray = [tagAry retain];
    
    [categoryTable reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categoryArray count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
    if ( cell == nil ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoryCell"] autorelease];
        [self initCell:cell];
    }
    
    [self updateData:cell index: row];
 
    return cell;
}

- (void) initCell:(UITableViewCell*) cell {
    UIImageView* imageView = [[UIImageView alloc] init];
    [imageView setTag:11];
    [imageView setFrame:CGRectMake(10, 4, 40, 40)];
    [cell.contentView addSubview:imageView];
    [imageView release];
    
    UILabel* label = [[UILabel alloc] init];
    [label setTag:12];
    [label setFrame:CGRectMake(56, 4, 120, 40)];
    [cell.contentView addSubview:label];
    [label release];
}

- (void) updateData:(UITableViewCell*) cell index:(int) row {
    CateInfo* info = [categoryArray objectAtIndex:row];
    
    UIImageView* imageView = (UIImageView*)[cell.contentView viewWithTag:11];
    
    [imageView setImageWithURL:info.imgUrl cacheFile:[NSString stringWithFormat:@"%@.png", info.cid] forever:YES];
    
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:12];
    [label setText:info.name];
}

@end
