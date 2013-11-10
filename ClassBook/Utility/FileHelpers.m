#import "FileHelpers.h"

// To use this function, you pass it a file name, and it will construct 
// the full path for that file in the Documents directory.
NSString *pathInDocumentDirectory(id fileName)
{
    // Get list of document directories in sandbox
//    NSArray *documentDirectories =
//    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
//                                        NSUserDomainMask, YES);
    
    // Get one and only document directory from that list
    NSString *documentDirectory = GET_APP_DOCUMENT_PATH;
    
    // Append passed in file name to that directory, return it
    if (fileName == [NSNull null]) {
        return nil;
    }
    return [documentDirectory stringByAppendingPathComponent:fileName];
}

//create unique identifier strings
NSString *uniqueIdentifierStrings(void)
{
    // Create a CFUUID object - it knows how to create unique identifier strings
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    
    // Create a string from unique identifier
    CFStringRef newUniqueIDString =
    CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    NSString * str = [NSString stringWithString:(NSString *)newUniqueIDString];
    
    // We used "Create" in the functions to make objects, we need to release them
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    return str;
}