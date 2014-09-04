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
    NSNumber* persons = order[@"persons"];
    NSString* players = order[@"players"];
    NSString* contact = [NSString stringWithFormat:@"%d人%@",[persons intValue],players];
    $(@"#contact").TEXT( contact );
    $(@"#time").TEXT( [self tsStringToDateString:order[@"playtime"]] );
    NSString* priceString = @"";
    if ([order[@"type"] intValue] == 1)//courseorder
    {
        NSObject* teetimeprice = order[@"price"][@"teetimeprice"];
        switch ([order[@"price"][@"payway"] intValue]) {
            case 3://全額預付
                priceString = [NSString stringWithFormat:@"￥%d",(teetimeprice == nil || ![teetimeprice isKindOfClass:[NSDictionary class]]?[order[@"price"][@"price"] intValue]:[order[@"price"][@"teetimeprice"][@"price"] intValue])*[persons intValue]];
                break;
            case 4://部分預付
                priceString = [NSString stringWithFormat:@"￥%d",([order[@"price"][@"deposit"] intValue]*[order[@"persons"] intValue])];
                break;
            case 2://前臺現付
                if([order[@"price"][@"deposit"] intValue] > 0)
                {
                    priceString = [NSString stringWithFormat:@"￥%d",[order[@"price"][@"deposit"] intValue]];
                }
                else
                {
                    priceString = @"线上免付";
                }
                break;
            default:
                break;
        }
    }
    else //套餐訂單
    {
        switch ([order[@"payway"] intValue]) {
            case 3:
                priceString = [NSString stringWithFormat:@"￥%d",([order[@"price"] intValue]*[order[@"persons"] intValue])];
                break;
            case 2:
                priceString = @"线上免付";
                break;
            default:
                break;
        }
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

ON_SIGNAL3( CourseOrderCellFooter_iPhone, orderagain, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onPressOrderAgain:)])
        {
            [self.delegate onPressOrderAgain:self.data];
        }
    }
}

- (void)dataDidChanged
{
}

@end

@implementation CourseOrderCellHeader_iPhone

SUPPORT_RESOURCE_LOADING( YES )

ON_SIGNAL3( CourseOrderCellHeader_iPhone, orderstatus, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        NSDictionary * order = self.data;
        if ([order[@"status"] intValue] == 1) {
            //立即支付
            if (self.delegate && [self.delegate respondsToSelector:@selector(onPressPay:)])
            {
                [self.delegate onPressPay:self.data];
            }
        }
    }
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        NSDictionary * order = self.data;
        
        $(@"#coursename").TEXT( order[@"coursename"] );
        $(@"#orderstatus").TEXT( [self status2string] );
        
        if ([order[@"status"] intValue] == 1) {
            $(@"#orderstatus").TEXT( @"立即支付" );
        }
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
    return @"";
}

@end

@implementation CourseOrderCellBody_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
//    ORDER_GOODS * goods = self.data;
    
//    $(@"#order-goods-count").TEXT( [NSString stringWithFormat:@"X %@", goods.goods_number] );
//    $(@"#order-goods-price").TEXT( goods.formated_shop_price );
//    $(@"#order-goods-title").TEXT( goods.name );
//    $(@"#order-goods-photo").IMAGE( goods.img.thumbURL );
}

@end


@implementation QiuchangOrderCell_iPhoneV2

DEF_SIGNAL( TOUCHED )

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
    
    self.tappable = YES;
	self.tapSignal = self.TOUCHED;
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
        cell.delegate = self;
        return cell;
    }
    else if( (count - 1) == index )
    {
        CourseOrderCellFooter_iPhone * cell = [scrollView dequeueWithContentClass:[CourseOrderCellFooter_iPhone class]];
        cell.data = self.courseorder;
        cell.delegate = self;
        return cell;
    }
    else if( (count - 2) == index )
    {
        CourseOrderCellInfo_iPhone * cell = [scrollView dequeueWithContentClass:[CourseOrderCellInfo_iPhone class]];
        cell.data = self.courseorder;
        cell.delegate = self;
        return cell;
    }
    else
    {
        CourseOrderCellBody_iPhone * cell = [scrollView dequeueWithContentClass:[CourseOrderCellBody_iPhone class]];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.data = self.courseorder;
        cell.delegate = self;
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
        size = CGSizeMake(320, 70);
    }
    else if( (count - 2) == index )
    {
        size = CGSizeMake(320, 70);
    }
    else
    {
        size = CGSizeMake(320, 50);
    }
    
	return size;
}

#pragma mark CourseOrderCellHeader_iPhoneDelegate
-(void)onPressPay:(NSDictionary*)courseorder
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPressPay:)])
    {
        [self.delegate onPressPay:self.courseorder];
    }
}

#pragma mark CourseOrderCellFooter_iPhoneDelegate
-(void)onPressOrderAgain:(NSDictionary*)courseorder
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPressOrderAgain:)])
    {
        [self.delegate onPressOrderAgain:self.courseorder];
    }
}
@end
