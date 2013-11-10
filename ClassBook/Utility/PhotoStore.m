#import "PhotoStore.h"
#import "ImageStore.h"
#import "Photo.h"
#import "FileHelpers.h"

static PhotoStore *defaultStore = nil;

@implementation PhotoStore

@synthesize groupId;

+ (PhotoStore *)defaultStore
{
    if (!defaultStore) {
        // Create the singleton
        defaultStore = [[super allocWithZone:NULL] init];
    }
    return defaultStore;
}

// Prevent creation of additional instances
+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultStore];
}

- (id)init
{
    if (defaultStore) {
        return defaultStore;
    }
    
    self = [super init];

    model = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    
    NSPersistentStoreCoordinator *psc = 
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    //数据库路径  名称
    NSString *path = pathInDocumentDirectory(@"store.data");
    
    NSLog(@"数据库路径  名称 %@",path);
    
    NSURL *storeURL = [NSURL fileURLWithPath:path]; 
    
    NSError *error = nil;
    
    if (![psc addPersistentStoreWithType:NSSQLiteStoreType 
                           configuration:nil
                                     URL:storeURL
                                 options:nil
                                   error:&error]) {
        [NSException raise:@"Open failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    
    //生成上下文
    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:psc];
    [psc release];
    
    [context setUndoManager:nil];
    return self;
}

- (id)retain
{
    // Do nothing
    return self;
}

- (oneway void)release
{
    // Do nothing
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}
/*****************************************
 *函数名：
 *参数：
 *返回值：
 *功能：结束程序和进入后台时注意 保存！
 ****************************************/
- (BOOL)saveChanges
{
    NSError *err = nil;
    BOOL successful = [context save:&err];
    if (!successful) {
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    return successful;
}

- (void)fetchPhotosIfNecessaryForGroupId:(NSInteger)_id
{
    static NSInteger group_id;
    
    if (!allPhotos||group_id!=_id) {
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"Photo"];
        [request setEntity:e];
        
//        NSSortDescriptor *sd = [NSSortDescriptor 
//                                sortDescriptorWithKey:@"orderingValue"
//                                ascending:YES];
//        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"group_id = %d",_id];
        [request setPredicate:predicate];
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        if (allPhotos) {
            [allPhotos release];
        }
        allPhotos = [[NSMutableArray alloc] initWithArray:result];
        group_id = _id;
    }
}

/*****************************************
 *函数名：
 *参数：  group_id
 *返回值：
 *功能：获取某一个组的全部照片
 ****************************************/
- (NSArray *)allPhotosForGroupId:(NSInteger)_id
{
    self.groupId = _id;
    
    [self fetchPhotosIfNecessaryForGroupId:_id];
    
    return allPhotos;
}
/*****************************************
 *函数名：
 *参数：  group_id
 *返回值：
 *功能：创建一张新图片
 ****************************************/
- (Photo *)createPhotoForGroupId:(NSInteger)_id
{
    self.groupId = _id;
    
    [self fetchPhotosIfNecessaryForGroupId:_id];
    
    Photo *p = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                 inManagedObjectContext:context];
    p.group_id = [NSNumber numberWithInt:_id];
    [p setImagekey:uniqueIdentifierStrings()];
    [allPhotos addObject:p];
    
    return p;
}
/*****************************************
 *函数名：
 *参数：  group_id    image
 *返回值：
 *功能：创建一张新图片
 ****************************************/
- (BOOL)addNewPhotoForGroupId:(NSInteger)_id withImage:(UIImage*)image
{
    self.groupId = _id;
    
    [self fetchPhotosIfNecessaryForGroupId:_id];
    
    Photo *p = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                             inManagedObjectContext:context];
    p.group_id = [NSNumber numberWithInt:_id];
    [p setImagekey:uniqueIdentifierStrings()];
    
    [[ImageStore defaultImageStore] setImage:image
                                      forKey:[p imagekey]];
    
    [allPhotos addObject:p];
    return [self saveChanges];
}
/*****************************************
 *函数名：
 *参数：
 *返回值：
 *功能：删除某一张图片
 ****************************************/
- (BOOL)removePhoto:(Photo *)p
{
    NSString *key = [p imagekey];
    [[ImageStore defaultImageStore] deleteImageForKey:key];
    [context deleteObject:p];
    [allPhotos removeObjectIdenticalTo:p];
    
    return [self saveChanges];
}

@end
