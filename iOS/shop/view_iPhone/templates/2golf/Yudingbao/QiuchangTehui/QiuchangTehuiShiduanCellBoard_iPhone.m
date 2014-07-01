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
//  QiuchangTehuiShiduanCellBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-4-26.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangTehuiShiduanCellBoard_iPhone.h"

#pragma mark -

@interface QiuchangTehuiShiduanCell_iPhone ()

@property (nonatomic,retain) QiuchangTehuiShiduanCellBoard_iPhone* ctrl;

@end

#pragma mark -

@implementation QiuchangTehuiShiduanCell_iPhone

DEF_SIGNAL( TOUCHED )

- (void)load
{
    [super load];
    
    self.tappable = YES;
	self.tapSignal = self.TOUCHED;
    
    self.ctrl = [QiuchangTehuiShiduanCellBoard_iPhone boardWithNibName:@"QiuchangTehuiShiduanCellBoard_iPhone"];
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
        self.ctrl.titleLbl.text = dict[@"shortcoursename"];
        self.ctrl.oldPriceLbl.text = [NSString stringWithFormat:@"原价￥%@",dict[@"originalprice"]];
        self.ctrl.newPriceLbl.text = [NSString stringWithFormat:@"￥%@",(dict[@"price"])[@"price"]];
        
        NSDate* d1 = [NSDate dateWithTimeIntervalSince1970:[dict[@"price"][@"starttime"] doubleValue]];
        NSDate* d2 = [NSDate dateWithTimeIntervalSince1970:[dict[@"price"][@"endtime"] doubleValue]];
        
        self.ctrl.timeLbl.text = [NSString stringWithFormat:@"%02d:%02d~%02d:%02d",[d1 hour],[d1 minute],[d2 hour],[d2 minute]];
        
        NSDate* searchDate = [NSDate dateWithTimeIntervalSinceNow:24*3600];
        NSDate* showDate = d1;
        if ([searchDate timeIntervalSince1970] > [d1 timeIntervalSince1970])
        {
            showDate = searchDate;
        }
        self.ctrl.dateLbl.text = [NSString stringWithFormat:@"%02d月%02d日",[showDate month],[showDate day]];
        
        self.ctrl.xianImg.hidden = YES;
        if (dict[@"payway"] != [NSNull null] && [dict[@"payway"] intValue] == 1)
        {
            self.ctrl.xianImg.hidden = NO;
        }
        else
        {
            self.ctrl.xianImg.hidden = YES;
        }
        
        self.ctrl.huiImg.hidden = YES;
        if (dict[@"distributortype"] != [NSNull null] && [dict[@"distributortype"] intValue] == 1)
        {
            self.ctrl.huiImg.hidden = NO;
        }
        else
        {
            self.ctrl.huiImg.hidden = YES;
        }
    }
}

@end

#pragma mark -

@interface QiuchangTehuiShiduanCellBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation QiuchangTehuiShiduanCellBoard_iPhone

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
