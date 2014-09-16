//
//  ASViewController.m
//  ASTextViewDemo
//
//  Created by Adil Soomro on 4/14/14.
//  Copyright (c) 2014 Adil Soomro. All rights reserved.
//

#import "ASViewController.h"
#import "ASTextField.h"
#import "AppDelegate.h"
#import "HostViewController.h"
#import "RegViewController.h"
#import "SetPasswordViewController.h"
#import "KSDIMStatus.h"
#import "NSString+MD5.h"
#import "User.h"
#import "NaviItems.h"
#import "Common.h"
#import "MBProgressHUD.h"
#import "ContentViewController.h"
@interface ASViewController ()
{
    MBProgressHUD *hud;
}
@property (nonatomic,retain) NSMutableArray *cellArray;
@end

@implementation ASViewController

- (id)init
{
    self = [super initWithNibName:@"ASViewController" bundle:nil];
    if (self) {
        // Something.
    }
    return self;
}
- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [self.tableView numberOfSections];
    if (s<1) return;
    NSInteger r = [self.tableView numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //bake a cellArray to contain all cells
    self.cellArray = [NSMutableArray arrayWithObjects: _usernameCell, _passwordCell, _doneCell, nil];
    
    
    //setup text field with respective icons
    [_usernameField setupTextFieldWithIconName:@"user_name_icon"];
    [_passwordField setupTextFieldWithIconName:@"password_icon"];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)]];
    _usernameField.center = self.view.center;
    _passwordField.center = self.view.center;
    
    
}
- (void)hide
{
    [self resignAllResponders];
}
#pragma mark - tableview deleagate datasource stuff
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return cell's height for particular row
    return ((UITableViewCell*)[self.cellArray objectAtIndex:indexPath.row]).frame.size.height;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return number of cells for the table
    
    return self.cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    //return cell for particular row
    cell = [self.cellArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //set clear color to cell.
    [cell setBackgroundColor:[UIColor clearColor]];
   
}

- (IBAction)changeFieldBackground:(UISegmentedControl *)segment {
    if ([segment selectedSegmentIndex] == 0) {
        //setup text field with default respective icons
        [_usernameField setupTextFieldWithIconName:@"user_name_icon"];
        [_passwordField setupTextFieldWithIconName:@"password_icon"];
    }else{
        [_usernameField setupTextFieldWithType:ASTextFieldTypeRound withIconName:@"user_name_icon"];
        [_passwordField setupTextFieldWithType:ASTextFieldTypeRound withIconName:@"password_icon"];
    }
}

- (IBAction)letMeIn:(id)sender {
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
- (IBAction)letMeReg:(id)sender
{

    [self presentViewController:[[RegViewController alloc]init] animated:YES completion:nil];
}

- (void)resignAllResponders{
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

@end
