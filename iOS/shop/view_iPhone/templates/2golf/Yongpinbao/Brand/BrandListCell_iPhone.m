//
//  QiuChangOrderDetailCell.m
//  2golf
//
//  Created by rolandxu on 14-9-3.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "BrandListCell_iPhone.h"
#import "Bee_UILabel.h"
#import "ServerConfig.h"

@implementation BrandListCell_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
	[super load];
}

- (void)unload
{
	[super unload];
}

- (void)layoutDidFinish
{

}

- (void)dataDidChanged
{
    for (int i = 0; i < [self.subviews count]; i++) {
        if (i >= [self.data count]) {
            [self.subviews[i] setHidden:YES];
        }
        else
        {
            [self.subviews[i] setHidden:NO];
            NSString* brandurl = ((BRAND*)self.data[i]).photo.url;
            NSString* url = [NSString stringWithFormat:@"%@%@",[ServerConfig sharedInstance].baseUrl,brandurl];
             [(BeeUIImageView*)[self.subviews objectAtIndex:i] GET:url];
        }
       
    }
}

ON_SIGNAL3( BrandListCell_iPhone, img0, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onClickBrand:)])
        {
            [self.delegate onClickBrand:self.data[0]];
        }
    }
}

ON_SIGNAL3( BrandListCell_iPhone, img1, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onClickBrand:)])
        {
            [self.delegate onClickBrand:self.data[1]];
        }
    }
}

ON_SIGNAL3( BrandListCell_iPhone, img2, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onClickBrand:)])
        {
            [self.delegate onClickBrand:self.data[2]];
        }
    }
}
@end
