//
//  RememberPasswordView.m
//  2golf
//
//  Created by Lee Justin on 14-8-15.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "RememberPasswordView.h"

@implementation RememberPasswordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.checkBtn.layer.masksToBounds = YES;
    self.checkBtn.layer.borderWidth = 2.0;
    self.checkBtn.layer.borderColor = [UIColor colorWithRed:0.405 green:0.507 blue:0.611 alpha:1.000].CGColor;
    
    [self.checkBtn addTarget:self action:@selector(onpressedcheckbtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void) onpressedcheckbtn
{
    if (!self.checkBtn.selected)
    {
        self.checkBtn.selected = YES;
    }
    else
    {
        self.checkBtn.selected = NO;
    }
    
    if (self.delegate)
    {
        [self.delegate rememberPasswordSelected:self.checkBtn.selected];
    }
}

- (void)dealloc {
    [_checkBtn release];
    [super dealloc];
}
@end
