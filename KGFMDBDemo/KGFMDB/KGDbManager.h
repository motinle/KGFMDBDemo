//
//  KGDbManager.h
//  KGFMDB
//
//  Created by Motinle(motinle@163.com) on 18/1/20.
//  Copyright © 2018年 Motinle. All rights reserved.
//
#import "KGFMDBSerializing.h"
#import "KGFMDBAdapter.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"


@interface KGDbManager : NSObject
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, strong) NSString *dbPath;



#pragma mrak - Create
-(void)createTable;


#pragma mark - Insert
/**
 Insert

 @param object (The object that implements the KGFMDBSerializing protocol)
 */
- (void)insertObject:(NSObject<KGFMDBSerializing> *)object
         completion:(void(^)(BOOL success))completion;

/**
 Batch insert(transaction&rollback)
 
 @param objects (The object that implements the KGFMDBSerializing protocol)
 */
- (void)insertObjects:(NSArray<NSObject<KGFMDBSerializing> *> *)objects
          completion:(void(^)(BOOL success))completion;


#pragma mark - Replace
/**
 Replace
 
 @param object (The object that implements the KGFMDBSerializing protocol)
 */
- (void)replaceObject:(NSObject<KGFMDBSerializing> *)object
          completion:(void(^)(BOOL success))completion;

/**
 Batch replace（transaction&rollback）
 
 @param objects (The object that implements the KGFMDBSerializing protocol)
 */
- (void)replaceObjects:(NSArray<NSObject<KGFMDBSerializing> *> *)objects
           completion:(void(^)(BOOL success))completion;



#pragma mark - Update
/**
 Update

 @param object (The object that implements the KGFMDBSerializing protocol)
 */
- (void)updateObject:(NSObject<KGFMDBSerializing> *)object
         completion:(void(^)(BOOL success))completion;
/**
 Batch Update(transaction&rollback)
 
 @param objects (The object that implements the KGFMDBSerializing protocol)
 */
- (void)updateObjects:(NSArray<NSObject<KGFMDBSerializing> *> *)objects
          completion:(void(^)(BOOL success))completion;


#pragma mark - Delete
/**
 Delete
 
 @param object (The object that implements the KGFMDBSerializing protocol)
 */
- (void)deleteObject:(NSObject<KGFMDBSerializing> *)object
         completion:(void(^)(BOOL success))completion;

/**
 Batch Delete(transaction&rollback)
 
 @param objects (The object that implements the KGFMDBSerializing protocol)
 */
- (void)deleteObjects:(NSArray *)objects
          completion:(void(^)(BOOL success))completion;





#pragma mark - Fetch
/**
 Fetch（Support YYModel）
 
 @param sql example:'select * from news_list'
 @param modelClass Need YYModel support
 
    How to Open YYModel?
        #1: Download YYModel library
        #2: In Build Setting -> Preprocessor Macros Add KGFMDB_YYModel_MAP = 1 option
 */
- (void)fetchStatementWithSql:(NSString *)sql
                 modelOfClass:(Class)modelClass
                   completion:(void(^)(NSArray * result, NSError * error))completion;



#pragma mark - DBUpdate
/**
 *  Check if the database table is to be updated
 *
 *  @param newVersion The new version of the database
 */
-(void)checkNeedUpdateDb:(NSInteger)newVersion;

/**
 *  When the database needs to be updated, implement this method in subclasses
 */
-(void)onUpdateDb;


@end
