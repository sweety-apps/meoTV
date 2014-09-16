//
//  SelectView.m
//  youLost
//
//  Created by 1528 MAC on 14-9-15.
//  Copyright (c) 2014年 ksd. All rights reserved.
//

#import "SelectView.h"

@implementation SelectView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.photo = [UIButton buttonWithType:UIButtonTypeCustom];
        self.photo.frame = CGRectMake(20, 5, 40, 30);
        [self.photo setTitle:@"相机" forState:UIControlStateNormal];
        [self.photo addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.photo];
        
        self.cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancel.frame = CGRectMake(260, 5, 40, 30);
        [self.cancel setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancel];
    }
    return self;
}

-(void)photoAction
{
    if(photoAction)
    {
        photoAction();
    }
}
-(void)cancelAction
{
    if(cancelAction)
    {
        cancelAction();
    }
}
- (void)setPhotnAction:(SelectItemAction)paction
{
    photoAction = paction;
}
- (void)setCancelAction:(SelectItemAction)caction
{
    cancelAction = caction;
}
@end
