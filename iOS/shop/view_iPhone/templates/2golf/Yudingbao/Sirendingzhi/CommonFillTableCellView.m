//
//  CommonFillTableCellView.m
//  2golf
//
//  Created by Lee Justin on 14-5-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "CommonFillTableCellView.h"

@implementation CommonFillTableCellView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.masksToBounds=YES;
        //self.layer.cornerRadius=20.0;
        self.layer.borderWidth=0.5;
        self.layer.borderColor=[UIColor lightGrayColor].CGColor;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.layer.masksToBounds=YES;
        //self.layer.cornerRadius=20.0;
        self.layer.borderWidth=0.5;
        self.layer.borderColor=[UIColor lightGrayColor].CGColor;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.masksToBounds=YES;
        //self.layer.cornerRadius=20.0;
        self.layer.borderWidth=0.5;
        self.layer.borderColor=[UIColor lightGrayColor].CGColor;
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

@end
