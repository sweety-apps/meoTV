//
//  KLDDatabase.h
//  zaime
//
//  Created by 1528 MAC on 14-8-14.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
typedef void(^CreateComplete)(void);
@interface KLDDatabase : NSObject
{
    FMDatabaseQueue *queue;
    NSString *dbName;
    BOOL isNeedUpdateDatabase;
    CreateComplete createDatabaseAndTableComplete;
}
@property (nonatomic,assign) BOOL isDatabaseReady;
+ (instancetype)sharedInstance;
- (void)createDatabaseAndTables :(NSString*)databaseName :(CreateComplete)complete;
@end
