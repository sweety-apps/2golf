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

@implementation QiuchangOrderCell_iPhoneLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

+ (QiuchangOrderCell_iPhoneLayout*)layoutWithDict:(NSDictionary*)dataDict
{
    if (dataDict == nil)
    {
        return nil;
    }
    
    CGRect desKeyRect = CGRectMake(0, 199, 56, 34);
    CGRect desKeyBgRect = CGRectMake(-1, 195, 56, 37);
    
    CGRect desContentRect = CGRectMake(57, 199, 113, 34);
    CGRect desContentBgRect = CGRectMake(55, 195, 120, 37);
    
    CGRect apxKeyRect = CGRectMake(0, 246, 56, 34);
    CGRect apxContentRect = CGRectMake(57, 246, 113, 34);
    
    CGRect btmBgRect = CGRectMake(0, 199, 320, 40);
    CGSize cellSize = CGSizeMake(320, 280);
    
    CGRect btn1Rect = CGRectMake(227, 152, 93, 40);
    CGRect btn2Rect = CGRectMake(227, 152, 93, 40);
    CGRect btn3Rect = CGRectMake(227, 152, 93, 40);
    CGRect btn4Rect = CGRectMake(227, 152, 93, 40);
    
    NSString* des = nil;
    des = dataDict[@"cancel_desc"];
    if ([des length] == 0)
    {
        des = dataDict[@"description"];
    }
    
    NSString* appendix = @" ";
    UIFont* font =[UIFont systemFontOfSize:16];
    
    CGSize desSize = [des sizeWithFont:font constrainedToSize:CGSizeMake(desContentRect.size.width, 999999) lineBreakMode:NSLineBreakByTruncatingTail];
    if (desSize.height < 90)
    {
        desSize.height = 90;
    }
    
    desContentRect.size.height = desSize.height;
    
    desContentBgRect.size.height = desSize.height + 10;
    
    desKeyRect.size.height = desSize.height;
    desKeyBgRect.size.height = desSize.height + 10;
    
    CGSize apxSize = [appendix sizeWithFont:font constrainedToSize:CGSizeMake(apxContentRect.size.width, 999999) lineBreakMode:NSLineBreakByTruncatingTail];
    apxContentRect.origin.y = CGRectGetMaxY(desKeyBgRect) + 5;
    apxContentRect.size.height = apxSize.height;
    
    apxKeyRect.origin.y = apxContentRect.origin.y;
    apxKeyRect.size.height = apxContentRect.size.height;
    
    cellSize.height = CGRectGetMaxY(apxContentRect) + 10;
    
    btmBgRect.size.height = cellSize.height - btmBgRect.origin.y;
    
    //计算btn
    CGFloat btnHeight = cellSize.height - 5 - btn1Rect.origin.y;
    btnHeight /= 4;
    
    btn1Rect.size.height = btnHeight + 1;
    
    btn2Rect.origin.y = CGRectGetMaxY(btn1Rect) - 1;
    btn2Rect.size.height = btnHeight + 1;
    
    btn3Rect.origin.y = CGRectGetMaxY(btn2Rect) - 1;
    btn3Rect.size.height = btnHeight + 1;
    
    btn4Rect.origin.y = CGRectGetMaxY(btn3Rect) - 1;
    btn4Rect.size.height = btnHeight + 1;
    
    QiuchangOrderCell_iPhoneLayout* ret = [[[QiuchangOrderCell_iPhoneLayout alloc] init] autorelease];
    
    ret.descriptionKeyLblRect = desKeyRect;
    ret.descriptionKeyBgImageViewRect = desKeyBgRect;
    ret.descriptionTimeLblRect = desContentRect;
    ret.descriptionBgImageViewRect = desContentBgRect;
    
    ret.appendixKeyLblRect = apxKeyRect;
    ret.appendixLblRect = apxContentRect;
    ret.bottomBgImageViewRect = btmBgRect;
    
    ret.btn1Rect = btn1Rect;
    ret.btn2Rect = btn2Rect;
    ret.btn3Rect = btn3Rect;
    ret.btn4Rect = btn4Rect;
    
    ret.cellSize = cellSize;
    
    return ret;
    
}

@end


#pragma mark -

@interface QiuchangOrderCell_iPhone () <ISSShareViewDelegate>

@end

#pragma mark -

@implementation QiuchangOrderCell_iPhone

-(void)setOrderCellType:(EOrderCellType)orderCellType
{
    _orderCellType = orderCellType;
}

- (void)setCellLayout:(QiuchangOrderCell_iPhoneLayout*)layout
{
    self.frame = CGRectMake(0, 0, layout.cellSize.width, layout.cellSize.height);
    self.ctrl.view.frame = self.frame;
    
    self.ctrl.btn1.frame = layout.btn1Rect;
    self.ctrl.btn2.frame = layout.btn2Rect;
    self.ctrl.btn3.frame = layout.btn3Rect;
    self.ctrl.btn4.frame = layout.btn4Rect;
    
    self.ctrl.appendixKeyLbl.frame = layout.appendixKeyLblRect;
    self.ctrl.appendixLbl.frame = layout.appendixLblRect;
    self.ctrl.descriptionKeyLbl.frame = layout.descriptionKeyLblRect;
    self.ctrl.descriptionTimeLbl.frame = layout.descriptionTimeLblRect;
    self.ctrl.descriptionKeyBgImageView.frame = layout.descriptionKeyBgImageViewRect;
    self.ctrl.descriptionBgImageView.frame = layout.descriptionBgImageViewRect;
    self.ctrl.bottomBgImageView.frame = layout.bottomBgImageViewRect;
}

- (void)load
{
    [super load];
    
    self.ctrl = [[QiuchangOrderCellViewController alloc] initWithNibName:@"QiuchangOrderCellViewController" bundle:nil];
    self.frame = self.ctrl.view.frame;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.ctrl.view];
    self.ctrl.bottomBgImageView.image = [self.ctrl.bottomBgImageView.image stretched];
    self.ctrl.descriptionBgImageView.image = [self.ctrl.descriptionBgImageView.image stretched];
    self.ctrl.descriptionKeyBgImageView.image = [self.ctrl.descriptionKeyBgImageView.image stretched];
    
    UIImage* btnBgImage = [self.ctrl.btn1 backgroundImageForState:UIControlStateNormal];
    btnBgImage = [btnBgImage stretched];
    [self.ctrl.btn1 setBackgroundImage:btnBgImage forState:UIControlStateNormal];
    [self.ctrl.btn2 setBackgroundImage:btnBgImage forState:UIControlStateNormal];
    [self.ctrl.btn3 setBackgroundImage:btnBgImage forState:UIControlStateNormal];
    [self.ctrl.btn4 setBackgroundImage:btnBgImage forState:UIControlStateNormal];
    
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
    self.ctrl.courseKeyLbl.text = @"球场";
    self.ctrl.playTimeTitleLbl.text = @"打球";
    self.ctrl.peopleTimeTitleLbl.text = @"人员";
    
    NSString* titleStr = dict[@"coursename"];
    NSString* distrbutorName = dict[@"price"][@"distributorname"];
    if (distrbutorName && [distrbutorName isKindOfClass:[NSString class]])
    {
        titleStr = [titleStr stringByAppendingFormat:@"(服务商:%@)",distrbutorName];
    }
    self.ctrl.courseNameLbl.text = titleStr;
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
    //[self resizeFontOfDesLabel];
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
    
    NSString* ret = [NSString stringWithFormat:@"%02d月%02d日 %02d:%02d\n%@",[date month],[date day],[date hour],[date minute],[date weekdayChinese]];
    return ret;
}

- (void)resizeFontOfDesLabel
{
    self.ctrl.descriptionTimeLbl.font = [UIFont systemFontOfSize:14.0f];
    CGSize size = self.ctrl.descriptionTimeLbl.frame.size;
    size = [self.ctrl.descriptionTimeLbl.text sizeWithFont:self.ctrl.descriptionTimeLbl.font constrainedToSize:CGSizeMake(self.ctrl.descriptionTimeLbl.frame.size.width, 999999) lineBreakMode:NSLineBreakByTruncatingTail];
    if (size.height > self.ctrl.descriptionTimeLbl.frame.size.height)
    {
        self.ctrl.descriptionTimeLbl.font = [UIFont systemFontOfSize:8.0f];
    }
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
    self.ctrl.courseKeyLbl.text = @"套餐";
    self.ctrl.playTimeTitleLbl.text = @"出行";
    self.ctrl.peopleTimeTitleLbl.text = @"人员";
    
    NSString* titleStr = dict[@"coursename"];
    
    self.ctrl.courseNameLbl.text = titleStr;
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
    //[self resizeFontOfDesLabel];
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
    
    self.ctrl.stateTimeLbl.textColor = [UIColor colorWithRed:0.064 green:0.266 blue:0.148 alpha:1.000];
    
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
            
            self.ctrl.stateTimeLbl.textColor = [UIColor colorWithRed:0.974 green:0.337 blue:0.107 alpha:1.000];
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
            
            self.ctrl.stateTimeLbl.textColor = [UIColor colorWithRed:0.974 green:0.337 blue:0.107 alpha:1.000];
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
            
            self.ctrl.stateTimeLbl.text = @"完成预订";
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
            
            self.ctrl.stateTimeLbl.textColor = [UIColor colorWithRed:0.974 green:0.337 blue:0.107 alpha:1.000];
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
    NSString *imagePath = nil;
    
    
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
