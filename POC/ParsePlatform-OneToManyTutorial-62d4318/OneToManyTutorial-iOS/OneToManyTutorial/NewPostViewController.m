//

#import "NewPostViewController.h"
#import "Parse/Parse.h"

@implementation NewPostViewController

@synthesize textView;

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    [self setTitle:@"Add new post"];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 310, 186)];
    [textView setFont:[UIFont systemFontOfSize:16]];
    [textView becomeFirstResponder];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addButtonTouchHandler:)]];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTouchHandler:)]];
    
    [self.view addSubview:textView];
}


#pragma mark - Button handlers

- (void)addButtonTouchHandler:(id)sender 
{
    // Create a new Post object and create relationship with PFUser
    PFObject *newPost = [PFObject objectWithClassName:@"Post"];
    [newPost setObject:[textView text] forKey:@"textContent"];
    [newPost setObject:[PFUser currentUser] forKey:@"author"]; // One-to-Many relationship created here!
    
    // Set ACL permissions for added security
    PFACL *postACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [postACL setPublicReadAccess:YES];
    [newPost setACL:postACL];
    
    // Save new Post object in Parse
    [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the viewController upon success
        }
    }];
}

- (void)cancelButtonTouchHandler:(id)sender 
{
    [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the viewController upon cancel
}

@end
