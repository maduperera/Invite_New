//
//  OutBoxCustomCell.h
//  Invite
//
//  Created by Madusha Perera on 3/30/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutBoxCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *outBoxEventLabel;

@property (weak, nonatomic) IBOutlet UIButton *showFeedBack;
@property (weak, nonatomic) IBOutlet UIButton *showQR;
@end
