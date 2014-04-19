//
//  InboxViewController.m
//  Invite
//
//  Created by Dhammini Fernando on 3/20/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "InboxViewController.h"
#import "TableCell.h"
#import "UIViewController+Utilities.h"
#import "InvitationViewController.h"
#import "InboxCustomCell.h"
#import "StaticMapViewViewController.h"
#import "RNGridMenu.h"
#import "SpringTransitioningDelegate.h"
#import "MapPreviewController.h"


@interface InboxViewController ()

@property (nonatomic, strong) SpringTransitioningDelegate *transitioningDelegate;

@end

@implementation InboxViewController
@synthesize tableData;

NSString *currentUserEmail;
NSString *currentUserInBoxTableName;
NSString *currentUserEmailWithOnlyAlhpaCharaters;
PFQuery *queryEvent;
NSString *event_ID;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"5S-background_1136*640_4.png"]]];
       
    } else {
        // code for 3.5-inch screen
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
            //Retina Display
            [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"4-background_960*640_4.png"]]];
        } else {
            //Non - Retina Display
            [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"4-background_480*320_4.png"]]];
        }
    }

}


-(void)viewWillAppear:(BOOL)animated{
//    [self.events removeAllObjects];
//    [self.eventIDs removeAllObjects];
//    [self.tableData removeAllObjects];
    [self getEvents];
    NSLog(@"view will appear");
}

-(void)getEvents{
    
   // get the email of cuurent user
   currentUserEmail = [[PFUser currentUser] objectForKey:@"email"];
    
    //create receiver_in_box table name
    currentUserEmailWithOnlyAlhpaCharaters = [currentUserEmail stringByReplacingOccurrencesOfString:@"@"withString:@""];
    currentUserEmailWithOnlyAlhpaCharaters = [currentUserEmailWithOnlyAlhpaCharaters stringByReplacingOccurrencesOfString:@"."withString:@""];
    
    //get the receiver inbox table name -> receiveremailwithout'@'and'.'_in_box
    currentUserInBoxTableName = [NSString stringWithFormat:@"%@_%@", currentUserEmailWithOnlyAlhpaCharaters, @"in_box"];
    NSLog(@"current user inbox table name: %@" , currentUserInBoxTableName);
    
    
    //get current user inbox mesages that are not deleted
    PFQuery *query = [PFQuery queryWithClassName:currentUserInBoxTableName];
    [query whereKey:@"isDeleted" equalTo:[NSNumber numberWithBool:FALSE]];
    
    // Run the query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //get event ids from each object of inbox table
            //self.eventIDs = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            self.events = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            self.tableData = [[NSMutableArray alloc] initWithCapacity:[objects count]];

            for(PFObject *obj in objects){
                [obj objectForKey:@"eventID"];
                queryEvent = [PFQuery queryWithClassName:@"Event"];
                [queryEvent whereKey:@"objectId" equalTo:[obj objectForKey:@"eventID"]];
                
                // Run the query
                [queryEvent findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        [self.events addObject:[objects objectAtIndex:0]];
                        [tableData addObject:[[objects objectAtIndex:0] objectForKey:@"title"]];
                        [self.tableView reloadData];
                    }
                }];
            }
            NSLog(@"size events arr : %i", [self.events count]);
            //[self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    InboxCustomCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"buttonCell"];
    //change the label of the cell to be restrict to 130 pixels. so that label content will not surpass the buttons inside the cell
	   
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-background_640.png"]];
        
    } else {
        // code for 3.5-inch screen
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-background_320.png"]];
    }
    
    PFObject *event = [self.events objectAtIndex:indexPath.row];
    NSLog(@"title: %@",[tableData objectAtIndex:indexPath.row]);
    NSLog(@"bool: %@",[event objectForKey:@"isCancelled"]);
    
    if([event objectForKey:@"isCancelled"]==[NSNumber numberWithBool:FALSE]){
        cell.eventTitleText.text = [tableData objectAtIndex:indexPath.row];
        NSLog(@"is not cancelled");
        
        
    }else{
        cell.eventTitleText.attributedText = [[NSMutableAttributedString alloc] initWithString:[tableData objectAtIndex:indexPath.row] attributes:@{ NSStrikethroughStyleAttributeName : @1, NSStrikethroughColorAttributeName : [UIColor redColor]}];
    }
    
    return cell;
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self.tableData removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
        
        //getObjectID of the inMsg object(row) in currentUserInBoxTable to be deleted
        PFQuery *queryForObjId = [PFQuery queryWithClassName:currentUserInBoxTableName];
        [queryForObjId whereKey:@"eventID" equalTo:[[self.events objectAtIndex:indexPath.row]objectId]];
        
        // Run the query
        [queryForObjId findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"...");
                [objects count];
              
                //update the user_in_box tables' row for the above event -> isdeleted = yes
                PFQuery *query = [PFQuery queryWithClassName:currentUserInBoxTableName];
                
                // Retrieve the object by id
                [query getObjectInBackgroundWithId:[[objects objectAtIndex:0] objectId] block:^(PFObject *inMsg, NSError *error) {
                    inMsg[@"isDeleted"] = [NSNumber numberWithBool:TRUE];
                    [inMsg saveInBackground];
                    //NSLog(@"isdeleted set to : %@", [self.eventIDs objectAtIndex:indexPath.row]);
                }];
                
            }
        }];
        
    }
    
    [self.tableView reloadData];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);
    NSIndexPath *indexPath = [[self.tableView indexPathsForSelectedRows]objectAtIndex:0];
    if ([segue.identifier isEqualToString:@"invitation"]) {
        InvitationViewController *invitation = segue.destinationViewController;
        invitation.event = [self.events objectAtIndex:indexPath.row];
        [invitation viewDidLoad];
    }
    
}

- (IBAction)mailToInvitor:(id)sender {
}

- (IBAction)callInvitor:(id)sender {
    NSLog(@"call");
    NSIndexPath *indexPath = [[self.tableView indexPathsForSelectedRows]objectAtIndex:0];
    event_ID = [[self.events objectAtIndex:indexPath.row] objectId];
    

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://2135554321"]];
}

- (IBAction)shop:(id)sender {
}

- (IBAction)showQR:(id)sender {
}
- (IBAction)showMap:(id)sender {
  //  StaticMapViewViewController *mapController = [self.storyboard instantiateViewControllerWithIdentifier:@"StaticMap"];
    
    StaticMapViewViewController *mapController = [StaticMapViewViewController new];
    NSIndexPath *indexPath = [[self.tableView indexPathsForSelectedRows]objectAtIndex:0];
    mapController.event = [self.events objectAtIndex:indexPath.row];
   // mapController.view.frame =CGRectMake(50, 50, 100, 100);
    
    self.transitioningDelegate = [[SpringTransitioningDelegate alloc] initWithDelegate:self];
    self.transitioningDelegate.transitioningDirection = TransitioningDirectionUp;
    [self.transitioningDelegate presentViewController:mapController];
    
   
   // [self presentPopupViewController:mapController animationType:MJPopupViewAnimationFade];
  //   [self.view addSubview:mapController.view];
    //[self.navigationController pushViewController:mapController animated:YES];
    
   
}



#pragma - mark Contact Invitation Sender

- (IBAction)contactInvitationSender:(id)sender {
    [self showGrid];
}

#pragma mark - RNGridMenuDelegate

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    NSLog(@"Dismissed with item %d: %@", itemIndex, item.title);
}

#pragma mark - Private

- (void)showImagesOnly {
    NSInteger numberOfOptions = 3;
    NSArray *images = @[
                        [UIImage imageNamed:@"icon_call_white"],
                        [UIImage imageNamed:@"icon_message_white"],
                        [UIImage imageNamed:@"icon_email_white"]
                        ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithImages:[images subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)showList {
    NSInteger numberOfOptions = 3;
    NSArray *options = @[
                         @"Call",
                         @"Message",
                         @"Email"
                         ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithTitles:[options subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.itemTextAlignment = NSTextAlignmentLeft;
    av.itemFont = [UIFont boldSystemFontOfSize:18];
    av.itemSize = CGSizeMake(150, 55);
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)showGrid {
    NSInteger numberOfOptions = 3;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_call_white"] title:@"Call"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_message_white"] title:@"Message"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_email_white"] title:@"Email"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)showGridWithHeaderFromPoint:(CGPoint)point {
    NSInteger numberOfOptions = 3;
    NSArray *items = @[
                       [RNGridMenuItem emptyItem],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_call_white"] title:@"Call"],
                       [RNGridMenuItem emptyItem],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_message_white"] title:@"Message"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_email_white"] title:@"Email"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.bounces = NO;
    av.animationDuration = 4.0;
    //av.blurExclusionPath = [UIBezierPath bezierPathWithOvalInRect:self.imageView.frame];
    av.backgroundPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.f, 0.f, av.itemSize.width*3, av.itemSize.height*3)];
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    header.text = @"Example Header";
    header.font = [UIFont boldSystemFontOfSize:18];
    header.backgroundColor = [UIColor clearColor];
    header.textColor = [UIColor whiteColor];
    header.textAlignment = NSTextAlignmentCenter;
    // av.headerView = header;
    
    [av showInViewController:self center:point];
}

- (void)showGridWithPath {
    NSInteger numberOfOptions = 3;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_call_white"] title:@"Call"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_massege_white"] title:@"Message"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_email_white"] title:@"Email"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

@end
