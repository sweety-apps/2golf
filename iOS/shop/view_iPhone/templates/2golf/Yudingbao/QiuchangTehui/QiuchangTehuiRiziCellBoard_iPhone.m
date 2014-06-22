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
//  QiuchangTehuiRiziCellBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-4-26.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangTehuiRiziCellBoard_iPhone.h"

#pragma mark -

@interface QiuchangTehuiRiziCell_iPhone ()

@property (nonatomic,retain) QiuchangTehuiRiziCellBoard_iPhone* ctrl;

@end

#pragma mark -

@implementation QiuchangTehuiRiziCell_iPhone

DEF_SIGNAL( TOUCHED )

- (void)load
{
    [super load];
    
    self.tappable = YES;
	self.tapSignal = self.TOUCHED;
    
    self.ctrl = [QiuchangTehuiRiziCellBoard_iPhone boardWithNibName:@"QiuchangTehuiRiziCellBoard_iPhone"];
    self.frame = self.ctrl.view.frame;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.ctrl.view];
    self.ctrl.bubbleImg.image = [__IMAGE(@"privilegelisticonspecialday") stretchableImageWithLeftCapWidth:50 topCapHeight:11];
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
        self.ctrl.newPriceLbl.text = [NSString stringWithFormat:@"￥%@",dict[@"price"]];
        
        if (dict[@"dayname"] == [NSNull null])
        {
            self.ctrl.desLbl.text = @"普通特惠";
        }
        else
        {
            self.ctrl.desLbl.text = dict[@"dayname"];
        }
        
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
        
        //self.ctrl.dateLbl.text =
    }
}

@end

#pragma mark -

@interface QiuchangTehuiRiziCellBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation QiuchangTehuiRiziCellBoard_iPhone

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
