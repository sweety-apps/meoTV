//
//  KSDSelectColor.m
//  zaime
//
//  Created by 1528 MAC on 14-8-28.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "KSDSelectColor.h"
@implementation KSDSelectColor

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       // [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)removeSubView
{
    for (UIView *sub in self.subviews)
    {
        [sub removeFromSuperview];
    }
}
- (void)setSelectColor:(SelectColour)action
{
    colour = action;
}
- (void)addButton
{
    [self addBloack];
    [self addgray];
    [self addpurple];
    [self addGreen];
    [self addYellow];
    [self addOrange];
    [self addRed];
    [self addWhite];
}
- (void)clickBlack
{
    NSLog(@"black");
    if(colour)
    {
        colour([UIColor blackColor]);
    }
}
- (void)clickGray
{
    NSLog(@"gray");
    if(colour)
    {
        colour([UIColor grayColor]);
    }
}
- (void)clickPurple
{
    NSLog(@"purple");
    if(colour)
    {
        colour([UIColor purpleColor]);
    }
}
- (void)clickBlue
{
    NSLog(@"blue");
    if(colour)
    {
        colour([UIColor blueColor]);
    }
}
- (void)clickGreen
{
    NSLog(@"green");
    if(colour)
    {
        colour([UIColor greenColor]);
    }
}
- (void)clickRed
{
    NSLog(@"red");
    if(colour)
    {
        colour([UIColor redColor]);
    }
}
- (void)clickYellow
{
    NSLog(@"yellow");
    if(colour)
    {
        colour([UIColor yellowColor]);
    }
}
- (void)clickOrange
{
    NSLog(@"orange");
    if(colour)
    {
        colour([UIColor orangeColor]);
    }
}
- (void)clickWhite
{
    NSLog(@"white");
    if(colour)
    {
        colour([UIColor whiteColor]);
    }
}
- (void)addBloack
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"black"];
    [btn setImage:image forState:UIControlStateNormal];
    btn.frame = CGRectMake(13.5, 150, image.size.width/2.f-1, 34);
    [btn addTarget:self action:@selector(clickBlack) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}
//purple
- (void)addgray
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"gray"];
    [btn setImage:image forState:UIControlStateNormal];
    btn.frame = CGRectMake(13.5, 150+35, image.size.width/2.f-1, 33);
    [btn addTarget:self action:@selector(clickGray) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [self addBlue];
}
- (void)addpurple
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"purple"];
    [btn setImage:image forState:UIControlStateNormal];
    btn.frame = CGRectMake(14, 150+2*35-1, image.size.width/2.f-1, 34);
    [btn addTarget:self action:@selector(clickPurple) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}
- (void)addBlue
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"blue"];
    [btn setImage:image forState:UIControlStateNormal];
    btn.frame = CGRectMake(13.5, 150+3*35-1, image.size.width/2.f-1, 34);
    [btn addTarget:self action:@selector(clickBlue) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}
- (void)addGreen
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"green"];
    [btn setImage:image forState:UIControlStateNormal];
    btn.frame = CGRectMake(13.5, 150+4*35-1, image.size.width/2.f-1, 33);
    [btn addTarget:self action:@selector(clickGreen) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}
- (void)addYellow
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"yellow"];
    [btn setImage:image forState:UIControlStateNormal];
    btn.frame = CGRectMake(13.5, 150+5*35-1, image.size.width/2.f-1, 33);
    [btn addTarget:self action:@selector(clickYellow) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}
- (void)addOrange
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"orange"];
    [btn setImage:image forState:UIControlStateNormal];
    btn.frame = CGRectMake(13.5, 150+6*35-2, image.size.width/2.f-1, 34);
    [btn addTarget:self action:@selector(clickOrange) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}
- (void)addRed
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"red"];
    [btn setImage:image forState:UIControlStateNormal];
    btn.frame = CGRectMake(13.5, 150+7*35-1, image.size.width/2.f-1, 33);
    [btn addTarget:self action:@selector(clickRed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}
- (void)addWhite
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"white"];
    [btn setImage:image forState:UIControlStateNormal];
    btn.frame = CGRectMake(13.5, 150+8*35-2, image.size.width/2.f-1, 33);
    [btn addTarget:self action:@selector(clickWhite) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}
@end
