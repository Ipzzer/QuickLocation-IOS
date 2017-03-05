//
//  CHLugaresCercanosViewController.h
//  Chronos
//
//  Created by Israel Pérez on 03/30/15.
//  Copyright (c) 2015 Sevenen Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMultiColorLoader.h"

@class CHLugaresCercanosViewController;

@protocol CHLugaresCercanosDelegate <NSObject>

-(void)CHHomeScreenDelegate:(CHLugaresCercanosViewController *) delegado
                       text:(NSDictionary *)textoEnvio;
@end


@interface CHLugaresCercanosViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) NSMutableArray *tableData;
@property (weak, nonatomic) IBOutlet UITableView *tblLugares;
@property(strong,nonatomic) NSString *latitude;
@property(strong,nonatomic) NSString *longitude;
@property(nonatomic,strong) NSString * locali;
@property(nonatomic, weak) id <CHLugaresCercanosDelegate> delegate;
@property (weak, nonatomic) IBOutlet BLMultiColorLoader *multiColorLoader;

- (id)initWithLatitud:(NSString *) lat
             Longitud:(NSString *) lon
         Localizacion:(NSString *) locali;
@end
