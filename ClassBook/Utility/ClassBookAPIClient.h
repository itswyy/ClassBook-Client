#import "AFHTTPClient.h"

@interface ClassBookAPIClient : AFHTTPClient

+ (ClassBookAPIClient *)sharedClient;

@end
