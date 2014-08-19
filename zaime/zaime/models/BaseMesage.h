//
//  BaseMesage.h
//  zaime
//
//  Created by 1528 MAC on 14-8-8.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    MessageText,
    MessageImage,
    MessageAudion,
    MessageEmotion,
    MEssageMoveEnd
    
}MessageType;

typedef enum
{
    MsgStatusSending=0,
    MsgStatusSuccess,
    MsgStatusFailed,
    MsgStatusSend
}MsgStatus;

@interface BaseMesage : NSObject

@property (nonatomic,strong) NSString *from;
@property (nonatomic,strong) NSString *to;
@property (nonatomic,assign) MessageType type;
@property (nonatomic,strong) NSDate *sendDate;
@property (nonatomic,strong) NSString *msgContent;

@end
