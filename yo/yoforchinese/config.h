//
//  config.h
//  yoforchinese
//
//  Created by NPHD on 14-7-30.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#ifndef yoforchinese_config_h
#define yoforchinese_config_h

#pragma - mark 通知名
#define kContactChange @"kContactChange" //通讯录变化发出通知
#define kReceiveRemoteNotifiaction @"kReceiveRemoteNotifiaction"//收到远程通知

#pragma - mark 字号
#define kFontSize 25

#pragma - mark 请求地址 
#define kSendMsg @"http://yo.meme-da.com/send_msg.php" //发送推送
#define kSignUp @"http://yo.meme-da.com/register.php" //注册
#define kSubmitContacts @"http://yo.meme-da.com/update_contact.php" //上传通讯录
#define kFetchFriendLists @"http://yo.meme-da.com/friends_list.php" //请求朋友列表
#define kSendMNS @"http://yo.meme-da.com/send_sms.php" //发送短信
#define kSearchFriends @"http://yo.meme-da.com/find.php" //查找好友
#define kDeleteFriends @"http://yo.meme-da.com/delete_friend.php" //删除好友

#pragma mark - 钥匙串组
#define keychainGroup @"szksd"
#endif
