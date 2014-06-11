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
#import "MyOrderListBoard_iPhone.h"

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
    
    self.cellArray = [NSMutableArray array];
    
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

-(void)setDataArray:(NSArray *)dataArray
{
    [dataArray retain];
    [_dataArray release];
    _dataArray = dataArray;
    
    self.view.hidden = NO;
    self.moreContainerView.hidden = NO;
    if ([_dataArray count] == 0)
    {
        self.view.hidden = YES;
    }
    else
    {
        if ([_dataArray count] < 4)
        {
            self.moreContainerView.hidden = YES;
        }
        else
        {
            self.moreContainerView.hidden = NO;
        }
        for (int i = 0; i < 3; ++i)
        {
            QiuchangCellViewController* cellCtrl = self.cellArray[i];
            
            if (i >= [_dataArray count])
            {
                cellCtrl.view.hidden = YES;
            }
            else
            {
                cellCtrl.view.hidden = NO;
                NSDictionary* dict = _dataArray[i];
                
                //[cellCtrl setNoIcon];
                cellCtrl.nameLabel.text = dict[@"coursename"];
                cellCtrl.distanceLabel.text = @"";
                cellCtrl.descriptionLabel.text = dict[@"description"];
                cellCtrl.valueLabel.text = [NSString stringWithFormat:@"￥%@",[dict[@"price"][@"price"] stringValue]];
                cellCtrl.huiIcon.hidden = YES;
                cellCtrl.guanIcon.hidden = YES;
            }
        }
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
    MyOrderListBoard_iPhone* board = [MyOrderListBoard_iPhone boardWithNibName:@"MyOrderListBoard_iPhone"];
    [[[[self.view superview] superview] superview].stack pushBoard:board animated:YES];
}

- (void)_pressedCell:(UIButton*)btn
{
    NSInteger index = btn.tag;
    
    QuichangDetailBoard_iPhone* board = [QuichangDetailBoard_iPhone boardWithNibName:@"QuichangDetailBoard_iPhone"];
    [board setCourseId:_dataArray[index][@"courseid"]];
    [[[[self.view superview] superview] superview].stack pushBoard:board animated:YES];
}

@end
