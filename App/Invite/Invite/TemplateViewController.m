//
//  TemplateViewController.m
//  Invite
//
//  Created by Madusha Perera on 3/27/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "TemplateViewController.h"
#import "TemplateCell.h"
#import "ComposeNewInviteViewController.h"

@interface TemplateViewController ()

@end

@implementation TemplateViewController

PFObject *tmplObj = nil;


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
    [self queryForTemplates];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)queryForTemplates {
    NSLog(@"start query");
    //Create query for all Templates available
    PFQuery *query = [PFQuery queryWithClassName:@"Template"];
    //get templates that are not marked as isExpired = true in the MBAAS
    [query whereKey:@"isExpired" equalTo:[NSNumber numberWithBool:FALSE]];
    // Run the query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //Save results and update the collection view
            self.templates = objects;
            [self.collectionView reloadData];
           
        }
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _templates.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"templateCell";
    TemplateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
 
    //get data from quaried result set
    PFObject *template = [_templates objectAtIndex:indexPath.row];
    PFFile *imageFile = [template objectForKey:@"template_image"];
    NSString *template_desc = [template objectForKey:@"description"];
    
    // animate the loading spinner
    cell.loadingSpinner.hidden = NO;
    [cell.loadingSpinner startAnimating];
    
    // populate each cell image and label
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            cell.templateImage.image = [UIImage imageWithData:data];
            cell.templateLabel.text = template_desc;
            [cell.loadingSpinner stopAnimating];
            cell.loadingSpinner.hidden = YES;
        }
    }];

    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);
    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
    tmplObj = [_templates objectAtIndex:indexPath.row];
    if ([segue.identifier isEqualToString:@"templateObj"]) {
        ComposeNewInviteViewController *compose = segue.destinationViewController;
        compose.templateObj = tmplObj;
    }
}


// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
