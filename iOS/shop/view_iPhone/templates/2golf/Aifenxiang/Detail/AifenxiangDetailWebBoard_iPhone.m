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
//  AifenxiangDetailWebBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-5-28.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "AifenxiangDetailWebBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "ServerConfig.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WeiboApi.h"

#pragma mark -

@interface AifenxiangDetailWebBoard_iPhone() <ISSShareViewDelegate>
{
    BOOL _showLoading;
}

@property (nonatomic, retain) NSString* detailID;
@property (nonatomic,retain) NSMutableDictionary* dataDict;
@property (nonatomic,retain) NSMutableDictionary* summaryDataDict;

@end

@implementation AifenxiangDetailWebBoard_iPhone

DEF_SIGNAL(DAIL_RIGHT_NAV_BTN);

-(void)setShareDetailID:(NSString*)detailID
{
    self.detailID = detailID;
}

-(void)setSummaryDictionary:(NSDictionary*)summaryDict
{
    self.summaryDataDict = [NSMutableDictionary dictionaryWithDictionary:summaryDict];
}

- (void)load
{
	[super load];
    _showLoading = YES;
}

- (void)unload
{
	[super unload];
}

#pragma mark Signal

static BeeUIButton* gRightBtn = nil;
static UIImageView* gBarBGView = nil;

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];
    
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"文章详情"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        if ([UIApplication sharedApplication].keyWindow.frame.size.height > 500)
        {
            self.webView.hidden = NO;
            self.webViewIP4.hidden = YES;
        }
        else
        {
            self.webView.hidden = YES;
            self.webView = self.webViewIP4;
            self.webView.hidden = NO;
        }
        
        CGRect rect;
        
        //右上角分享按钮
        UIView* rightBtnContainerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)] autorelease];
        
        rightBtnContainerView.backgroundColor = [UIColor clearColor];
        BeeUIButton* rightBtn = [BeeUIButton buttonWithType:UIButtonTypeCustom];
        UIImage* image = __IMAGE(@"goodsmyorderbtn");
        [rightBtn setBackgroundImage:image forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor]];
        [rightBtn setTitle:@"分享" forState:UIControlStateNormal];
        rightBtn.backgroundColor = [UIColor clearColor];
        gRightBtn = rightBtn;
        [rightBtn addSignal:self.DAIL_RIGHT_NAV_BTN forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(-8, 0, 56, 38);
        [rightBtnContainerView addSubview:rightBtn];
        [self showBarButton:BeeUINavigationBar.RIGHT custom:rightBtnContainerView];
        //rightBtnContainerView.left = -15;
        
        rect = self.viewBound;
        rect.origin.y+=6+64;
        rect.size.height-=6+64;
        self.webView.frame = rect;
        
        //NavigationBar背景太短
        UIImageView* barBGView = [[[UIImageView alloc] initWithImage:__IMAGE(@"titlebarbg")] autorelease];
        rect = barBGView.frame;
        if (IOS7_OR_LATER)
        {
            rect.origin.y = 0;
        }
        else
        {
            rect.origin.y = -20;
        }
        barBGView.frame = rect;
        gBarBGView=barBGView;
        UINavigationBar* bar = self.navigationController.navigationBar;
        bar.clipsToBounds = NO;
        [[bar subviews][0] insertSubview:barBGView atIndex:2];
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
        CGRect rect = self.view.frame;
        rect.origin.y=0;
        rect.size.height-=6+64;
        self.webView.frame = rect;
        self.webView.scrollView.frame = rect;
        //self.webView.bounds = rect;
        [self fetchData];
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
        [self.stack popBoardAnimated:YES];
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
        
	}
}

ON_SIGNAL( signal )
{
    if ( [signal is:self.DAIL_RIGHT_NAV_BTN] )
    {
        //分享按钮
        [self shareAllButtonClickHandler:nil];
    }
}


#pragma mark - UIWebViewDelegate

ON_SIGNAL2( BeeUIWebView, signal )
{
	//[self updateUI];
    
    if ( [signal is:BeeUIWebView.DID_START] )
    {
		if ( _showLoading )
		{
			BeeUIActivityIndicatorView * activity = [BeeUIActivityIndicatorView spawn];
			[activity startAnimating];
			[activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
			[self showBarButton:BeeUINavigationBar.RIGHT custom:activity];
            //			[self presentLoadingTips:__TEXT(@"tips_loading")].useMask = NO;
		}
    }
    else if ( [signal is:BeeUIWebView.DID_LOAD_FINISH] )
    {
		if ( _showLoading )
		{
			[self dismissTips];
			[self hideBarButton:BeeUINavigationBar.RIGHT];
            //			[self presentSuccessTips:@"加载成功"];
		}
    }
    else if ( [signal is:BeeUIWebView.DID_LOAD_CANCELLED] )
    {
		if ( _showLoading )
		{
			[self dismissTips];
			[self hideBarButton:BeeUINavigationBar.RIGHT];
            //			[self presentSuccessTips:@"取消加载"];
		}
    }
    else if( [signal is:BeeUIWebView.DID_LOAD_FAILED] )
    {
		if ( _showLoading )
		{
			[self dismissTips];
			[self hideBarButton:BeeUINavigationBar.RIGHT];
			
			[self presentSuccessTips:__TEXT(@"error_network")];
		}
    }
}

#pragma mark - Network

- (void)fetchData
{
    [self presentLoadingTips:@"正在加载"];
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"sharedetail"]).PARAM(@"sharedetailid",self.detailID).TIMEOUT(30);
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
        //头顶tab
        if ([[req.url absoluteString] rangeOfString:@"sharedetail"].length > 0)
        {
            //网页内容
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                self.dataDict = [NSMutableDictionary dictionaryWithDictionary:dict[@"data"]];
                [self _loadPage];
            }
            else
            {
                [self presentFailureTips:__TEXT(@"error_network")];
            }
        }
    }
}

#pragma mark - Private

- (void)_loadPage
{
    if (self.dataDict)
    {
        NSString* html = [NSString stringWithFormat:@"<html xmlns=\"http://www.w3.org/1999/xhtml\"><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /></head><body>%@</body></html>",self.dataDict[@"sharedetail"]];
        [self.webView loadHTMLString:html baseURL:nil];
        [self.webView reload];
        //[self.webView setUrl:@"http://www.baidu.com"];
    }
}

#pragma mark - ButtonHandler

/**
 *	@brief	分享全部
 *
 *	@param 	sender 	事件对象
 */
- (void)shareAllButtonClickHandler:(UIButton *)sender
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"" ofType:@"jpg"];
    
    NSString* title = nil;
    NSString* url = nil;
    NSString* summary = nil;
    NSString* imageUrl = nil;
    
    if (self.summaryDataDict)
    {
        title = self.summaryDataDict[@"title"];
        url = [[ServerConfig sharedInstance].baseUrl stringByAppendingFormat:@"/article.php?id=%@",self.detailID];
        summary = self.summaryDataDict[@"summary"];
        imageUrl = self.summaryDataDict[@"imgurl"];
    }
    else
    {
        title = self.title;
        url = [[ServerConfig sharedInstance].baseUrl stringByAppendingFormat:@"/article.php?id=%@",self.detailID];
        summary = @"";
        imageUrl = [[NSURL URLWithString:self.summaryDataDict[@"imgurl"]] absoluteString];
    }
    
    
    if ([summary length] == 0)
    {
        summary = @"爱高高尔夫，爱上高尔夫";
    }
    
    NSString* collectedContent = [NSString stringWithFormat:@"【爱高高尔夫】%@ %@",title,url];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:collectedContent
                                       defaultContent:collectedContent
                                                image:[ShareSDK imageWithUrl:imageUrl]
                                                title:title
                                                  url:url
                                          description:summary
                                            mediaType:SSPublishContentMediaTypeNews];
    
    ///////////////////////
    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                         content:summary
                                           title:title
                                             url:url
                                      thumbImage:[ShareSDK imageWithUrl:imageUrl]
                                           image:[ShareSDK imageWithUrl:imageUrl]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:summary
                                            title:title
                                              url:url
                                       thumbImage:[ShareSDK imageWithUrl:imageUrl]
                                            image:[ShareSDK imageWithUrl:imageUrl]
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制微信收藏信息
    [publishContent addWeixinFavUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                     content:summary
                                       title:title
                                         url:url
                                  thumbImage:[ShareSDK imageWithUrl:imageUrl]
                                       image:[ShareSDK imageWithUrl:imageUrl]
                                musicFileUrl:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil];
    
    //定制短信信息
    [publishContent addSMSUnitWithContent:collectedContent];
    
    //结束定制信息
    ////////////////////////
    
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //[container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:self];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"内容分享"
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:self
                                                          friendsViewDelegate:self
                                                        picViewerViewDelegate:nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:[ShareSDK getShareListWithType:ShareTypeSMS, ShareTypeWeixiTimeline, ShareTypeWeixiSession,ShareTypeSinaWeibo, ShareTypeTencentWeibo, nil]
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}


#pragma mark - ISSShareViewDelegate

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
}

- (void)view:(UIViewController *)viewController autorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation shareType:(ShareType)shareType
{
}

@end
