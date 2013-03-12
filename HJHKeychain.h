//
//  HJHKeychain.h
//  BetterBugs
//
//  Created by Jonghwan Hyeon on 3/11/13.
//  Copyright (c) 2013 Jonghwan Hyeon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJHKeychain : NSObject
@property (nonatomic, strong) NSString *defaultService;

+ (id)keychain;

- (void)setPassword:(NSString *)password forAccount:(NSString *)account ofService:(NSString *)service;
- (NSString *)passwordForAccount:(NSString *)account ofService:(NSString *)service;

- (void)setPassword:(NSString *)password forAccount:(NSString *)account;
- (NSString *)passwordForAccount:(NSString *)account;

- (BOOL)hasPasswordForAccount:(NSString *)account ofService:(NSString *)service;
- (BOOL)hasPasswordForAccount:(NSString *)account;
@end
