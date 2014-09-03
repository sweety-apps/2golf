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
        
        $(@"#coursename").TEXT( order[@"coursename"] );
        $(@"#orderstatus").TEXT( [self status2string] );
        
        if ([order[@"status"] intValue] == 1) {
            $(@"#orderstatus").TEXT( @"立即支付" );
        }
        BeeUILabel* lbl = $(@"#orderdescription");
        lbl.numberOfLines = 0;
        lbl.lineBreakMode = UILineBreakModeWordWrap;
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
