//
//  config.h
//  zaime
//
//  Created by 1528 MAC on 14-8-8.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#ifndef zaime_config_h
#define zaime_config_h

#pragma mark - openfire地址

#define kServerAddress @"192.168.1.138"
#define kServerName @"127.0.0.1"

#pragma mark - 通知名
#define kReceiveTextMsg @"kReceiveTextMsg"
#define kReceiveEmotionMsg @"kReceiveEmotionMsg"
#define kReceiveMoveEnd @"kReceiveMoveEnd"

#pragma mark - 手指移动不发送范围矩形的边长
#define kNotSendSquire 3

#pragma mark - 0
#define kZero 0

#pragma mark -手指方块的大小

#pragma mark - 发送位置的间隔，单位是毫秒
#define kSendMsgInterval 500

#pragma - mark 请求地址
#define kSendMsg @"http://yo.meme-da.com/send_msg.php" //发送推送
#define kSignUp @"http://yo.meme-da.com/register.php" //注册
#define kSubmitContacts @"http://yo.meme-da.com/update_contact.php" //上传通讯录
#define kFetchFriendLists @"http://yo.meme-da.com/friends_list.php" //请求朋友列表
#define kSendMNS @"http://yo.meme-da.com/send_sms.php" //发送短信
#define kSearchFriends @"http://yo.meme-da.com/find.php" //查找好友
#define kDeleteFriends @"http://yo.meme-da.com/delete_friend.php" //删除好友

#pragma mark - 接受照片的尺寸

#pragma mark - 数据库版本号
#define kDBVersion @"1"

#pragma mark - keychain的组名
#define keychainGroup @"szkldinc"

#pragma mark - 表结构
//发送图片历史表
#define kPicHistory @[@"from",@"url",@"time"]
#define kPicHistoryColumnsType @[@"VARCHAR",@"VARCHAR",@"DATETIME"]

#pragma mark - 表名 
#define kPicTableName @"kPicTableName"

#pragma mark - 图片头像大小
#define kAvatarSize 80

#pragma mark - 震动范围
#define kShockSize 100

#pragma mark - 图片的旋转角度
#define kImageRotation 10

#endif
