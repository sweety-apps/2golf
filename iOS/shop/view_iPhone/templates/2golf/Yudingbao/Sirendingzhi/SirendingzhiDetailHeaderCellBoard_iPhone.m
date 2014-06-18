//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  SirendingzhiDetailHeaderCellBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-5-10.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "SirendingzhiDetailHeaderCellBoard_iPhone.h"
#import "TimeSquareBoard_iPhone.h"
#import "TaocanOrderEditBoard_iPhone.h"
#import "QuichangDetailBoard_iPhone.h"
#import "FlightViewBoard_iPhone.h"

#pragma mark -

@interface SirendingzhiDetailHeaderCell_iPhone ()

@end

#pragma mark -

@implementation SirendingzhiDetailHeaderCell_iPhone

- (void)load
{
    [super load];
    
    self.ctrl = [SirendingzhiDetailHeaderCellBoard_iPhone boardWithNibName:@"SirendingzhiDetailHeaderCellBoard_iPhone"];
    self.frame = self.ctrl.view.frame;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.ctrl.view];
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
        
        self.ctrl.leftLabel0.text = dict[@"comboname"];
        
        [self.ctrl resetDate];
        
        self.ctrl.leftLabel2.text = [NSString stringWithFormat:@"服务商：%@",dict[@"distributorname"]];
        NSString* price = dict[@"price"];
        if (price == nil)
        {
            price = dict[@"normalprice"];
        }
        
        self.ctrl.leftLabel3.text = [NSString stringWithFormat:@"套餐价：￥%@",price];
        
        
        self.ctrl.leftLabel4.text = dict[@"coursename"][0];
        self.ctrl.leftLabel5.text = @"往返航班及机票参考价";
        
        self.ctrl.dataDict = dict;
        
        //[self.ctrl.orderBtn addTarget:self action:@selector(_pressedBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

@end

#pragma mark -

@interface SirendingzhiDetailHeaderCellBoard_iPhone()
{
	//<#@private var#>
}

@end

@implementation SirendingzhiDetailHeaderCellBoard_iPhone

- (void)load
{
	[super load];
}

- (void)unload
{
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {	
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        [self.bgBtn0 setBackgroundImage:[[self.bgBtn0 backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
        [self.bgBtn1 setBackgroundImage:[[self.bgBtn1 backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
        [self.bgBtn2 setBackgroundImage:[[self.bgBtn2 backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
        [self.bgBtn3 setBackgroundImage:[[self.bgBtn3 backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
        [self.bgBtn4 setBackgroundImage:[[self.bgBtn4 backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
        [self.bgBtn5 setBackgroundImage:[[self.bgBtn5 backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
        
        [self resetDate];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
	{
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
	}
}

#pragma mark Set

- (void)resetDate
{
    NSString* str = nil;
    //日期
    NSDate* date = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_date"];
    if (date == nil)
    {
        date = [NSDate date];
    }
    str = [NSString stringWithFormat:@"%d年%d月%d日\n%@",[date year],[date month],[date day],[date weekdayChinese]];
    if ([str length] == 0)
    {
        str = @"2014年02月21日\n星期五";
    }
    self.leftLabel1.text = [NSString stringWithFormat:@"启程日期：%@",str];
}

#pragma mark Event

- (IBAction)onPressedBgBtn0:(id)sender
{
    
}

- (IBAction)onPressedBgBtn1:(id)sender
{
    [[[self.view superview] recursiveFindUIBoard].stack pushBoard:[TimeSquareBoard_iPhone board] animated:YES];
}

- (IBAction)onPressedBgBtn2:(id)sender
{
    
}

- (IBAction)onPressedBgBtn3:(id)sender
{
    
}


- (IBAction)onPressedBgBtn4:(id)sender
{
    QuichangDetailBoard_iPhone* board = [QuichangDetailBoard_iPhone boardWithNibName:@"QuichangDetailBoard_iPhone"];
    [board setCourseId:self.dataDict[@"courseid"][0]];
    [[[self.view superview] recursiveFindUIBoard].stack pushBoard:board animated:YES];
}

- (IBAction)onPressedBgBtn5:(id)sender
{
    
}


- (IBAction)onPressedYudingBtn:(id)sender
{
    TaocanOrderEditBoard_iPhone* board = [TaocanOrderEditBoard_iPhone boardWithNibName:@"TaocanOrderEditBoard_iPhone"];
    board.dataDict = self.dataDict;
    [[[self.view superview] recursiveFindUIBoard].stack pushBoard:board animated:YES];
}

@end
