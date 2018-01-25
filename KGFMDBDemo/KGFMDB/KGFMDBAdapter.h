//
//  KGFMDBAdapter.h
//  KGFMDB
//
//  Created by Motinle(motinle@163.com) on 18/1/20.
//  Copyright © 2018年 Motinle. All rights reserved.
//

#import "KGFMDBSerializing.h"


@interface KGFMDBAdapter : NSObject 

+ (NSString *)insertStatementForObject:(NSObject<KGFMDBSerializing> *)object;
+ (NSString *)replaceStatementForObject:(NSObject<KGFMDBSerializing> *)object;
+ (NSString *)updateStatementForObject:(NSObject<KGFMDBSerializing> *)object;
+ (NSString *)deleteStatementForObject:(NSObject<KGFMDBSerializing> *)object;

+ (NSArray  *)primaryKeysValues:(NSObject<KGFMDBSerializing> *)object;
+ (NSArray *)objectValues:(NSObject<KGFMDBSerializing> *)object;


@end
