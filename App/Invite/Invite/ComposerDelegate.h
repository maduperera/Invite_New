//
//  ComposerDelegate.h
//  Invite
//
//  Created by Madusha Perera on 3/31/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ComposerDelegate <NSObject>
-(void)setEventLocationOnStaticMapAt:(CLLocationCoordinate2D) eventLocation;
@end
