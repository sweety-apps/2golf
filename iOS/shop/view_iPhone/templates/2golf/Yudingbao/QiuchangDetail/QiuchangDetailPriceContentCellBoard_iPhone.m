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
//  QiuchangDetailPriceContentCellBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-4-17.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangDetailPriceContentCellBoard_iPhone.h"

#pragma mark -

@interface QiuchangDetailPriceContentCell_iPhone ()

@property (nonatomic,retain) QiuchangDetailPriceContentCellBoard_iPhone* ctrl;

@end

#pragma mark -

@implementation QiuchangDetailPriceContentCell_iPhone

- (void)load
{
    [super load];
    
    self.ctrl = [QiuchangDetailPriceContentCellBoard_iPhone boardWithNibName:@"QiuchangDetailPriceContentCellBoard_iPhone"];
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
        
        NSString* nameAppendix = @"";
        if (dict[@"holecount"])
        {
            NSInteger holeType = [dict[@"holecount"] intValue];
            if (holeType == 1)
            {
                nameAppendix = @"(9洞)";
            }
            else if (holeType == 2)
            {
                //nameAppendix = @"(18洞)";
            }
            else if (holeType == 3)
            {
                nameAppendix = @"(27洞)";
            }
        }
        
        if ([dict[@"distributortype"] intValue] == 1)
        {
            self.ctrl.nameLbl.text = [NSString stringWithFormat:@"%@%@",dict[@"distributorname"],nameAppendix];
        }
        if ([dict[@"distributortype"] intValue] == 0)
        {
            //self.ctrl.nameLbl.text = [NSString stringWithFormat:@"%@区%@",dict[@"areaname"],nameAppendix];
            self.ctrl.nameLbl.text = [NSString stringWithFormat:@"%@%@",dict[@"distributorname"],nameAppendix];
        }
        
        self.ctrl.priceLbl.text = [NSString stringWithFormat:@"￥%@",dict[@"price"]] ;
        
        [self.ctrl.orderBtn addTarget:self action:@selector(_pressedBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark -

- (void)_pressedBtn:(UIButton*)btn
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onPressedPriceButton:)])
    {
        [self.delegate onPressedPriceButton:self];
    }
}

@end

#pragma mark -

@interface QiuchangDetailPriceContentCellBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation QiuchangDetailPriceContentCellBoard_iPhone

@synthesize orderBtn;
@synthesize nameLbl;
@synthesize priceLbl;

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
