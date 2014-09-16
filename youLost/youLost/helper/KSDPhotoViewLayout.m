//
//  KSDPhotoView.m
//  youLost
//
//  Created by 1528 MAC on 14-9-5.
//  Copyright (c) 2014年 ksd. All rights reserved.
//

#import "KSDPhotoViewLayout.h"
#import "UIImageView+WebCache.h"
#import "KSDImageResize.h"
#import "KSDShotScreen.h"
#import "UIButton+WebCache.h"
#define kLeftPading 50
#define kTopPading 30
#define kBottomPading 30
#define kTextImagePAding 10
#define kImagePading 5
#define kImageHeight 60
#define kTagOff 100
@implementation KSDPhotoViewLayout

- (id)initWithContent:(ContentItem *)aitem cell:(UITableViewCell *)acell
{
    self = [super init];
    if(self)
    {
        item = aitem;
        cell = acell;
    }
    return self;
}
- (CGSize)getResizeSize :(CGSize)imageSize
{
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if(width<height)
    {
        if(height <= kImageHeight*3) return imageSize;
        width = width/(height/(kImageHeight*3));
        height = kImageHeight*3;
    }else
    {
        if(width <= kImageHeight*3) return imageSize;
        height = height/(width/(kImageHeight*3));
        width = kImageHeight*3;
    }
    
    
    
    return CGSizeMake(width, height);
}
- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}
- (UILabel*)createDesc:(NSString*)str :(UIFont*)font
{
    CGSize labelSize = [str sizeWithFont:font
                       constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-kLeftPading, 100)
                           lineBreakMode:UILineBreakModeCharacterWrap];   // str是要显示的字符串
    UILabel *patternLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftPading, kTopPading, labelSize.width, labelSize.height)];
    patternLabel.text = str;
    patternLabel.backgroundColor = [UIColor clearColor];
    patternLabel.font = font;
    patternLabel.numberOfLines = 0;// 不可少Label属性之一
    patternLabel.lineBreakMode = UILineBreakModeCharacterWrap;// 不可少Label属性之二
    return patternLabel;
}
- (void)layout
{
    for (UIView *sub in cell.contentView.subviews) {
        [sub removeFromSuperview];
    }
    UILabel *desc = [self createDesc:item.desc :[UIFont systemFontOfSize:14.f]];
    [cell.contentView addSubview:desc];
    CGFloat offset = desc.frame.origin.y+desc.frame.size.height+5;
    for (int i = 0; i != item.images.count; i++)
    {
        UIButton *imageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageView addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        imageView.tag = kTagOff+i;
        [imageView sd_setBackgroundImageWithURL:[NSURL URLWithString:item.images[i]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if([imageURL.absoluteString hasSuffix:@".gif"])
            {
                image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 1.f)];
            }
            
            double shortLine = image.size.height>image.size.width?image.size.width:image.size.height;
            UIImage *cutimage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], CGRectMake((image.size.width-shortLine)/2.f, (image.size.height-shortLine)/2.f, shortLine, shortLine))];
            [imageView setImage:cutimage forState:UIControlStateNormal];
            imageView.frame = CGRectMake(kLeftPading+(i%3)*(kImageHeight+5), offset+(i/3)*(kImageHeight+5), kImageHeight, cutimage.size.height/(cutimage.size.width/kImageHeight));
            
        }];
        [cell.contentView addSubview:imageView];
    }
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:item.avatarURLStr] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        imageView.frame = CGRectMake((kLeftPading-30)/2.f, 10, 30, 30);
    }];
    [cell.contentView addSubview:imageView];
    
    UILabel *name = [self createDesc:item.name :[UIFont systemFontOfSize:15.f]];
    name.frame = CGRectMake(kLeftPading, 10, name.frame.size.width, name.frame.size.height);
    [cell.contentView addSubview:name];
    
   
}
- (void)setSelectImage:(SelectImage)aselectImage
{
    selectImgage = aselectImage;
}
- (void)tap:(UIButton*)sender
{
    if(selectImgage)
    {
        selectImgage(item,sender.tag-kTagOff);
    }
}
@end
