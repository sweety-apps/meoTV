//
//  XMPPClient.m
//  zaime
//
//  Created by 1528 MAC on 14-8-8.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "XMPPClient.h"
#import "XMPP.h"
#import "SharedInstanceGCD.h"
#import "config.h"
#import "XMPPReconnect.h"
#import "XMPPStream.h"
@implementation XMPPClient
@synthesize xmppStream;
@synthesize xmppReconnect;
SHARED_INSTANCE_GCD_USING_BLOCK(^{
    return [[self alloc]init];
})

- (void)setupStream
{
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
	xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		
		xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	xmppReconnect = [[XMPPReconnect alloc] init];
	[xmppReconnect         activate:xmppStream];
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppStream setHostName:kServerAddress];
	[xmppStream setHostPort:5222];
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
}
- (void)teardownStream
{
	[xmppStream removeDelegate:self];
	[xmppReconnect         deactivate];
	[xmppStream disconnect];
	xmppStream = nil;
	xmppReconnect = nil;
}
- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    NSString *domain = [xmppStream.myJID domain];
    
    
    if([domain isEqualToString:@"gmail.com"]
       || [domain isEqualToString:@"gtalk.com"]
       || [domain isEqualToString:@"talk.google.com"])
    {
        NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
        [presence addChild:priority];
    }
	
	[[self xmppStream] sendElement:presence];
    NSLog(@"上线了");
}
- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}
- (NSString*)getMessageType :(MessageType)type
{
     NSString *typeStr;
    switch (type) {
           
        case MessageAudion:
            typeStr = @"audio";
            break;
        case MessageEmotion:
            typeStr = @"emotion";
            break;
        case MessageText:
            typeStr = @"text";
            break;
        case MessageImage:
            typeStr = @"image";
            break;
        default:
            break;
    }
    return typeStr;
}
- (NSXMLElement*)createMsg :(BaseMesage*)msg
{
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:msg.msgContent];
	
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    
    NSString *jid = [[msg.to stringByAppendingString:@"@"] stringByAppendingString:kServerName];
    [message addAttributeWithName:@"to" stringValue:jid];
    [message addAttributeWithName:@"from" stringValue:msg.from];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"kind" stringValue:[self getMessageType:msg.type]];
    [message addChild:body];
    return message;
}
- (void)registerWithAccount:(NSString*)account password:(NSString*)pass;
{
    NSString *tjid = [[NSString alloc] initWithFormat:@"anonymous@%@", kServerName];
    registerPass = pass;
    registerAccount = account;
    [xmppStream setMyJID:[XMPPJID jidWithString:tjid]];
    if ([xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:nil])
    {
        isRegister = YES;
    }
    
}
- (void)sendMsg:(BaseMesage *)msg
{
    NSXMLElement *message = [self createMsg:msg];
    NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [message addChild:receipt];
    [xmppStream sendElement:message];
}
- (BOOL)connectWithAccount :(NSString*)account pwd:(NSString*)pwd
{
	if (![xmppStream isDisconnected]) {
		return YES;
	}
    NSString *myJID =  [NSString stringWithFormat:@"%@@%@",account,kServerName];
    NSString *myPassword =  pwd;
	
	if (myJID == nil || myPassword == nil) {
		return NO;
	}
	[xmppStream setMyJID:[XMPPJID jidWithString:myJID resource:@"ios"]];
	password = myPassword;
    
	NSError *error = nil;
	if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
        
		return NO;
	}
    
	return YES;
}
- (void)registerUser
{
    NSString *myJID = [[registerAccount stringByAppendingString:@"@"] stringByAppendingString:kServerName];
    [xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
    NSError *error=nil;
    if (![xmppStream registerWithPassword:registerPass error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建帐号失败"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	
	isXmppConnected = YES;
    
    
    if(isRegister)
    {
        isRegister = NO;
        [self registerUser];
        return;
    }
	
	NSError *error = nil;
	
	if (![[self xmppStream] authenticateWithPassword:password error:&error])
	{
        
	}
}
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"%@",error);
}
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kRegisterSuccess" object:nil];
}
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    NSLog(@"%@",error);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kRegisterFailed" object:nil];
}
- (void)logout
{
    isLogin = NO;
    [self disconnect];
}
- (void)disconnect
{
	[self goOffline];
    
	[xmppStream disconnect];
    //[self teardownStream];
}
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"%@",message);
    NSString *body = message.body;
   NSString *kind = [[message attributeForName:@"kind"] stringValue];
    if([kind isEqualToString:@"text"])
    {
         [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveTextMsg object:body];
    }else if([kind isEqualToString:@"emotion"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveEmotionMsg object:body];
    }
   
}
@end
