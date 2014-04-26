//
//  QiuchangOrderCellViewController.m
//  2golf
//
//  Created by Lee Justin on 14-4-18.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangOrderCellViewController.h"
#import "QuichangDetailBoard_iPhone.h"


#pragma mark -

@interface QiuchangOrderCell_iPhone ()

@end

#pragma mark -

@implementation QiuchangOrderCell_iPhone

- (void)load
{
    [super load];
    
    self.ctrl = [[QiuchangOrderCellViewController alloc] initWithNibName:@"QiuchangOrderCellViewController" bundle:nil];
    self.frame = self.ctrl.view.frame;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.ctrl.view];
    
    [self.ctrl.btn1 addTarget:self action:@selector(pressedPay:) forControlEvents:UIControlEventTouchUpInside];
    [self.ctrl.btn2 addTarget:self action:@selector(pressedQuichang:) forControlEvents:UIControlEventTouchUpInside];
    [self.ctrl.btn3 addTarget:self action:@selector(pressedShare:) forControlEvents:UIControlEventTouchUpInside];
    [self.ctrl.btn4 addTarget:self action:@selector(pressedCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    //self.ctrl.phoneTextField.delegate = self;
}

- (void)unload
{
    self.ctrl = nil;
    
	[super unload];
}

- (void)layoutDidFinish
{
    
}

- (void)dataDidChanged
{
    if (self.data)
    {
        NSDictionary* dict = self.data;
    }
}

#pragma mark -

- (void)pressedPay:(UIButton*)btn
{
    
}

- (void)pressedQuichang:(UIButton*)btn
{
    QuichangDetailBoard_iPhone* board = [QuichangDetailBoard_iPhone boardWithNibName:@"QuichangDetailBoard_iPhone"];
    UIView* view = self;
    BeeUIStack* stack = nil;
    while (view != nil)
    {
        if (view.board.stack != nil)
        {
            stack = view.board.stack;
            break;
        }
        view = [view superview];
    }
    [stack pushBoard:board animated:YES];
}

- (void)pressedShare:(UIButton*)btn
{
    
}

- (void)pressedCancel:(UIButton*)btn
{
    self.ctrl.btn1.hidden = YES;
    self.ctrl.btn4.hidden = YES;
    self.ctrl.stateTimeLbl.text = @"已取消";
}

@end


#pragma mark -

@interface QiuchangOrderCellViewController ()

@end

@implementation QiuchangOrderCellViewController

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
