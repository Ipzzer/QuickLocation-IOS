//
//  CHPlaces.h
//  Chronos
//
//  Created by Israel Pérez on 03/30/15.
//  Copyright (c) 2015 Sevenen Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CHPlaces;

typedef void (^PlacesCallback) (NSMutableArray *lugares, NSError *error);

@interface CHPlaces : NSObject

@property(nonatomic, strong) NSString* placeId;
@property(nonatomic, strong) NSString* photoRef;
@property(nonatomic, strong) NSString* nombreLugar;
@property(nonatomic, strong) NSString* vicinityLugar;
@property(nonatomic, strong) UIImage* iconLugar;
@property(nonatomic, strong) NSString* latLugar;
@property(nonatomic, strong) NSString* lonLugar;

@end
