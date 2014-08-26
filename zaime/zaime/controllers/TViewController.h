//
//  TViewController.h
//  zaime
//
//  Created by 1528 MAC on 14-8-26.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "KSDPhotoStackView.h"

@interface TViewController :UIViewController<MFMessageComposeViewControllerDelegate,PhotoStackViewDataSource,PhotoStackViewDelegate>

@end
