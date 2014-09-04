//
//  QiuChangOrderDetailCell.m
//  2golf
//
//  Created by rolandxu on 14-9-3.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuChangOrderDetailCell.h"
#import "Bee_UILabel.h"

@implementation QiuChangOrderDetailCell

SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
	[super load];
}

- (void)unload
{
	[super unload];
}

ON_SIGNAL3( QiuChangOrderDetailCell, orderagain, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(onPressOrderAgain:)])
//        {
//            [self.delegate onPressOrderAgain:self.data];
//        }
    }
}

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
    CGSize size = CGSizeMake( width, 640 );
    return size;
}

- (void)layoutDidFinish
{

}

- (void)dataDidChanged
{
    if ( self.data )
    {
        NSDictionary * order = self.data;
        NSString* priceString = @"";
        NSNumber* persons = order[@"persons"];
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
        $(@"#coursename").TEXT( order[@"coursename"] );
        $(@"#status").TEXT( [self status2string] );
        
        if ([order[@"status"] intValue] == 1) {
            $(@"#orderstatus").TEXT( @"立即支付" );
        }
        $(@"#playtimetips").TEXT( ([order[@"type"] intValue] == 1)?@"打球时间":@"出行时间");
        $(@"#playtime").TEXT( [self tsStringToDateString:order[@"playtime"]] );
        
        NSString* players = order[@"players"];
        NSString* contact = [NSString stringWithFormat:@"%d人%@",[persons intValue],players];
        $(@"#contact").TEXT(contact);
        
        UILabel* distributor = (UILabel*)[self findSubViewByID:@"distributor"];
        $(@"distributor").TEXT(([order[@"type"] intValue] == 1)?order[@"price"][@"distributorname"]:@"");
        distributor.hidden = ([order[@"type"] intValue] != 1);
        [self findSubViewByID:@"distributortips"].hidden = ([order[@"type"] intValue] != 1);
        
        
        
        $(@"ordertime").TEXT([self tsStringToDateString:order[@"createtime"]]);
        

        UIButton* cancelbtn = (UIButton*)[self findSubViewByID:@"ordercancel"];
        cancelbtn.hidden = ([order[@"status"] intValue] == 6 || [order[@"status"] intValue] == 3 || [order[@"status"] intValue]);
        
        BeeUIQuery* lblarray = $(@"#orderdescription");
        UILabel* lbl = (UILabel*)[lblarray.views objectAtIndex:0];
        lbl.numberOfLines = 0;
        lbl.lineBreakMode = UILineBreakModeWordWrap;
        [lbl setText:[NSString stringWithFormat:@"%@\n%@",order[@"description"],order[@"cancel_desc"] == nil?@"":order[@"cancel_desc"]]];
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

- (NSString*)tsStringToDateString:(NSString*)tsStr
{
    NSTimeInterval iterval = [tsStr doubleValue];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:iterval];
    
    NSString* ret = [NSString stringWithFormat:@"%02d月%02d日 %02d:%02d\n%@",[date month],[date day],[date hour],[date minute],[date weekdayChinese]];
    return ret;
}

-(UIView*)findSubViewByID:(NSString*)id
{
    BeeUIQuery* viewarray = $([NSString stringWithFormat:@"#%@",id]);
    if(viewarray.views.count != 0)
    {
        UIView* view = (UIButton*)[viewarray.views objectAtIndex:0];
        return view;
    }
    return nil;
}
@end
