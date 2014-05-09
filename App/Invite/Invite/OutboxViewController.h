//
//  OutboxViewController.h
//  Invite
//
//  Created by Dhammini Fernando on 3/20/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteLoginViewController.h"
#import "InviteSignupViewController.h"

@interface OutboxViewController : UITableViewController<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property(nonatomic, strong) NSMutableArray *tableData;
@property(nonatomic, strong) NSMutableArray *events;

@property(nonatomic, strong) NSMutableArray *eventIDs;

- (IBAction)reload:(id)sender;

@end
