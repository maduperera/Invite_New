//
//  InviteLoginViewController.m
//  Invite
//
//  Created by Madusha Perera on 3/21/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "InviteLoginViewController.h"

@interface InviteLoginViewController ()

@end

@implementation InviteLoginViewController

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
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invite.png"]]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
   
}

@end
