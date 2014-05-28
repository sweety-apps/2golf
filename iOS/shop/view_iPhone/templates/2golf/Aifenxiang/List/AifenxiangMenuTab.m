//
//  AifenxiangMenuTab.m
//  2golf
//
//  Created by Lee Justin on 14-5-28.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "AifenxiangMenuTab.h"

@implementation AifenxiangMenuTab

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

-(void)awakeFromNib
{
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}

-(void)setTabTitleAndResizeTab:(NSString*)text
{
    CGRect rect = self.frame;
    CGFloat width = [text sizeWithFont:[self titleLabel].font].width;
    rect.size.width = width + 20;
    self.frame = rect;
    [self setTitle:text forState:UIControlStateNormal];
}

@end
