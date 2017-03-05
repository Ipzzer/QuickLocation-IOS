//
//  QLPlaceDetailViewController.h
//  QuickLocation
//
//  Created by Perez on 03/04/17.
//  Copyright © 2017 Artixworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFStretchableTableHeaderView.h"
#import "CHPlaces.h"

@interface QLPlaceDetailTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIView *stretchView;
@property (nonatomic) NSInteger barIndex;
@property (nonatomic, strong) HFStretchableTableHeaderView* stretchableTableHeaderView;
@property (nonatomic, strong) CHPlaces *detalleLugar;
@property (weak, nonatomic) IBOutlet UIImageView *imgPortada;

- (id) initWithPlace: (CHPlaces*) place;

@end
