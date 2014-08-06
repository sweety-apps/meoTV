//
//  LoginViewController.m
//  yoforchinese
//
//  Created by NPHD on 14-7-28.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "LoginViewController.h"
#import "APService.h"
#import "Friend.h"
#import "FriendViewController.h"
#import "config.h"
#import "SBJson4.h"
#import "JSONKit.h"
#import "Common.h"
#import "AppDelegate.h"
@interface LoginViewController ()
{
    UITextField *username;
    UITextField *pass;
}
@end

@implementation LoginViewController

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
    return 87;
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
        username.keyboardType = UIKeyboardTypeNumberPad;
        username.delegate = self;
        username.backgroundColor = [UIColor clearColor];
        username.placeholder = @"请输入用户名";
        username.textAlignment = NSTextAlignmentCenter;
        username.textColor = [UIColor whiteColor];
        username.font = [UIFont boldSystemFontOfSize:25.f];
        username.textColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor colorWithRed:31/255.f green:176/255.f blue:139/255.f alpha:1.f];
        [cell.contentView addSubview:username];
    }
    if(indexPath.row == 1)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:31/255.f green:177/255.f blue:139/255.f alpha:1.f];
        pass = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, [[UIScreen mainScreen] bounds].size.width-10, 81)];
        pass.keyboardType = UIKeyboardTypeNumberPad;
        pass.backgroundColor = [UIColor clearColor];
        pass.placeholder = @"请输入密码";
        pass.delegate = self;
        pass.textAlignment = NSTextAlignmentCenter;
        pass.textColor = [UIColor whiteColor];
        pass.font = [UIFont boldSystemFontOfSize:25.f];
        pass.textColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor colorWithRed:44/255.f green:197/255.f blue:94/255.f alpha:1.f];
        [cell.contentView addSubview:pass];
    }
    if(indexPath.row == 2)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:43/255.f green:132/255.f blue:211/255.f alpha:1.f];
        cell.textLabel.text = @"点击登录";
       
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
        [username resignFirstResponder];
        [pass resignFirstResponder];
        [APService setTags:[NSSet setWithObjects:@"user", nil] alias:username.text callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
        
        NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
        [parm setObject:username.text forKey:@"owner"];
        
        NSString *json = [[[SBJson4Writer alloc]init] stringWithObject:parm];
        
        NSURL *url = [NSURL URLWithString:kFetchFriendLists];
        
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
    NSDictionary *retinfo = [responseString objectFromJSONString];
    [Common sharedInstance].login = username.text;
    [Common sharedInstance].nickname = pass.text;
    if([[retinfo objectForKey:@"ret"] integerValue] == 0)
    {
        NSArray *friends = [retinfo objectForKey:@"friends"];
        NSMutableArray *parm = [[NSMutableArray alloc]init];
        for (NSDictionary *info in friends)
        {
            Friend *friend = [[Friend alloc]init];
            friend.name = [info objectForKey:@"nickname"];
            friend.phone = [info objectForKey:@"phone"];
            [parm addObject:friend];
        }
        FriendViewController *fvc = [[FriendViewController alloc]initWithFriends:parm style:UITableViewStylePlain];
      
        [self presentViewController:fvc animated:YES completion:^{
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            delegate.window.rootViewController = fvc;
        }];
    }
    
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    
}
@end
