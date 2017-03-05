//
//  Utils.h
//  beeTrackr
//
//  Created by Sevenen Corp on 12/17/15.
//  Copyright © 2015 Sevenen Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BLMultiColorLoader.h"

/********************** CONSTANTES **********************/
#define URL_BASE             @""
#define GOOGLE_GEOPLACES     @" AIzaSyD8SNVxSyGRignyWNyfyExoYDyJKLZXSJ0"
#define GOOGLE_PLACES_NEARBY @"https://maps.googleapis.com/maps/api/place/nearbysearch/json"
#define GOOGLE_PLACES_DETAIL @"https://maps.googleapis.com/maps/api/place/details/json"
#define GOOGLE_PLACES_PHOTO  @"https://maps.googleapis.com/maps/api/place/photo"
/********************** CONSTANTES **********************/

typedef void (^ResponseCallback) (id dict, NSError *error);

@interface Utils : NSObject

+ (void) getUrl: (NSString *)url
   withCallback: (ResponseCallback) callback;

+ (void)          post: (NSDictionary *) args
                   url: (NSString *)url
    userIteractionView: (UIView*) rootView
          withCallback: (ResponseCallback) callback;

+ (BOOL) ValidEmail:(NSString *)checkString;

+ (void)  fadeOUT: (NSArray*) views;
+ (void)  fadeIN: (NSArray*) views;
+ (void) fadeOUTIN: (UIView*) views;
+ (void) upAppearAnimation: (UIView*) view
                viewsApper: (NSArray*) views;

+ (void) colorLoaderIN : (BLMultiColorLoader*) multiColorLoader;
+ (void) colorLoaderOUT: (BLMultiColorLoader*) multiColorLoader;

+ (void) setShadowViewCorner: (UIView*) view;
+ (void) setShadowViewCorner2: (UIView*) view;
+ (void) showAlert: (NSString*) title
           message: (NSString*) message
           context: (UIViewController*) context;

+ (void)resetDefaults;

@end
