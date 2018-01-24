
#import "NewsObject.h"
#import "NewsDbManager.h"
static NSInteger NEWS_DB_VERSION = 1;

@implementation NewsDbManager
+ (NSString *)newsDirectory
{
    NSString* dir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    dir = [dir stringByAppendingPathComponent:@"News"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    return dir;
}

- (id)init
{
    if (self = [super init]) {
        
        NSString * dbPath = [[NewsDbManager newsDirectory] stringByAppendingPathComponent:@"news.sqlite"];
        self.dbPath = dbPath;
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
        [self createTables];
    }
    
    return self;
}


-(void)onUpdateDb
{
    [self.dbQueue inDatabase:^(FMDatabase *adb) {
        //创建新闻列表的索引(news_id)
        [adb executeUpdate:@"DROP TABLE news_list;"];
        
    }];
    
}

#pragma mark - public
- (void)createTables
{
    [super createTable];
    
    [self checkNeedUpdateDb:NEWS_DB_VERSION];
    
    [self.dbQueue inDatabase:^(FMDatabase *adb) {
        // 新闻列表
        [adb executeUpdate:@"create table if not exists 'news_list' (\
         news_id TEXT PRIMARY KEY   NOT NULL,\
         news_title TEXT,\
         news_interge INT\
          );"];
        //创建新闻列表的索引(news_id)
        [adb executeUpdate:@"CREATE UNIQUE INDEX  IF NOT EXISTS news_list_index ON news_list (news_id);"];
        
        //已阅读的新闻列表
        [adb executeUpdate:@"create table if not exists 'read_news_list' (\
         news_id TEXT PRIMARY KEY   NOT NULL\
         );"];
        
    }];
    
}



@end
