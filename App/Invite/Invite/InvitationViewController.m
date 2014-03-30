//
//  InvitationViewController.m
//  Invite
//
//  Created by Madusha Perera on 3/29/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "InvitationViewController.h"

@interface InvitationViewController ()

@end

@implementation InvitationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.invitationTitle.text = [self.event objectForKey:@"title"];
    self.invitationAddress.text = [self.event objectForKey:@"address"];
    self.invitationFrom.text = [self.event objectForKey:@"startTime"];
    self.invitationTo.text = [self.event objectForKey:@"endTime"];
    self.invitationContactNo.text = [self.event objectForKey:@"contactNo"];
    self.invitationDate.text = [self.event objectForKey:@"eventDate"];
        
}

-(void)viewDidAppear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
