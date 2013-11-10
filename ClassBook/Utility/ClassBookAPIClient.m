#import "ClassBookAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kClassBookAPIBaseURLString = @"http://202.206.100.231:85/ClassBookServer/";
//static NSString * const kClassBookAPIBaseURLString = @"http://localhost/~wtlucky/ClassBookServer/";
//static NSString * const kClassBookAPIBaseURLString = @"http://localhost/~parker/ClassBookServer/";
//static NSString * const kClassBookAPIBaseURLString = @"http://127.0.0.1/classbook/";

@implementation ClassBookAPIClient

+ (ClassBookAPIClient *)sharedClient {
    static ClassBookAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kClassBookAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json,text/html"];
    
    return self;
}

@end
