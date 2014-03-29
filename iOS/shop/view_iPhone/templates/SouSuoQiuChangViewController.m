//
//  SouSuoQiuChangViewController.m
//  2golf
//
//  Created by Lee Justin on 14-3-29.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "SouSuoQiuChangViewController.h"
#import "TimeSquareBoard_iPhone.h"

@interface SouSuoQiuChangViewController ()

@end

@implementation SouSuoQiuChangViewController

@synthesize uiStack = _uiStack;

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

- (void)dealloc
{
    self.uiStack = nil;
    [super dealloc];
}

- (IBAction)onPressedLocal:(id)sender
{
    
}

- (IBAction)onPressedDate:(id)sender
{
    [self.uiStack pushBoard:[TimeSquareBoard_iPhone board] animated:YES];
}

- (IBAction)onPressedTime:(id)sender
{
    
}

- (IBAction)onPressedSearch:(id)sender
{
    
}

@end
