//
//  KGFMDBAdapter.m
//  KGFMDB
//
//  Created by Motinle(motinle@163.com) on 18/1/20.
//  Copyright © 2018年 Motinle. All rights reserved.
//

#import "KGFMDBAdapter.h"
#import <FMDB/FMDB.h>


@implementation KGFMDBAdapter

+ (NSString *)insertStatementForObject:(NSObject<KGFMDBSerializing> *)object {
    NSDictionary    *ob_dbDic = [object.class FMDBColumnsByPropertyKey];
    
    NSMutableArray  *db_keys = [NSMutableArray array];
    NSMutableArray  *db_valueMark = [NSMutableArray array];
    for (NSString *ob_Key in ob_dbDic.allKeys)
    {
        NSString *db_Key = ob_dbDic[ob_Key];
        db_Key = db_Key ? : ob_Key;
        
        if (db_Key != nil && ![db_Key isEqual:[NSNull null]])
        {
            [db_keys addObject:db_Key];
            [db_valueMark addObject:@"?"];
        }
    }
    
    NSString *statement = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)",
                           [object.class FMDBTableName],
                           [db_keys componentsJoinedByString:@", "],
                           [db_valueMark componentsJoinedByString:@", "]];
    
    return statement;
}

+ (NSString *)replaceStatementForObject:(NSObject<KGFMDBSerializing> *)object
{
    NSDictionary    *ob_dbDic = [object.class FMDBColumnsByPropertyKey];
    
    NSMutableArray  *db_keys = [NSMutableArray array];
    NSMutableArray  *db_valueMark = [NSMutableArray array];
    for (NSString *ob_Key in ob_dbDic.allKeys)
    {
        NSString *db_Key = ob_dbDic[ob_Key];
        db_Key = db_Key ? : ob_Key;
        
        if (db_Key != nil && ![db_Key isEqual:[NSNull null]])
        {
            [db_keys addObject:db_Key];
            [db_valueMark addObject:@"?"];
        }
    }
    
    NSString *statement = [NSString stringWithFormat:@"replace into %@ (%@) values (%@)",
                           [object.class FMDBTableName],
                           [db_keys componentsJoinedByString:@", "],
                           [db_valueMark componentsJoinedByString:@", "]];
    
    return statement;
}



+ (NSString *)updateStatementForObject:(NSObject<KGFMDBSerializing> *)object {
    NSDictionary    *ob_dbDic = [object.class FMDBColumnsByPropertyKey];
    
    NSMutableArray  *db_keys = [NSMutableArray array];
    for (NSString *ob_Key in ob_dbDic.allKeys)
    {
        NSString *db_Key = ob_dbDic[ob_Key];
        db_Key = db_Key ? : ob_Key;
        
        if (db_Key != nil && ![db_Key isEqual:[NSNull null]])
        {
            NSString *s = [NSString stringWithFormat:@"%@ = ?", db_Key];
            [db_keys addObject:s];
        }
    }
    
    return [NSString stringWithFormat:@"update %@ set %@ where %@", [object.class FMDBTableName],
            [db_keys componentsJoinedByString:@", "],
            [self whereStatementForObject:object]];
    
}

+ (NSString *)deleteStatementForObject:(NSObject<KGFMDBSerializing> *)object {
    return [NSString stringWithFormat:@"delete from %@ where %@", [object.class FMDBTableName], [self whereStatementForObject:object]];
}




+ (NSArray *)primaryKeysValues:(NSObject<KGFMDBSerializing> *)object {
    NSDictionary    *ob_dbDic = [object.class FMDBColumnsByPropertyKey];
    NSArray *pk_keys = [object.class FMDBPrimaryKeys];
    NSMutableArray *values = [NSMutableArray array];
    for (NSString *pk_key in pk_keys) {
        NSString *ob_key = [self keyForValue:pk_key inDictionary:ob_dbDic];
        id pk_value = [object valueForKey:ob_key];
        if (pk_value == nil) {
            NSLog(@"Warning: value for key %@ is nil", pk_value);
            pk_value = [NSNull null];
        }
        [values addObject:pk_value];
    }
    
    return values;
}
+(NSString *)keyForValue:(NSString *)value inDictionary:(NSDictionary *)dic
{
    __block NSString *_key = @"_key";
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isEqualToString: value]) {
            _key = key;
            *stop = YES;
        }
    }];
    return _key;
    
}
+ (NSString *)whereStatementForObject:(NSObject<KGFMDBSerializing> *)object
{
    // Build the where statement
    NSArray *keys = [object.class FMDBPrimaryKeys];
    NSMutableArray *where = [NSMutableArray array];
    for (NSString *key in keys) {
        NSString *s = [NSString stringWithFormat:@"%@ = ?", key];
        [where addObject:s];
    }
    return [where componentsJoinedByString:@" AND "];
}

+ (NSArray *)objectValues:(NSObject<KGFMDBSerializing> *)object {
    NSDictionary    *ob_dbDic = [object.class FMDBColumnsByPropertyKey];
    
    NSMutableArray *ob_values = [NSMutableArray array];
    
    for (NSString *ob_Key in ob_dbDic.allKeys)
    {
        NSString *db_Key = ob_dbDic[ob_Key];
        db_Key = db_Key ? : ob_Key;
        if (db_Key != nil && ![db_Key isEqual:[NSNull null]])
        {
            id ob_value = [object valueForKey:ob_Key];
            if (ob_value == nil) {
                NSLog(@"Warning: value for key %@ is nil", ob_Key);
                ob_value = [NSNull null];
            }
            [ob_values addObject:ob_value];
        }
    }
    return ob_values;
}

@end
