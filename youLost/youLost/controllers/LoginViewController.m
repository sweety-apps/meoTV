//
//  LoginViewController.m
//  youLost
//
//  Created by 1528 MAC on 14-9-15.
//  Copyright (c) 2014年 ksd. All rights reserved.
//

#import "LoginViewController.h"
#import "ASTextField.h"
#import "MBProgressHUD.h"
#import "KSDIMStatus.h"
#import "NSString+MD5.h"
#import "User.h"
#import "Common.h"
#import "Appdelegate.h"
#import "ContentViewController.h"
#import "RegViewController.h"
#import "NaviItems.h"
@interface LoginViewController ()
{
    MBProgressHUD *hud;
}
@end

@implementation LoginViewController
@synthesize usernameField = _usernameField,passwordField = _passwordField;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //bake a cellArray to contain all cells
   // self.cellArray = [NSMutableArray arrayWithObjects: _usernameCell, _passwordCell, _doneCell, nil];
    self.title = @"注册";
    self.view.backgroundColor = [UIColor colorWithRed:114/255.f green:127/255.f blue:188/255.f alpha:1.f];
    _usernameField = [[ASTextField alloc]initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-250/320.f*[[UIScreen mainScreen] bounds].size.width)/2.f, 90, 250/320.f*[[UIScreen mainScreen] bounds].size.width, 40)];
    _passwordField = [[ASTextField alloc]initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-250/320.f*[[UIScreen mainScreen] bounds].size.width)/2.f, 135, 250/320.f*[[UIScreen mainScreen] bounds].size.width, 40)];
    
    [_usernameField setupTextFieldWithIconName:@"user_name_icon"];
    [_passwordField setupTextFieldWithIconName:@"password_icon"];
    _passwordField.placeholder = @"密   码";
    _usernameField.placeholder = @"用户名";
    _passwordField.secureTextEntry = YES;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)]];
    [self.view addSubview:_passwordField];
    [self.view addSubview:_usernameField];
    
    UIButton *login = [UIButton buttonWithType:UIButtonTypeCustom];
    login.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-250/320.f*[[UIScreen mainScreen] bounds].size.width)/2.f, 212/568.f*[[UIScreen mainScreen] bounds].size.height, 250/320.f*[[UIScreen mainScreen] bounds].size.width, 40);
    [login setBackgroundImage:[UIImage imageNamed:@"login_button.png"] forState:UIControlStateNormal];
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:login];
    [login addTarget:self action:@selector(letMeIn:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *reg = [UIButton buttonWithType:UIButtonTypeCustom];
    reg.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-250/320.f*[[UIScreen mainScreen] bounds].size.width)/2.f, 263/568.f*[[UIScreen mainScreen] bounds].size.height, 250/320.f*[[UIScreen mainScreen] bounds].size.width, 40);
    [reg setBackgroundImage:[UIImage imageNamed:@"login_button.png"] forState:UIControlStateNormal];
    [reg setTitle:@"注册" forState:UIControlStateNormal];
    [reg addTarget:self action:@selector(letMeReg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reg];
    
}
- (void)hide
{
    [self resignAllResponders];
}



- (void)letMeIn:(id)sender {
    if(_usernameField.text.length == 0 || _passwordField.text.length == 0)
    {
        return;
    }
    [self resignAllResponders];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登录";
    [[KSDIMStatus sharedClient] POST:@"/login" parameters:[NSDictionary dictionaryWithObjectsAndKeys:_usernameField.text,@"username", [_passwordField.text MD5Digest],@"password",nil] success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        if([[dic objectForKey:@"retcode"] integerValue] == 0)
        {
            NSDictionary *data = [dic objectForKey:@"data"];
            User *user = [[User alloc]init];
            user.username = _usernameField.text;
            [Common sharedInstance].user = user;
            [Common sharedInstance].token = [data objectForKey:@"token"];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[[ContentViewController alloc]init]];
            
            [self presentViewController:navi animated:YES completion:^{
                AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                delegate.window.rootViewController = navi;
            }];
        }else
        {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"登录失败" message:[dic objectForKey:@"desc"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}
- (void)letMeReg:(id)sender
{
    [self.navigationController pushViewController:[[RegViewController alloc]init] animated:YES];
   
}

- (void)resignAllResponders{
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

@end
