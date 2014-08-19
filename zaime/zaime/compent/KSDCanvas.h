//
//  KSDCanvas.h
//  zaime
//
//  Created by 1528 MAC on 14-8-19.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MovingAction)(CGPoint point);
@interface KSDCanvas : UIView
{
    MovingAction moving;
}
- (void)setMoveing:(MovingAction)actio;
@end
