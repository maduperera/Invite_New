//
//  FeedBackViewController.m
//  Invite
//
//  Created by Madusha Perera on 4/17/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "FeedBackViewController.h"
#import "FeedBackTableViewCell.h"


@interface FeedBackViewController ()

@end

@implementation FeedBackViewController

NSArray *tableData;


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
//    tableData = [NSArray arrayWithObjects:@"John", @"Matt", nil];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{

    
    //construct the currentuser feedback table name -> currentuseremailwithout'@'and'.'_in_box
    
    //current user email address
    NSString * currentUserEmailWithOnlyAlhpaCharaters = [[[PFUser currentUser] objectForKey:@"email"] stringByReplacingOccurrencesOfString:@"@"withString:@""];
    currentUserEmailWithOnlyAlhpaCharaters = [currentUserEmailWithOnlyAlhpaCharaters stringByReplacingOccurrencesOfString:@"."withString:@""];
    
    NSString *currentUserFeedBackTableName = [NSString stringWithFormat:@"%@_%@", currentUserEmailWithOnlyAlhpaCharaters, @"feed_back"];
    NSLog(@"currentUser FeedBack TableName: %@" , currentUserFeedBackTableName);
    
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:currentUserFeedBackTableName];
    [query whereKey:@"eventID" equalTo:self.eventID];
    
    // Run the query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.receiverName = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            self.receiverResponce = [[NSMutableArray alloc] initWithCapacity:[objects count]];
          
            
            for(PFObject *obj in objects){
                [self.receiverName addObject:[obj objectForKey:@"receiverEmail"]];
                [self.receiverResponce addObject:[obj objectForKey:@"feedBack"]];
                
            }
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
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"feedBackCell";
    FeedBackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[FeedBackTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.receiverName objectAtIndex:indexPath.row];
    
    if([[self.receiverResponce objectAtIndex:indexPath.row] isEqualToString: @"pending"]){
        cell.feebackStatusImageView.image = [UIImage imageNamed:@"notSure.png"];
    }else if ([[self.receiverResponce objectAtIndex:indexPath.row] isEqualToString:@"accepted"]){
        cell.feebackStatusImageView.image = [UIImage imageNamed:@"thumbsUp.png"];
    }else{
        cell.feebackStatusImageView.image = [UIImage imageNamed:@"thumbsDown.png"];
    }
    
    //cell.feebackStatusImageView.image = [UIImage imageNamed:@"notSure.png"];
    
    
    return cell;
}

@end
