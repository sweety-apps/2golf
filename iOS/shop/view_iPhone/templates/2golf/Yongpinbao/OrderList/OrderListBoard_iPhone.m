//
//  OrderListBoard_iPhone.m
//  2golf
//
//  Created by rolandxu on 9/30/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#import "OrderListBoard_iPhone.h"

@interface OrderListBoard_iPhone()
{
    BeeUIScrollView* _scroll;
}

@property (nonatomic,assign) NSInteger currentSelectBtnIndex;
@property (nonatomic, assign) BOOL	loaded;

@end


@implementation OrderListBoard_iPhone

- (void)load
{
    [super load];
//    self.switchCtrl = [[MyOrderListTopSwitchViewController alloc] initWithNibName:@"MyOrderListTopSwitchViewController" bundle:nil];
//    self.currentLayoutArray = [NSMutableArray array];
//    self.loaded = false;
}

- (void)unload
{
//    self.dataDict = nil;
//    self.currentLayoutArray = nil;
    [super unload];
}


ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];
    
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"用品订单"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        
//        [self setTitleView:self.switchCtrl.view];
//        
//        [self.switchCtrl selectButtonCourse];
//        self.isTaocan = NO;
//        [self.switchCtrl.buttonCourse addTarget:self action:@selector(_selectCourse) forControlEvents:UIControlEventTouchUpInside];
//        [self.switchCtrl.buttonTaocan addTarget:self action:@selector(_selectTaocan) forControlEvents:UIControlEventTouchUpInside];
//        
//        CGRect rect;
//        
//        ////
//        rect = self.viewBound;
//        rect.origin.y+=40;
//        rect.size.height-=40;
//        _scroll = [[BeeUIScrollView alloc] initWithFrame:rect];
//        _scroll.dataSource = self;
//        _scroll.vertical = YES;
//        //_scroll.bounces = NO;
//        [_scroll showHeaderLoader:YES animated:YES];
//        [self.view addSubview:_scroll];
        [self pressedSwitchBtn:self.btnsel0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchData) name:@"moneyPaid" object:nil];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
//        SAFE_RELEASE_SUBVIEW( _scroll );
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
//        [_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, [AppBoard_iPhone sharedInstance].tabbar.height, 0)];
        CGRect rect = self.viewBound;
        rect.origin.y+=40;
        rect.size.height-=40;
//        _scroll.frame =rect;
        
        if (!self.hasRefreshed)
        {
//            [self fetchData];
        }
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
//        [[AppBoard_iPhone sharedInstance] setTabbarHidden:YES animated:NO];
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
}



- (IBAction)pressedSwitchBtn:(UIButton *)sender
{
    NSArray* btnArr = @[
                        self.btnsel0,
                        self.btnsel1,
                        self.btnsel2,
                        self.btnsel3,
                        self.btnsel4,
                        ];
    
    for (int i = 0; i < btnArr.count; ++i)
    {
        UIButton* b = btnArr[i];
        b.selected = NO;
        if (b == sender)
        {
            self.currentSelectBtnIndex = i;
            b.selected = YES;
        }
    }
//    [self fetchData];
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
