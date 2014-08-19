//
//  KLDDatabase.m
//  zaime
//
//  Created by 1528 MAC on 14-8-14.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "KLDDatabase.h"
#import "SharedInstanceGCD.h"
#import "config.h"
#define kTableCount 1

@implementation KLDDatabase

SHARED_INSTANCE_GCD_USING_BLOCK(^{
    return [[self alloc]init];
})
//- (id)init
//{
//    self = [super init];
//    if(self)
//    {
//        
//    }
//}
-(void)addColumn:(NSString*)columnName :(NSString*)type intoTable:(NSString*)tableName :(void(^)(BOOL isSuccess))complete
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *updateStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD '%@' %@",tableName,columnName,type];
        if(NO == [db executeUpdate:updateStr])
        {
            NSAssert(NO==YES, @"插入行失败了");
        }
        if(complete)
        {
            MAIN(^{
                complete(YES);
            });
        }
        
    }];
    
    
}
- (void)tableOk :(NSString*)tableName
{
    NSLog(@"%@",tableName);
    static int finsihCount = 0;
    finsihCount++;
    if(finsihCount == kTableCount && !isNeedUpdateDatabase)
    {
        self.isDatabaseReady = YES;
        finsihCount = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kDatabaseCreateFinished" object:nil];
        if(createDatabaseAndTableComplete)
        {
            createDatabaseAndTableComplete();
        }
        
    }
}
- (void)addField :(NSArray*)field :(NSArray*)type :(NSString*)table
{
    KLDDatabase __weak *tmp = self;
    [self createTableWithTableName:table :^(BOOL isTableOk) {
        if(isTableOk)
        {
            [tmp tableOk:table];
            return ;
        }else
        {
            int  i = 0;
            NSString *last = field.lastObject;
            for (NSString *column in field)
            {
                if([column isEqualToString:last])
                {
                    [self addColumn :column :[type objectAtIndex:i] intoTable:table :^(BOOL isSuccess) {
                        [tmp tableOk:table];
                    }];
                }else
                {
                    [tmp addColumn:column :[type objectAtIndex:i] intoTable:table :nil];
                }
                i++;
                
            }
        }
    }];
}
-(void)createTableWithTableName:(NSString*)name :(void(^)(BOOL isTableOk))complete
{
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type='table' AND name=?"];
        FMResultSet *rs = [db executeQuery:querySql,name];
        int count = 0;
        if(rs.next)
        {
            count = [rs intForColumn:@"count"];
        }
        [db closeOpenResultSets];
        if(count > 0)
        {
            if(complete)
            {
                MAIN(^{
                    complete(YES);
                });
            }
            
            return ;
        }else
        {
            NSString *createStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE)",name];
            if (NO==[db executeUpdate:createStr])
            {
            }else
            {
                if(complete)
                {
                    MAIN(^{
                        complete(NO);
                    });
                }
                
            }
        }
        [db closeOpenResultSets];
        
    }];
    
}

- (void)createPicHistoryTable
{
    [self addField:kPicHistory :kPicHistoryColumnsType :kPicTableName];
}
 
- (void)createDatabaseAndTables:(NSString *)databaseName :(void (^)(void))complete
{
    dbName = databaseName;
    if(complete)
    {
        createDatabaseAndTableComplete = complete;
    }
    NSString *dbVersion = [[NSUserDefaults standardUserDefaults] objectForKey:databaseName];
    if(!dbVersion)
    {
        [[NSUserDefaults standardUserDefaults] setObject:kDBVersion forKey:databaseName];
    }
    if(!queue)
    {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:databaseName];
        BOOL isDir = YES;
        if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir)
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
            
        }
        path = [path stringByAppendingPathComponent:[databaseName stringByAppendingString:@".sqlite"]];
        queue = [[FMDatabaseQueue alloc]initWithPath:path];
    }
    if(!dbVersion || [dbVersion isEqualToString:kDBVersion])
    {
        [self createPicHistoryTable];

    }else if([dbVersion intValue] < [kDBVersion intValue])
    {
        isNeedUpdateDatabase = YES;
        
        for(int i = [dbVersion intValue];i < [kDBVersion intValue];i++)
        {
            NSString *selStr=[NSString stringWithFormat:@"updateDbFrom%dTo%d",i,i+1];
            
            SEL sel=NSSelectorFromString(selStr);
            
            if (YES==[self respondsToSelector:sel])
            {
                IMP imp = [self methodForSelector:sel];
                void (*performSelector)(id, SEL) = (void *)imp;
                performSelector(self,sel);
            }
        }
        
    }
    
    
}
- (void)updateDbFrom1To2
{
}
/*- (void)createDbWithName :(NSString*)name complete:(void(^)(NSString *path,BOOL isDbExist))complete;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [[documentDirectory stringByAppendingPathComponent:@"db"] stringByAppendingPathComponent:name];
    BOOL isDir = NO;
    BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:dbPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dbPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    dbPath = [dbPath stringByAppendingPathComponent:[name stringByAppendingString:@".db"]];
    BOOL isFileExist = [[NSFileManager defaultManager] fileExistsAtPath:dbPath];
    if(!isFileExist)
    {
        [[NSFileManager defaultManager] createFileAtPath:dbPath contents:nil attributes:nil];
        
        complete(dbPath,NO);
    }else
    {
        complete(dbPath,YES);
    }
}
 */

@end
