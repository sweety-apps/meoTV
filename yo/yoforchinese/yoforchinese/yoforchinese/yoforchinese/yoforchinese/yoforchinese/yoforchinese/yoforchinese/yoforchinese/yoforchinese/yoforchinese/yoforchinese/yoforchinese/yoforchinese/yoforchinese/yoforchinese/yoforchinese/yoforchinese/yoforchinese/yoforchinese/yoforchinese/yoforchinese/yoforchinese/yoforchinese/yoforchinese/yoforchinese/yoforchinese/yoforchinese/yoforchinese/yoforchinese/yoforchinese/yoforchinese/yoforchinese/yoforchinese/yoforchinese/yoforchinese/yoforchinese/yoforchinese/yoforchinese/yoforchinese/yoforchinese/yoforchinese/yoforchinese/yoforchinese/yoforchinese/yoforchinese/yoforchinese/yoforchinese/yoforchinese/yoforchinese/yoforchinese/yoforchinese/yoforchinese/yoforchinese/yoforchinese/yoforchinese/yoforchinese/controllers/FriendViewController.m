//
//  FriendViewController.m
//  yoforchinese
//
//  Created by NPHD on 14-7-30.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "FriendViewController.h"
#import "Friend.h"

#import "config.h"
#import "SetPhoneViewController.h"
#import "WCShare.h"
#import "APAddressBook.h"
#import "APContact.h"
#import "SBJson4.h"
#import "ContactListController.h"
#import "Common.h"
#import "JSONKit.h"
#import "APService.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "APAudioPlayer.h"
#define kUploadContactRequestTag 1011
#define kSendMNSRequestTag 1012
#define kFetchFriendsTag 1013
@interface FriendViewController ()
{
    APAddressBook *addressBook;
    APAudioPlayer *audioPlayer;
    UITextField *inviteFriend;
    UITableViewCell *dest;
    NSMutableDictionary *queue;
}
@end

@implementation FriendViewController

- (id)initWithFriends :(NSArray*)parmFriends style:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if(self)
    {
        friends = parmFriends;
    }
    return self;
}
- (void)fetchFriends
{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:[Common sharedInstance].login forKey:@"owner"];
    
    NSString *json = [[[SBJson4Writer alloc]init] stringWithObject:parm];
    
    NSURL *url = [NSURL URLWithString:kFetchFriendLists];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDelegate:self];
    request.tag = kFetchFriendsTag;
    [request setRequestMethod:@"POST"];
    [request setPostBody:[NSMutableData dataWithData:[json dataUsingEncoding:NSUTF8StringEncoding]]];
    [request startAsynchronous];
}
- (void)loadContacts
{
    [addressBook loadContacts:^(NSArray *acontacts, NSError *error) {
        if (!error && [APAddressBook access] == APAddressBookAccessGranted)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
                [parm setObject:[Common sharedInstance].login forKey:@"owner"];
                NSMutableArray *contacts = [[NSMutableArray alloc]init];
                for (APContact *ap in acontacts)
                {
                    NSString *aphone = [[ap.phones objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@""];
                    aphone = [aphone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    NSString *firstName = [ap.lastName==nil?@"":ap.lastName stringByAppendingString:ap.firstName==nil?@"":ap.firstName];
                    [contacts addObject: [NSDictionary dictionaryWithObjectsAndKeys:aphone,@"phone",firstName.length <=0?aphone:firstName,@"name", nil]];
                }
                [parm setObject:contacts forKey:@"contacts"];
                
                NSString *json = [[[SBJson4Writer alloc]init] stringWithObject:parm];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //上传通讯录
                    NSURL *url = [NSURL URLWithString:kSubmitContacts];
                    
                    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                    request.tag = kUploadContactRequestTag;
                    [request setDelegate:self];
                    [request setRequestMethod:@"POST"];
                    [request setPostBody:[NSMutableData dataWithData:[json dataUsingEncoding:NSUTF8StringEncoding]]];
                    [request startAsynchronous];
                });
            });
           
        }
        else
        {
            
        }
    }];
    
}
- (void)createAddressBook
{
    if(!addressBook)
    {
        addressBook = [[APAddressBook alloc] init];
    }
    
    [addressBook startObserveChangesWithCallback:^
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:kContactChange object:nil userInfo:nil];
         [self loadContacts];
     }];
    addressBook.filterBlock = ^BOOL(APContact *contact)
    {
        return contact.phones.count > 0;
    };
   
}
- (void)sendYo :(NSIndexPath*)indexPath
{
    Friend *friend = [friends objectAtIndex:indexPath.row];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:@"yo" forKey:@"content"];
    [parm setObject:friend.phone forKey:@"to"];
    
    NSString *json = [[[SBJson4Writer alloc]init] stringWithObject:parm];
    
    NSURL *url = [NSURL URLWithString:kSendMsg];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.tag = indexPath.row;
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setPostBody:[NSMutableData dataWithData:[json dataUsingEncoding:NSUTF8StringEncoding]]];
    [request startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(request.tag == kUploadContactRequestTag)
    {
        [self fetchFriends];
        return;
    }else if(request.tag == kSendMNSRequestTag)
    {
        NSLog(@"%@",[request responseString]);
        return;
    }else if(request.tag == kFetchFriendsTag)
    {
        NSString *responseString = [request responseString];
        NSDictionary *retinfo = [responseString objectFromJSONString];
        if([[retinfo objectForKey:@"ret"] integerValue] == 0)
        {
            NSArray *afriends = [retinfo objectForKey:@"friends"];
            NSMutableArray *parm = [[NSMutableArray alloc]init];
            for (NSDictionary *info in afriends)
            {
                Friend *friend = [[Friend alloc]init];
                friend.name = [info objectForKey:@"nickname"];
                friend.phone = [info objectForKey:@"phone"];
                [parm addObject:friend];
            }
            friends = parm;
            [self.tableView reloadData];
        }
        return;
    }
    NSInteger row = request.tag;
    UIActivityIndicatorView *act = [queue objectForKey:[NSString stringWithFormat:@"%d",(int)row]];
    [act stopAnimating];
    [act removeFromSuperview];
    [queue removeObjectForKey:[NSString stringWithFormat:@"%d",(int)row]];
    NSMutableArray *friendsCopy = [NSMutableArray arrayWithArray:friends];
    [friendsCopy removeObjectAtIndex:row];
    [friendsCopy insertObject:[friends objectAtIndex:row] atIndex:0];
    friends = [NSArray arrayWithArray:friendsCopy];
    [self.tableView reloadData];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request

{
}
- (BOOL)canUseCachedDataForRequest:(ASIHTTPRequest *)request
{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:136/255.f green:64/255.f blue:167/255.f alpha:1.f];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    queue = [[NSMutableDictionary alloc]init];
    [self createAddressBook];
    [self loadContacts];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification:) name:kReceiveRemoteNotifiaction object:nil];
    
}
- (void)receiveRemoteNotification :(NSNotification*)noti
{
     NSDictionary *info = [noti object];
    NSDictionary *aps = [info objectForKey:@"aps"];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0)];
    
    view.tag = 101;
     view.backgroundColor = [UIColor blackColor];
     view.alpha = 0.7;
    [self.view addSubview:view];
    [UIView animateWithDuration:0.1 animations:^{
        
        [self.view bringSubviewToFront:view];
        CGRect frame = view.frame;
        frame.size.height = 60;
        view.frame = frame;

    }completion:^(BOOL finished) {
        UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 100, 20)];
        message.textColor = [UIColor whiteColor];
        message.text = [aps objectForKey:@"alert"];
        message.backgroundColor = [UIColor clearColor];
        message.tag = 101;
        [view addSubview:message];
       [self performSelector:@selector(clearNoti) withObject:nil afterDelay:2.5f];
    }];
    if(!audioPlayer)
    {
        audioPlayer = [[APAudioPlayer alloc]init];
    }
    [audioPlayer playItemWithURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"yo" ofType:@".mp3"]]];
   
    
}
- (void)clearNoti
{
     UIView *view = [self.view viewWithTag:101];
    [[view viewWithTag:101] removeFromSuperview];
    [UIView animateWithDuration:0.1 animations:^{
        
       
        [self.view bringSubviewToFront:view];
        
        CGRect frame = view.frame;
        frame.size.height = 0;
        view.frame = frame;
        
    }completion:^(BOOL finished) {
         [[self.view viewWithTag:101] removeFromSuperview];
    }];
   
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return friends.count+3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"FriendVCCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:28.f];
    if(indexPath.row%5 == 0)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:31/255.f green:177/255.f blue:139/255.f alpha:1.f];
        
        
    }else if(indexPath.row%5 == 1)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:44/255.f green:197/255.f blue:94/255.f alpha:1.f];
    }else if(indexPath.row%5 == 2)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:43/255.f green:132/255.f blue:211/255.f alpha:1.f];
    }else if(indexPath.row%5 == 3)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:237/255.f green:185/255.f blue:16/255.f alpha:1.f];
    }else
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:40/255.f green:57/255.f blue:75/255.f alpha:1.f];
    }
    if(indexPath.row < friends.count)
    {
        Friend *friend = friends[indexPath.row];
        cell.textLabel.text = friend.name;
//    }else if(indexPath.row == friends.count)
//    {
//        cell.textLabel.text = @"发现朋友";
    }else if(indexPath.row == friends.count)
    {
        cell.textLabel.text = @"邀请朋友";
    }else if(indexPath.row == friends.count+1)
    {
        cell.textLabel.text = @"添加朋友";
    }else if(indexPath.row == friends.count+2)
    {
        cell.textLabel.text = @"退出";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == friends.count)
    {
        /*[[WCShare sharedInstance] makeShareContent:@"我正在用..." defaultConent:nil title:nil jumpUrl:nil description:nil imagePath:nil];
        [[WCShare sharedInstance] addSMSShareHandler:^{

        } shareFailed:^(id<ICMErrorInfo> error) {

        }];
        [[WCShare sharedInstance] showShareItems];
         */
        
        [addressBook loadContacts:^(NSArray *contacts, NSError *error) {
            UINavigationController *navi =[[UINavigationController alloc]initWithRootViewController:[[ContactListController alloc]initWithContacts:contacts style:UITableViewStylePlain :^(NSArray *results) {
                
                NSMutableArray *phones = [[NSMutableArray alloc]init];
                for (APContact *ap in results)
                {
                    NSString *phone = [[ap.phones[0] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    [phones addObject:phone];
                }
                NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
                [parm setObject:@"zgw" forKey:@"nickname"];
                [parm setObject:phones forKey:@"to"];
                
                NSString *json = [[[SBJson4Writer alloc]init] stringWithObject:parm];
                
                NSURL *url = [NSURL URLWithString:kSendMNS];
                
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                request.tag = kSendMNSRequestTag;
                [request setDelegate:self];
                [request setRequestMethod:@"POST"];
                [request setPostBody:[NSMutableData dataWithData:[json dataUsingEncoding:NSUTF8StringEncoding]]];
                [request startAsynchronous];
            }]];
            [self presentViewController:navi animated:YES completion:nil];
        }];
    }else if(indexPath.row == friends.count+1)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        dest = cell;
        if(!inviteFriend)
        {
            
            inviteFriend = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, cell.frame.size.width-20,cell.frame.size.height-10)];
            inviteFriend.placeholder = @"请输入朋友的账号";
            inviteFriend.textColor = [UIColor whiteColor];
            inviteFriend.font = [UIFont boldSystemFontOfSize:24.f];
            inviteFriend.textAlignment = NSTextAlignmentCenter;
            inviteFriend.delegate = self;
        }
        [inviteFriend removeFromSuperview];
        [inviteFriend becomeFirstResponder];
        [cell.contentView addSubview:inviteFriend];
        cell.textLabel.text = nil;
    }else if(indexPath.row == friends.count+2)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"退出后将不能收到来自朋友的消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
        [alert show];
    }
    else
    {
        if([queue objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row]])
            return;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.center = CGPointMake(cell.frame.size.width/2.f, cell.frame.size.height/2.f);
        CGRect frame = activityIndicator.frame;
        activityIndicator.frame = frame;
        [activityIndicator startAnimating]; // 开始旋转
        [activityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        [cell.contentView addSubview:activityIndicator];
        [queue setObject:activityIndicator forKey:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
        [self sendYo:indexPath];
    }
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    dest.textLabel.text = @"添加朋友";
    [inviteFriend resignFirstResponder];
    [inviteFriend removeFromSuperview];
    return YES;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [addressBook stopObserveChanges];
}
#pragma mark - alert的delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [APService setTags:[NSSet set] alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[[MainViewController alloc]init]];
        [navi setNavigationBarHidden:YES];
        [UIApplication sharedApplication].statusBarHidden = YES;
        delegate.window.rootViewController = navi;
        
    }
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    
}
@end
