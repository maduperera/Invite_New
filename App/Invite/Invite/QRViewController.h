//
//  QRViewController.h
//  Invite
//
//  Created by Madusha Perera on 4/11/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "qrencode.h"

@interface QRViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *qrView;
@property(nonatomic,weak) PFObject *invitation;
@end
