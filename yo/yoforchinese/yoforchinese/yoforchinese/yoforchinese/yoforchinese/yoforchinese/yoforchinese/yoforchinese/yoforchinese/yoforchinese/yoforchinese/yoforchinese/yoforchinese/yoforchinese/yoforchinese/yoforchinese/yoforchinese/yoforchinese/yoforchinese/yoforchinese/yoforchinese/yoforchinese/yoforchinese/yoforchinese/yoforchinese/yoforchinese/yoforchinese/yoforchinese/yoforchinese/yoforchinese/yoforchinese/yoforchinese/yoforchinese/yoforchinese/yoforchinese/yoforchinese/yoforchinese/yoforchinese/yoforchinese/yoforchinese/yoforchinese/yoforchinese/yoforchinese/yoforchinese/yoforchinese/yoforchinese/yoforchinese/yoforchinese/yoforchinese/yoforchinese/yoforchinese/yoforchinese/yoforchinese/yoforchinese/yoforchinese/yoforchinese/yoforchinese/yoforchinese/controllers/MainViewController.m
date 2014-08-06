//
//  MainViewController.m
//  yoforchinese
//
//  Created by NPHD on 14-7-28.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "MainViewController.h"
#import "SignUpViewController.h"
#import "LoginViewController.h"
#import "NSString+MD5.h"
#import "AFAppDotNetAPIClient.h"
#import "MF_Base64Additions.h"
#import "SBJson4.h"
#import "config.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor = [UIColor colorWithRed:136/255.f green:64/255.f blue:167/255.f alpha:1.f];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"CellForMainView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:kFontSize];
    if(indexPath.row == 0)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:31/255.f green:177/255.f blue:139/255.f alpha:1.f];
        cell.textLabel.text = @"注册";
        
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    if(indexPath.row == 1)
    {
       cell.contentView.backgroundColor = [UIColor colorWithRed:44/255.f green:197/255.f blue:94/255.f alpha:1.f];
        cell.textLabel.text = @"登录";
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    if(indexPath.row == 2)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:43/255.f green:132/255.f blue:211/255.f alpha:1.f];
        cell.textLabel.text = @"找回密码";
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    if(indexPath.row == 3)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:43/255.f green:132/255.f blue:211/255.f alpha:1.f];
        cell.textLabel.text = @"推送";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:20.f];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        [self.navigationController pushViewController:[[SignUpViewController alloc]init] animated:YES];
    }else if(indexPath.row == 1)
    {
        [self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES];
    }else if(indexPath.row == 3)
    {
        NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
        [parm setObject:@"yo" forKey:@"content"];
        [parm setObject:@"18630148154" forKey:@"to"];
        
        NSString *json = [[[SBJson4Writer alloc]init] stringWithObject:parm];
       
        NSURL *url = [NSURL URLWithString:kSendMsg];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];

        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request setPostBody:[NSMutableData dataWithData:[json dataUsingEncoding:NSUTF8StringEncoding]]];
        [request startAsynchronous];
    }
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    
    NSData *responseData = [request responseData];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request

{
    NSError *error = [request error];
}
@end
