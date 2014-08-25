//
//  DKLiveBlurView.h
//
//  zaime
//
//  Created by NPHD on 14-8-4.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//
#import <UIKit/UIKit.h>

#define kDKBlurredBackgroundDefaultLevel 0.9f
#define kDKBlurredBackgroundDefaultGlassLevel 0.2f
#define kDKBlurredBackgroundDefaultGlassColor [UIColor whiteColor]

@interface KSDLiveBlurView : UIImageView

@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) float initialBlurLevel;
@property (nonatomic, assign) float initialGlassLevel;
@property (nonatomic, assign) BOOL isGlassEffectOn;
@property (nonatomic, strong) UIColor *glassColor;

@end
