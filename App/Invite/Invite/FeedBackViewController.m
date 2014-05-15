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
int accpeted = 0;
int ignored = 0;
int pending = 0;


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
    //reset counters
    accpeted = 0;
    ignored = 0;
    pending = 0;
   
    self.feedbacks.backgroundColor = [UIColor clearColor];
    
    [self loadData];
    
}

-(void)loadData{
    
    
    NSString * currentUserEmailWithOnlyAlhpaCharaters = [[[PFUser currentUser] objectForKey:@"email"] stringByReplacingOccurrencesOfString:@"@"withString:@""];
    currentUserEmailWithOnlyAlhpaCharaters = [currentUserEmailWithOnlyAlhpaCharaters stringByReplacingOccurrencesOfString:@"."withString:@""];
    
    NSString *currentUserFeedBackTableName = [NSString stringWithFormat:@"%@_%@", currentUserEmailWithOnlyAlhpaCharaters, @"feed_back"];
    NSLog(@"currentUser FeedBack TableName: %@" , currentUserFeedBackTableName);
    
    NSLog(@"event id : %@",[self.event objectId]);
    
    PFQuery *query = [PFQuery queryWithClassName:currentUserFeedBackTableName];
    [query whereKey:@"eventID" equalTo:[self.event objectId]];
    
    // Run the query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.receiverName = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            self.receiverResponce = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            
            for(PFObject *obj in objects){
                [self.receiverName addObject:[obj objectForKey:@"receiverEmail"]];
                [self.receiverResponce addObject:[obj objectForKey:@"feedBack"]];
                
            }
            NSLog(@"receiver emails : %@",self.receiverName);
            NSLog(@"receiver status : %@",self.receiverResponce);
            self.feedbacks.reloadData;
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.receiverName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"feedBackCell";
    FeedBackTableViewCell *feedCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    feedCell.receiver.text = [self.receiverName objectAtIndex:indexPath.row];
    UIImage *imageIcon;
    if([[self.receiverResponce objectAtIndex:indexPath.row] isEqualToString: @"pending"]){
        imageIcon = [UIImage imageNamed:@"notSure.png"];
        pending++;
    }else if ([[self.receiverResponce objectAtIndex:indexPath.row] isEqualToString:@"accepted"]){
        imageIcon = [UIImage imageNamed:@"thumbsUp.png"];
        accpeted++;
    }else{
        imageIcon = [UIImage imageNamed:@"thumbsDown.png"];
        ignored++;
    }
    
    [feedCell.feebackStatusImageView setImage:imageIcon];
 
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        feedCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-background_640.png"]];
        
    } else {
        // code for 3.5-inch screen
        feedCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-background_320.png"]];
    }
    
    feedCell.contentView.backgroundColor = [UIColor clearColor];
    
    
    self.accepted.text = [NSString stringWithFormat:@"%d",accpeted];
    self.pending.text = [NSString stringWithFormat:@"%d",pending];
    self.ignored.text = [NSString stringWithFormat:@"%d",ignored];
    self.totalCount.text = [NSString stringWithFormat:@"%d",[self.receiverName count]];
    
    return feedCell;
}

@end
