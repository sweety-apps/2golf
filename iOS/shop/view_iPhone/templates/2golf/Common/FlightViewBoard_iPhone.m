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
//  FlightViewBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-6-18.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "FlightViewBoard_iPhone.h"

#pragma mark -

@interface FlightViewBoard_iPhone()
{
	//<#@private var#>
}

@property (nonatomic,assign) BOOL isShowing;
@property (nonatomic,assign) NALLabelsMatrix* matrixView;

@end

@implementation FlightViewBoard_iPhone

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
    CGRect rect = [self.view superview].frame;
    CGRect rectSelfView = self.view.frame;
    if (rect.size.height < 480)
    {
        rectSelfView.origin.y = -((568-420)/2);
    }
    self.view.frame = rectSelfView;
}

- (void)setupCellsWithDataArray:(NSArray*)dataArr
{
    CGRect rectMtx = self.view.frame;
    rectMtx.origin = CGPointZero;
    rectMtx.origin.y = rectMtx.size.height*0.34;
    rectMtx.size.height = 100;
    self.matrixView = [[NALLabelsMatrix alloc] initWithFrame:rectMtx andColumnsWidths:@[@80,@80,@80,@84]];
    
    //self.matrixView.backgroundColor = [UIColor blueColor];
    
    [self.matrixView addRecord:@[@"航空公司",@"去程",@"回程",@"参考价"]];
    
    for (NSDictionary* dict in dataArr)
    {
        [self.matrixView addRecord:@[dict[@"airline"],dict[@"toflightnum"],dict[@"backflightnum"],[NSString stringWithFormat:@"%@",dict[@"price"]]]];
    }
     
    //[[[UIApplication sharedApplication] keyWindow] addSubview:self.matrixView];
    [self.view addSubview:self.matrixView];
}

- (void)showViewWithDataArray:(NSArray*)dataArr;
{
    if (self.isShowing)
    {
        return;
    }
    
    self.isShowing = YES;
    
    [self adjustSubviews];
    [self setupCellsWithDataArray:dataArr];
    
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
