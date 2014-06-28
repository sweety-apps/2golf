//
//  QiuchangOrderCellViewController.m
//  2golf
//
//  Created by Lee Justin on 14-4-18.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangOrderCellViewController.h"
#import "QuichangDetailBoard_iPhone.h"
#import "SirendingzhiDetailBoard_iPhone.h"
#import "ServerConfig.h"
#import <ShareSDK/ShareSDK.h>

#pragma mark -

@interface QiuchangOrderCell_iPhone () <ISSShareViewDelegate>

@end

#pragma mark -

@implementation QiuchangOrderCell_iPhone

-(void)setOrderCellType:(EOrderCellType)orderCellType
{
    _orderCellType = orderCellType;
}

+ (CGSize)getCellSize
{
    return CGSizeMake(320, 243);
}

- (void)load
{
    [super load];
    
    self.ctrl = [[QiuchangOrderCellViewController alloc] initWithNibName:@"QiuchangOrderCellViewController" bundle:nil];
    self.frame = self.ctrl.view.frame;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.ctrl.view];
    
    _orderCellType = EOrderCellTypeCourse;
    //self.ctrl.phoneTextField.delegate = self;
}

- (void)unload
{
    self.ctrl = nil;
    
	[super unload];
}

- (void)layoutDidFinish
{
    
}

- (void)_setupSelfCourseDict:(NSDictionary*)dict
{
    self.ctrl.playTimeTitleLbl.text = @"打球";
    self.ctrl.peopleTimeTitleLbl.text = @"人员";
    
    self.ctrl.courseNameLbl.text = dict[@"coursename"];
    self.ctrl.orderIdLbl.text = dict[@"order_sn"];
    self.ctrl.orderTimeLbl.text = dict[@"createtime"];
    NSObject* playTime = dict[@"playtime"];
    if ([playTime isKindOfClass:[NSString class]])
    {
        self.ctrl.playTimeLbl.text = (NSString*)playTime;
    }
    else if([playTime isKindOfClass:[NSNumber class]])
    {
        self.ctrl.playTimeLbl.text = [((NSNumber*)playTime) stringValue];
    }
    if ([self.ctrl.orderTimeLbl.text length] > 0)
    {
        self.ctrl.orderTimeLbl.text = [self tsStringToDateString:self.ctrl.orderTimeLbl.text];
    }
    if (self.ctrl.playTimeLbl.text)
    {
        self.ctrl.playTimeLbl.text = [self tsStringToDateString:self.ctrl.playTimeLbl.text];
    }
    self.ctrl.peopleTimeLbl.text = dict[@"players"];
    self.ctrl.descriptionTimeLbl.text = dict[@"cancel_desc"];
    if ([self.ctrl.descriptionTimeLbl.text length] == 0)
    {
        self.ctrl.descriptionTimeLbl.text = dict[@"description"];
    }
    NSObject* price = dict[@"price"];
    if ([price isKindOfClass:[NSString class]])
    {
        self.ctrl.priceTimeLbl.text = (NSString*)price;
    }
    else if([price isKindOfClass:[NSNumber class]])
    {
        self.ctrl.priceTimeLbl.text = [((NSNumber*)price) stringValue];
    }
    else if([price isKindOfClass:[NSDictionary class]])
    {
        if ([((NSDictionary*)price)[@"price"] isKindOfClass:[NSDictionary class]])
        {
            self.ctrl.priceTimeLbl.text = [((NSDictionary*)price)[@"price"][@"price"] stringValue];
        }
        else
        {
            self.ctrl.priceTimeLbl.text = [((NSDictionary*)price)[@"price"] stringValue];
        }
    }
    else
    {
        self.ctrl.priceTimeLbl.text = @"获取数据失败";
    }
    
    if (![@"获取数据失败" isEqualToString:self.ctrl.priceTimeLbl.text])
    {
        NSNumber* persons = dict[@"persons"];
        if (persons == nil || [persons isKindOfClass:[NSNull class]])
        {
            persons = [NSNumber numberWithInt:1];
        }
        NSNumber* money = [NSNumber numberWithDouble:[self.ctrl.priceTimeLbl.text doubleValue] * [persons doubleValue]];
        self.ctrl.priceTimeLbl.text = [NSString stringWithFormat:@"￥%@",money];
    }
    
    int status = [dict[@"status"] integerValue];
    [self _setupButtonsWithState:status];
}

- (NSString*)tsStringToDateString:(NSString*)tsStr
{
    NSTimeInterval iterval = [tsStr doubleValue];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:iterval];
    
    NSString* ret = [NSString stringWithFormat:@"%04d/%02d/%02d %02d:%02d\n%@",[date year],[date month],[date day],[date hour],[date minute],[date weekdayChinese]];
    return ret;
}

- (NSString*)tsStringToYearMonthOnlyDateString:(NSString*)tsStr
{
    NSTimeInterval iterval = [tsStr doubleValue];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:iterval];
    
    NSString* ret = [NSString stringWithFormat:@"%04d/%02d/%02d\n%@",[date year],[date month],[date day],[date weekdayChinese]];
    return ret;
}

- (void)_setupSelfTaocanDict:(NSDictionary*)dict
{
    self.ctrl.playTimeTitleLbl.text = @"出行";
    self.ctrl.peopleTimeTitleLbl.text = @"人员";
    
    self.ctrl.courseNameLbl.text = dict[@"coursename"];
    self.ctrl.orderIdLbl.text = dict[@"order_sn"];
    self.ctrl.orderTimeLbl.text = dict[@"createtime"];
    NSObject* playTime = dict[@"playtime"];
    if ([playTime isKindOfClass:[NSString class]])
    {
        self.ctrl.playTimeLbl.text = (NSString*)playTime;
    }
    else if([playTime isKindOfClass:[NSNumber class]])
    {
        self.ctrl.playTimeLbl.text = [((NSNumber*)playTime) stringValue];
    }
    if ([self.ctrl.orderTimeLbl.text length] > 0)
    {
        self.ctrl.orderTimeLbl.text = [self tsStringToDateString:self.ctrl.orderTimeLbl.text];
    }
    if (self.ctrl.playTimeLbl.text)
    {
        self.ctrl.playTimeLbl.text = [self tsStringToYearMonthOnlyDateString:self.ctrl.playTimeLbl.text];
    }
    self.ctrl.peopleTimeLbl.text = dict[@"players"];
    self.ctrl.descriptionTimeLbl.text = dict[@"cancel_desc"];
    if ([self.ctrl.descriptionTimeLbl.text length] == 0)
    {
        self.ctrl.descriptionTimeLbl.text = dict[@"description"];
    }
    NSObject* price = dict[@"price"];
    if ([price isKindOfClass:[NSString class]])
    {
        self.ctrl.priceTimeLbl.text = (NSString*)price;
    }
    else if([price isKindOfClass:[NSNumber class]])
    {
        self.ctrl.priceTimeLbl.text = [((NSNumber*)price) stringValue];
    }
    else if([price isKindOfClass:[NSDictionary class]])
    {
        if ([((NSDictionary*)price)[@"price"] isKindOfClass:[NSDictionary class]])
        {
            self.ctrl.priceTimeLbl.text = [((NSDictionary*)price)[@"price"][@"price"] stringValue];
        }
        else
        {
            self.ctrl.priceTimeLbl.text = [((NSDictionary*)price)[@"price"] stringValue];
        }
    }
    else
    {
        self.ctrl.priceTimeLbl.text = @"获取数据失败";
    }
    
    if (![@"获取数据失败" isEqualToString:self.ctrl.priceTimeLbl.text])
    {
        NSNumber* persons = dict[@"persons"];
        if (persons == nil || [persons isKindOfClass:[NSNull class]])
        {
            persons = [NSNumber numberWithInt:1];
        }
        NSNumber* money = [NSNumber numberWithDouble:[self.ctrl.priceTimeLbl.text doubleValue] * [persons doubleValue]];
        self.ctrl.priceTimeLbl.text = [NSString stringWithFormat:@"￥%@",money];
    }
    
    int status = [dict[@"status"] integerValue];
    [self _setupButtonsWithState:status];
}

- (void)_setupButtonsWithState:(NSInteger)status
{
    [self.ctrl.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.ctrl.btn2 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.ctrl.btn3 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.ctrl.btn4 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    
    self.ctrl.btn1.hidden = NO;
    self.ctrl.btn2.hidden = NO;
    self.ctrl.btn3.hidden = NO;
    self.ctrl.btn4.hidden = NO;
    
    switch (status)
    {
        case 0:
        {
            if (self.orderCellType == EOrderCellTypeCourse)
            {
                [self.ctrl.btn1 addTarget:self action:@selector(pressedQuichang:) forControlEvents:UIControlEventTouchUpInside];
                [self.ctrl.btn1 setTitle:@"查看球场" forState:UIControlStateNormal];
            }
            if (self.orderCellType == EOrderCellTypeTaocan)
            {
                [self.ctrl.btn1 addTarget:self action:@selector(pressedQuichang:) forControlEvents:UIControlEventTouchUpInside];
                [self.ctrl.btn1 setTitle:@"查看套餐" forState:UIControlStateNormal];
            }
            
            [self.ctrl.btn2 addTarget:self action:@selector(pressedShare:) forControlEvents:UIControlEventTouchUpInside];
            [self.ctrl.btn2 setTitle:@"分享订单" forState:UIControlStateNormal];
            [self.ctrl.btn3 addTarget:self action:@selector(pressedCancel:) forControlEvents:UIControlEventTouchUpInside];
            [self.ctrl.btn3 setTitle:@"取消订单" forState:UIControlStateNormal];
            self.ctrl.btn4.hidden = YES;
            
            self.ctrl.stateTimeLbl.text = @"待确认";
        }
            break;
        case 1:
        {
            if (self.orderCellType == EOrderCellTypeCourse)
            {
                [self.ctrl.btn1 addTarget:self action:@selector(pressedQuichang:) forControlEvents:UIControlEventTouchUpInside];
                [self.ctrl.btn1 setTitle:@"查看球场" forState:UIControlStateNormal];
            }
            if (self.orderCellType == EOrderCellTypeTaocan)
            {
                [self.ctrl.btn1 addTarget:self action:@selector(pressedQuichang:) forControlEvents:UIControlEventTouchUpInside];
                [self.ctrl.btn1 setTitle:@"查看套餐" forState:UIControlStateNormal];
            }
            
            [self.ctrl.btn2 addTarget:self action:@selector(pressedShare:) forControlEvents:UIControlEventTouchUpInside];
            [self.ctrl.btn2 setTitle:@"分享订单" forState:UIControlStateNormal];
            [self.ctrl.btn3 addTarget:self action:@selector(pressedCancel:) forControlEvents:UIControlEventTouchUpInside];
            [self.ctrl.btn3 setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.ctrl.btn4 addTarget:self action:@selector(pressedPay:) forControlEvents:UIControlEventTouchUpInside];
            [self.ctrl.btn4 setTitle:@"付款" forState:UIControlStateNormal];
            
            self.ctrl.stateTimeLbl.text = @"待付款";
        }
            break;
        case 2:
        {
            if (self.orderCellType == EOrderCellTypeCourse)
            {
                [self.ctrl.btn1 addTarget:self action:@selector(pressedQuichang:) forControlEvents:UIControlEventTouchUpInside];
                [self.ctrl.btn1 setTitle:@"查看球场" forState:UIControlStateNormal];
            }
            if (self.orderCellType == EOrderCellTypeTaocan)
            {
                [self.ctrl.btn1 addTarget:self action:@selector(pressedQuichang:) forControlEvents:UIControlEventTouchUpInside];
                [self.ctrl.btn1 setTitle:@"查看套餐" forState:UIControlStateNormal];
            }
            
            [self.ctrl.btn2 addTarget:self action:@selector(pressedShare:) forControlEvents:UIControlEventTouchUpInside];
            [self.ctrl.btn2 setTitle:@"分享订单" forState:UIControlStateNormal];
            self.ctrl.btn3.hidden = YES;
            self.ctrl.btn4.hidden = YES;
            
            self.ctrl.stateTimeLbl.text = @"完成预定";
        }
            break;
        case 3:
        {
            if (self.orderCellType == EOrderCellTypeCourse)
            {
                [self.ctrl.btn1 addTarget:self action:@selector(pressedQuichang:) forControlEvents:UIControlEventTouchUpInside];
                [self.ctrl.btn1 setTitle:@"查看球场" forState:UIControlStateNormal];
            }
            if (self.orderCellType == EOrderCellTypeTaocan)
            {
                [self.ctrl.btn1 addTarget:self action:@selector(pressedQuichang:) forControlEvents:UIControlEventTouchUpInside];
                [self.ctrl.btn1 setTitle:@"查看套餐" forState:UIControlStateNormal];
            }
            
            [self.ctrl.btn2 addTarget:self action:@selector(pressedShare:) forControlEvents:UIControlEventTouchUpInside];
            [self.ctrl.btn2 setTitle:@"分享订单" forState:UIControlStateNormal];
            self.ctrl.btn3.hidden = YES;
            self.ctrl.btn4.hidden = YES;
            
            self.ctrl.stateTimeLbl.text = @"完成消费";
        }
            break;
        case 4:
        {
            if (self.orderCellType == EOrderCellTypeCourse)
            {
                [self.ctrl.btn1 addTarget:self action:@selector(pressedQuichang:) forControlEvents:UIControlEventTouchUpInside];
                [self.ctrl.btn1 setTitle:@"查看球场" forState:UIControlStateNormal];
            }
            if (self.orderCellType == EOrderCellTypeTaocan)
            {
                [self.ctrl.btn1 addTarget:self action:@selector(pressedQuichang:) forControlEvents:UIControlEventTouchUpInside];
                [self.ctrl.btn1 setTitle:@"查看套餐" forState:UIControlStateNormal];
            }
            
            [self.ctrl.btn2 addTarget:self action:@selector(pressedShare:) forControlEvents:UIControlEventTouchUpInside];
            [self.ctrl.btn2 setTitle:@"分享订单" forState:UIControlStateNormal];
            self.ctrl.btn3.hidden = YES;
            self.ctrl.btn4.hidden = YES;
            
            self.ctrl.stateTimeLbl.text = @"撤销申请";
        }
            break;
        case 5:
        {
            if (self.orderCellType == EOrderCellTypeCourse)
            {
                [self.ctrl.btn1 addTarget:self action:@selector(pressedQuichang:) forControlEvents:UIControlEventTouchUpInside];
                [self.ctrl.btn1 setTitle:@"查看球场" forState:UIControlStateNormal];
            }
            if (self.orderCellType == EOrderCellTypeTaocan)
            {
                [self.ctrl.btn1 addTarget:self action:@selector(pressedQuichang:) forControlEvents:UIControlEventTouchUpInside];
                [self.ctrl.btn1 setTitle:@"查看套餐" forState:UIControlStateNormal];
            }
            
            [self.ctrl.btn2 addTarget:self action:@selector(pressedShare:) forControlEvents:UIControlEventTouchUpInside];
            [self.ctrl.btn2 setTitle:@"分享订单" forState:UIControlStateNormal];
            self.ctrl.btn3.hidden = YES;
            self.ctrl.btn4.hidden = YES;
            
            self.ctrl.stateTimeLbl.text = @"已撤销";
        }
            break;
        case 6:
        {
            if (self.orderCellType == EOrderCellTypeCourse)
            {
                [self.ctrl.btn1 addTarget:self action:@selector(pressedQuichang:) forControlEvents:UIControlEventTouchUpInside];
                [self.ctrl.btn1 setTitle:@"查看球场" forState:UIControlStateNormal];
            }
            if (self.orderCellType == EOrderCellTypeTaocan)
            {
                [self.ctrl.btn1 addTarget:self action:@selector(pressedQuichang:) forControlEvents:UIControlEventTouchUpInside];
                [self.ctrl.btn1 setTitle:@"查看套餐" forState:UIControlStateNormal];
            }
            
            [self.ctrl.btn2 addTarget:self action:@selector(pressedShare:) forControlEvents:UIControlEventTouchUpInside];
            [self.ctrl.btn2 setTitle:@"分享订单" forState:UIControlStateNormal];
            self.ctrl.btn3.hidden = YES;
            self.ctrl.btn4.hidden = YES;
            
            self.ctrl.stateTimeLbl.text = @"已取消";
        }
            break;
        case 7:
        {
            if (self.orderCellType == EOrderCellTypeCourse)
            {
                [self.ctrl.btn1 addTarget:self action:@selector(pressedQuichang:) forControlEvents:UIControlEventTouchUpInside];
                [self.ctrl.btn1 setTitle:@"查看球场" forState:UIControlStateNormal];
            }
            if (self.orderCellType == EOrderCellTypeTaocan)
            {
                [self.ctrl.btn1 addTarget:self action:@selector(pressedQuichang:) forControlEvents:UIControlEventTouchUpInside];
                [self.ctrl.btn1 setTitle:@"查看套餐" forState:UIControlStateNormal];
            }
            
            [self.ctrl.btn2 addTarget:self action:@selector(pressedShare:) forControlEvents:UIControlEventTouchUpInside];
            [self.ctrl.btn2 setTitle:@"分享订单" forState:UIControlStateNormal];
            self.ctrl.btn3.hidden = YES;
            self.ctrl.btn4.hidden = YES;
            
            self.ctrl.stateTimeLbl.text = @"未到场";
        }
            break;
            
        default:
            break;
    }
}

- (void)dataDidChanged
{
    if (self.data)
    {
        NSDictionary* dict = self.data;
        if ([dict[@"type"] intValue] == 1)
        {
            self.orderCellType = EOrderCellTypeCourse;
        }
        else if ([dict[@"type"] intValue] == 2)
        {
            self.orderCellType = EOrderCellTypeTaocan;
        }
        switch (_orderCellType)
        {
            case EOrderCellTypeCourse:
            {
                [self _setupSelfCourseDict:dict];
            }
                break;
            case EOrderCellTypeTaocan:
            {
                [self _setupSelfTaocanDict:dict];
            }
                break;
                
            default:
                break;
        }
        
        
        
    }
}

#pragma mark -

- (void)pressedPay:(UIButton*)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(QiuchangOrderCell_iPhone:onPressedPay:)])
    {
        [self.delegate QiuchangOrderCell_iPhone:self onPressedPay:self.data];
    }
}

- (void)pressedQuichang:(UIButton*)btn
{
    switch (_orderCellType)
    {
        case EOrderCellTypeCourse:
        {
            QuichangDetailBoard_iPhone* board = [QuichangDetailBoard_iPhone boardWithNibName:@"QuichangDetailBoard_iPhone"];
            if (self.data)
            {
                [board setCourseId:((NSDictionary*)self.data)[@"price"][@"courseid"]];
            }
            UIView* view = self;
            BeeUIStack* stack = nil;
            while (view != nil)
            {
                if (view.board.stack != nil)
                {
                    stack = view.board.stack;
                    break;
                }
                view = [view superview];
            }
            [stack pushBoard:board animated:YES];
        }
            break;
        case EOrderCellTypeTaocan:
        {
            SirendingzhiDetailBoard_iPhone* board = [SirendingzhiDetailBoard_iPhone boardWithNibName:@"SirendingzhiDetailBoard_iPhone"];
            if (self.data)
            {
                [board setCustomId:((NSDictionary*)self.data)[@"courseid"]];
            }
            UIView* view = self;
            BeeUIStack* stack = nil;
            while (view != nil)
            {
                if (view.board.stack != nil)
                {
                    stack = view.board.stack;
                    break;
                }
                view = [view superview];
            }
            [stack pushBoard:board animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)pressedShare:(UIButton*)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(QiuchangOrderCell_iPhone:onPressedShare:)])
    {
        [self.delegate QiuchangOrderCell_iPhone:self onPressedShare:self.data];
    }
}

- (void)pressedCancel:(UIButton*)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(QiuchangOrderCell_iPhone:onPressedCancel:)])
    {
        [self.delegate QiuchangOrderCell_iPhone:self onPressedCancel:self.data];
    }
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
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"jpg"];
    
    
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
    
    NSString* title = @"高尔夫人士必备之应用";
    NSString* url = [[ServerConfig sharedInstance].baseUrl stringByAppendingFormat:@"/app/"];
    NSString* summary = [NSString stringWithFormat:@"我预订了 %@ %02d月%02d日 %@ %02d:%02d 的球场，欢迎一起打球哦",dict[@"coursename"],[date month],[date day],[date weekdayChinese],[date hour],[date minute]];
    
    if ([summary length] == 0)
    {
        summary = @"爱高高尔夫，爱上高尔夫";
    }
    
    NSString* collectedContent = [NSString stringWithFormat:@"【爱高高尔夫】%@ %@",title,url];
#endif
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:collectedContent
                                       defaultContent:collectedContent
                                                image:[ShareSDK imageWithPath:imagePath]
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
                                      thumbImage:[ShareSDK imageWithPath:imagePath]
                                           image:[ShareSDK imageWithPath:imagePath]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:summary
                                            title:title
                                              url:url
                                       thumbImage:[ShareSDK imageWithPath:imagePath]
                                            image:[ShareSDK imageWithPath:imagePath]
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制微信收藏信息
    [publishContent addWeixinFavUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                     content:summary
                                       title:title
                                         url:url
                                  thumbImage:[ShareSDK imageWithPath:imagePath]
                                       image:[ShareSDK imageWithPath:imagePath]
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


#pragma mark -

@interface QiuchangOrderCellViewController ()

@end

@implementation QiuchangOrderCellViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
