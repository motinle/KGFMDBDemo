
#import "NewsObject.h"

@implementation NewsObject

    
    
    
#pragma mark  -KGFMDBSerializing
+ (NSDictionary *)FMDBColumnsByPropertyKey
{
    return  @{@"newsId" : @"news_id",
              @"newsTitle" : @"news_title",
              @"newsInt":@"news_interge",
              };
}
+ (NSArray *)FMDBPrimaryKeys
{
    return @[@"news_id"];
}

+ (NSString *)FMDBTableName {
    return @"news_list";
}
@end
