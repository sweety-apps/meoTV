//
//  XMPPClient.h
//  zaime
//
//  Created by 1528 MAC on 14-8-8.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "XMPPFramework.h"
#import "XMPPReconnect.h"
#import "BaseMesage.h"
@interface XMPPClient : NSObject
{
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    
	NSString *password;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	BOOL isXmppConnected;
    BOOL isRegister;
    BOOL isLogin;
    
    NSString *registerPass;
    NSString *registerAccount;
}
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;

+ (instancetype)sharedInstance;

- (BOOL)connectWithAccount :(NSString*)account pwd:(NSString*)pwd;
- (void)registerWithAccount:(NSString*)account password:(NSString*)pass;
- (void)logout;
- (void)sendMsg :(BaseMesage*)msg;
- (void)setupStream;
- (void)teardownStream;
- (void)goOnline;
- (void)goOffline;
@end
