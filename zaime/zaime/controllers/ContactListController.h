//
//  ContactListController.h
//  yoforchinese
//
//  Created by NPHD on 14-8-1.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectComplete)(NSArray *result);
@interface ContactListController : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate>
{
    @private
    NSArray *contacts;
    SelectComplete complete;
}
@property(nonatomic,strong) UISearchBar *searchBar;
@property(nonatomic,strong) UISearchDisplayController *searchDc;

- (id)initWithContacts :(NSArray*)contacts  style:(UITableViewStyle)style :(void(^)(NSArray *results))selectComplete;
@end
