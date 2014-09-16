//
//  SetPasswordViewController.m
//  youLost
//
//  Created by 1528 MAC on 14-9-9.
//  Copyright (c) 2014年 ksd. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "ASTextField.h"
#import "KSDIMStatus.h"
#import "AppDelegate.h"
#import "HostViewController.h"
#import "MBProgressHUD.h"
#import "NSString+MD5.h"
@interface SetPasswordViewController ()
{
    ASTextField *pass;
    ASTextField *passAgain;
    ASTextField *nickName;
    NSString *_phone;
    MBProgressHUD *hud;
}
@end

@implementation SetPasswordViewController

- (id)initWithPhone:(NSString *)phone
{
    self = [super init];
    if(self)
    {
        _phone = phone;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *remind = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, 40)];
    remind.backgroundColor = [UIColor clearColor];
    remind.text = @"请设置您的密码";
    remind.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:remind];
    self.view.backgroundColor = [UIColor colorWithRed:113/255.f green:128/255.f blue:190/255.f alpha:1.f];
    
    nickName = [[ASTextField alloc]initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-280)/2.f, 80, 280, 40)];
    [nickName setupTextFieldWithIconName:@"user_name_icon"];
    nickName.placeholder = @"请填写昵称";
    [self.view addSubview:nickName];

    
    
    pass = [[ASTextField alloc]initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-280)/2.f, 124, 280, 40)];
     [pass setupTextFieldWithIconName:@"password_icon"];
    pass.placeholder = @"请填写密码";
    [self.view addSubview:pass];
    
    passAgain = [[ASTextField alloc]initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-280)/2.f, 168, 280, 40)];
    [passAgain setupTextFieldWithIconName:@"password_icon"];
    passAgain.placeholder = @"请再次填写密码";
    [self.view addSubview:passAgain];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setBackgroundImage:[UIImage imageNamed:@"login_button.png"] forState:UIControlStateNormal];
    submit.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-280)/2.f, 220, 280, 40);
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(reg) forControlEvents:UIControlEventTouchUpInside];
    self.title = @"设置密码";
    [self.view addSubview:submit];
    
    
    
    
    
}
- (void)reg
{
    
    [nickName resignFirstResponder];
    [passAgain resignFirstResponder];
    [pass resignFirstResponder];
    if(![pass.text isEqualToString:passAgain.text])
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码输入不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if(nickName.text.length == 0)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"昵称不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在设置...";
    [[KSDIMStatus sharedClient] POST:@"/reg" parameters:[NSDictionary dictionaryWithObjectsAndKeys:[pass.text MD5Digest],@"password",_phone,@"username",nickName.text,@"nickName", nil] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *retinfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if([[retinfo objectForKey:@"retcode"] integerValue] == 0)
        {
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[[HostViewController alloc]init]];
            [self presentViewController:navi animated:YES completion:^{
                AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                delegate.window.rootViewController = navi;
            }];
        }else
        {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"注册失败" message:[retinfo objectForKey:@"desc"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"注册失败" message:@"注册失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
