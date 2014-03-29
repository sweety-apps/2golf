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
//  SouSuoQiuChangBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-3-29.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "SouSuoQiuChangBoard_iPhone.h"
#import "SouSuoQiuChangViewController.h"

#pragma mark -

@interface SouSuoQiuChangBoard_iPhone()
{
	//<#@private var#>
    SouSuoQiuChangViewController* _ctrl;
}
@end

@implementation SouSuoQiuChangBoard_iPhone

//SUPPORT_AUTOMATIC_LAYOUT( YES )
//SUPPORT_RESOURCE_LOADING( YES )

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
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"球场搜索"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        SouSuoQiuChangViewController* ctrl = [[SouSuoQiuChangViewController alloc] initWithNibName:@"SouSuoQiuChangViewController" bundle:nil];
        _ctrl = ctrl;
        [self.view addSubview:ctrl.view];
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
        _ctrl.uiStack = self.stack;
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
        [self.stack popBoardAnimated:YES];
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
	}
}

@end
