//
//  KSDPhotoView.h
//  youLost
//
//  Created by 1528 MAC on 14-9-5.
//  Copyright (c) 2014年 ksd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ContentItem.h"

typedef void(^SelectImage)(ContentItem *item,int imageIndex);
@interface KSDPhotoViewLayout : NSObject
{
    ContentItem *item;
    UITableViewCell *cell;
    SelectImage selectImgage;
}
- (id)initWithContent:(ContentItem *)aitem cell:(UITableViewCell *)acell;
- (void)layout;
- (void)setSelectImage :(SelectImage)aselectImage;
@end
