//
//  RegViewController.m
//  SMS_SDKDemo
//
//  Created by admin on 14-6-4.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "RegViewController.h"
#import <SMS_SDK/SMS_SDK.h>
#import <SMS_SDK/SMS_SRUtils.h>
#import <SMS_SDK/CountryAndAreaCode.h>
#import "VerifyViewController.h"
#import "MBProgressHUD.h"
#import "KSDIMStatus.h"
#import "NaviItems.h"

@interface RegViewController ()
{
    CountryAndAreaCode* _data2;
    NSString* _str;
    SMS_SDK* _sdk;
    NSMutableData* _data;
    int _state;
    NSString* _localPhoneNumber;
    NSString* _localZoneNumber;
    
    NSString* _appKey;
    NSString* _duid;
    
    NSString* _token;
    
    NSString* _appSecret;
    
    NSMutableArray* _areaArray;
    MBProgressHUD *hud;
}

@end

@implementation RegViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)clickLeftButton
{
    [self dismissViewControllerAnimated:YES completion:^{
        _window.hidden=YES;
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //不允许用户输入 国家码
    if (textField==_areaCodeField) {
        [self.view endEditing:YES];
    }
    NSLog(@"textFieldDidBeginEditing");
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

#pragma mark - SecondViewControllerDelegate的方法
- (void)setSecondData:(CountryAndAreaCode *)data {
    _data2=data;
    NSLog(@"从Second传过来的数据：%@,%@", data.areaCode,data.countryName);
    //self.areaCodeField.text=data.areaCode;
    self.areaCodeField.text=[NSString stringWithFormat:@"+%@",data.areaCode];
    [self.tableView reloadData];
}

-(void)nextStep
{
    int compareResult = 0;
    for (int i=0; i<_areaArray.count; i++) {
        NSDictionary* dict1=[_areaArray objectAtIndex:i];
        NSString* code1=[dict1 valueForKey:@"zone"];
        NSLog(@"areacode:%@",code1);
        if ([code1 isEqualToString:[_areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@""]]) {
            compareResult=1;
            NSString* rule1=[dict1 valueForKey:@"rule"];
            NSLog(@"rule:%@",rule1);
            NSPredicate* pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule1];
            BOOL isMatch=[pred evaluateWithObject:self.telField.text];
            if (!isMatch) {
                //手机号码不正确
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码非法，请重新填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            break;
        }
    }
    
    if (!compareResult) {
        if (self.telField.text.length!=11) {
            //手机号码不正确
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码非法，请重新填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }

    NSString* str=[NSString stringWithFormat:@"我们将发送验证码短信到这个号码:%@ %@",self.areaCodeField.text,self.telField.text];
    _str=[NSString stringWithFormat:@"%@",self.telField.text];
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"确认手机号码" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.telField resignFirstResponder];
    if (1==buttonIndex)
    {
        NSLog(@"点击了确定按钮");
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在发送...";
        [[KSDIMStatus sharedClient] POST:@"/isUserExist" parameters:[NSDictionary dictionaryWithObjectsAndKeys:self.telField.text,@"username", nil] success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *retinfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if([[retinfo objectForKey:@"retcode"] integerValue] != 0)
            {
                VerifyViewController* verify=[[VerifyViewController alloc] init];
                NSString* str2=[self.areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
                [verify setPhone:self.telField.text AndAreaCode:str2];
                
                [SMS_SDK getVerifyCodeByPhoneNumber:self.telField.text AndZone:str2 result:^(enum SMS_GetVerifyCodeResponseState state) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (1==state) {
                        NSLog(@"block 获取验证码成功");
                        [self.navigationController pushViewController:verify animated:YES];
                       // [self presentViewController:verify animated:YES completion:nil];
                        
                    }
                    else if(0==state)
                    {
                        NSLog(@"block 获取验证码失败");
                        NSString* str=[NSString stringWithFormat:@"验证码发送失败 请稍后重试"];
                        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"发送失败" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];

                    }
                    else if (SMS_ResponseStateMaxVerifyCode==state)
                    {
                        NSString* str=[NSString stringWithFormat:@"请求验证码超上限 请稍后重试"];
                        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"超过上限" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    else if(SMS_ResponseStateGetVerifyCodeTooOften==state)
                    {
                        NSString* str=[NSString stringWithFormat:@"客户端请求发送短信验证过于频繁"];
                        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    
                }];
            }else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提升" message:@"用户已经存在" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提升" message:@"请求失败，稍后重试。" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }];
        
    }else if (0==buttonIndex) {
        NSLog(@"点击了取消按钮");
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat statusBarHeight=0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight=20;
    }
    self.navigationItem.leftBarButtonItem = [NaviItems naviLeftBtnWithTitle:@"返回" target:self selector:@selector(goback)];
    
    UILabel* label=[[UILabel alloc] init];
    label.frame=CGRectMake(0, 56+statusBarHeight, [[UIScreen mainScreen] bounds].size.width, 21);
    label.text=[NSString stringWithFormat:@"请确认输入手机号"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:16];
    label.textColor=[UIColor darkGrayColor];
    [self.view addSubview:label];

    
//    UITableView* tableView=[[UITableView alloc] initWithFrame:CGRectMake(7, 85+statusBarHeight, 305, 45) style:UITableViewStylePlain];
//    [self.view addSubview:tableView];
    
    
    UITextField* areaCodeField=[[UITextField alloc] init];
    areaCodeField.frame=CGRectMake(7, 147+statusBarHeight-40, 59, 35+statusBarHeight/4);
    areaCodeField.borderStyle=UITextBorderStyleBezel;
    areaCodeField.text=[NSString stringWithFormat:@"+86"];
    areaCodeField.textAlignment=NSTextAlignmentCenter;
    areaCodeField.font=[UIFont fontWithName:@"Helvetica" size:18];
    areaCodeField.keyboardType=UIKeyboardTypePhonePad;
    [self.view addSubview:areaCodeField];
    
    UITextField* telField=[[UITextField alloc] init];
    telField.frame=CGRectMake(74, 147+statusBarHeight-40, 238, 35+statusBarHeight/4);
    telField.borderStyle=UITextBorderStyleBezel;
    telField.placeholder=@"请填写手机号码";
    telField.keyboardType=UIKeyboardTypePhonePad;
    telField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:telField];
    
    UIButton* nextBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    NSString *icon = [NSString stringWithFormat:@"smssdk.bundle/button4.png"];
    [nextBtn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    nextBtn.frame=CGRectMake(7, 200+statusBarHeight-40, 305, 42);
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];

    
    _telField=telField;
    
    _areaCodeField=areaCodeField;
    
   // _tableView=tableView;
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    self.areaCodeField.delegate=self;
    self.telField.delegate=self;
    
    _areaArray=[NSMutableArray array];
    //获取支持的地区列表
    [SMS_SDK getZone:^(enum SMS_ResponseState state, NSArray *array) {
        if (1==state)
        {
            NSLog(@"block 获取区号成功");
            //区号数据
            _areaArray=[NSMutableArray arrayWithArray:array];
        }
        else if (0==state)
        {
            NSLog(@"block 获取区号失败");
        }
        
    }];
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 保证性能问题
    static NSString *identifier = @"UITableViewCell";
    
    // 1.拿一个标识去缓存池里面找可循环利用的Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        // 2.如果没有可循环利用的Cell，就必须创建一个Cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] ;
        
    }
    cell.textLabel.text=@"国家和地区";
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor=[UIColor darkGrayColor];
    
    if (_data2) {
        cell.detailTextLabel.text=_data2.countryName;
    }
    else
    {
        cell.detailTextLabel.text=@"中国";
    }
    
    cell.detailTextLabel.textColor=[UIColor blackColor];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *tempView = [[UIView alloc] init];
    [cell setBackgroundView:tempView];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"弹出国家和地区列表用于选择区号");
    SectionsViewController* country2=[[SectionsViewController alloc] init];
    country2.delegate=self;
    [country2 setAreaArray:_areaArray];
    [self presentViewController:country2 animated:YES completion:^{
        ;
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
