//
//  QiuchangOrderCell_iPhoneV2.m
//  2golf
//
//  Created by rolandxu on 14-8-25.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangOrderCell_iPhoneV2.h"

@implementation CourseOrderCellInfo_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
    NSDictionary* order = self.data;
    
    $(@"#contact").TEXT( [NSString stringWithFormat:@"%@人%@",[order[@"persons"] stringValue],[order[@"players"] stringValue]] );
    $(@"#time").TEXT( [self tsStringToDateString:[order[@"playtime"] stringValue]] );
    NSString* priceString = @"";
    if ([order[@"type"] intValue] == 1)//courseorder
    {
        switch ([order[@"normalprice"][@"payway"] intValue]) {
            case 3://全額預付
                priceString = [NSString stringWithFormat:@"￥%d",order[@"normalprice"][@"teetimeprice"] == nil?[order[@"normalprice"][@"price"] intValue]:[order[@"normalprice"][@"teetimeprice"][@"price"] intValue]];
                break;
            case 4://部分預付
                priceString = [NSString stringWithFormat:@"￥%d",([order[@"normalprice"][@"deposit"] intValue]*[order[@"persons"] intValue])];
                break;
            case 2://前臺現付
                if
                break;
            default:
                break;
        }
    }
    else //套餐訂單
    {
        
    }
    $(@"#price").TEXT( priceString );
}

- (NSString*)tsStringToDateString:(NSString*)tsStr
{
    NSTimeInterval iterval = [tsStr doubleValue];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:iterval];
    
    NSString* ret = [NSString stringWithFormat:@"%02d月%02d日 %02d:%02d\n%@",[date month],[date day],[date hour],[date minute],[date weekdayChinese]];
    return ret;
}

@end

@implementation CourseOrderCellFooter_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
}

@end

@implementation CourseOrderCellHeader_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
    if ( self.data )
    {
        NSDictionary * order = self.data;
        
        $(@"#coursename").TEXT( order[@"coursename"] );
        $(@"#orderstatus").TEXT( [self status2string] );
    }
}

-(NSString*)status2string
{
    NSDictionary * order = self.data;
    switch ([order[@"status"] intValue]) {
        case 0:
            return @"待确认";
        case 1:
            return @"待付款";
        case 2:
            return @"已付款";
        case 3:
            return @"已成功";
        case 4:
            return @"已申请撤销";
        case 5:
            return @"已撤销";
        case 6:
            return @"已取消";
        case 7:
            return @"未到场";
            
        default:
            break;
    }
}
@end

@implementation CourseOrderCellBody_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
    ORDER_GOODS * goods = self.data;
    
//    $(@"#order-goods-count").TEXT( [NSString stringWithFormat:@"X %@", goods.goods_number] );
//    $(@"#order-goods-price").TEXT( goods.formated_shop_price );
//    $(@"#order-goods-title").TEXT( goods.name );
//    $(@"#order-goods-photo").IMAGE( goods.img.thumbURL );
}

@end


@implementation QiuchangOrderCell_iPhoneV2

DEF_SIGNAL( ORDER_CANCEL )
DEF_SIGNAL( ORDER_PAY )

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
    CGSize size = CGSizeMake( width, 195 + 90 );
    return size;
}

- (void)layoutDidFinish
{
    _scroll.frame = CGRectMakeBound(self.width, self.height);
	[_scroll reloadData];
}

- (void)load
{
    [super load];
    
    _scroll = [[BeeUIScrollView alloc] init];
    _scroll.scrollEnabled = NO;
    _scroll.dataSource = self;
    [self addSubview:_scroll];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _scroll );
    
    [super unload];
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        self.courseorder = self.data;
        
        [_scroll reloadData];
    }
}

ON_SIGNAL3( AwaitPayCellFooter_iPhone, cancel, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.ORDER_CANCEL];
    }
}

ON_SIGNAL3( AwaitPayCellFooter_iPhone, pay, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.ORDER_PAY];
    }
}

#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    NSUInteger count =  1;
    
    if ( count )
    {
        count += 2;
    }
    
	return count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    NSUInteger count =  1;
    
    if ( count )
    {
        count += 2;
    }
    
    if ( 0 == index )
    {
        CourseOrderCellHeader_iPhone * cell = [scrollView dequeueWithContentClass:[CourseOrderCellHeader_iPhone class]];
        cell.data = self.courseorder;
        return cell;
    }
    else if( (count - 1) == index )
    {
        CourseOrderCellFooter_iPhone * cell = [scrollView dequeueWithContentClass:[CourseOrderCellFooter_iPhone class]];
        cell.data = self.courseorder;
        return cell;
    }
    else if( (count - 2) == index )
    {
        CourseOrderCellInfo_iPhone * cell = [scrollView dequeueWithContentClass:[CourseOrderCellInfo_iPhone class]];
        cell.data = self.courseorder;
//        cell.formated_integral_money = self.order.formated_integral_money;
//        cell.formated_bonus = self.order.formated_bonus;
//        cell.formated_shipping_fee = self.order.formated_shipping_fee;
        cell.data = nil;
        return cell;
    }
    else
    {
        CourseOrderCellBody_iPhone * cell = [scrollView dequeueWithContentClass:[CourseOrderCellBody_iPhone class]];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.data = self.courseorder;
        return cell;
    }
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    NSUInteger count =  1;
    
    if ( count )
    {
        count += 2;
    }
    
    CGSize size = CGSizeZero;
    
    if ( 0 == index )
    {
        size = CGSizeMake(320, 50);
    }
    else if( (count - 1) == index )
    {
        size = CGSizeMake(320, 90);
    }
    else if( (count - 2) == index )
    {
        size = CGSizeMake(320, 70);
    }
    else
    {
        size = CGSizeMake(320, 90);
    }
    
	return size;
}
@end
