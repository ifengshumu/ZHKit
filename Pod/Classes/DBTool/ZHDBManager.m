//
//  ZHDBManager.m
//
//  Created by 李志华 on 2019/7/6.
//

#import "ZHDBManager.h"
#import "BGFMDB.h"

static ZHDBManager *manager = nil;
@implementation ZHDBManager
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *toPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Preferences/data.db"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:toPath]) {
            bg_setSqlitePath(toPath);
            bg_setSqliteName(@"data");
        } else {
            NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"db"];
            NSError *error = nil;
            BOOL isSuccess = [fileManager copyItemAtPath:dbPath toPath:toPath error:&error];
            if (isSuccess) {
                [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:toPath]];
                bg_setSqlitePath(toPath);
                bg_setSqliteName(@"data");
            } else {
                NSLog(@"copy db failed");
            }
        }
    }
    return self;
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL{
    NSError *error = nil;
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error: &error];
    if (!success) {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

- (NSArray<CityDBModel *> *)queryAllCity {
    NSArray *citys = [CityDBModel bg_findAll:@"city_full"];
    return citys;
}

- (CityDBModel *)modelForCity:(NSString *)city {
    NSString *where = [NSString stringWithFormat:@"where city like '%@%%'",city];
    NSArray *citys = [CityDBModel bg_find:@"city_full" where:where];
    CityDBModel *m = citys.firstObject;
    return m;
}

- (NSArray<CityDBModel *> *)queryCitysByName:(NSString *)name {
    NSString *where = [NSString stringWithFormat:@"where city like '%%%@%%'",name];
    NSArray *citys = [CityDBModel bg_find:@"city_full" where:where];
    return citys;
}

@end
