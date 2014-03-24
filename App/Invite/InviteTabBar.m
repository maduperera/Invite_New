//
//  InviteTabBar.m
//  Invite
//
//  Created by Madusha Perera on 3/21/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "InviteTabBar.h"
//#import "InviteLoginViewController.h"
//#import "InviteSignupViewController.h"

@interface InviteTabBar ()

@end

@implementation InviteTabBar

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
    self.selectedIndex = 1;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"in");
    
//    if (![PFUser currentUser]) { // No user logged in
//        // Create the log in view controller
//        InviteLoginViewController *logInViewController = [[InviteLoginViewController alloc] init];
//        [logInViewController setDelegate:self]; // Set ourselves as the delegate
//        
//        // Create the sign up view controller
//        InviteSignupViewController *signUpViewController = [[InviteSignupViewController alloc] init];
//        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
//        
//        // Assign our sign up controller to be displayed from the login controller
//        [logInViewController setSignUpController:signUpViewController];
//        
//        // Present the log in view controller
//        [self presentViewController:logInViewController animated:YES completion:NULL];
//        NSLog(@"in");
//    }
}

//// Sent to the delegate when a PFUser is logged in.
//- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}



@end
