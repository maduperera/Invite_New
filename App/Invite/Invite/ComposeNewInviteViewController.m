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
    
    //set delegeate to the mapview
    self.map.delegate = self;
    
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
