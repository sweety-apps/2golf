//
//  SouSuoQiuchangBottomViewController.m
//  2golf
//
//  Created by Lee Justin on 14-4-17.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "SouSuoQiuchangBottomViewController.h"
#import "QiuchangCellViewController.h"
#import "QuichangDetailBoard_iPhone.h"

@interface SouSuoQiuchangBottomViewController ()

@property (nonatomic,retain) NSMutableArray* cellArray;

@end

@implementation SouSuoQiuchangBottomViewController

@synthesize cellContainerView;
@synthesize moreBtn;
@synthesize cellArray;

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
    
    for (int i = 0; i < 3; ++i)
    {
        QiuchangCellViewController* cellCtrl = [[[QiuchangCellViewController alloc] initWithNibName:@"QiuchangCellViewController" bundle:nil] autorelease];
        
        self.cellArray[i] = cellCtrl;
        
        CGRect rect = cellCtrl.view.frame;
        rect.origin = CGPointMake(0, rect.size.height*i);
        cellCtrl.view.frame = rect;
        
        [self.cellContainerView addSubview:cellCtrl.view];
        
        cellCtrl.btn.tag = i;
        [cellCtrl.btn addTarget:self action:@selector(_pressedCell:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.cellArray = nil;
    [super dealloc];
}


- (IBAction)onPressedMore:(id)sender
{
    
}

- (void)_pressedCell:(UIButton*)btn
{
    NSInteger index = btn.tag;
    
    QuichangDetailBoard_iPhone* board = [QuichangDetailBoard_iPhone boardWithNibName:@"QuichangDetailBoard_iPhone"];
    [[self.view superview].stack pushBoard:board animated:YES];
}

@end
