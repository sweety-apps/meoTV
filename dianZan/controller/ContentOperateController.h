//
//  ContentOperateController.h
//  dianZan
//
//  Created by NPHD on 14-5-29.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Content.h"

@interface ContentOperateController : UIViewController <AVAudioPlayerDelegate> {
    int _nCount;
    Content* _content;
}

@property (nonatomic, retain) IBOutlet UIButton* _btnZan;
@property (nonatomic, retain) IBOutlet UIImageView* _imageZan;
@property (nonatomic, retain) IBOutlet UIView*   _viewZan;
@property (nonatomic, retain) IBOutlet UIView*   _viewCoin;
@property (nonatomic, retain) IBOutlet UILabel*  _labelZan;

- (IBAction)onClickZan:(id)sender;

- (void) setContent:(Content*) content;

@end
