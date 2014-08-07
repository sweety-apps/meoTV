//
//  FriendViewController.m
//  yoforchinese
//
//  Created by NPHD on 14-7-30.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "FriendViewController.h"
#import "Friend.h"
#import "AppDelegate.h"
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
#import "NotificationCompent.h"
#import "KeyChainHelper.h"
#import "SWTableViewCell.h"
#import "MBProgressHUD.h"
#import "UIColor+iOS7Colors.h"
@interface FriendViewController ()
{
    APAddressBook *addressBook;
    APAudioPlayer *audioPlayer;
    UITextField *inviteFriend;
    UITableViewCell *dest;
    NSMutableDictionary *queue;
    NSIndexPath *deleteIndexPath;
    MBProgressHUD *hud;
    NSString *newNickName;
}
@end

@implementation FriendViewController

- (id)initWithFriends :(NSArray*)parmFriends style:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if(self)
    {
        if(parmFriends)
        {
            friends = parmFriends;
        }else
        {
            friends = [NSMutableArray array];
        }
        
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
    [request setRequestMethod:@"POST"];
    [request setPostBody:[NSMutableData dataWithData:[json dataUsingEncoding:NSUTF8StringEncoding]]];
    [request startAsynchronous];
}
- (void)loadContacts
{
    [addressBook loadContacts:^(NSArray *acontacts, NSError *error) {
        if (!error && [APAddressBook access] == APAddressBookAccessGranted)
        {
           // if(acontacts.count <= 0) return ;
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
            NSURL *url = [NSURL URLWithString:kSubmitContacts];
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            [request setDelegate:self];
            [request setRequestMethod:@"POST"];
            [request setPostBody:[NSMutableData dataWithData:[json dataUsingEncoding:NSUTF8StringEncoding]]];
            [request startAsynchronous];
           
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
    
//    [addressBook startObserveChangesWithCallback:^
//     {
//         [self loadContacts];
//         [addressBook stopObserveChanges];
//     }];
    
    addressBook.filterBlock = ^BOOL(APContact *contact)
    {
        return contact.phones.count > 0;
    };
   
}
- (void)sendYo :(NSIndexPath*)indexPath
{
    if(indexPath.row >= friends.count) return;
    Friend *friend = [friends objectAtIndex:indexPath.row];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:[@"YO FROM " stringByAppendingString:[Common sharedInstance].login==nil?@"":[Common sharedInstance].login] forKey:@"content"];
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
- (void)deleteFriend :(NSIndexPath*)indexPath
{
    deleteIndexPath = indexPath;
    Friend *friend = [friends objectAtIndex:indexPath.row];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:friend.phone forKey:@"phone"];
    [parm setObject:[Common sharedInstance].login forKey:@"owner"];
    
    NSString *json = [[[SBJson4Writer alloc]init] stringWithObject:parm];
    
    NSURL *url = [NSURL URLWithString:kDeleteFriends];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.tag = indexPath.row;
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setPostBody:[NSMutableData dataWithData:[json dataUsingEncoding:NSUTF8StringEncoding]]];
    [request startAsynchronous];
}
- (BOOL)isFriendIn :(NSString*)phone
{
    for (Friend *f in friends)
    {
        if([f.phone isEqualToString:phone])
            return YES;
    }
    return NO;
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if([[[request url] absoluteString] isEqualToString:kSubmitContacts])//上传通讯录
    {
        [self fetchFriends];
        request = nil;
        return;
    }else if([[[request url] absoluteString] isEqualToString:kFetchFriendLists])//获得朋友列表
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
            request = nil;
        }
        return;
    }else if([[[request url] absoluteString] isEqualToString:kSearchFriends])//查找朋友
    {
        NSString *responseString = [request responseString];
        NSDictionary *retinfo = [responseString objectFromJSONString];
        if(!retinfo)
            return;
        if([[retinfo objectForKey:@"ret"] integerValue] == 1)
        {
            request = nil;
            return;
        }else if([[retinfo objectForKey:@"ret"] integerValue] == 0)
        {
            if([self isFriendIn:inviteFriend.text]) return;
            Friend *friend = [[Friend alloc]init];
            friend.phone = inviteFriend.text;
            friend.name = [retinfo objectForKey:@"nickname"];
            NSMutableArray *data = [NSMutableArray arrayWithArray:friends];
            [data addObject:friend];
            friends = data;
            [self.tableView reloadData];
            request = nil;
            return;
        }
    }else if([[[request url] absoluteString] isEqualToString:kDeleteFriends])
    {
        NSString *responseString = [request responseString];
        NSDictionary *retinfo = [responseString objectFromJSONString];
        if([[retinfo objectForKey:@"ret"] integerValue] == 0)
        {
            NSMutableArray *friendsCopy = [NSMutableArray arrayWithArray:friends];
            [friendsCopy removeObjectAtIndex:deleteIndexPath.row];
            friends = friendsCopy;
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        return;
    }else if([[[request url] absoluteString] isEqualToString:kSignUp])
    {
        [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
        if(newNickName.length > 0)
        {
           [Common sharedInstance].nickname = newNickName;
        }
        newNickName = nil;
        NSString *responseString = [request responseString];
        NSDictionary *retinfo = [responseString objectFromJSONString];
        if([[retinfo objectForKey:@"ret"] integerValue] == 0)
        {
            
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
    [self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request

{
    NSInteger row = request.tag;
    
    UIActivityIndicatorView *act = [queue objectForKey:[NSString stringWithFormat:@"%d",(int)row]];
    [act stopAnimating];
    [act removeFromSuperview];
    [queue removeObjectForKey:[NSString stringWithFormat:@"%d",(int)row]];
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
    NotificationCompent *notic = [[NotificationCompent alloc]initWithMSg:[aps objectForKey:@"alert"] from:nil];
    [self.view addSubview:notic];
    [notic show];
    [notic performSelector:@selector(hide) withObject:nil afterDelay:2.5f];
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
    return friends.count+4;
}

-(int)getRandomNumber:(int)from to:(int)to

{
    
    return (int)(from + (arc4random()%(to - from + 1))); //+1,result is [from to]; else is [from, to)!!!!!!!
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
        cell.backgroundColor = [UIColor colorWithRed:136/255.f green:64/255.f blue:167/255.f alpha:1.f];
    }
    cell.rightUtilityButtons = nil;
    cell.leftUtilityButtons = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:28.f];
    if(indexPath.row%5 == 0)
    {
        //cell.contentView.backgroundColor = [UIColor colorWithRed:31/255.f green:177/255.f blue:139/255.f alpha:1.f];
        cell.contentView.backgroundColor = [UIColor iOS7redGradientStartColor];
        
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
    //cell.contentView.backgroundColor = [UIColor colorWithRed:[self getRandomNumber:0 to:255]/255.f green:[self getRandomNumber:0 to:255]/255.f blue:[self getRandomNumber:0 to:255]/255.f alpha:1.f];
    if(indexPath.row < friends.count)
    {
        Friend *friend = friends[indexPath.row];
        cell.textLabel.text = friend.name;
        cell.rightUtilityButtons = [self rightButtons];
    }else if(indexPath.row == friends.count)
    {
        cell.textLabel.text = @"邀请朋友";
       // cell.rightUtilityButtons = [self inviteFriends];
    }else if(indexPath.row == friends.count+1)
    {
        cell.textLabel.text = @"添加朋友";
    }else if(indexPath.row == friends.count+2)
    {
        cell.textLabel.text = @"编辑";
    }else if(indexPath.row == friends.count+3)
    {
        cell.textLabel.text = @"退出";
    }
    
    return cell;
}
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:78/255.f green:30/255.f blue:100/255.f alpha:1.0]
//                                                title:@"取消"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:26/255.f green:77/255.f blue:122/255.f alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}
- (NSArray *)inviteFriends
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    //[rightUtilityButtons sw_addUtilityButtonWithColor:
    // [UIColor colorWithRed:78/255.f green:30/255.f blue:100/255.f alpha:1.0]
    //                                            title:@"取消"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:26/255.f green:77/255.f blue:122/255.f alpha:1.0f]
                                                title:@"短信"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:222/255.f green:52/255.f blue:46/255.f alpha:1.0f]
                                                title:@"微信"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                icon:[UIImage imageNamed:@"check.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0]
                                                icon:[UIImage imageNamed:@"clock.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
                                                icon:[UIImage imageNamed:@"cross.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
                                                icon:[UIImage imageNamed:@"list.png"]];
    
    return leftUtilityButtons;
}
- (void)dispSendMsg :(NSArray*)results
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]) {
        
        controller.body = @"你好嘛？";
        
        NSMutableArray *phones = [[NSMutableArray alloc]init];
        for (APContact *ap in results)
        {
            [phones addObject:ap.phones[0]];
        }
        controller.recipients = phones;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == friends.count)
    {
        [addressBook loadContacts:^(NSArray *contacts, NSError *error) {
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[[ContactListController alloc]initWithContacts:contacts style:UITableViewStylePlain :^(NSArray *results) {
                
                [self performSelector:@selector(dispSendMsg:) withObject:results afterDelay:0.5f];
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
        inviteFriend.text = nil;
        [cell.contentView addSubview:inviteFriend];
        cell.textLabel.text = nil;
    }else if(indexPath.row == friends.count+2)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请输入新的昵称"
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        // 基本输入框，显示实际输入的内容
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert textFieldAtIndex:0].text = [Common sharedInstance].nickname;
        alert.delegate = self;
        alert.tag = 1011;
        [alert show];
    }else if(indexPath.row == friends.count+3)
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
    if(textField.text.length <= 0) return YES;
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:inviteFriend.text forKey:@"phone"];
    [parm setObject:[Common sharedInstance].login forKey:@"owner"];
    
    NSString *json = [[[SBJson4Writer alloc]init] stringWithObject:parm];
    
    NSURL *url = [NSURL URLWithString:kSearchFriends];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setPostBody:[NSMutableData dataWithData:[json dataUsingEncoding:NSUTF8StringEncoding]]];
    [request startAsynchronous];
    return YES;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark - alert的delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1011)
    {
        if([alertView textFieldAtIndex:0].text.length <= 0) return;
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:kSignUp]];
        NSDictionary *parm = [NSDictionary dictionaryWithObjectsAndKeys:[Common sharedInstance].login,@"phone",[alertView textFieldAtIndex:0].text,@"nickname", nil];
        NSString *json = [[[SBJson4Writer alloc]init] stringWithObject:parm];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request setPostBody:[NSMutableData dataWithData:[json dataUsingEncoding:NSUTF8StringEncoding]]];
        [request startAsynchronous];
        hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
        hud.labelText = @"正在修改...";
        newNickName = [alertView textFieldAtIndex:0].text;
        return;
    }
    if(buttonIndex == 1)
    {
        [APService setTags:[NSSet set] alias:@"" callbackSelector:nil  target:nil];
        [[KeyChainHelper sharedInstance] reset];
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [[ASIHTTPRequest sharedQueue] cancelAllOperations];
        if(delegate.window.rootViewController == self)
        {
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[[MainViewController alloc]init]];
            [navi setNavigationBarHidden:YES];
            delegate.window.rootViewController = navi;
        }else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
}
//- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
//    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
//    
//    
//}
#pragma mark - 单元格代理
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    [cell hideUtilityButtonsAnimated:YES];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if(indexPath.row == friends.count)
    {
        if(index == 1)
        {
            [addressBook loadContacts:^(NSArray *contacts, NSError *error) {
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[[ContactListController alloc]initWithContacts:contacts style:UITableViewStylePlain :^(NSArray *results) {
                    
                    [self performSelector:@selector(dispSendMsg:) withObject:results afterDelay:0.5f];
                }]];
                [self presentViewController:navi animated:YES completion:nil];
            }];
        }else if(index == 2)
        {
            
        }
    }else
    {
        if(index == 0)
        {
            [self deleteFriend:[self.tableView indexPathForCell:cell]];
        }
    }
    
    
}
#pragma mark - 发短信代理
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultSent:
            //讯息传送成功
            break;
            
        case MessageComposeResultFailed:
            //讯息传送失败
            break;
            
        case MessageComposeResultCancelled:
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
            
            
        default:
            break;
    }
}
@end
