//
//  SelectView.h
//  youLost
//
//  Created by 1528 MAC on 14-9-15.
//  Copyright (c) 2014年 ksd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectItemAction)();
@interface SelectView : UIView
{
    SelectItemAction photoAction;
    SelectItemAction cancelAction;
}
@property(nonatomic,strong) UIButton *photo;
@property(nonatomic,strong) UIButton *cancel;
- (void)setPhotnAction :(SelectItemAction)paction;
- (void)setCancelAction :(SelectItemAction)caction;
@end
