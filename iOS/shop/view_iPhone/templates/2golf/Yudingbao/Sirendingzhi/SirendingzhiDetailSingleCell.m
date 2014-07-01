//
//  SirendingzhiDetailSingleCell.m
//  2golf
//
//  Created by Lee Justin on 14-6-29.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "SirendingzhiDetailSingleCell.h"

@implementation SirendingzhiDetailSingleCell

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
    [self.bgBtn setBackgroundImage:[[self.bgBtn backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
}

- (void)setH
{
    [self.bgBtn setBackgroundImage:[__IMAGE(@"normallist_content_bg_h") stretched] forState:UIControlStateNormal];
}

- (void)setM
{
    [self.bgBtn setBackgroundImage:[__IMAGE(@"normallist_content_bg_m") stretched] forState:UIControlStateNormal];
}

- (void)setB
{
    [self.bgBtn setBackgroundImage:[__IMAGE(@"normallist_content_bg_t") stretched] forState:UIControlStateNormal];
}

- (void)dealloc {
    [_bgBtn release];
    [_leftLabel release];
    [_rightLabel release];
    [_rightArrowImageView release];
    [super dealloc];
}
@end
