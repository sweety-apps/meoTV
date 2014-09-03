//
//  KSDSelectColor.h
//  zaime
//
//  Created by 1528 MAC on 14-8-28.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectColour)(UIColor *color);
@interface KSDSelectColor : UIImageView
{
    SelectColour colour;
}
- (void)addButton;
- (void)removeSubView;
- (void)setSelectColor :(SelectColour)action;
@end
