//
//  QiuchangCellViewController.m
//  2golf
//
//  Created by Lee Justin on 14-4-16.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangCellViewController.h"

@interface QiuchangCellViewController ()

@end

@implementation QiuchangCellViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setNoIcon
{
    CGRect rect;
    
    self.iconImageView.hidden = YES;
    
    rect = self.nameLabel.frame;
    rect.origin.x = 10;
    self.nameLabel.frame = rect;
    
    rect = self.distanceLabel.frame;
    rect.origin.x = 10;
    self.distanceLabel.frame = rect;
    
    rect = self.descriptionLabel.frame;
    rect.origin.x = 10;
    self.descriptionLabel.frame = rect;
}

@end
