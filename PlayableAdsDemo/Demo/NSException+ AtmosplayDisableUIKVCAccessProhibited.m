//
//  NSException+ AtmosplayDisableUIKVCAccessProhibited.m
//  PlayableAds_Example
//
//  Created by 王泽永 on 2019/9/16.
//  Copyright © 2019 on99. All rights reserved.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation NSException (AtmosplayDisableUIKVCAccessProhibited)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getClassMethod(self, @selector(raise:format:));
        Method swizzlingMethod = class_getClassMethod(self, @selector(sw_raise:format:));
        method_exchangeImplementations(originalMethod, swizzlingMethod);
        
    });
}

+ (void)sw_raise:(NSExceptionName)raise format:(NSString *)format, ... {
    if (raise == NSGenericException && [format isEqualToString:@"Access to %@'s %@ ivar is prohibited. This is an application bug"]) {
        return;
    }
    
    va_list args;
    va_start(args, format);
    NSString *reason =  [[NSString alloc] initWithFormat:format arguments:args];
    [self sw_raise:raise format:reason];
    va_end(args);
}

@end
