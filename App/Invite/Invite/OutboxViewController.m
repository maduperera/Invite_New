//
//  OutboxViewController.m
//  Invite
//
//  Created by Dhammini Fernando on 3/20/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "OutboxViewController.h"
#import "OutBoxCustomCell.h"
#import "InvitationViewController.h"


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
  
//    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"view did appear");
    [self getEvents];
    //[self getEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}
//
//// Sent to the delegate when a PFUser is logged in.
//- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}


-(void)getEvents{
    
    // get the email of cuurent user
    currentUserEmail = [[PFUser currentUser] objectForKey:@"email"];
    
    //create receiver_out_box table name
    currentUserEmailWithOnlyAlhpaCharaters = [currentUserEmail stringByReplacingOccurrencesOfString:@"@"withString:@""];
    currentUserEmailWithOnlyAlhpaCharaters = [currentUserEmailWithOnlyAlhpaCharaters stringByReplacingOccurrencesOfString:@"."withString:@""];
    
    //get the receiver outbox table name -> receiveremailwithout'@'and'.'_in_box
    currentUserOutBoxTableName = [NSString stringWithFormat:@"%@_%@", currentUserEmailWithOnlyAlhpaCharaters, @"out_box"];
    NSLog(@"current user outbox table name: %@" , currentUserOutBoxTableName);
    
    
    //get current user outbox mesages that are not deleted
    PFQuery *query = [PFQuery queryWithClassName:currentUserOutBoxTableName];
    [query whereKey:@"isDeleted" equalTo:[NSNumber numberWithBool:FALSE]];
    
    // Run the query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //get event ids from each object of inbox table
            self.eventIDs = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            self.events = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            self.tableData = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            
            for(PFObject *obj in objects){
                [obj objectForKey:@"eventID"];
                NSLog(@"eventID: %@", [obj objectForKey:@"eventID"]);
                [self.eventIDs addObject:[obj objectForKey:@"eventID"]];
            }
            [self extractEvents];
            
        }
    }];
    
    
}

-(void)extractEvents{
    
    for(NSString *obj in self.eventIDs){
        queryEvent = [PFQuery queryWithClassName:@"Event"];
        [queryEvent whereKey:@"objectId" equalTo:obj];
        
        // Run the query
        [queryEvent findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"TITLE: %@", [[objects objectAtIndex:0] objectForKey:@"title"]);
                [self.events addObject:[objects objectAtIndex:0]];
                [_tableData addObject:[[objects objectAtIndex:0] objectForKey:@"title"]];
                [self.tableView reloadData];
            }
        }];
        
    }
    //    [self.tableView reloadData];
    
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

    cell.outBoxEventLabel.text = [self.tableData objectAtIndex:indexPath.row];
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
        
        //getObjectID of the outMsg object(row) in currentUseroutBoxTable to be deleted
        PFQuery *queryForObjId = [PFQuery queryWithClassName:currentUserOutBoxTableName];
        [queryForObjId whereKey:@"eventID" equalTo:[self.eventIDs objectAtIndex:indexPath.row]];
        
        // Run the query
        [queryForObjId findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"...");
                [objects count];
                NSLog(@"isdeleted set to : %@", [self.eventIDs objectAtIndex:indexPath.row]);
                NSLog(@"objectid : %@",[[objects objectAtIndex:0] objectId]);
                
                //update the user_out_box tables' row for the above event -> isdeleted = yes
                PFQuery *query = [PFQuery queryWithClassName:currentUserOutBoxTableName];
                
                // Retrieve the object by id
                [query getObjectInBackgroundWithId:[[objects objectAtIndex:0] objectId] block:^(PFObject *inMsg, NSError *error) {
                    inMsg[@"isDeleted"] = [NSNumber numberWithBool:TRUE];
                    [inMsg saveInBackground];
                    NSLog(@"isdeleted set to : %@", [self.eventIDs objectAtIndex:indexPath.row]);
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
    NSString *event_ID = [[self.events objectAtIndex:indexPath.row] objectId];
    
    // get the selected event object from Event table
    PFQuery *queryForEvent = [PFQuery queryWithClassName:@"Event"];
    [queryForEvent getObjectInBackgroundWithId:event_ID block:^(PFObject *event, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        if ([segue.identifier isEqualToString:@"invitationfromOutBox"]) {
            InvitationViewController *invitation = segue.destinationViewController;
            invitation.event = event;
            [invitation viewDidLoad];
        }
        
    }];
}

@end
