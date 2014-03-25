//
//  InviteSignupViewController.m
//  Invite
//
//  Created by Madusha Perera on 3/21/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "InviteSignupViewController.h"

@interface InviteSignupViewController ()

@end

@implementation InviteSignupViewController

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
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invite.png"]]];
    
	// Do any additional setup after loading the view.
    
    // Remove text shadow
    CALayer *layer = self.signUpView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.emailField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.additionalField.layer;
    layer.shadowOpacity = 0.0f;

//    // Set text color
    [self.signUpView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.emailField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.additionalField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];

    // Change "Additional" to match our use
    [self.signUpView.additionalField setPlaceholder:@"Phone number"];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    // Move all fields down on smaller screen sizes
//    float yOffset = [UIScreen mainScreen].bounds.size.height <= 480.0f ? 30.0f : 0.0f;
//    
//    CGRect fieldFrame = self.signUpView.usernameField.frame;
//    
//    [self.signUpView.dismissButton setFrame:CGRectMake(10.0f, 10.0f, 87.5f, 45.5f)];
//    [self.signUpView.logo setFrame:CGRectMake(66.5f, 70.0f, 187.0f, 58.5f)];
//    [self.signUpView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
//    [self.fieldsBackground setFrame:CGRectMake(35.0f, fieldFrame.origin.y + yOffset, 250.0f, 174.0f)];
//    
//    [self.signUpView.usernameField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
//                                                       fieldFrame.origin.y + yOffset,
//                                                       fieldFrame.size.width - 10.0f,
//                                                       fieldFrame.size.height)];
//    yOffset += fieldFrame.size.height;
//    
//    [self.signUpView.passwordField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
//                                                       fieldFrame.origin.y + yOffset,
//                                                       fieldFrame.size.width - 10.0f,
//                                                       fieldFrame.size.height)];
//    yOffset += fieldFrame.size.height;
//    
//    [self.signUpView.emailField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
//                                                    fieldFrame.origin.y + yOffset,
//                                                    fieldFrame.size.width - 10.0f,
//                                                    fieldFrame.size.height)];
//    yOffset += fieldFrame.size.height;
//    
//    [self.signUpView.additionalField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
//                                                         fieldFrame.origin.y + yOffset,
//                                                         fieldFrame.size.width - 10.0f,
//                                                         fieldFrame.size.height)];
//
//}

@end
