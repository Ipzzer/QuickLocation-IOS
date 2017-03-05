//
//  Utils.m
//  beeTrackr
//
//  Created by Sevenen Corp on 12/17/15.
//  Copyright © 2015 Sevenen Corp. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void) getUrl: (NSString *)url
   withCallback: (ResponseCallback) callback{
    
    dispatch_queue_t queue = dispatch_queue_create("process", NULL);
    dispatch_async(queue, ^{
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        if (url) {
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", url]]];
            //NSLog(@"CALL: %@", [NSString stringWithFormat:@"%@", url]);
        }else{
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_BASE, url]]];
            //NSLog(@"CALL: %@", [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"URL_BASE", nil), url]);
        }
        
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:[request copy]
                    completionHandler:^(NSData *data,
                                        NSURLResponse *response,
                                        NSError *error) {
                        if (response != nil) {
                            id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                            callback(dict, error);
                        }else{
                            callback(nil, error);
                        }
                        
                    }] resume];
    });
}

+ (void)          post: (NSDictionary *) args
                   url: (NSString *)url
    userIteractionView: (UIView*) rootView
          withCallback: (ResponseCallback) callback{
    
    dispatch_queue_t queue = dispatch_queue_create("process", NULL);
    dispatch_async(queue, ^{
        
        NSError *fail;
        NSData *postData = [NSJSONSerialization dataWithJSONObject: args
                                                           options: 0
                                                             error:&fail];
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        if (url) {
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", url]]];
        }else{
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_BASE, url]]];
        }
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        [request setTimeoutInterval:16.0];
        
        //NSString *JSONString = [[NSString alloc] initWithBytes:[postData bytes] length:[postData length] encoding:NSUTF8StringEncoding];
        //NSLog(@"JSON OUTPUT: %@",JSONString);
        //NSLog(@"URL: %@", [NSString stringWithFormat:@"%@%@", URL_BASE, url]);
        
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:[request copy]
                    completionHandler:^(NSData *data,
                                        NSURLResponse *response,
                                        NSError *error) {
                        if (response != nil) {
                            id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                            callback(dict, error);
                        }else{
                            callback(nil, error);
                        }
                        
                    }] resume];
    });
}

+ (BOOL) ValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString            = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex           = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest         = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+ (void) fadeIN: (NSArray*) views{
    [UIView animateWithDuration:1.0f animations:^{
        //[self colorLoaderOUT:multiColorLoader];
        for (UIView* view in views) {
            [view  setAlpha:1.0f];
        }
    } completion:nil];
}

+ (void) fadeOUT: (NSArray*) views{
    
    [UIView animateWithDuration:1.0f animations:^{
        for (UIView* view in views) {
            [view  setAlpha:0.0f];
        }
        //[self colorLoaderIN:multiColorLoader];
    } completion:nil];
}

+ (void) fadeOUTIN: (UIView*) views{
    [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationCurveEaseInOut animations:^{
        views.alpha = 0;
    } completion:^(BOOL finished) {}];
}

+ (void) upAppearAnimation: (UIView*) view
                viewsApper: (NSArray*) views{
    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        //Efectos para el logotipo principal
        view.frame = CGRectMake(view.frame.origin.x, 100.5f, view.frame.size.width, view.frame.size.height);
        
        
        //Efectos para el footer
        for (UIView* view in views) {
            if (view.tag == 100) {
                view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+45, view.frame.size.width, view.frame.size.height);
                [view  setAlpha:0.0f];
                break;
            }
        }
    } completion:^(BOOL finished){
        //Efectos para que aparezcan las cajas de texto y los botones
        [UIView animateWithDuration:0.5f animations:^{
            for (UIView* view in views) {
                if (view.tag != 100) {
                    [view  setAlpha:1.0f];
                }
            }
        } completion:nil];
    }];
}

+ (void) colorLoaderIN: (BLMultiColorLoader*) multiColorLoader{
    multiColorLoader.lineWidth = 3.0;
    multiColorLoader.colorArray = [NSArray arrayWithObjects:
                                   [UIColor colorWithRed:251.0/255.f green:187/255.f blue:10/255.f alpha:1.0], nil];
    [multiColorLoader startAnimation];
}

+ (void) colorLoaderOUT: (BLMultiColorLoader*) multiColorLoader{
    [multiColorLoader stopAnimation];
}

+ (void) setShadowViewCorner: (UIView*) view{
    [view.layer setCornerRadius:2.0f];
    [view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [view.layer setBorderWidth:0.3f];
    
    [view.layer setShadowColor:[UIColor grayColor].CGColor];
    [view.layer setShadowOpacity:0.7];
    [view.layer setShadowRadius:2.0];
    [view.layer setShadowOffset:CGSizeMake(0.0, 1.0)];
}

+ (void) setShadowViewCorner2: (UIView*) view{
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
    [view.layer setShadowOpacity:0.7];
    [view.layer setShadowRadius:2.0];
    [view.layer setShadowOffset:CGSizeMake(0.0, 1.0)];
}

+ (void) showAlert: (NSString*) title
           message: (NSString*) message
           context: (UIViewController*) context{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:NSLocalizedString(@"OK", nil)
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];

    [alert addAction:ok];
    
    [context presentViewController:alert animated:YES completion:nil];
}

+ (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

@end
