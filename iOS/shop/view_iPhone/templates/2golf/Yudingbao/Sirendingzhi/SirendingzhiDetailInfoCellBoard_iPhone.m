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
//  SirendingzhiDetailInfoCellBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-5-10.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "SirendingzhiDetailInfoCellBoard_iPhone.h"

#pragma mark -

@interface SirendingzhiDetailInfoCell_iPhone ()

@property (nonatomic,retain) SirendingzhiDetailInfoCellBoard_iPhone* ctrl;
@property (nonatomic,retain) UILabel* titleLabel;
@property (nonatomic,retain) UILabel* contentLabel;
@property (nonatomic,retain) UIView* titleBg;
@property (nonatomic,retain) UIView* bottomLine;

@end

#pragma mark -

@implementation SirendingzhiDetailInfoCell_iPhone

SUPPORT_RESOURCE_LOADING( NO );
SUPPORT_AUTOMATIC_LAYOUT( NO );

- (void)load
{
    [super load];
    
    self.ctrl = [SirendingzhiDetailInfoCellBoard_iPhone board];
    //self.frame = self.ctrl.view.frame;
    self.backgroundColor = [UIColor clearColor];
    
    self.titleBg = [[[UIView alloc] initWithFrame:CGRectMake(0, 5, 150, 20)] autorelease];
    self.titleBg.backgroundColor = RGB(101, 149, 161);
    [self addSubview:self.titleBg];
    
    self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 6, 120, 20)] autorelease];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [self addSubview:self.titleLabel];
    
    self.contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 30, 280, 20)] autorelease];
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.font = [UIFont systemFontOfSize:13.f];
    [self addSubview:self.contentLabel];
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 320, 1)];
    self.bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.bottomLine];
}

- (void)unload
{
    self.ctrl = nil;
    self.titleBg = nil;
    self.titleLabel = nil;
    self.contentLabel = nil;
    self.bottomLine = nil;
    
	[super unload];
}

- (void)layoutDidFinish
{
}

- (void)dataDidChanged
{
    //self.frame = CGRectMake(0, 0, 320, 200);
    if (self.data)
    {
        NSDictionary* dict = self.data;
        [self.ctrl setupWithDatadict:dict];
        
        self.titleLabel.text = dict[@"title"];
        self.contentLabel.text = dict[@"content"];
        
        CGRect rect;
        
        UILabel* title = self.titleLabel;
        rect = title.frame;
        title.numberOfLines = 0;
        rect.size = [title.text sizeWithFont:title.font constrainedToSize:CGSizeMake(rect.size.width, 999999)];
        title.frame = rect;
        
        UILabel* content = self.contentLabel;
        rect = content.frame;
        content.numberOfLines = 0;
        rect.size = [content.text sizeWithFont:content.font constrainedToSize:CGSizeMake(rect.size.width, 999999)];
        content.frame = rect;
        
        UIView* bottom = self.bottomLine;
        rect = bottom.frame;
        CGFloat y = CGRectGetMaxY(content.frame);
        y += 5;
        rect.origin.y = y;
        bottom.frame = rect;
        
        rect = self.frame;
        rect.size.height = CGRectGetMaxY(bottom.frame);
        self.frame = rect;
        
        //title.frame = CGRectMake(0, 5, <#CGFloat width#>, <#CGFloat height#>)
        //[self.ctrl.orderBtn addTarget:self action:@selector(_pressedBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark -

- (void)_pressedBtn:(UIButton*)btn
{
    /*
     if(self.delegate && [self.delegate respondsToSelector:@selector(onPressedPriceButton:)])
     {
     [self.delegate onPressedPriceButton:self];
     }*/
}

@end

#pragma mark -

@interface SirendingzhiDetailInfoCellBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation SirendingzhiDetailInfoCellBoard_iPhone

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

- (void)setupWithDatadict:(NSDictionary*)dataDict
{
    
}

@end
