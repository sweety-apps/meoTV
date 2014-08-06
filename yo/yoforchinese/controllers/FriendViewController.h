//
//  FriendViewController.h
//  yoforchinese
//
//  Created by NPHD on 14-7-30.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "SWTableViewCell.h"
#import <MessageUI/MessageUI.h>
@interface FriendViewController : UITableViewController<UITextFieldDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate,SWTableViewCellDelegate,MFMessageComposeViewControllerDelegate>{
    @private
    NSArray *friends;
}
- (id)initWithFriends :(NSArray*)parmFriends style:(UITableViewStyle)style;
@end
