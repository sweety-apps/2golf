//
//  QiuChangOrderDetailBoard_iPhoneV2.m
//  2golf
//
//  Created by rolandxu on 14-9-3.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuChangOrderDetailBoard_iPhone.h"
#import <ShareSDK/ShareSDK.h>
#import "QiuChangOrderDetailCell.h"

@interface QiuChangOrderDetailBoard_iPhone ()
<QiuChangOrderDetailCellDelegate>
{
    
}
@end

@implementation QiuChangOrderDetailBoard_iPhone

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
    
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:[NSString stringWithFormat:@"订单%@",self.order[@"order_sn"]]];
        [self showNavigationBarAnimated:YES];
        
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        [self showBarButton:BeeUINavigationBar.RIGHT image:[UIImage imageNamed:@"item-info-header-share-icon.png"]];
        
		_scroll = [[[BeeUIScrollView alloc] init] autorelease];
        _scroll.dataSource = self;
		_scroll.baseInsets = UIEdgeInsetsMake(0, 0, 20.0f, 0);
		[_scroll showHeaderLoader:NO animated:NO];
		[_scroll showFooterLoader:NO animated:NO];
        [self.view addSubview:_scroll];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
		[self unobserveAllNotifications];
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        /*
         CGRect rect = self.viewBound;
         rect.origin.y+=6;
         rect.size.height-=6;
         _scroll.frame =rect;
         */
		_scroll.frame = CGRectMake(0, 0, self.width, self.height);
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
		_scroll.frame = CGRectMake(0, 0, self.width, self.height);
        _scroll.clipsToBounds = NO;
		
        [_scroll asyncReloadData];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.MODALVIEW_DID_HIDDEN] )
    {

    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];
    
    if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
    {
        [self.stack popBoardAnimated:NO];
    }
    else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
    {
		[self shareOrder:self.order];
    }
}


//ON_SIGNAL2( BeeUIScrollView, signal )
//{
//	[super handleUISignal:signal];
//	
//	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
//	{
//        
//	}
//}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    NSUInteger row = 0;
    
	row += 1;
	//row += self.helpModel.articleGroups.count;
    
	return row;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    QiuChangOrderDetailCell* cell = [scrollView dequeueWithContentClass:[QiuChangOrderDetailCell class]];
    cell.delegate = self;
    cell.data = self.order;
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    NSUInteger section = 0;
	
	section += 1;
	if ( index < section )
	{
        return [QiuChangOrderDetailCell estimateUISizeByWidth:scrollView.width forData:nil];
	}
    
    return CGSizeZero;
}

- (void)shareOrder:(NSDictionary*)dict
{
#if 0
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"jpg"];
    
    NSString* title = [NSString stringWithFormat:@"我正在使用爱高高尔夫订场，场地众多，价格实惠"];
    NSString* url = [[ServerConfig sharedInstance].baseUrl stringByAppendingFormat:@"/app/"];
    NSString* summary = @" ";
    
    if ([summary length] == 0)
    {
        summary = @"爱高高尔夫，爱上高尔夫";
    }
    
    NSString* collectedContent = [NSString stringWithFormat:@"【爱高高尔夫】%@ %@",title,url];
#else
    
    
    NSObject* playTime = dict[@"playtime"];
    NSString* tsStr = nil;
    if ([playTime isKindOfClass:[NSString class]])
    {
        tsStr = (NSString*)playTime;
    }
    else if([playTime isKindOfClass:[NSNumber class]])
    {
        tsStr = [((NSNumber*)playTime) stringValue];
    }
    NSTimeInterval iterval = [tsStr doubleValue];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:iterval];
    
    NSString* title = nil;//@"高尔夫人士必备之应用";
    NSString* url = nil;//[[ServerConfig sharedInstance].baseUrl stringByAppendingFormat:@"/app/"];
    NSString* summary = nil;//[NSString stringWithFormat:@"我预订了 %@ %02d月%02d日 %@ %02d:%02d 的球场，欢迎一起打球哦",dict[@"coursename"],[date month],[date day],[date weekdayChinese],[date hour],[date minute]];
    
    NSString* orderType = @"球场";
    if ([dict[@"type"] integerValue] == 1)
    {
        orderType = @"球场";
    }
    else if ([dict[@"type"] integerValue] == 2)
    {
        orderType = @"套餐";
    }
    NSNumber* personCount = dict[@"persons"];
    
    NSString* collectedContent = nil;
    if ([dict[@"type"] integerValue] == 1)
    {
        collectedContent = [NSString stringWithFormat:@"您好！已预订%@：%@，日期：%d月%d日（%@），时间：%02d：%02d分，人数：%@人，祝您打球愉快！用爱高订场真的很方便，一站式服务平台，您也试试看：http://www.2golf.cn/app【爱高高尔夫】400-822-9222",orderType,dict[@"coursename"],[date month],[date day],[date weekdayChinese],[date hour],[date minute],personCount];
    }
    else if ([dict[@"type"] integerValue] == 2)
    {
        collectedContent = [NSString stringWithFormat:@"您好！已预订%@：%@，日期：%d月%d日（%@），人数：%@人，祝您打球愉快！用爱高订场真的很方便，一站式服务平台，您也试试看：http://www.2golf.cn/app【爱高高尔夫】400-822-9222",orderType,dict[@"coursename"],[date month],[date day],[date weekdayChinese],personCount];
    }
    
    title = collectedContent;
    summary = collectedContent;
    
#endif
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:collectedContent
                                       defaultContent:collectedContent
                                                image:nil//[ShareSDK imageWithPath:imagePath]
                                                title:title
                                                  url:url
                                          description:summary
                                            mediaType:SSPublishContentMediaTypeText//SSPublishContentMediaTypeNews
                                     ];
    
    ///////////////////////
    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeText//SSPublishContentMediaTypeNews
                                                  ]
                                         content:summary
                                           title:title
                                             url:url
                                      thumbImage:nil//[ShareSDK imageWithPath:imagePath]
                                           image:nil//[ShareSDK imageWithPath:imagePath]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeText//SSPublishContentMediaTypeNews
                                                   ]
                                          content:summary
                                            title:title
                                              url:url
                                       thumbImage:nil//[ShareSDK imageWithPath:imagePath]
                                            image:nil//[ShareSDK imageWithPath:imagePath]
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制微信收藏信息
    [publishContent addWeixinFavUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeText//SSPublishContentMediaTypeNews
                                              ]
                                     content:summary
                                       title:title
                                         url:url
                                  thumbImage:nil//[ShareSDK imageWithPath:imagePath]
                                       image:nil//[ShareSDK imageWithPath:imagePath]
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
                                    NSLog(@"[TEXT_ShARE_FAI] 分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

#pragma mark QiuChangOrderDetailCellDelegate
-(void)orderagain:(NSDictionary*)order
{
    
}

-(void)cancelorder:(NSDictionary*)order
{
    
}
@end
