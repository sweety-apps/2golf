//
//  RechargeViewUICell.m
//  2golf
//
//  Created by Lee Justin on 14-6-28.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "RechargeViewUICell.h"
#import "ChargeValueView.h"
#import "ChargeConfirmView.h"
#import "NibLoader.h"

@interface RechargeViewUICell ()

@property (nonatomic,retain) NSArray* chargeValues;

@end

@implementation RechargeViewUICell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    self.chargeValues = @[@1000,@2000,@5000,@10000,@20000,@50000];
    
    CGFloat startY = 38;
    
    for (int i = 0; i < self.chargeValues.count; ++i)
    {
        NSNumber* value = self.chargeValues[i];
        ChargeValueView* v = CREATE_NIBVIEW(@"ChargeValueView");
        v.valueLabel.text = [NSString stringWithFormat:@"￥%@",value];
        CGRect rect = v.frame;
        rect.origin.y = startY;
        v.tag = i;
        v.button.tag = i;
        [v.button addTarget:self action:@selector(_pressedValue:) forControlEvents:UIControlEventTouchUpInside];
        v.frame = rect;
        startY+=rect.size.height;
        [self addSubview:v];
    }
    
    ChargeConfirmView* v = CREATE_NIBVIEW(@"ChargeConfirmView");
    CGRect rect = v.frame;
    rect.origin.y = startY;
    v.frame = rect;
    startY+=rect.size.height;
    [v.confirmBtn addTarget:self action:@selector(_pressedConfirm:) forControlEvents:UIControlEventTouchUpInside];
    
    self.confirmView = v;
    
    [self addSubview:v];
    
    self.frame = CGRectMake(0, 0, 320, startY);
}

- (void)_pressedValue:(UIButton*)btn
{
    self.confirmView.valueTextField.text = [NSString stringWithFormat:@"%@",self.chargeValues[btn.tag]];
}

- (void)_pressedConfirm:(UIButton*)btn
{
    double value = [self.confirmView.valueTextField.text doubleValue];
    if (value < 0.01)
    {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(rechargeViewUICell:confirmedValue:)])
    {
        [self.delegate rechargeViewUICell:self confirmedValue:[NSNumber numberWithDouble:value]];
    }
}

@end
