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
//  ContactListCellBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-5-22.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "ContactListCellBoard_iPhone.h"

#pragma mark -

@interface ContactListCell_iPhone ()

@end

#pragma mark -

@implementation ContactListCell_iPhone

DEF_SIGNAL( TOUCHED )

- (void)load
{
    [super load];
    
    self.tappable = YES;
	self.tapSignal = self.TOUCHED;
    
    self.ctrl = [ContactListCellBoard_iPhone boardWithNibName:@"ContactListCellBoard_iPhone"];
    self.frame = self.ctrl.view.frame;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.ctrl.view];
    self.ctrl.checkImg.hidden = YES;
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
        BOOL selected = [dict[@"selected"] boolValue];
        self.ctrl.nameLbl.text = dict[@"name"];
        if (!selected)
        {
            self.ctrl.checkImg.hidden = YES;
        }
        else
        {
            self.ctrl.checkImg.hidden = NO;
        }
    }
}

@end


#pragma mark -

@interface ContactListCellBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation ContactListCellBoard_iPhone

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
