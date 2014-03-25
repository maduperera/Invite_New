
#import "UIViewController+Utilities.h"
#import "InviteLoginViewController.h"
#import "InviteSignupViewController.h"

@implementation UIViewController (Utilities)

- (IBAction)signout:(id)sender {
    [PFUser logOut];
    [self showLoginView];
}


-(void)showLoginView{
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        InviteLoginViewController *logInViewController = [[InviteLoginViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        //set fields
        logInViewController.fields = PFLogInFieldsUsernameAndPassword
        | PFLogInFieldsLogInButton
        | PFLogInFieldsSignUpButton
        | PFLogInFieldsPasswordForgotten;
        
        
        // Create the sign up view controller
        InviteSignupViewController *signUpViewController = [[InviteSignupViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    
}

@end
