//
//  NSDictionary+UrlEncoding.m
//  AlertaCiudadana
//
//  Created by Eivar Montenegro on 2/1/15.
//  Copyright (c) 2015 Sevenen Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+UrlEncoding.h"

/**
 * Helper function: get the string form of any object
 */
static NSString *toString(id object)
{
    return [NSString stringWithFormat: @"%@", object];
}

/**
 * Helper function: get the url encoded string form of any object
 */
static NSString *urlEncode(id object)
{
    NSString *str = toString(object);
    return [str stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLHostAllowedCharacterSet]];
}

@implementation NSDictionary (UrlEncoding)

-(NSString *) urlEncodedString
{
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in self) {
        id value = [self objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

@end