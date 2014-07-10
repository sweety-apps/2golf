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
//  SearchKeywordsListBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-4-15.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "SearchKeywordsListBoard_iPhone.h"
#import "CitySelectCellBoard_iPhone.h"
#import "ServerConfig.h"

#pragma mark -

@interface SearchKeywordsCellContainer : BeeUICell
{
    CitySelectCellBoard_iPhone* _board;
}

@property (nonatomic, retain) CitySelectCell* cell;

@end


@implementation SearchKeywordsCellContainer

@synthesize cell;

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data expaned:(BOOL)expaned
{
    return CGSizeMake( width, 35.0f );
}

- (void)initSubView
{
    CitySelectCellBoard_iPhone* board = [[CitySelectCellBoard_iPhone boardWithNibName:@"CitySelectCellBoard_iPhone"] retain];
    [self addSubview:board.view];
    self.cell = (CitySelectCell*)board.view;
    _board = board;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)dealloc
{
    self.cell = nil;
    [_board release];
    [super dealloc];
}

- (void)dataDidChanged
{
    
}

@end


#pragma mark -

@interface SearchKeywordsListBoard_iPhone()
{
	//
}

@property (nonatomic,retain) NSMutableArray* keyWordsArray;

@end

@implementation SearchKeywordsListBoard_iPhone

@synthesize tableView;
@synthesize textField;
@synthesize keyWordsArray;

- (void)load
{
	[super load];
    self.keyWordsArray = [NSMutableArray array];
}

- (void)unload
{
    self.keyWordsArray = nil;
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
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:self.textField];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        [self.textField resignFirstResponder];
        [self.stack popBoardAnimated:YES];
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
	}
}

#pragma mark -

- (void)_onPressedCell:(UIButton*)sender
{
    self.textField.text = self.keyWordsArray[sender.tag];
    [self onPressedSearch:nil];
}

#pragma mark -

- (IBAction)onPressedSearch:(id)sender
{
    NSString* keywords = self.textField.text;
    if (keywords == nil)
    {
        keywords = @"";
    }
    [[NSUserDefaults standardUserDefaults] setObject:keywords forKey:@"search_keywords"];
    [self.textField resignFirstResponder];
    [self.stack popBoardAnimated:YES];
}


#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.keyWordsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        SearchKeywordsCellContainer* container = [[SearchKeywordsCellContainer alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
        [container.cell.cellBg addTarget:self action:@selector(_onPressedCell:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:container];
    }
    
    for (UIView* view in [cell.contentView subviews])
    {
        if ([view isKindOfClass:[SearchKeywordsCellContainer class]])
        {
            SearchKeywordsCellContainer* container = (SearchKeywordsCellContainer*)view;
            if ([self.keyWordsArray count] == 1)
            {
                [container.cell setBeContentS];
            }
            else if (indexPath.row == 0)
            {
                [container.cell setBeContentH];
            }
            else if (indexPath.row == [self.keyWordsArray count] - 1)
            {
                [container.cell setBeContentB];
            }
            else
            {
                [container.cell setBeContentM];
            }
            container.cell.cellTitle.text = self.keyWordsArray[indexPath.row];
            container.cell.cellBg.tag = indexPath.row;
            break;
        }
    }
    
    return cell;
}

#pragma mark -
- (void)textFieldChanged:(UITextField *)textField
{
    [self fetchData];
}

#pragma mark - <UITextFieldDelegate>

/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.05];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.keyWordsArray removeAllObjects];
    [self.tableView reloadData];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.05];
}
 */

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[self onPressedSearch:nil];
    [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.05];
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark - HTTP

- (void)fetchData
{
    NSLog(@"[KEY WORDS =\n \'%@\']",self.textField.text);
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"coursekeyword"]).PARAM(@"keyword",self.textField.text).TIMEOUT(30);
}

- (NSDictionary*) commonCheckRequest:(BeeHTTPRequest *)req
{
    if ( req.sending) {
    } else if ( req.recving ) {
    } else if ( req.failed ) {
        [self dismissTips];
        [self presentFailureTips:__TEXT(@"error_network")];
    } else if ( req.succeed ) {
        [self dismissTips];
        // 判断返回数据是
        NSError* error;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:req.responseData options:NSJSONReadingMutableLeaves error:&error];
        if ( dict == nil || [dict count] == 0 ) {
            [self presentFailureTips:__TEXT(@"error_network")];
        } else {
            return dict;
        }
    }
    return nil;
}

- (void) handleRequest:(BeeHTTPRequest *)req
{
    NSDictionary* dict = [self commonCheckRequest:req];
    if (dict)
    {
        //关键字数组
        if ([[req.url absoluteString] rangeOfString:@"coursekeyword"].length > 0) {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                [self dismissTips];
                self.keyWordsArray = [NSMutableArray arrayWithArray:(dict[@"data"])[@"name"]];
                [self.tableView reloadData];
            }
            else
            {
                //[self presentFailureTips:__TEXT(@"error_network")];
                self.keyWordsArray = [NSMutableArray array];
                [self.tableView reloadData];
            }
        }
        
    }
}

@end
