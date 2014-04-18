//
//  QiuchangOrderEditCellViewController.m
//  2golf
//
//  Created by Lee Justin on 14-4-18.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangOrderEditCellViewController.h"

@interface QiuchangOrderEditCellViewController ()

@end

@implementation QiuchangOrderEditCellViewController

@synthesize cellBg;
@synthesize cellTitle;
@synthesize normalRightTitle;

//联系人
@synthesize contactRightTitle;
@synthesize contactArrow;
@synthesize contactBtn;

//人数
@synthesize numDecreaseBtn;
@synthesize numIncreaseBtn;
@synthesize numLabel;

//联系电话
@synthesize phoneTextField;

//确认按钮
@synthesize confirmBtn;

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

@end
