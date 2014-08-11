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
    MEssageAudion
    
}MessageType;

typedef enum
{
    MsgStatusSending=0,
    MsgStatusSuccess,
    MsgStatusFailed,
    MsgStatusSend
}MsgStatus;

@interface BaseMesage : NSObject

@property (nonatomic,assign) BOOL isIncoming;
@property (nonatomic,assign) MsgStatus status;
@property (nonatomic,strong) NSString *conversationId;
@property (nonatomic,strong) NSString *from;
@property (nonatomic,strong) NSString *to;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSDate *sendDate;
@property (nonatomic,strong) NSString *msgContent;
@property (nonatomic,strong) NSString *messageId;

@end
