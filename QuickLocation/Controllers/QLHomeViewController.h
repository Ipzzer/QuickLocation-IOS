//
//  ViewController.h
//  QuickLocation
//
//  Created by Perez on 03/02/17.
//  Copyright © 2017 Artixworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface QLHomeViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;

- (IBAction)btnPolicia:(id)sender;
- (IBAction)btnHospitales:(id)sender;
- (IBAction)btnBomberos:(id)sender;
- (IBAction)btnFarmacias:(id)sender;

@end

