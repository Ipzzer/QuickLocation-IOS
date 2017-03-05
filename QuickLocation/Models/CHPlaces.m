//
//  CHPlaces.m
//  Chronos
//
//  Created by Israel Pérez on 03/30/15.
//  Copyright (c) 2015 Sevenen Corp. All rights reserved.
//

#import "CHPlaces.h"
//#import "ACWebServicesClient.h"
//#import "NSDictionary+JSON.h"
//#import "TBXML.h"
#import "NSString+HTML.h"
#import "Utils.h"

@implementation CHPlaces


/*
+(void) latitud: (NSString *) lat
       longitud: (NSString *) lon
         locali: (NSString *) local
   withCallback: (PlacesCallback) callback2{
    
    NSMutableArray __block *placesList = [[NSMutableArray alloc] init];
    ACWebServicesClient *query = [[ACWebServicesClient alloc] initWithUrl: gPlaces];
    NSString *str = lat;
    str = [str stringByAppendingString:@","];
    str = [str stringByAppendingString:lon];
    NSDictionary *header = [NSDictionary dictionaryWithObjectsAndKeys:
                            str, @"location",
                            @"500", @"radius",
                            GOOGLE_GEOPLACES, @"key",
                            nil];
    
    __block NSError *error = nil;
    
    TBXMLSuccessBlock successBlock = ^(TBXML *xmlDoc) {
        
        TBXMLElement *root = xmlDoc.rootXMLElement;
        
        if (root) {
            TBXMLElement *eleResult;
            eleResult = [TBXML childElementNamed:@"result" parentElement:root];
            
            CHPlaces *itemObj = [[CHPlaces alloc] init];
            itemObj.nombreLugar = NSLocalizedString(@"mi_ubicacion", nil);
            itemObj.vicinityLugar = local;
            itemObj.iconLugar = [UIImage imageNamed:@"sv_beeTrackr_places"];
            itemObj.latLugar = [NSString stringWithFormat:@"%@", lat];
            itemObj.lonLugar = [NSString stringWithFormat:@"%@", lon];
            [placesList addObject:itemObj];
            
            while (eleResult) {
                
                CHPlaces *itemObj = [[CHPlaces alloc] init];
                itemObj.nombreLugar = [TBXML textForElement:[TBXML childElementNamed:@"name" parentElement:eleResult]];
                itemObj.vicinityLugar = [TBXML textForElement:[TBXML childElementNamed:@"vicinity" parentElement:eleResult]];
                //NSString *imagm = [TBXML textForElement:[TBXML childElementNamed:@"icon" parentElement:eleResult]];
                itemObj.iconLugar = [UIImage imageNamed:@"sv_beeTrackr_places"];

                TBXMLElement *selResult = [TBXML childElementNamed:@"geometry" parentElement:eleResult];
                selResult = [TBXML childElementNamed:@"location" parentElement:selResult];
                itemObj.latLugar = [TBXML textForElement:[TBXML childElementNamed:@"lat" parentElement:selResult]];
                itemObj.lonLugar = [TBXML textForElement:[TBXML childElementNamed:@"lng" parentElement:selResult]];
                
                [placesList addObject:itemObj];
                eleResult = [TBXML nextSiblingNamed:@"result" searchFromElement:eleResult];
            }
        }
        else{
            placesList = nil;
            error = [NSError errorWithDomain:@"sevenenmobile.com"  code:-1 userInfo:
                     @{NSLocalizedDescriptionKey: NSLocalizedString(@"validate_cosa", nil)}];
            
        }
        callback(placesList, error);

    };
    TBXMLFailureBlock failureBlock = ^(TBXML *xmlDoc, NSError *error){
        //NSLog(@"Google places Webservice error %@ %@", [error localizedDescription], [error userInfo]);
        callback (placesList, error);
    };
    
    [query get: header success:successBlock failured:failureBlock];
}*/
@end
