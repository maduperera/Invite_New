//
//  InboxCustomCell.h
//  Invite
//
//  Created by Madusha Perera on 3/30/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;
@property (weak, nonatomic) IBOutlet UITextView *eventTitleText;
@property (weak, nonatomic) IBOutlet UILabel *eventStatus;
@property (weak, nonatomic) IBOutlet UIImageView *eventStatusColor;
@property (weak, nonatomic) IBOutlet UIButton *btnContact;

@end
