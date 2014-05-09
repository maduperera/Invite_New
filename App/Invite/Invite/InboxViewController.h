//
//  InboxViewController.h
//  Invite
//
//  Created by Dhammini Fernando on 3/20/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteLoginViewController.h"
#import "InviteSignupViewController.h"
#import <MessageUI/MessageUI.h>


@interface InboxViewController : UITableViewController<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate,  MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property(nonatomic, strong) NSMutableArray *tableData;
@property(nonatomic, strong) NSMutableArray *events;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;
@property(nonatomic, strong) NSMutableArray *eventIDs;
@property(nonatomic, strong) NSMutableArray *eventStatus;


- (IBAction)mailToInvitor:(id)sender;
- (IBAction)callInvitor:(id)sender;
- (IBAction)shop:(id)sender;
- (IBAction)showQR:(id)sender;
- (IBAction)showMap:(id)sender;
- (IBAction)contactInvitationSender:(id)sender;
- (IBAction)reload:(id)sender;

@end
