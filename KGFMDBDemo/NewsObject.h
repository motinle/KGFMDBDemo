
#import "KGFMDBAdapter.h"
#import "KGFMDBSerializing.h"
@interface NewsObject : NSObject<KGFMDBSerializing>
@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, assign) NSInteger  newsInt;
@property (nonatomic, copy) NSString *newsTitle;

@end
