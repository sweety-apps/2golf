//
//  ExtractViewUICell.m
//  2golf
//
//  Created by Lee Justin on 14-6-28.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "ExtractViewUICell.h"
#import "ChargeValueView.h"
#import "ChargeConfirmView.h"
#import "UserModel.h"

@implementation ExtractViewUICell

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
}

- (void)dealloc {
    [_yueLabel release];
    [_shouxufeiLabel release];
    [_zongjineLabel release];
    [_kaihuhangTextField release];
    [_yinhangzhanghaoTextField release];
    [_humingTextField release];
    [_tixianjineTextField release];
    [_passwordField release];
    [_confirmBtn release];
    [super dealloc];
}

- (void)dataDidChanged
{
    self.yueLabel.text = [NSString stringWithFormat:@"￥%@",[UserModel sharedInstance].user.user_money];
    self.shouxufeiLabel.text = @"￥5";
    self.zongjineLabel.text = @"￥0";
}

- (IBAction)pressedConfirmBtn:(id)sender
{
    if ([self.kaihuhangTextField.text length] <= 5)
    {
        [[self recursiveFindUIBoard] presentMessageTips:@"请输入正确的开户行名称"];
        return;
    }
    if ([self.yinhangzhanghaoTextField.text length] <= 5)
    {
        [[self recursiveFindUIBoard] presentMessageTips:@"请输入接收的银行账号"];
        return;
    }
    if ([self.humingTextField.text length] <= 0)
    {
        [[self recursiveFindUIBoard] presentMessageTips:@"请输入您的户名"];
        return;
    }
    if ([self.tixianjineTextField.text length] <= 0)
    {
        [[self recursiveFindUIBoard] presentMessageTips:@"请输入提现金额"];
        return;
    }
    if ([self.passwordField.text length] <= 0)
    {
        [[self recursiveFindUIBoard] presentMessageTips:@"请输入您的登陆密码"];
        return;
    }
    
    double value = [self.tixianjineTextField.text doubleValue];
    if (value < 50)
    {
        [[self recursiveFindUIBoard] presentMessageTips:@"提现金额不能小于50元"];
        return;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(extractViewUICell:confirmedValue:)])
    {
        [self.delegate extractViewUICell:self confirmedValue:nil];
    }
}
@end
