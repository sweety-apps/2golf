//
//  UserDetailBoard_iPhone.m
//  2golf
//
//  Created by rolandxu on 14-10-6.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "UserDetailBoard_iPhone.h"
#import "AppBoard_iPhone.h"

@implementation UserDetailCell_iPhone

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data expaned:(BOOL)expaned
{
    return CGSizeMake( width, 60.0f );
}

- (void)load
{
    [super load];
    self.titleview = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 90, 60)];
    [self.titleview setTextAlignment:NSTextAlignmentRight];
    self.valueview = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 190, 60)];
    self.editvalueview = [[UITextField alloc] initWithFrame:CGRectMake(110, 1, 190, 59)];
    self.editvalueview.backgroundColor = [UIColor clearColor];
    self.editvalueview.returnKeyType = UIReturnKeyDone;
    [self addSubview:self.titleview];
    [self addSubview:self.valueview];
    [self addSubview:self.editvalueview];
    
}

- (void)dataDidChanged
{
    if ( self.data )
    {

    }
    else
    {
        
    }
}

-(void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    if (_isEditing) {
        [self.valueview setHidden:YES];
        [self.editvalueview setHidden:NO];
    }
    else
    {
        [self.valueview setHidden:NO];
        [self.editvalueview setHidden:YES];
    }
}
@end

@interface UserDetailBoard_iPhone ()
{
    BeeUIScrollView* _scroll;
    NSMutableArray* _titlearray;
    NSMutableArray* _valuearray;
    CGSize privilegesize;
}
@end

@implementation UserDetailBoard_iPhone

- (void)load
{
	[super load];
	[[UserModel sharedInstance] addObserver:self];
    _titlearray = [[NSMutableArray alloc] initWithObjects:@"爱高会员：",@"姓       名：",@"电       话：",@"生       日：",@"性       别：",@"邮       箱：",nil];
    _valuearray = [[NSMutableArray alloc] init];
    privilegesize = CGSizeZero;
}

- (void)unload
{
    [[UserModel sharedInstance] removeObserver:self];
    [_titlearray release];
    [_valuearray release];
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];
    
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"会员详情"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"collect_compile") image:[UIImage imageNamed:@"nav-right.png"]];
        
        self.isEditing = NO;
		self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"body-bg.png"]];
		_scroll = [[BeeUIScrollView alloc] init];
		_scroll.dataSource = self;
        [_scroll showHeaderLoader:YES animated:NO];
        [_scroll showFooterLoader:NO animated:NO];
		[self.view addSubview:_scroll];
        [_scroll setBackgroundColor:[UIColor clearColor]];
        [self.view setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0f alpha:1.0]];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
		SAFE_RELEASE_SUBVIEW( _scroll );
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        [_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
		_scroll.frame = self.viewBound;
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        [[UserModel sharedInstance] loadCache];
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
		[[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
		
		[self updateViews];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
		[[UserModel sharedInstance] updateProfile];
        
        [_scroll reloadData];
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
		self.isEditing = NO;
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
        self.isEditing = !self.isEditing;
        
        [self updateViews];
	}
}

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{
		[[UserModel sharedInstance] updateProfile];
	}
	else if ( [signal is:BeeUIScrollView.REACH_BOTTOM] )
	{
//		[self.usermodel nextPageFromServer];
	}
}


- (void)updateViews
{
    if ( self.isEditing )
    {
        [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"collect_done") image:[UIImage imageNamed:@"nav-right.png"]];
        [_scroll reloadData];
    }
    else
    {
        [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"collect_compile") image:[UIImage imageNamed:@"nav-right.png"]];
//        [UserModel sharedInstance] updateUser:<#(NSString *)#> phone:<#(NSString *)#> email:<#(NSString *)#> sexval:<#(int)#> birthday:<#(NSString *)#>
    }
    
}

#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    if (_valuearray.count != 0) {
        return [_valuearray count] + 4;
    }
    else
    {
        return 0;
    }
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    if (index < 6) {
        UserDetailCell_iPhone * cell = [scrollView dequeueWithContentClass:[UserDetailCell_iPhone class]];
        if(index != 0)
        {
            cell.isEditing = self.isEditing;
            if (self.isEditing && index == 1) {
                [cell.editvalueview becomeFirstResponder];
            }
        }
        else
        {
            cell.isEditing = NO;
        }
        cell.titleview.text = [_titlearray objectAtIndex:index];
        cell.valueview.text = [_valuearray objectAtIndex:index] ;
        cell.editvalueview.text = [_valuearray objectAtIndex:index];
        return cell;
    }
    else if(index == 6)
    {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(30, 0, 270, 40)];
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 280, 1)];
//        [view setBackgroundColor:[UIColor colorWithString:@"b0afb0"]];
        [view setBackgroundColor:[UIColor colorWithRed:176/255.0 green:175/255.0 blue:176/255 alpha:1.0]];
        [cell.contentView addSubview:view];
        return cell;
    }
    else if(index == 7)
    {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(20, 0, 280, 120)];
        BeeUIImageView* view = [[BeeUIImageView alloc] initWithFrame:CGRectMake(20, 0, 280, 120)];
        [view setUrl:[UserModel sharedInstance].user.vip_card_url];
        [cell addSubview:view];
        return cell;
    }
    else if(index == 8)
    {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
        UILabel* view = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 280, 40)];
        [view setTextAlignment:NSTextAlignmentLeft];
        [view setText:@"会员特权："];
        [cell addSubview:view];
        return cell;
    }
    else if (index == 9)
    {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(20, 0, privilegesize.width, privilegesize.height)];
        UITextView* lbl = [[UITextView alloc] initWithFrame:CGRectMake(20, 0, privilegesize.width, privilegesize.height)];
        [lbl setText:[UserModel sharedInstance].user.privilege];
        [cell addSubview:lbl];
        [lbl setFont:[UIFont systemFontOfSize:16]];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setEditable:NO];
        return cell;
    }
    else
    {
        return nil;
    }
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    if(index < 7)
        return CGSizeMake( (scrollView.width), 40.0f );
    else if(index == 7)
    {
        return CGSizeMake(scrollView.width, 120);
    }
    else if (index == 8)
    {
        return  CGSizeMake( (scrollView.width), 40.0f );
    }
    else if(index == 9)
    {
        return privilegesize;
    }
    else
    {
        return CGSizeZero;
    }
}

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];
    
    if ( [msg is:API.user_info] )
    {
        {
            [_scroll setHeaderLoading:msg.sending];
        }
        
        if ( msg.succeed )
        {
            [self _resetData];
            [_scroll reloadData];
        }
    }
}

-(void)_resetData
{
    [_valuearray removeAllObjects];
    [_valuearray addObject:[UserModel sharedInstance].user.vip_number];
    [_valuearray addObject:[UserModel sharedInstance].user.name];
    [_valuearray addObject:[UserModel sharedInstance].user.user_name];
    [_valuearray addObject:[UserModel sharedInstance].user.birthday];
    [_valuearray addObject:[UserModel sharedInstance].user.sex];
    [_valuearray addObject:[UserModel sharedInstance].user.email];
    privilegesize = [[UserModel sharedInstance].user.privilege sizeWithFont:[UIFont systemFontOfSize:18] byWidth:280];
}
@end
