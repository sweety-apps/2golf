//
//  CitySelectCell.m
//  2golf
//
//  Created by Lee Justin on 14-4-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "CitySelectCell.h"

@implementation CitySelectCell

@synthesize cellBg;
@synthesize cellTitle;
@synthesize rightPullBtn;

- (void)dataDidChanged
{
    
}

- (void)setBeHeaderH
{
    [self.cellBg setBackgroundImage:[__IMAGE(@"normallist_head_content_bg_h") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
    
    self.cellBg.userInteractionEnabled = NO;
    
    self.cellTitle.textColor = RGBA(16, 88, 32, 1.0f);
    
    self.rightPullBtn.hidden = YES;
    self.rightPullBtn.image = __IMAGE(@"expand_down");
}

- (void)setBeHeaderM
{
    [self.cellBg setBackgroundImage:[__IMAGE(@"normallist_head_content_bg_m") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
    
    self.cellBg.userInteractionEnabled = NO;
    
    self.cellTitle.textColor = RGBA(16, 88, 32, 1.0f);
    
    self.rightPullBtn.hidden = YES;
    self.rightPullBtn.image = __IMAGE(@"expand_down");
}

- (void)setBeHeaderB
{
    [self.cellBg setBackgroundImage:[__IMAGE(@"normallist_head_content_bg_t") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
    
    self.cellBg.userInteractionEnabled = NO;
    
    self.cellTitle.textColor = RGBA(16, 88, 32, 1.0f);
    
    self.rightPullBtn.hidden = YES;
    self.rightPullBtn.image = __IMAGE(@"expand_down");
}

- (void)setBeHeaderS
{
    [self.cellBg setBackgroundImage:[__IMAGE(@"normallist_head_content_bg_s") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
    
    self.cellBg.userInteractionEnabled = NO;
    
    self.cellTitle.textColor = RGBA(16, 88, 32, 1.0f);
    
    self.rightPullBtn.hidden = YES;
    self.rightPullBtn.image = __IMAGE(@"expand_down");
}

- (void)setBeContentH
{
    [self.cellBg setBackgroundImage:[__IMAGE(@"normallist_content_bg_h") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
    
    self.cellBg.userInteractionEnabled = YES;
    
    self.cellTitle.textColor = RGBA(150, 154, 157, 1.0f);
    
    self.rightPullBtn.hidden = YES;
    self.rightPullBtn.image = __IMAGE(@"expand_down");
}

- (void)setBeContentM
{
    [self.cellBg setBackgroundImage:[__IMAGE(@"normallist_content_bg_m") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
    
    self.cellBg.userInteractionEnabled = YES;
    
    self.cellTitle.textColor = RGBA(150, 154, 157, 1.0f);
    
    self.rightPullBtn.hidden = YES;
    self.rightPullBtn.image = __IMAGE(@"expand_down");
}

- (void)setBeContentB
{
    [self.cellBg setBackgroundImage:[__IMAGE(@"normallist_content_bg_t") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
    
    self.cellBg.userInteractionEnabled = YES;
    
    self.cellTitle.textColor = RGBA(150, 154, 157, 1.0f);
    
    self.rightPullBtn.hidden = YES;
    self.rightPullBtn.image = __IMAGE(@"expand_down");
}

- (void)setBeContentS
{
    [self.cellBg setBackgroundImage:[__IMAGE(@"normallist_content_bg_s") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
    
    self.cellBg.userInteractionEnabled = YES;
    
    self.cellTitle.textColor = RGBA(150, 154, 157, 1.0f);
    
    self.rightPullBtn.hidden = YES;
    self.rightPullBtn.image = __IMAGE(@"expand_down");
}

- (void)setBeContentExpH
{
    [self.cellBg setBackgroundImage:[__IMAGE(@"normallist_content_bg_h") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
    
    self.cellBg.userInteractionEnabled = YES;
    
    self.cellTitle.textColor = RGBA(150, 154, 157, 1.0f);
    
    self.rightPullBtn.hidden = NO;
    self.rightPullBtn.image = __IMAGE(@"expand_left");
}

- (void)setBeContentExpM
{
    [self.cellBg setBackgroundImage:[__IMAGE(@"normallist_content_bg_m") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
    
    self.cellBg.userInteractionEnabled = YES;
    
    self.cellTitle.textColor = RGBA(150, 154, 157, 1.0f);
    
    self.rightPullBtn.hidden = NO;
    self.rightPullBtn.image = __IMAGE(@"expand_left");
}

- (void)setBeContentExpB
{
    [self.cellBg setBackgroundImage:[__IMAGE(@"normallist_content_bg_t") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
    
    self.cellBg.userInteractionEnabled = YES;
    
    self.cellTitle.textColor = RGBA(150, 154, 157, 1.0f);
    
    self.rightPullBtn.hidden = NO;
    self.rightPullBtn.image = __IMAGE(@"expand_left");
}

- (void)setBeContentExpS
{
    [self.cellBg setBackgroundImage:[__IMAGE(@"normallist_content_bg_s") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
    
    self.cellBg.userInteractionEnabled = YES;
    
    self.cellTitle.textColor = RGBA(150, 154, 157, 1.0f);
    
    self.rightPullBtn.hidden = NO;
    self.rightPullBtn.image = __IMAGE(@"expand_left");
}

- (void)setExpand:(BOOL)exp
{
    NSString* image = @"";
    
    if (exp)
    {
        image = @"expand_down";
    }
    else
    {
        image = @"expand_left";
    }
    
    self.rightPullBtn.image = __IMAGE(image);
}

@end
