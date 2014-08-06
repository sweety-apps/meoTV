//
//  SignUpViewController.m
//  yoforchinese
//
//  Created by NPHD on 14-7-28.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "SignUpViewController.h"
#import "config.h"
#import "SBJson4.h"
#import "config.h"
#import "JSONKit.h"
#import "FriendViewController.h"
#import "Common.h"
#import "KeyChainHelper.h"
@interface SignUpViewController ()
{
    UITextField *username;
    UITextField *pass;
}
@end

@implementation SignUpViewController

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
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cellForSignVC";
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
        username = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, [[UIScreen mainScreen] bounds].size.width-10, 81)];
        username.delegate = self;
        username.backgroundColor = [UIColor clearColor];
        username.placeholder = @"请输入手机号码";
        username.textAlignment = NSTextAlignmentCenter;
        username.textColor = [UIColor whiteColor];
        username.font = [UIFont boldSystemFontOfSize:kFontSize];
        username.textColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor colorWithRed:31/255.f green:176/255.f blue:139/255.f alpha:1.f];
        username.keyboardType = UIKeyboardTypeNumberPad;
        [cell.contentView addSubview:username];
    }
    if(indexPath.row == 1)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:31/255.f green:177/255.f blue:139/255.f alpha:1.f];
        pass = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, [[UIScreen mainScreen] bounds].size.width-10, 81)];
        pass.backgroundColor = [UIColor clearColor];
        pass.placeholder = @"请输入昵称";
        pass.delegate = self;
        pass.textAlignment = NSTextAlignmentCenter;
        pass.textColor = [UIColor whiteColor];
        pass.font = [UIFont boldSystemFontOfSize:kFontSize];
        pass.textColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor colorWithRed:44/255.f green:197/255.f blue:94/255.f alpha:1.f];
        [cell.contentView addSubview:pass];
    }
    if(indexPath.row == 2)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:43/255.f green:132/255.f blue:211/255.f alpha:1.f];
        cell.textLabel.text = @"点击注册";

        cell.textLabel.textColor = [UIColor whiteColor];
    }
    if(indexPath.row == 3)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:39/255.f green:56/255.f blue:75/255.f alpha:1.f];
        cell.textLabel.text = @"返回";
        
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    // Configure the cell...
    
    return cell;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [username resignFirstResponder];
    [pass resignFirstResponder];
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if(indexPath.row == 2)
    {
        NSString *phone = username.text;
        NSString *nickName = pass.text;
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:kSignUp]];
        NSDictionary *parm = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",nickName,@"nickname", nil];
        NSString *json = [[[SBJson4Writer alloc]init] stringWithObject:parm];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request setPostBody:[NSMutableData dataWithData:[json dataUsingEncoding:NSUTF8StringEncoding]]];
        [request startAsynchronous];
        
    }
}
#pragma mark - 网络请求代理
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *info = [responseString objectFromJSONString];
    if([[info objectForKey:@"add"] boolValue])
    {
        FriendViewController *fvc = [[FriendViewController alloc]initWithFriends:nil style:UITableViewStylePlain];
        [Common sharedInstance].login = username.text;
        [Common sharedInstance].nickname = pass.text;
        [[KeyChainHelper sharedInstance] saveAccount:[Common sharedInstance].login];
        [[KeyChainHelper sharedInstance] savePass:[Common sharedInstance].nickname];
        [self presentViewController:fvc animated:YES completion:^{
            username.text = nil;
            pass.text = nil;
        }];
    }else
    {
        
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request

{
    NSError *error = [request error];
}

@end
