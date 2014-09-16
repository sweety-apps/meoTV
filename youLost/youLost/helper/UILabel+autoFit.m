//
//  UILabel+autoFit.m
//  youLost
//
//  Created by 1528 MAC on 14-9-5.
//  Copyright (c) 2014年 ksd. All rights reserved.
//

#import "UILabel+autoFit.h"

@implementation UILabel (autoFit)
- (void)autoFit:(NSString *)str :(UIFont*)font :(CGSize)size
{
    CGSize labelSize = [str sizeWithFont:font
                       constrainedToSize:size
                           lineBreakMode:UILineBreakModeCharacterWrap];   // str是要显示的字符串
    CGRect frame = self.frame;
    frame.size = labelSize;
    self.frame = frame;
    self.text = str;
    self.backgroundColor = [UIColor clearColor];
    self.font = [UIFont systemFontOfSize:12.f];
    self.numberOfLines = 0;// 不可少Label属性之一
    self.lineBreakMode = UILineBreakModeCharacterWrap;// 不可少Label属性之二
    //CGSizeMake([[UIScreen mainScreen] bounds].size.width-kLeftPading, 100)
}
@end
