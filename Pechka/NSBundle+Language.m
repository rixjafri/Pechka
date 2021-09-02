//
//  NSBundle+Language.m
//  Medznat
//
//  Created by Shammi on 13/02/16.
//  Copyright (c) 2016 Sarvjeet. All rights reserved.
//

#import "NSBundle+Language.h"
#import <objc/runtime.h>



static const char kBundleKey = 0;

@interface BundleEx : NSBundle
    
    @end

@implementation BundleEx
    
    
-(NSString*)localizedStringForKey:(NSString *)key
                            value:(NSString *)value
                            table:(NSString *)tableName
    {
        NSBundle* bundle=objc_getAssociatedObject(self, &kBundleKey);
        return bundle ? [bundle localizedStringForKey:key
                                                value:value
                                                table:tableName] : [super localizedStringForKey:key
                                                                                          value:value
                                                                                          table:tableName];
    }
    
    @end

@implementation NSBundle (Language)
    
    
+ (void)setLanguage:(NSString *)language
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            object_setClass([NSBundle mainBundle],[BundleEx class]);
        });
        id value = language ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil;
        objc_setAssociatedObject([NSBundle mainBundle], &kBundleKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    
    @end

