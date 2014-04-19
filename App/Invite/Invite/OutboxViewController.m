//
//  OutboxViewController.m
//  Invite
//
//  Created by Dhammini Fernando on 3/20/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "OutboxViewController.h"
#import "OutBoxCustomCell.h"
#import "OutBoxInvitationViewController.h"


@interface OutboxViewController ()

@end

@implementation OutboxViewController

NSString *currentUserEmail;
NSString *currentUserOutBoxTableName;
NSString *currentUserEmailWithOnlyAlhpaCharaters;
PFQuery *queryEvent;


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
    NSLog(@"view did load");
}



-(void)viewWillAppear:(BOOL)animated{
    [self getEvents];
//    [self.events removeAllObjects];
//    [self.eventIDs removeAllObjects];
//    [self.tableData removeAllObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getEvents{
    
    // get the email of cuurent user
    currentUserEmail = [[PFUser currentUser] objectForKey:@"email"];
    
    //create receiver_out_box table name
    currentUserEmailWithOnlyAlhpaCharaters = [currentUserEmail stringByReplacingOccurrencesOfString:@"@"withString:@""];
    currentUserEmailWithOnlyAlhpaCharaters = [currentUserEmailWithOnlyAlhpaCharaters stringByReplacingOccurrencesOfString:@"."withString:@""];
    
    //get the receiver inbox table name -> receiveremailwithout'@'and'.'_in_box
    currentUserOutBoxTableName = [NSString stringWithFormat:@"%@_%@", currentUserEmailWithOnlyAlhpaCharaters, @"out_box"];
    NSLog(@"current user outbox table name: %@" , currentUserOutBoxTableName);
    
    //get current user outbox mesages that are not deleted
    PFQuery *query = [PFQuery queryWithClassName:currentUserOutBoxTableName];
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
                NSLog(@"eventID: %@", [obj objectForKey:@"eventID"]);
                
                queryEvent = [PFQuery queryWithClassName:@"Event"];
                [queryEvent whereKey:@"objectId" equalTo:[obj objectForKey:@"eventID"]];
                
                // Run the query
                [queryEvent findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        NSLog(@"TITLE: %@", [[objects objectAtIndex:0] objectForKey:@"title"]);
                        [self.events addObject:[objects objectAtIndex:0]];
                        [self.tableData addObject:[[objects objectAtIndex:0] objectForKey:@"title"]];
                        [self.tableView reloadData];
                    }
                }];
                
            }
            //[self.tableView reloadData];
            
        }
    }];
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
    return [_tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OutBoxCustomCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"outBoxCell"];
    //change the label of the cell to be restrict to 130 pixels. so that label content will not surpass the buttons inside the cell
    
    PFObject *event = [self.events objectAtIndex:indexPath.row];
    if([event objectForKey:@"isCancelled"]==[NSNumber numberWithBool:FALSE]){
    
        cell.outBoxEventLabel.text = [self.tableData objectAtIndex:indexPath.row];
 
    }else{
      cell.outBoxEventLabel.attributedText = [[NSAttributedString alloc] initWithString:[self.tableData objectAtIndex:indexPath.row] attributes:@{ NSStrikethroughStyleAttributeName : @1, NSStrikethroughColorAttributeName : [UIColor redColor]}];
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
        
        //getObjectID of the inMsg object(row) in currentUserOutnBoxTable to be deleted
        PFQuery *queryForObjId = [PFQuery queryWithClassName:currentUserOutBoxTableName];
        [queryForObjId whereKey:@"eventID" equalTo:[[self.events objectAtIndex:indexPath.row]objectId]];
        
        // Run the query
        [queryForObjId findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"...");
                [objects count];
                
                //update the user_in_box tables' row for the above event -> isdeleted = yes
                PFQuery *query = [PFQuery queryWithClassName:currentUserOutBoxTableName];
                
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
    if ([segue.identifier isEqualToString:@"invitationfromOutBox"]) {
        OutBoxInvitationViewController *invitation = segue.destinationViewController;
        invitation.event = [self.events objectAtIndex:indexPath.row];
        invitation.event = [self.events objectAtIndex:indexPath.row];
        [invitation viewDidLoad];
    }
    
}

@end
