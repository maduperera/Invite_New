//
//  TemplateViewController.h
//  Invite
//
//  Created by Madusha Perera on 3/27/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteLoginViewController.h"
#import "InviteSignupViewController.h"

@interface TemplateViewController : UICollectionViewController<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property(nonatomic,strong)NSArray *templates;
@end
