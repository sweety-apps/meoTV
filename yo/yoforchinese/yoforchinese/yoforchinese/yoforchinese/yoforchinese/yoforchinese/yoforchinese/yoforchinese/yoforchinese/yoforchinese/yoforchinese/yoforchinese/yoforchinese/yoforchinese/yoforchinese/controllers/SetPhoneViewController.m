//
//  UpLoadPhoneViewController.m
//  yoforchinese
//
//  Created by NPHD on 14-7-30.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "SetPhoneViewController.h"
#import "APAddressBook.h"
#import "APContact.h"
#import "config.h"
#import "SBJson4.h"
@interface SetPhoneViewController ()
{
    UITextField *phone;
    UIView *tip;
    UIView *phoneBg;
    
    APAddressBook *addressBook;
    
}
@end

@implementation SetPhoneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)readContact
{
    if(addressBook)
    {
        [addressBook stopObserveChanges];
    }
    addressBook = [[APAddressBook alloc] init];
    [addressBook startObserveChangesWithCallback:^
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:kContactChange object:nil userInfo:nil];
     }];
    addressBook.filterBlock = ^BOOL(APContact *contact)
    {
        return contact.phones.count > 0;
    };
    [addressBook loadContactsOnQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) completion:^(NSArray *contacts, NSError *error) {
        if (!error && [APAddressBook access] == APAddressBookAccessGranted)
        {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
            [parm setObject:phone.text forKey:@"owner"];
            NSMutableArray *contacts = [[NSMutableArray alloc]init];
            for (APContact *ap in contacts)
            {
                NSString *aphone = [[ap.phones objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString *firstName = [ap firstName];
                [contacts addObject: [NSDictionary dictionaryWithObjectsAndKeys:aphone,@"phone",firstName,@"name", nil]];
            }
            [parm setObject:contacts forKey:@"contacts"];
            
            NSString *json = [[[SBJson4Writer alloc]init] stringWithObject:parm];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //上传通讯录
                
            });
        }
        else
        {
            
        }
        
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    tip = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height/994.f*306.f)];
    tip.backgroundColor = [UIColor colorWithRed:31/255.f green:177/255.f blue:139/255.f alpha:1.f];
    [self.view addSubview:tip];
    self.view.backgroundColor = [UIColor colorWithRed:26/255.f green:129/255.f blue:165/255.f alpha:1.f];
    
    phoneBg = [[UIView alloc]initWithFrame:CGRectMake(0, tip.frame.size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height/994.f*158)];
    phoneBg.backgroundColor = [UIColor colorWithRed:44/255.f green:197/255.f blue:94/255.f alpha:1.f];
    phone = [[UITextField alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/3.f, 0.f, [[UIScreen mainScreen] bounds].size.width-[[UIScreen mainScreen] bounds].size.width/3.f, phoneBg.frame.size.height)];
    phone.borderStyle = UITextBorderStyleNone;
    phone.placeholder = @"请输入电话号码";
    phone.textColor = [UIColor whiteColor];
    phone.textAlignment = NSTextAlignmentCenter;
    phone.font = [UIFont boldSystemFontOfSize:22.f];
    phone.keyboardType = UIKeyboardTypeNumberPad;
    [phoneBg addSubview:phone];
    [phone becomeFirstResponder];
    [self.view addSubview:phoneBg];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    
    

}
- (void)goback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)submit
{
    
}
- (void)keyboardWillShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    UIButton *goback = [UIButton buttonWithType:UIButtonTypeCustom];
    goback.backgroundColor = [UIColor colorWithRed:39/255.f green:56/255.f blue:75/255.f alpha:2.f];
    goback.frame = CGRectMake(0, tip.frame.size.height+phoneBg.frame.size.height, [[UIScreen mainScreen] bounds].size.width/2.f, [[UIScreen mainScreen] bounds].size.height-tip.frame.size.height-phoneBg.frame.size.height-keyboardSize.height);
    [goback setTitle:@"返回" forState:UIControlStateNormal];
    [goback addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goback];
    
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    confirm.backgroundColor = [UIColor colorWithRed:122/255.f green:44/255.f blue:157/255.f alpha:2.f];
    confirm.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2.f, tip.frame.size.height+phoneBg.frame.size.height, [[UIScreen mainScreen] bounds].size.width-[[UIScreen mainScreen] bounds].size.width/2.f, [[UIScreen mainScreen] bounds].size.height-tip.frame.size.height-phoneBg.frame.size.height-keyboardSize.height);
    [confirm setTitle:@"提交" forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:confirm];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
