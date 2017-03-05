//
//  QLPlaceDetailViewController.m
//  QuickLocation
//
//  Created by Perez on 03/04/17.
//  Copyright © 2017 Artixworks. All rights reserved.
//

#import "QLPlaceDetailTableViewController.h"
#import "Utils.h"
#import "NSDictionary+UrlEncoding.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "QLPlaceDetailTableViewCell.h"
#import "BLMultiColorLoader.h"

@interface QLPlaceDetailTableViewController (){
    NSMutableDictionary *detailsData;
    BLMultiColorLoader *activityIndicatorView;
}

@end

@implementation QLPlaceDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.tableView setContentInset:UIEdgeInsetsMake(-64,0,0,0)];
    //_stretchableTableHeaderView = [HFStretchableTableHeaderView new];
    //[_stretchableTableHeaderView stretchHeaderForTableView:self.tableView withView:_stretchView];
    
    [self showLoadingWave];
    [self loadDetails];
    [self loadPhotoReference];
}


- (id) initWithPlace: (CHPlaces*) place{
    
    if (self = [super init]) {
        _detalleLugar = place;
    }
    
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated{
    self.title = [self.detalleLugar nombreLugar];
    //self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor          = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor       = [UIColor colorWithRed:0.09 green:0.47 blue:0.57 alpha:1.0];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}
/*
- (void)viewDidLayoutSubviews
{
    [_stretchableTableHeaderView resizeView];
    
}*/


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 427.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"placeDetailTableViewCell";
    
    QLPlaceDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[QLPlaceDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (detailsData) {
        cell.lblTelefono.text = [detailsData objectForKey:@"telefono"];
        cell.lblDireccion.text = [detailsData objectForKey:@"direccion"];
        cell.lblEstado.text = [detailsData objectForKey:@"estado"];
        cell.lblHorario.text = @"Horario";
        
        NSArray *parts = [detailsData objectForKey:@"horarios"];
        NSString *weekdayText = [parts componentsJoinedByString: @"\n"];
        
        cell.txtHorarios.text = weekdayText;
        
        [cell.btnLlamar addTarget:self action:@selector(callTelephoneBar:) forControlEvents:UIControlEventTouchDown];
        
        [cell.btnIr addTarget:self action:@selector(callGoogleMapsNavigation:) forControlEvents:UIControlEventTouchDown];
    }
    
    return cell;
}


#pragma mark - Peticiones
-(void) loadDetails{
    
    ResponseCallback callback = ^(id result, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *data = result;
            //NSLog(@"data: %@", data);
            
            if (!error) {
                if ([[data objectForKey:@"status"] isEqualToString:@"OK"]) {
                    
                    
                    NSDictionary *result = [data objectForKey:@"result"];
                    
                    NSString *telefono = [result objectForKey:@"formatted_phone_number"];
                    NSString *direccion = [result objectForKey:@"formatted_address"];
                    BOOL estadoValor = [[result objectForKey:@"opening_hours"]
                                        objectForKey:@"open_now"];
                    
                    NSArray *horarios = [[result objectForKey:@"opening_hours"]
                                          objectForKey:@"weekday_text"];
                    
                    NSString *estado = estadoValor == YES ?
                    @"Abierto en este momento" :
                    @"Cerrado en este momento" ;
                    
                    telefono = telefono ? telefono : @"No proporcionado";
                    direccion = direccion ? direccion : @"";
                    
                    detailsData = [[NSMutableDictionary alloc]
                                   initWithObjectsAndKeys:
                                   telefono, @"telefono",
                                   direccion, @"direccion",
                                   estado, @"estado",
                                   horarios, @"horarios",
                                   nil];
                    
                    [self.tableView reloadData];
                    
                    
                }else{
                    
                }
            }
            
            [self hidedrawLoadingWave];
            
        });
    };
    
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
                          [self.detalleLugar placeId], @"placeid",
                          GOOGLE_GEOPLACES, @"key",
                          nil];
    
    NSArray *parts = [NSArray arrayWithObjects: GOOGLE_PLACES_DETAIL, [args urlEncodedString], nil];
    NSString *urlString = [parts componentsJoinedByString: @"?"];
    
    [Utils getUrl:urlString withCallback:callback];
}

-(void) loadPhotoReference{
    
    if ([self.detalleLugar photoRef]) {
        NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"400", @"maxwidth",
                              [self.detalleLugar photoRef], @"photoreference",
                              GOOGLE_GEOPLACES, @"key",
                              nil];
        
        NSArray *parts = [NSArray arrayWithObjects: GOOGLE_PLACES_PHOTO, [args urlEncodedString], nil];
        NSString *urlString = [parts componentsJoinedByString: @"?"];
        
        [self.imgPortada sd_setImageWithURL:[NSURL URLWithString:urlString]
                           placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }else{
        self.imgPortada.image = [UIImage imageNamed:@"placeholder"];
    }
    
}

- (void)callTelephoneBar:(id)sender{
    
    if ([detailsData objectForKey:@"telefono"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [detailsData objectForKey:@"telefono"]]]
                                           options:@{}
                                 completionHandler:nil];
    }else{
        [Utils showAlert:@"Alerta"
                 message:@"No existe un número para contactar"
                 context:self];
    }
}

- (void)callGoogleMapsNavigation:(id)sender{
    NSURL *testURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
    if ([[UIApplication sharedApplication] canOpenURL:testURL]) {
        
        NSString *directionsRequest = [NSString stringWithFormat:@"%@%@%@,%@%@",
                                       @"comgooglemaps-x-callback://",
                                       @"?daddr=",
                                       [self.detalleLugar latLugar],
                                       [self.detalleLugar lonLugar],
                                       @"&x-success=sourceapp://?resume=true"];
        NSURL *directionsURL = [NSURL URLWithString:directionsRequest];
        [[UIApplication sharedApplication] openURL:directionsURL
                                           options:@{}
                                 completionHandler:nil];
    } else {
        NSLog(@"Can't use comgooglemaps-x-callback:// on this device.");
    }
}

- (void) showLoadingWave{
    CGSize size = self.view.frame.size;
    activityIndicatorView = [[BLMultiColorLoader alloc] init];
    activityIndicatorView.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    [Utils colorLoaderIN:activityIndicatorView];
    
    [activityIndicatorView setCenter:CGPointMake(size.width/2, size.height/2)];
    
    [self.view addSubview:activityIndicatorView];
    [self.view.subviews setValue:@YES forKeyPath:@"hidden"];
    [self.view insertSubview:activityIndicatorView atIndex:1];
}

- (void) hidedrawLoadingWave{
    [activityIndicatorView removeFromSuperview];
    [self.view.subviews setValue:@NO forKeyPath:@"hidden"];
}


@end
