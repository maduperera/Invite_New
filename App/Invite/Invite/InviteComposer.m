//
//  InviteComposer.m
//  Invite
//
//  Created by Madusha Perera on 3/21/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "InviteComposer.h"
#import "InviteTabBar.h"

@interface InviteComposer ()

@end

@implementation InviteComposer

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signOut:(id)sender {
    [PFUser logOut];
    // Present Invite Tab Bar Controller
//    InviteTabBar *tabBar = [[InviteTabBar alloc] init];
//    [self presentViewController:tabBar animated:YES completion:NULL];
}

@end
