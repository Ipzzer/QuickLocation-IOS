//
//  NSDictionary+UrlEncdoing.h
//  AlertaCiudadana
//
//  Created by Eivar Montenegro on 2/1/15.
//  Copyright (c) 2015 Sevenen Corp. All rights reserved.
//

#ifndef AlertaCiudadana_NSDictionary_UrlEncoding_h
#define AlertaCiudadana_NSDictionary_UrlEncoding_h
#endif

@interface NSDictionary (UrlEncoding)

/**
 * Convert a dictionary into a URL encoded params string
 */
- (NSString *) urlEncodedString;

@end