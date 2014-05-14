//
//  InboxViewController.m
//  Invite
//
//  Created by Dhammini Fernando on 3/20/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "InboxViewController.h"
#import "UIViewController+Utilities.h"
#import "InBoxInvitationViewController.h"
#import "InboxCustomCell.h"
#import "StaticMapViewViewController.h"
#import "RNGridMenu.h"
#import "mapPopupViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "AppDelegate.h"


@interface InboxViewController ()

@property (nonatomic) NSInteger objectCount;
@property (nonatomic) NSInteger rowID;

@end

@implementation InboxViewController
@synthesize tableData;

NSString *currentUserEmail;
NSString *currentUserInBoxTableName;
NSString *currentUserEmailWithOnlyAlhpaCharaters;
PFQuery *queryEvent;
NSString *event_ID;
UIColor * labelColor;
UIFont * labelFont;

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
    NSLog(@"view did load");
    //set font fortext view in the cell
    labelFont = [UIFont fontWithName:@"Helvetica-Light" size:14];
    labelColor = [UIColor colorWithWhite:1 alpha:1];
    
    // populate the table
    [self getEvents];
    
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
            self.eventStatus = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            
            self.objectCount = [objects count];
            
            for(PFObject *obj in objects){
                [obj objectForKey:@"eventID"];
                queryEvent = [PFQuery queryWithClassName:@"Event"];
                [queryEvent whereKey:@"objectId" equalTo:[obj objectForKey:@"eventID"]];
                
                // Run the query
                [queryEvent findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        [self.events addObject:[objects objectAtIndex:0]];
                        NSLog(@"size events arr : %i", [self.events count]);
                        [tableData addObject:[[objects objectAtIndex:0] objectForKey:@"title"]];
                        [self.eventStatus addObject:[obj objectForKey:@"isPending"]];
                        [self.tableView reloadData];

                    }else{
                        //NSLog(@"error : %@" , error);
                    }
                }];
                
            }
            NSLog(@"size events arr : %i", [self.events count]);
//            [self.tableView reloadData];
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

    NSString *identifier = @"buttonCell";
    InboxCustomCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"buttonCell"];
    if (cell == nil) {
        cell = [[InboxCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
	   
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-background_640.png"]];
        
    } else {
        // code for 3.5-inch screen
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-background_320.png"]];
    }
    
    
    //display the event status : pending/accepted
    //events that are pending
    if([self.eventStatus objectAtIndex:indexPath.row] == [NSNumber numberWithBool:TRUE]){
        cell.eventStatusColor.image = [UIImage imageNamed:@"icon_notification_red.png"];
        cell.eventStatus.text = @"your decision is pending";
    }else{
        // events that are accepted
        cell.eventStatusColor.image = [UIImage imageNamed:@"icon_notification_blue.png"];
        cell.eventStatus.text = @"your are going";
    }

    
    
    //strike the event name with red color line if the event is canceled
    PFObject *event = [self.events objectAtIndex:indexPath.row];
    cell.eventTitleText.text = nil;
    cell.eventTitleText.attributedText = nil;
   
    
    if([event objectForKey:@"isCancelled"]==[NSNumber numberWithBool:FALSE]){
        
        cell.eventTitleText.attributedText = [[NSAttributedString alloc] initWithString:[tableData objectAtIndex:indexPath.row]attributes:@{NSFontAttributeName : labelFont,NSForegroundColorAttributeName : labelColor}];
        
    }else{
        cell.eventTitleText.attributedText = [[NSAttributedString alloc] initWithString:[tableData objectAtIndex:indexPath.row] attributes:@{ NSFontAttributeName : labelFont,NSForegroundColorAttributeName : labelColor, NSStrikethroughStyleAttributeName : @1, NSStrikethroughColorAttributeName : [UIColor redColor]}];
    }
    
    cell.btnContact.tag = [indexPath indexAtPosition:[indexPath length] - 1];
    NSLog(@"contact tag : %d", cell.btnContact.tag);
    [cell.btnContact addTarget:self action:@selector(setSelectedRow:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnMap.tag = [indexPath indexAtPosition:[indexPath length]-1];
    NSLog(@"map tag : %d", cell.btnMap.tag);
    [cell.btnMap addTarget:self action:@selector(showMap:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row >= self.objectCount -1){
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // helps w/ our colors when blurring
        // feel free to adjust jpeg quality (lower = higher perf)
        NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
        image = [UIImage imageWithData:imageData];
        
        
        
        //Get a screen capture from the current view.
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        AppDelegate *sharedObject = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [sharedObject setCurrentScreen:image];
    }
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
        InBoxInvitationViewController *invitation = segue.destinationViewController;
        invitation.event = [self.events objectAtIndex:indexPath.row];
        invitation.inBoxTableName = currentUserInBoxTableName;
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
    mapPopupViewController *mapController = [[mapPopupViewController alloc]initWithNibName:@"mapPopupViewController" bundle:nil];
    
//    NSIndexPath *indexPath = [[self.tableView indexPathsForSelectedRows]objectAtIndex:0];
//    mapController.event = [self.events objectAtIndex:indexPath.row];
    UIButton *clicked = (UIButton *) sender;
    mapController.event = [self.events objectAtIndex:clicked.tag];
    NSLog(@"selected row id: %d", clicked.tag);
    NSLog(@"event name when map popped : %@", [mapController.event objectForKey:@"title"]);
    // mapController.view.frame =CGRectMake(50, 50, 100, 100);
    
    [self presentPopupViewController:mapController animationType:MJPopupViewAnimationSlideTopBottom];
   
}



#pragma - mark Contact Invitation Sender

-(void) setSelectedRow: (id) sender{
    UIButton *clicked = (UIButton *) sender;
    self.rowID = clicked.tag;
    NSLog(@"rowid : %d", self.rowID);
}

- (IBAction)contactInvitationSender:(id)sender {
    [self showGrid];
}

- (IBAction)reload:(id)sender {
    // populate the table
    [self getEvents];
}

#pragma mark - RNGridMenuDelegate

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    PFObject *currentObject = [self.events objectAtIndex:self.rowID];
    NSLog(@"rowid : %d", self.rowID);
    if ([item.title  isEqualToString: @"Call"]) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:[NSString stringWithFormat:@"%@: %@", @"Contact", [currentObject objectForKey:@"contactNo"]]];
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    } else if([item.title isEqualToString:@"Email"]){
        [self sendEmail:currentObject];
    } else if ([item.title isEqualToString:@"Message"]){
        [self sendMessage: currentObject];
    }
}

#pragma mark - Message UI Delegates and Methods

-(void) sendEmail: (PFObject *) currentEvent {
    
    //Get info - event object
    
    NSString *sender = [currentEvent objectForKey:@"senderEmail"];
    
    NSString *emailTitle = [NSString stringWithFormat:@"RE: %@", [currentEvent objectForKey:@"title"]];
    NSString *messageBody = nil;

    NSArray *toRecipents = [NSArray arrayWithObject:sender];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    mc.view.frame = CGRectMake(0, 0, 310, 530);
    [self presentPopupViewController:mc animationType:MJPopupViewAnimationSlideTopBottom];
}

-(void) sendMessage: (PFObject *) currentEvent {

    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"SMS message here";
        controller.recipients = [NSArray arrayWithObjects:[currentEvent objectForKey:@"contactNo"], nil];
        controller.messageComposeDelegate = self;
        [self presentPopupViewController:controller animationType:MJPopupViewAnimationSlideTopBottom];
    }

}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private RNGridMenuDelegate

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
