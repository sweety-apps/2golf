//
//  MyOrderListTopSwitchViewController.m
//  2golf
//
//  Created by Lee Justin on 14-6-9.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "MyOrderListTopSwitchViewController.h"

@interface MyOrderListTopSwitchViewController ()

@property (nonatomic,retain) UIColor* oldColor;

@end

@implementation MyOrderListTopSwitchViewController

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
    self.oldColor = [self.buttonCourse backgroundColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) selectButtonCourse
{
    self.buttonCourse.backgroundColor = self.oldColor;
    self.buttonTaocan.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (void) selectButtonTaocan
{
    self.buttonCourse.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.buttonTaocan.backgroundColor = self.oldColor;
}

@end
