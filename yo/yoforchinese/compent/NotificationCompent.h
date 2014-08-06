//
//  NotificationCompent.h
//  yoforchinese
//
//  Created by NPHD on 14-8-4.
//  Copyright (c) 2014年 NPHD. All rights reserved.
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
