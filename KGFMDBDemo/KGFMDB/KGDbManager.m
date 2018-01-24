//
//  KGDatabase.h
//  KGFMDB
//
//  Created by Motinle(motinle@163.com) on 18/1/20.
//  Copyright © 2018年 Motinle. All rights reserved.
//
#import "KGFMDBAdapter.h"
#import "KGDbManager.h"
#if KGFMDB_YYModel_MAP
#import "YYModel.h"
#endif


@implementation KGDbManager


#pragma mark - public methods

-(void)createTable
{
    [self.dbQueue inDatabase:^(FMDatabase *adb) {
        //Create a database version table
        [adb executeUpdate:@"create table if not exists 'db_version' (\
         version INTEGER PRIMARY KEY NOT NULL);"];
    }];
}


- (void)insertObject:(NSObject<KGFMDBSerializing> *)object
         completion:(void(^)(BOOL success))completion
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString * sql = [KGFMDBAdapter insertStatementForObject:object];
            NSArray * parameters = [KGFMDBAdapter objectValues:object];
            handleDbexecuteUpdateSqlwithArgumentsInArray(db, sql, parameters, completion);
        }
    }];
}


- (void)insertObjects:(NSArray *)objects
          completion:(void(^)(BOOL success))completion
{
    [self.dbQueue inTransaction:^(FMDatabase *adb, BOOL *rollback) {

        BOOL success = YES;
        for (NSObject<KGFMDBSerializing> *object in objects) {
            NSString * stmt = [KGFMDBAdapter insertStatementForObject:object];
            NSArray * parameters = [KGFMDBAdapter objectValues:object];
            success = [adb executeUpdate:stmt withArgumentsInArray:parameters];
            if (success == NO) {
                break;
            }
        }

        *rollback = !success;

        if (completion) {
            completion(success);
        }

    }];
}



- (void)replaceObject:(NSObject<KGFMDBSerializing> *)object
          completion:(void(^)(BOOL success))completion
{
    
    [self.dbQueue inDatabase:^(FMDatabase *adb) {
        if ([adb open]) {
            NSString * sql = [KGFMDBAdapter replaceStatementForObject:object];
            NSArray * parameters = [KGFMDBAdapter objectValues:object];
            handleDbexecuteUpdateSqlwithArgumentsInArray(adb, sql, parameters, completion);
        }
    }];
}


- (void)replaceObjects:(NSArray<NSObject<KGFMDBSerializing> *> *)objects
           completion:(void(^)(BOOL success))completion
{
    
    [self.dbQueue inTransaction:^(FMDatabase *adb, BOOL *rollback)
     {
         
         BOOL success = YES;
         for (NSObject<KGFMDBSerializing> *object in objects) {
             NSString * stmt = [KGFMDBAdapter replaceStatementForObject:object];
             NSArray * parameters = [KGFMDBAdapter objectValues:object];
             if ([adb executeUpdate:stmt withArgumentsInArray:parameters] == NO) {
                 success = NO;
                 break;
             }
         }
         
         *rollback = !success;
         
         if (completion) {
             completion(success);
         }
         
     }];
}




- (void)updateObject:(NSObject<KGFMDBSerializing> *)object
         completion:(void(^)(BOOL success))completion
{
    [self.dbQueue inDatabase:^(FMDatabase *adb) {
        if ([adb open]) {
            NSString * sql = [KGFMDBAdapter updateStatementForObject:object];
            NSArray *columnValues = [KGFMDBAdapter objectValues:object];
            NSArray *primaryKeysValues = [KGFMDBAdapter primaryKeysValues:object];
            NSMutableArray *parameters = [NSMutableArray array];
            [parameters addObjectsFromArray:columnValues];
            [parameters addObjectsFromArray:primaryKeysValues];

            handleDbexecuteUpdateSqlwithArgumentsInArray(adb, sql, parameters, completion);
        }
    }];
}



- (void)updateObjects:(NSArray<NSObject<KGFMDBSerializing> *>*)objects
          completion:(void(^)(BOOL success))completion
{
    [self.dbQueue inTransaction:^(FMDatabase *adb, BOOL *rollback)
     {

         BOOL success = YES;
         for (NSObject<KGFMDBSerializing> *object in objects) {
             NSString * stmt = [KGFMDBAdapter updateStatementForObject:object];
             NSArray *columnValues = [KGFMDBAdapter objectValues:object];
             NSArray *primaryKeysValues = [KGFMDBAdapter primaryKeysValues:object];
             NSMutableArray *parameters = [NSMutableArray array];
             [parameters addObjectsFromArray:columnValues];
             [parameters addObjectsFromArray:primaryKeysValues];

             success = [adb executeUpdate:stmt withArgumentsInArray:parameters];
             if (success == NO) {
                 break;
             }
         }

         *rollback = !success;

         if (completion) {
             completion(success);
         }

     }];
}





- (void)deleteObject:(NSObject<KGFMDBSerializing> *)object
         completion:(void(^)(BOOL success))completion
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString * sql = [KGFMDBAdapter deleteStatementForObject:object];
            NSArray * parameters = [KGFMDBAdapter primaryKeysValues:object];
            handleDbexecuteUpdateSqlwithArgumentsInArray(db, sql, parameters, completion);
        }
    }];
}

- (void)deleteObjects:(NSArray *)objects
{
    [self deleteObjects:objects completion:nil];
}

- (void)deleteObjects:(NSArray *)objects
          completion:(void(^)(BOOL success))completion
{

    [self.dbQueue inTransaction:^(FMDatabase *adb, BOOL *rollback)
     {

         BOOL success = YES;
         for (NSObject<KGFMDBSerializing> *object in objects) {
             NSString * stmt = [KGFMDBAdapter deleteStatementForObject:object];
             NSArray * parameters = [KGFMDBAdapter primaryKeysValues:object];
             success = [adb executeUpdate:stmt withArgumentsInArray:parameters];
             if (success == NO) {
                 break;
             }
         }

         *rollback = !success;

         if (completion) {
             completion(success);
         }

     }];
}

- (void)fetchStatementWithSql:(NSString *)sql
                 modelOfClass:(Class)modelClass
                   completion:(void(^)(NSArray * result, NSError * error))completion
{
    [self.dbQueue inDatabase:^(FMDatabase *adb)
     {
         if ([adb open] == NO) {
             if (completion) {
                 completion(nil, nil);
             }
             return ;
         }

         NSMutableArray * resultArray = [NSMutableArray array];
         NSError *error = nil;
         FMResultSet *resultSet = [adb executeQuery:sql];
         NSDictionary    *ob_dbDic = [modelClass FMDBColumnsByPropertyKey];
         while ([resultSet next]) {
             
             NSDictionary *resultDictionary = resultSet.resultDictionary;
             NSMutableDictionary   *tempResultDictionary = @{}.mutableCopy;
             for (NSString *key in ob_dbDic.allKeys) {
                 id value = [resultDictionary objectForKey: [ob_dbDic objectForKey:key]];
                 if(value)
                 [tempResultDictionary setObject:value forKey:key];
             }
             
            #if KGFMDB_YYModel_MAP
             if (modelClass) {
                 id obj = [modelClass yy_modelWithDictionary:tempResultDictionary];
                 if (obj)
                     [resultArray addObject:obj];
             }
             else {
                 if(tempResultDictionary)
                     [resultArray addObject:tempResultDictionary];
             }
            #else
                if(tempResultDictionary)
                    [resultArray addObject:tempResultDictionary];
            #endif
         }
         if (completion) {
             completion(resultArray, error);
         }

     }];
}


#pragma mark - private methods
void handleDbexecuteUpdateSqlwithArgumentsInArray(FMDatabase *db ,NSString *sql ,NSArray *arguments ,void(^completion)(BOOL success))
{
    BOOL success = [db executeUpdate:sql withArgumentsInArray:arguments];
    if (success) {
        NSLog(@"Sql:%@ execution succeed",sql);
    }else{
        NSLog(@"Sql:%@ Execution failed", sql);
    }
    if (completion) {
        completion(success);
    }
}


#pragma mark - Database Vesion
- (NSInteger)dbVersion
{
    __block int version = -1;

    [self.dbQueue inDatabase:^(FMDatabase *adb)
     {
         FMResultSet *rs = [adb executeQuery:@"SELECT * FROM db_version"];

         while ([rs next]) {

             version  = [rs intForColumn:@"version"];
         }
         [rs close];

     }];
    return version;

}


-(void)checkNeedUpdateDb:(NSInteger)newVersion
{
    NSInteger currentVersion = [self dbVersion];

    if (currentVersion < 0) {
        [self.dbQueue inDatabase:^(FMDatabase *adb) {
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO db_version (version) VALUES (%ld);",newVersion];
            [adb executeUpdate:sql];
            return ;
        }];
    }
    else if (newVersion>currentVersion)
    {
        //Execute the update database method
        [self onUpdateDb];
        [self.dbQueue inDatabase:^(FMDatabase *adb) {
            //Update the database version data
            NSString *sql = [NSString stringWithFormat:@"UPDATE db_version SET version = %ld;",newVersion];
            [adb executeUpdate:sql];
        }];
    }
}

-(void)onUpdateDb
{

}
@end

