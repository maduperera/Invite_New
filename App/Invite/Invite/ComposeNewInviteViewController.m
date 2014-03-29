//
//  ComposeNewInviteViewController.m
//  Invite
//
//  Created by Madusha Perera on 3/28/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "ComposeNewInviteViewController.h"

@interface ComposeNewInviteViewController ()

@end

@implementation ComposeNewInviteViewController

NSString *currentUserEmail;
NSString *currentUserOutBoxTableName;
NSString *currentUserFeedBackTableName;
NSString *recieverInBoxTableName;
NSString *receiverEmailWithOnlyAlhpaCharaters;
UIDatePicker *datePicker = nil;

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
    
    //initiate datepicker
    datePicker = [[UIDatePicker alloc] init];
    NSLog(@"template obj desc : %@", [self.templateObj objectForKey:@"description"]);
    
    //set delegate to the mapview
    self.map.delegate = self;
    
    //initiate geopint
    self.geoPoint = [[PFGeoPoint alloc] init];
    
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"view did appear");
    //enable the send button which may have been disabled by sending invitation
    self.SendButton.enabled = YES;
}

- (IBAction)pickDate:(id)sender{
    if(self.event_date.inputView == nil){
        self.event_date.inputView = datePicker;
        datePicker.datePickerMode = UIDatePickerModeDate;
    }
    
	[datePicker addTarget:self
                   action:@selector(changeDateInTextField:)
         forControlEvents:UIControlEventValueChanged];
}

- (IBAction)addReciever:(id)sender {
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentModalViewController:picker animated:YES];
}


- (void)changeDateInTextField:(id)sender{
	//Use NSDateFormatter to write out the date in a friendly format
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	self.event_date.text = [NSString stringWithFormat:@"%@",
                  [df stringFromDate:datePicker.date]];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//make the keyboard disappear when return was pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    self.event_date.text = self.theData[row];
    [self.event_date resignFirstResponder];
}


- (IBAction)send:(id)sender {
 
    //disable the send button to stop duplicating sends
    self.SendButton.enabled = NO;
    
    //get the current user email address
    PFUser *currentUser = [PFUser currentUser];
    currentUserEmail = [[PFUser currentUser] objectForKey:@"email"];
    NSString *currentUserEmailWithOnlyAlhpaCharaters = [currentUserEmail stringByReplacingOccurrencesOfString:@"@"withString:@""];
    currentUserEmailWithOnlyAlhpaCharaters = [currentUserEmailWithOnlyAlhpaCharaters stringByReplacingOccurrencesOfString:@"."withString:@""];
    
    //get the current user outbox table name -> useremailwithout'@'and'.'_out_box
    currentUserOutBoxTableName = [NSString stringWithFormat:@"%@_%@", currentUserEmailWithOnlyAlhpaCharaters, @"out_box"];
    NSLog(@"outboxtable name: %@" , currentUserOutBoxTableName);
    
    //get current date - time
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    //write to the event object
    NSLog(@"TEMPLATEID : %@", [self.templateObj objectId]);
    PFObject *event = [PFObject objectWithClassName:@"Event"];
    [event setObject:[self.templateObj objectId] forKey:@"templateID"];
    [event setObject:self.event_address.text forKey:@"address"];
    [event setObject:self.event_contatctNo.text forKey:@"contactNo"];
    [event setObject:self.event_date.text forKey:@"eventDate"];
    [event setObject:self.event_end_time.text forKey:@"endTime"];
    [event setObject:self.event_start_time.text forKey:@"startTime"];
    [event setObject:self.event_title.text forKey:@"title"];
    [event setObject:currentUserEmail forKey:@"senderEmail"];
    [event setObject:self.geoPoint forKey:@"geoPoint"];
    
    //save to event table
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"data written to the Event successfully");
            NSLog(@"EVENTID : %@", [event objectId]);
            
            PFObject *outMsg = [PFObject objectWithClassName:currentUserOutBoxTableName];
            [outMsg setObject:[event objectId] forKey:@"eventID"];
            [outMsg setObject:dateString forKey:@"dateSent"];
            
            
            //save to user_out_box table
            [outMsg saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"data written to the outbox successfully");
                    
                    //get the current user user_feed_back table name -> useremailwithout'@'and'.'_feed_back
                    currentUserFeedBackTableName = [NSString stringWithFormat:@"%@_%@", currentUserEmailWithOnlyAlhpaCharaters, @"feed_back"];
                    NSLog(@"feed_back table name name: %@" , currentUserFeedBackTableName);
                    
                    //loop through array of recivers to popultae user_Feed_back table and the receiver_in_box tables
                    //populate usersWithEmail for testing
                    self.usersWithEmail = [NSArray arrayWithObjects:@"madupiz@gmail.com",@"dhammini.dev@gmail.com",nil];
                    for(NSString *email in (self.usersWithEmail)) {
                        
                        NSLog(@"receiver : %@",email);
                        
                        // write to the feed_back object
                        PFObject *feedback = [PFObject objectWithClassName:currentUserFeedBackTableName];
                        [feedback setObject:[event objectId] forKey:@"eventID"];
                        [feedback setObject:email forKey:@"receiverEmail"];
                        [feedback setObject:@"pending" forKey:@"feedBack"];
                        
                        //save to user_feed_back table
                        [feedback saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                NSLog(@"data written to the feed_back successfully");
                            }else{
                                NSLog(@"error in writing to the db");
                            }
                        }];
                        
                        //create receiver_in_box table name
                        receiverEmailWithOnlyAlhpaCharaters = [email stringByReplacingOccurrencesOfString:@"@"withString:@""];
                        receiverEmailWithOnlyAlhpaCharaters = [receiverEmailWithOnlyAlhpaCharaters stringByReplacingOccurrencesOfString:@"."withString:@""];
                        
                        //get the receiver inbox table name -> receiveremailwithout'@'and'.'_in_box
                        recieverInBoxTableName = [NSString stringWithFormat:@"%@_%@", receiverEmailWithOnlyAlhpaCharaters, @"in_box"];
                        NSLog(@"receiver inboxtable name: %@" , recieverInBoxTableName);
                        
                        //write to the receiverInBox object
                        PFObject *inMsg = [PFObject objectWithClassName:recieverInBoxTableName];
                        [inMsg setObject:[event objectId] forKey:@"eventID"];
                        [inMsg setObject:dateString forKey:@"dateSent"];
                        
                        
                        //save to receiver_in_box table
                        [inMsg saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                NSLog(@"data written to the inbox successfully");
                            }else{
                                NSLog(@"error in writing to the db");
                            }
                        }];
                        
                    }
                    
                }else{
                    NSLog(@"error in writing to the db");
                }
            }];
            
            
        }else{
            NSLog(@"error in writing to the db");
        }
    }];
    
}


- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    NSString* name = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    self.event_to.text = name;
    
    [self dismissModalViewControllerAnimated:YES];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

- (IBAction)cancel:(id)sender {
    
    self.event_address.text = @"";
    self.event_contatctNo.text = @"";
    self.event_date.text = @"";
    self.event_end_time.text = @"";
    self.event_start_time.text = @"";
    self.event_title.text = @"";
    self.event_to.text = @"";
    
}


@end
