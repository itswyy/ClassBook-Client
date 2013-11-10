//
//  NSString+MD5.m
//  ASSWMapKit
//
//  Created by wtlucky on 12-12-2.
//
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

- (NSString *)MD5
{
    return [NSString MD5ByAStr:self];
}

+ (NSString *)MD5ByAStr:(NSString *)aSourceStr
{
    const char* cStr = [aSourceStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    
    return ret;
}

@end
