//
//  QLPlaceDetailTableViewCell.h
//  QuickLocation
//
//  Created by Perez on 03/04/17.
//  Copyright © 2017 Artixworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLPlaceDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnLlamar;
@property (weak, nonatomic) IBOutlet UIButton *btnIr;
@property (weak, nonatomic) IBOutlet UILabel *lblTelefono;
@property (weak, nonatomic) IBOutlet UILabel *lblDireccion;
@property (weak, nonatomic) IBOutlet UILabel *lblEstado;
@property (weak, nonatomic) IBOutlet UILabel *lblHorario;
@property (weak, nonatomic) IBOutlet UITextView *txtHorarios;


@end
