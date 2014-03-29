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

@interface InboxViewController ()

@end

@implementation InboxViewController
@synthesize tableData;

NSString *currentUserEmail;
NSString *currentUserInBoxTableName;
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

    //get inbox events from backend MBAAS
    [self getEvents];
    [self.tableView reloadData];

//    //[self.tableView registerNib:[UINib nibWithNibName:@"TableCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"TableCell"
//                                               bundle:[NSBundle mainBundle]]
//    forCellReuseIdentifier:@"Cell"];
}

-(void)viewDidAppear:(BOOL)animated{
    //[self.tableView reloadData];
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
                            [tableData addObject:[[objects objectAtIndex:0] objectForKey:@"title"]];
                            [self.tableView reloadData];
                        }
                    }];

    }
//    [self.tableView reloadData];

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
//    static NSString *CellIdentifier = @"Cell";
//    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (!cell) {
//        cell = [[TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    [cell.name setText: [tableData objectAtIndex:indexPath.row]];
    
//    return cell;
    
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"buttonCell"];
	cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
	   
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
        [queryForObjId whereKey:@"eventID" equalTo:[self.eventIDs objectAtIndex:indexPath.row]];
        
        // Run the query
        [queryForObjId findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"...");
                [objects count];
                NSLog(@"isdeleted set to : %@", [self.eventIDs objectAtIndex:indexPath.row]);
                NSLog(@"objectid : %@",[[objects objectAtIndex:0] objectId]);
                
                //update the user_in_box tables' row for the above event -> isdeleted = yes
                PFQuery *query = [PFQuery queryWithClassName:currentUserInBoxTableName];
                
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
    NSString *event_ID = [self.eventIDs objectAtIndex:indexPath.row];
    
    //getObjectID of the inMsg object(row) in currentUserInBoxTable to be deleted
    PFQuery *queryForEvent = [PFQuery queryWithClassName:@"Event"];
    [queryForEvent whereKey:@"objectId" equalTo:event_ID];
    
    // Run the query
    [queryForEvent findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([segue.identifier isEqualToString:@"invitation"]) {
                InvitationViewController *invitation = segue.destinationViewController;
                invitation.event = [objects objectAtIndex:0];
            }
        }else{}
    }];
    
    
}

@end
