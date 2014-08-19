//
//  NotificationCompent.h
//  zaime
//
//  Created by 1528 MAC on 14-8-7.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCompent : UIView
{
    NSString *msg;
    NSString *from;
}
- (id)initWithMSg :(NSString*)msg from:(NSString*)from;
- (void)show;
- (void)hide;
@end
