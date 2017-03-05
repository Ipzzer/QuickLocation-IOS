//
//  ViewController.m
//  QuickLocation
//
//  Created by Perez on 03/02/17.
//  Copyright © 2017 Artixworks. All rights reserved.
//

#import "QLHomeViewController.h"
#import "CHLugaresCercanosViewController.h"

@interface QLHomeViewController (){
    CLLocation *crnLoc;
    int cont;
    NSString *lat;
    NSString *lon;
}

@end

@implementation QLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    cont = 0;
    [self locationLoad];
}


- (void) viewWillAppear:(BOOL)animated{
    self.title = @"SOS Places";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor          = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor       = [UIColor colorWithRed:0.09 green:0.47 blue:0.57 alpha:1.0];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark- Location

-(void) locationLoad{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

-(void) locationManager: (CLLocationManager *) manager didUpdateLocations: (NSArray *) locations

{
    crnLoc = [locations lastObject];
    if (crnLoc) {
        //NSLog(@"%@", [NSString stringWithFormat:@"Latitud: %.8f    -     Longitud: %.8f    -     Altitud: %.0f m    -     Velocidad: %.1f m/s",crnLoc.coordinate.latitude, crnLoc.coordinate.longitude, crnLoc.altitude, crnLoc.speed]);
        
        lat = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.latitude];
        lon = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.longitude];
        
        if (cont==0) {
            cont = 1;
        }
        
        //[self.locationManager setDelegate:nil];
    }
    
}


- (void) lugares: (NSString *) comercio{
    CHLugaresCercanosViewController *vc = [self.storyboard
                                           instantiateViewControllerWithIdentifier:@"lugaresCercanosViewController"];
    vc.locali = comercio;
    vc.latitude = lat;
    vc.longitude = lon;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnPolicia:(id)sender {
    [self lugares:@"police"];
}

- (IBAction)btnHospitales:(id)sender {
    [self lugares:@"hospital"];
}

- (IBAction)btnBomberos:(id)sender {
    [self lugares:@"fire_station"];
}

- (IBAction)btnFarmacias:(id)sender {
    [self lugares:@"pharmacy"];
}

@end
