//
//  HJHKeychain.m
//  BetterBugs
//
//  Created by Jonghwan Hyeon on 3/11/13.
//  Copyright (c) 2013 Jonghwan Hyeon. All rights reserved.
//

#import "HJHKeychain.h"

@implementation HJHKeychain
- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.defaultService = [[NSBundle mainBundle] bundleIdentifier];
    
    return self;
}


+ (id)keychain
{
    return [[self alloc] init];
}

- (void)setPassword:(NSString *)password forAccount:(NSString *)account ofService:(NSString *)service
{
    if ([account isEqualToString:@""]) return ;
    if (!service) service = self.defaultService;
    
    const char *serviceUTF8String = [service UTF8String];
    UInt32 lengthOfServiceUTF8String = (UInt32)strlen(serviceUTF8String);
    const char *accountUTF8String = [account UTF8String];
    UInt32 lengthOfAccountUTF8String = (UInt32)strlen(accountUTF8String);
    const char *passwordUTF8String = [password UTF8String];
    UInt32 lengthOfPasswordUTF8String = (UInt32)strlen(passwordUTF8String);
    
    if ([self hasPasswordForAccount:account ofService:service]) {
        SecKeychainItemRef keychainItem = [self keychainItemForAccount:account ofService:service];
        SecKeychainItemModifyAttributesAndData(keychainItem, NULL, lengthOfPasswordUTF8String, passwordUTF8String);
        CFRelease(keychainItem);
    } else {
        SecKeychainAddGenericPassword(NULL, lengthOfServiceUTF8String, serviceUTF8String, lengthOfAccountUTF8String, accountUTF8String, lengthOfPasswordUTF8String, passwordUTF8String, NULL);
    }
}

- (NSString *)passwordForAccount:(NSString *)account ofService:(NSString *)service
{
    if ([account isEqualToString:@""]) return nil;
    if (!service) service = self.defaultService;
    
    const char *serviceUTF8String = [service UTF8String];
    UInt32 lengthOfServiceUTF8String = (UInt32)strlen(serviceUTF8String);
    const char *accountUTF8String = [account UTF8String];
    UInt32 lengthOfAccountUTF8String = (UInt32)strlen(accountUTF8String);
    
    char *passwordUTF8String;
    UInt32 lengthOfPasswordUTF8String;
    NSString *password = nil;;
    OSStatus status = SecKeychainFindGenericPassword(NULL, lengthOfServiceUTF8String, serviceUTF8String, lengthOfAccountUTF8String, accountUTF8String, &lengthOfPasswordUTF8String, (void **)&passwordUTF8String, NULL);
    
    if (status == noErr) {
        password = [[NSString alloc] initWithBytes:passwordUTF8String length:lengthOfPasswordUTF8String encoding:NSUTF8StringEncoding];
        SecKeychainItemFreeContent(NULL, passwordUTF8String);
    }
    
    return password;
}

- (SecKeychainItemRef)keychainItemForAccount:(NSString *)account ofService:(NSString *)service
{
    if (!service) service = self.defaultService;
    
    const char *serviceUTF8String = [service UTF8String];
    UInt32 lengthOfServiceUTF8String = (UInt32)strlen(serviceUTF8String);
    const char *accountUTF8String = [account UTF8String];
    UInt32 lengthOfAccountUTF8String = (UInt32)strlen(accountUTF8String);
    
    SecKeychainItemRef keychainItem;
    SecKeychainFindGenericPassword(NULL, lengthOfServiceUTF8String, serviceUTF8String, lengthOfAccountUTF8String, accountUTF8String, NULL, NULL, &keychainItem);
    
    return keychainItem;
}

- (void)setPassword:(NSString *)password forAccount:(NSString *)account
{
    [self setPassword:password forAccount:account ofService:nil];
}

- (NSString *)passwordForAccount:(NSString *)account
{
    return [self passwordForAccount:account ofService:nil];
}

- (BOOL)hasPasswordForAccount:(NSString *)account ofService:(NSString *)service
{
    return ([self passwordForAccount:account ofService:service] != nil);
}

- (BOOL)hasPasswordForAccount:(NSString *)account
{
    return [self hasPasswordForAccount:account ofService:nil];
}
@end
