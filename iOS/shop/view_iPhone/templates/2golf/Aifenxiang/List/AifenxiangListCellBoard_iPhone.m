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
//  AifenxiangListCellBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-5-28.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "AifenxiangListCellBoard_iPhone.h"
#import "NSDate+BeeExtension.h"

#pragma mark -

@interface AifenxiangListCell_iPhone ()

@end

#pragma mark -

@implementation AifenxiangListCell_iPhone

DEF_SIGNAL( TOUCHED )

- (void)load
{
    [super load];
    
    self.tappable = YES;
	self.tapSignal = self.TOUCHED;
    
    self.ctrl = [AifenxiangListCellBoard_iPhone boardWithNibName:@"AifenxiangListCellBoard_iPhone"];
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
        self.ctrl.titleLbl.text = dict[@"title"];
        [self.ctrl.imgView setUrl:dict[@"imgurl"]];
        self.ctrl.desLbl.text = dict[@"summary"];
        if ([self.ctrl.desLbl.text length] == 0)
        {
            self.ctrl.desLbl.text = self.ctrl.titleLbl.text;
        }
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:[dict[@"publishdate"] intValue]];
        self.ctrl.dateLbl.text = [NSString stringWithFormat:@"发表日期：%d年%d月%d日",[date year],[date month],[date day]];
    }
}

@end

#pragma mark -

@interface AifenxiangListCellBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation AifenxiangListCellBoard_iPhone

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

@end