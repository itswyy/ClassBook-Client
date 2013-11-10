#import <CoreData/CoreData.h>

@class Photo;

@interface PhotoStore : NSObject
{
    NSMutableArray *allPhotos;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    NSInteger groupId;
}
@property(nonatomic, assign) NSInteger groupId;

+ (PhotoStore *)defaultStore;

- (BOOL)saveChanges;

- (NSArray *)allPhotosForGroupId:(NSInteger)_id;
- (Photo *)createPhotoForGroupId:(NSInteger)_id;
- (BOOL)addNewPhotoForGroupId:(NSInteger)_id withImage:(UIImage*)image;
- (BOOL)removePhoto:(Photo *)p;

@end
