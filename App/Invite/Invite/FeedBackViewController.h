//
//  FeedBackViewController.h
//  Invite
//
//  Created by Madusha Perera on 4/17/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(weak,nonatomic)PFObject *event;
@property(nonatomic, strong) NSMutableArray *receiverName;
@property (weak, nonatomic) IBOutlet UITableView *feedbacks;
@property(nonatomic, strong) NSMutableArray *receiverResponce;
@property (weak, nonatomic) IBOutlet UILabel *accepted;

@property (weak, nonatomic) IBOutlet UILabel *totalCount;
@property (weak, nonatomic) IBOutlet UILabel *ignored;
@property (weak, nonatomic) IBOutlet UILabel *pending;



@end
