//
//  TemplateViewController.m
//  Invite
//
//  Created by Madusha Perera on 3/27/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "TemplateViewController.h"
#import "TemplateCell.h"

@interface TemplateViewController ()

@end

@implementation TemplateViewController

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
    //[self.collectionView registerClass:[TemplateCell class] forCellWithReuseIdentifier:@"templateCell"];
    _templates = [NSArray arrayWithObjects:@"invite.png", @"invite.png", @"invite.png", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _templates.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *identifier = @"templateCell";
//    
//     TemplateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    

    static NSString *CellIdentifier = @"templateCell";
    TemplateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    

    cell.templateImage.image = [UIImage imageNamed:[_templates objectAtIndex:indexPath.row]];
    cell.templateLabel.text = [_templates objectAtIndex:indexPath.row];
    
    
    return cell;
}

@end
