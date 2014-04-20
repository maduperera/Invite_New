//
//  FeedBackViewController.h
//  Invite
//
//  Created by Madusha Perera on 4/17/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(weak,nonatomic)NSString *eventID;
@property(nonatomic, strong) NSMutableArray *receiverName;
@property(nonatomic, strong) NSMutableArray *receiverResponce;
@end
