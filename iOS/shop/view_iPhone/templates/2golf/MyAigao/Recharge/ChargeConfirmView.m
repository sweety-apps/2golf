//
//  ChargeConfirmView.m
//  2golf
//
//  Created by Lee Justin on 14-6-28.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "ChargeConfirmView.h"

@implementation ChargeConfirmView

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

- (void)dealloc {
    [_valueTextField release];
    [_confirmBtn release];
    [super dealloc];
}
- (IBAction)comfirmCharge:(id)sender {
}
@end
