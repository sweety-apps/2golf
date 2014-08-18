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
//  TimeSquareBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-3-29.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "TimeSquareBoard_iPhone.h"
#import "TSQTAViewController.h"
#import "CommonUtility.h"

#pragma mark -

@interface TimeSquareBoard_iPhone() <TSQCalendarViewDelegate>
{
	TSQTAViewController* _ctrl;
}
@end

@implementation TimeSquareBoard_iPhone

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
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"日期选择"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        _ctrl = [[TSQTAViewController alloc] init];
        _ctrl.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        _ctrl.calendar.locale = [NSLocale currentLocale];
        
        
        [self.view addSubview:_ctrl.view];
        
        _ctrl.tsqView.delegate = self;
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        [_ctrl viewDidLayoutSubviews];
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        [_ctrl viewWillAppear:YES];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        [_ctrl viewDidAppear:YES];
        CGRect rect = self.viewBound;
        rect.origin.y+=6;
        rect.size.height-=6;
        _ctrl.view.frame =rect;
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
        [_ctrl viewWillDisappear:YES];
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
        [_ctrl viewDidDisappear:YES];
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

#pragma mark - <TSQCalendarViewDelegate>
- (BOOL)calendarView:(TSQCalendarView *)calendarView shouldSelectDate:(NSDate *)date
{
//    NSDate* todyDate = [NSDate date];
//    NSTimeInterval todyDateInterval =  [todyDate timeIntervalSince1970] - ((int)[todyDate timeIntervalSince1970]) % (3600 * 24);
//    //NSTimeInterval dateInterval =  [date timeIntervalSince1970] - ((int)[date timeIntervalSince1970]) % (3600 * 24);
//    NSTimeInterval dateInterval =  [date timeIntervalSince1970];
//    if (dateInterval - todyDateInterval < 0/*3600 * 23*/)
//    {
//        return NO;
//    }
    NSDate* search_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_time"];
    
    return YES;
}

- (void)calendarView:(TSQCalendarView *)calendarView didSelectDate:(NSDate *)date
{
//    NSDate* todyDate = [NSDate date];
//    NSTimeInterval todyDateInterval =  [todyDate timeIntervalSince1970] - ((int)[todyDate timeIntervalSince1970]) % (3600 * 24);
    //NSTimeInterval dateInterval =  [date timeIntervalSince1970] - ((int)[date timeIntervalSince1970]) % (3600 * 24);
//    NSTimeInterval dateInterval =  [date timeIntervalSince1970];
//    if (dateInterval - todyDateInterval < 0/*3600 * 23*/)
//    {
//        BeeUIAlertView * alert = [BeeUIAlertView spawn];
//        alert.title = @"选择日期不能早于明天";
//        [alert addCancelTitle:@"好的"];
//        [alert showInViewController:self];
//    }
//    else
//    {
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"search_date"];
        [self.stack popBoardAnimated:YES];
//    }
    
}

@end
