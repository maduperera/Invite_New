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
NSString *recieverInBoxTableName;
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
 
    // Create a new Post object and create relationship with PFUser
    //    PFObject *newPost = [PFObject objectWithClassName:@"Post"];
    //    [newPost setObject:@"abcdefg" forKey:@"textContent"];
    //    [newPost setObject:[PFUser currentUser] forKey:@"author"]; // One-to-Many relationship created here!
    //
    //    // Set ACL permissions for added security
    //    PFACL *postACL = [PFACL ACLWithUser:[PFUser currentUser]];
    //    [postACL setPublicReadAccess:YES];
    //    [newPost setACL:postACL];
    //
    //    // Save new Post object in Parse
    //    [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    //        if (!error) {
    //            //            [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the viewController upon success
    //        }
    //    }];
    
    
    //get templates that are not marked as isExpired = true in the MBAAS
//    [queryForEmail whereKey:@"email" equalTo:[NSNumber numberWithBool:FALSE]];
//    // Run the query
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            //Save results and update the collection view
//            self.templates = objects;
//            [self.collectionView reloadData];
//            
//        }
//    }];
//    
//    PFObject *newPost = [PFObject objectWithClassName:@"Post"];

    
    //populate usersWithEmail for testiing
    self.usersWithEmail = [NSArray arrayWithObjects:@"madupiz@gmail.com",@"dhammini.dev@gmail.com",nil];
    
    //get the current user email address
    PFUser *currentUser = [PFUser currentUser];
    currentUserEmail = [[PFUser currentUser] objectForKey:@"email"];
    
    //get the current user outbox table name
    currentUserOutBoxTableName = [NSString stringWithFormat:@"%@_%@", [[PFUser currentUser] objectForKey:@"username"], @"out_box"];
    NSLog(@"outboxtable name: %@" , currentUserOutBoxTableName);
    
    //get current date - time
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    //write to the out box of sender
    //PFObject *outMsg = [PFObject objectWithClassName:currentUserOutBoxTableName];
    //PFObject *event = [self createEventObject];
    //[outMsg setObject:[event objectId] forKey:@"eventID"];
    //[outMsg setObject:dateString forKey:@"dateSent"];
    
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
    // [event setObject:Nil forKey:@"feedBack"];
    //    [event setObject:feedback forKey:@"feedBack"];
    
    //save data
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"data written to the Event successfully");
            NSLog(@"EVENTID : %@", [event objectId]);
            
            PFObject *outMsg = [PFObject objectWithClassName:currentUserOutBoxTableName];
            [outMsg setObject:[event objectId] forKey:@"eventID"];
            [outMsg setObject:dateString forKey:@"dateSent"];
            
            
            //save data
            [outMsg saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"data written to the outbox successfully");
                }else{
                    NSLog(@"error in writing to the db");
                }
            }];
            
            
        }else{
            NSLog(@"error in writing to the db");
        }
    }];
    
    
    
    
    
    //write to the in box of reciver

    
    
}

//-(PFObject*)createEventObject{

//    //create FeedbackTable object to include in the EventObject
//    PFObject *feedback = [PFObject objectWithClassName:@"FeedBack"];
//    //loop through array of recivers to popultae FeedBack table
//    for(NSString * email in self.usersWithEmail) {
//        NSLog(@"receiver : %@",email);
//        [feedback setObject:email forKey:@"receiverEmail"];
//        [feedback setObject:@"pending" forKey:@"feedBack"];
//    }
//
//    //save feedback data
//    [feedback saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            NSLog(@"data written to the FeedBack successfully");
//        }else{
//            NSLog(@"error in writing to the db");
//        }
//    }];
    
    
//    NSLog(@"TEMPLATEID : %@", [self.templateObj objectId]);
//    PFObject *event = [PFObject objectWithClassName:@"Event"];
//    [event setObject:[self.templateObj objectId] forKey:@"templateID"];
//    [event setObject:self.event_address.text forKey:@"address"];
//    [event setObject:self.event_contatctNo.text forKey:@"contactNo"];
//    [event setObject:self.event_date.text forKey:@"eventDate"];
//    [event setObject:self.event_end_time.text forKey:@"endTime"];
//    [event setObject:self.event_start_time.text forKey:@"startTime"];
//    [event setObject:self.event_title.text forKey:@"title"];
//    [event setObject:currentUserEmail forKey:@"senderEmail"];
//    [event setObject:self.geoPoint forKey:@"geoPoint"];
//   // [event setObject:Nil forKey:@"feedBack"];
////    [event setObject:feedback forKey:@"feedBack"];
//    
//    //save data
//    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            NSLog(@"data written to the Event successfully");
//            NSLog(@"EVENTID : %@", [event objectId]);
//        }else{
//            NSLog(@"error in writing to the db");
//        }
//    }];
    
    
    
    
//    return event;
//}


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
