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
//  WeatherViewBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-6-10.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "WeatherViewBoard_iPhone.h"

#pragma mark -

@implementation WeatherViewCellView

- (void)load
{
    [super load];
}

- (void)unload
{
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
        
        self.bgImageView.image = [__IMAGE(@"body-cont-bg.png") stretched];
        self.leftLabel.text = dict[@"date"];
        self.leftLabel1.text = dict[@"temperature"];
        self.midLabel.text = [NSString stringWithFormat:@"%@,%@",dict[@"weather"],dict[@"wind"]];
        self.iconImageView.url = dict[@"dayPictureUrl"];
    }
}

@end


#pragma mark -

@interface WeatherViewBoard_iPhone()
{
	
}

@property (nonatomic,assign) BOOL isShowing;

@end

@implementation WeatherViewBoard_iPhone

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

- (void)adjustSubviews
{
    /*
    CGRect rect = [self.view superview].frame;
    rect.origin = CGPointZero;
    
    CGRect rectContainer = self.containerView.frame;
    rectContainer.origin.y = (rect.size.height - rectContainer.size.height)/2;
    
    self.containerView.frame = rectContainer;
     */
    CGRect rect = [self.view superview].frame;
    CGRect rectSelfView = self.view.frame;
    if (rect.size.height < 480)
    {
        rectSelfView.origin.y = -((568-420)/2);
    }
    self.view.frame = rectSelfView;
}

- (void)setupCellsWithDataDict:(NSDictionary*)dataDict
{
    NSArray* cells = @[self.cell0,self.cell1,self.cell2,self.cell3];
    
    for (int i = 0; i < cells.count; ++i)
    {
        if (i < [dataDict[@"weather_data"] count])
        {
            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:dataDict[@"weather_data"][i]];
            
            if (i == 0)
            {
                dict[@"date"] = @"今天";
            }
            
            ((WeatherViewCellView*)(cells[i])).data = dict;
        }
    }
}

- (void)showViewWithDataDict:(NSDictionary*)dataDict
{
    if (self.isShowing)
    {
        return;
    }
    
    self.isShowing = YES;
    
    [self adjustSubviews];
    [self setupCellsWithDataDict:dataDict];
    
    self.view.alpha = 0.0f;
    
    void (^animationBlk)() = ^() {
        self.view.alpha = 1.0f;
    };
    
    void (^endBlk)() = ^() {
        
    };
    
    [UIView animateWithDuration:0.2f animations:animationBlk completion:^(BOOL finished) {
        endBlk();
    }];
}

- (IBAction)pressedCancel:(id)sender
{
    void (^animationBlk)() = ^() {
        self.view.alpha = 0.0f;
    };
    
    void (^endBlk)() = ^() {
        [self.view removeFromSuperview];
    };
    
    [UIView animateWithDuration:0.2f animations:animationBlk completion:^(BOOL finished) {
        endBlk();
    }];
}

@end
