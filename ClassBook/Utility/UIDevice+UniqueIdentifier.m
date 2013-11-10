//
//  UIDevice+UniqueIdentifier.m
//  ClassBook
//
//  Created by wtlucky on 13-3-22.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "UIDevice+UniqueIdentifier.h"
#import "NSString+MD5.h"

#include <sys/socket.h> 
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface UIDevice (private)

- (NSString *)macAddress;

@end

@implementation UIDevice (UniqueIdentifier)

- (NSString *)macAddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

- (NSString *)uniqueDeviceIdentifier
{
    NSString *macAddress = [[UIDevice currentDevice] macAddress];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@", macAddress, bundleIdentifier];
    NSString *uniqueIdentifier = [stringToHash MD5];
    
    return uniqueIdentifier;
}

- (NSString *)uniqueGlobalDeviceIdentifier
{
    NSString *macAddress = [[UIDevice currentDevice] macAddress];
    
    NSString *uniqueGlobalIdentifier = [macAddress MD5];
    
    return uniqueGlobalIdentifier;
}

@end
