
#import "UIViewController+Utilities.h"
#import "InviteLoginViewController.h"
#import "InviteSignupViewController.h"

@implementation UIViewController (Utilities)

- (IBAction)signout:(id)sender {
    [PFUser logOut];
    [self showLoginView];
    NSLog(@"logged out successfully");
}


-(void)showLoginView{
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        InviteLoginViewController *logInViewController = [[InviteLoginViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        //set fields to login view controller
        logInViewController.fields = PFLogInFieldsUsernameAndPassword
        | PFLogInFieldsLogInButton
        | PFLogInFieldsSignUpButton
        | PFLogInFieldsPasswordForgotten;
        
        
        // Create the sign up view controller
        InviteSignupViewController *signUpViewController = [[InviteSignupViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
       
        //set fields to signup view controller
        signUpViewController.fields = PFSignUpFieldsUsernameAndPassword
        | PFSignUpFieldsSignUpButton
        | PFSignUpFieldsEmail
        | PFSignUpFieldsAdditional
        | PFSignUpFieldsDismissButton;
        
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    
}

@end
