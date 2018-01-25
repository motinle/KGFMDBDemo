//
//  KGFMDBSerializing.h
//  KGFMDBDemo
//
//  Created by Motinle(motinle@163.com) on 2018/1/20.
//  Copyright © 2018年 Motinle. All rights reserved.
//

#ifndef KGFMDBSerializing_h
#define KGFMDBSerializing_h
#import <Foundation/Foundation.h>
@protocol KGFMDBSerializing <NSObject>
@required

/**
 Kev-Value Map
 */
+ (NSDictionary *)FMDBColumnsByPropertyKey;

/**
 Table PrimaryKeys
 */
+ (NSArray *)FMDBPrimaryKeys;

/**
 Table Name
 */
+ (NSString *)FMDBTableName;
@end

#endif /* KGFMDBSerializing_h */
