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
    int count = [(NSArray*)self.data count];
    $(@"#img0").HIDE();$(@"#img1").HIDE();$(@"#img2").HIDE();
    $(@"#btn0").HIDE();$(@"#btn1").HIDE();$(@"#btn2").HIDE();
    if (count == 3) {
        NSString* brandurl = @"";
        NSString* url = @"";
        
        $(@"#img0").SHOW();
        $(@"#btn0").SHOW();
        brandurl = ((BRAND*)self.data[0]).photo.url;
        url = [NSString stringWithFormat:@"%@%@",[ServerConfig sharedInstance].baseUrl,brandurl];
        $(@"#img0").IMAGE(url);
        
        $(@"#img1").SHOW();
        $(@"#btn1").SHOW();
        brandurl = ((BRAND*)self.data[1]).photo.url;
        url = [NSString stringWithFormat:@"%@%@",[ServerConfig sharedInstance].baseUrl,brandurl];
        $(@"#img1").IMAGE(url);
        
        $(@"#img2").SHOW();
        $(@"#btn2").SHOW();
        brandurl = ((BRAND*)self.data[2]).photo.url;
        url = [NSString stringWithFormat:@"%@%@",[ServerConfig sharedInstance].baseUrl,brandurl];
        $(@"#img2").IMAGE(url);
        
    }
    else if(count == 2)
    {
        NSString* brandurl = @"";
        NSString* url = @"";
        
        $(@"#img0").SHOW();
        $(@"#btn0").SHOW();
        brandurl = ((BRAND*)self.data[0]).photo.url;
        url = [NSString stringWithFormat:@"%@%@",[ServerConfig sharedInstance].baseUrl,brandurl];
        $(@"#img0").IMAGE(url);
        
        $(@"#img1").SHOW();
        $(@"#btn1").SHOW();
        brandurl = ((BRAND*)self.data[1]).photo.url;
        url = [NSString stringWithFormat:@"%@%@",[ServerConfig sharedInstance].baseUrl,brandurl];
        $(@"#img1").IMAGE(url);
        
    }
    else if(count == 1)
    {
        NSString* brandurl = @"";
        NSString* url = @"";
        
        $(@"#img0").SHOW();
        $(@"#btn0").SHOW();
        brandurl = ((BRAND*)self.data[0]).photo.url;
        url = [NSString stringWithFormat:@"%@%@",[ServerConfig sharedInstance].baseUrl,brandurl];
        $(@"#img0").IMAGE(url);
        
    }
    else
    {
        
    }
}

ON_SIGNAL3( BrandListCell_iPhone, btn0, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onClickBrand:)])
        {
            [self.delegate onClickBrand:self.data[0]];
        }
    }
}

ON_SIGNAL3( BrandListCell_iPhone, btn1, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onClickBrand:)])
        {
            [self.delegate onClickBrand:self.data[1]];
        }
    }
}

ON_SIGNAL3( BrandListCell_iPhone, btn2, signal )
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
