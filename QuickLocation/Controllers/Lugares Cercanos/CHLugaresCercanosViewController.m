//
//  CHLugaresCercanosViewController.m
//  Chronos
//
//  Created by Israel Pérez on 03/30/15.
//  Copyright (c) 2015 Sevenen Corp. All rights reserved.
//

#import "CHLugaresCercanosViewController.h"
#import "CHPlaces.h"
#import "CHLugaresCeldaTableViewCell.h"
#import "NSString+HTML.h"
#import "NSDictionary+UrlEncoding.h"
#import "Utils.h"
#import "QLPlaceDetailTableViewController.h"

@interface CHLugaresCercanosViewController (){
    UIButton *button;
}

@end

@implementation CHLugaresCercanosViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [Utils colorLoaderIN:self.multiColorLoader];
    self.tblLugares.hidden = YES;
    
    [self latitud:self.latitude longitud:self.longitude locali:self.locali];
    [self.tblLugares setDelegate:self];
    [self.tblLugares setDataSource:self];
    
}

- (void) viewWillAppear:(BOOL)animated{
    self.title = @"Lugares Cercanos";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor          = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor       = [UIColor colorWithRed:0.09 green:0.47 blue:0.57 alpha:1.0];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"d_sorting-50"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = barButton;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) sortAscending{
    
    NSArray* asc = [self.tableData sortedArrayUsingComparator:^NSComparisonResult(CHPlaces* n1, CHPlaces* n2) {
        return [[n1 rating] compare:[n2 rating]];
    }];
    
    [button setImage:[UIImage imageNamed:@"a_sorting-50"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sortDescending)forControlEvents:UIControlEventTouchUpInside];
    
    self.tableData = [asc mutableCopy];
    [self.tblLugares reloadData];
}

- (void) sortDescending{
    
    NSArray* desc = [self.tableData sortedArrayUsingComparator:^NSComparisonResult(CHPlaces* n1, CHPlaces* n2) {
        return [[n2 rating] compare:[n1 rating]];
    }];
    
    [button setImage:[UIImage imageNamed:@"d_sorting-50"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sortAscending)forControlEvents:UIControlEventTouchUpInside];
    
    self.tableData = [desc mutableCopy];
    [self.tblLugares reloadData];
}


- (id)initWithLatitud:(NSString *) lat
             Longitud:(NSString *) lon
         Localizacion:(NSString *) locali{
    if (self=[super init]) {
        _latitude = lat;
        _longitude = lon;
        _locali = locali;
    }
    return self;
}

-(void)processListResponse: (NSMutableArray *)placesList error: (NSError *)error{
    if(placesList)
    {
        [Utils colorLoaderOUT:self.multiColorLoader];
        self.tblLugares.hidden = NO;
        self.tableData = [[NSMutableArray alloc] init];
        self.tableData = placesList;
        [self sortDescending];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cellIdentify";
    
    CHLugaresCeldaTableViewCell *cell = (CHLugaresCeldaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CHLugaresCeldaTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.txtTituloCell.font    = [UIFont fontWithName:@"Roboto-Regular" size:17];
    cell.txtTituloCell.text    = [[self.tableData objectAtIndex:indexPath.row] nombreLugar];
    
    cell.txtSubCell.font       = [UIFont fontWithName:@"Roboto-Regular" size:13];
    cell.txtSubCell.text       = [[self.tableData objectAtIndex:indexPath.row] vicinityLugar];
    cell.imgCell.image         =[[self.tableData objectAtIndex:indexPath.row] iconLugar];
    
    
    cell.txtRating.text        = [NSString stringWithFormat:@"%.1f", [[[self.tableData objectAtIndex:indexPath.row] rating] floatValue]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QLPlaceDetailTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"placeDetailTableViewController"];
    vc.detalleLugar = [self.tableData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void) latitud: (NSString *) lat
       longitud: (NSString *) lon
         locali: (NSString *) local{
    
    NSMutableArray *lugares = [[NSMutableArray alloc] init];
    
    ResponseCallback callback = ^(id result, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *data = result;
            //NSLog(@"data: %@", data);
            
            if (!error) {
                if ([[data objectForKey:@"status"] isEqualToString:@"OK"]) {
                    
                    NSArray *results = [data objectForKey:@"results"];
                    for (int o = 0; o < results.count; o++) {
                        CHPlaces *places = [[CHPlaces alloc] init];
                        
                        [places setPlaceId:[[results objectAtIndex:o] objectForKey:@"place_id"]];
                        
                        NSArray *photos = [[results objectAtIndex:o] objectForKey:@"photos"];
                        
                        if (photos) {
                            [places setPhotoRef:[[photos objectAtIndex:0] objectForKey:@"photo_reference"]];
                        }
                        
                        if ([[results objectAtIndex:o] objectForKey:@"rating"]) {
                            [places setRating: [NSNumber numberWithFloat:[[[results objectAtIndex:o] objectForKey:@"rating"] floatValue]]];
                        }else{
                            [places setRating:[NSNumber numberWithFloat:0.f]];
                        }
                        
                        [places setNombreLugar:[[results objectAtIndex:o] objectForKey:@"name"]];
                        [places setVicinityLugar:[[results objectAtIndex:o] objectForKey:@"vicinity"]];
                        [places setIconLugar:[UIImage imageNamed:self.locali]];
                        
                        
                        [places setLatLugar:[[[[results objectAtIndex:o]
                                               objectForKey:@"geometry"]
                                              objectForKey:@"location"]
                                             objectForKey:@"lat"]];
                        
                        [places setLonLugar:[[[[results objectAtIndex:o]
                                               objectForKey:@"geometry"]
                                              objectForKey:@"location"]
                                             objectForKey:@"lng"]];
                        
                        [lugares addObject:places];
                    }
                    
                    
                }else{
                
                }
            }
            
            [self processListResponse:lugares error:error];
            
        });
    };
    
    
    NSString *str = lat;
    str = [str stringByAppendingString:@","];
    str = [str stringByAppendingString:lon];
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
                            str, @"location",
                            @"500", @"radius",
                            GOOGLE_GEOPLACES, @"key",
                            self.locali, @"types",
                            nil];
    
    NSArray *parts = [NSArray arrayWithObjects: GOOGLE_PLACES_NEARBY, [args urlEncodedString], nil];
    NSString *urlString = [parts componentsJoinedByString: @"?"];
    
    [Utils getUrl:urlString withCallback:callback];
}


@end
