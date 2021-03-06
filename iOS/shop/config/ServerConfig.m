/*
 *                                                                          
 *       _/_/_/                      _/        _/_/_/_/_/                     
 *    _/          _/_/      _/_/    _/  _/          _/      _/_/      _/_/    
 *   _/  _/_/  _/_/_/_/  _/_/_/_/  _/_/          _/      _/    _/  _/    _/   
 *  _/    _/  _/        _/        _/  _/      _/        _/    _/  _/    _/    
 *   _/_/_/    _/_/_/    _/_/_/  _/    _/  _/_/_/_/_/    _/_/      _/_/       
 *                                                                          
 *
 *  Copyright 2013-2014, Geek Zoo Studio
 *  http://www.ecmobile.cn/license.html
 *
 *  HQ China:
 *    2319 Est.Tower Van Palace 
 *    No.2 Guandongdian South Street 
 *    Beijing , China
 *
 *  U.S. Office:
 *    One Park Place, Elmira College, NY, 14901, USA
 *
 *  QQ Group:   329673575
 *  BBS:        bbs.ecmobile.cn
 *  Fax:        +86-10-6561-5510
 *  Mail:       info@geek-zoo.com
 */

#import "ServerConfig.h"

#pragma mark -

@implementation ServerConfig

DEF_SINGLETON( ServerConfig )

@synthesize url = _url;
@synthesize baseUrl = _baseUrl;

- (id)init
{
	self = [super init];
	if ( self )
	{
        //self.url = @"http://shop.ecmobile.me/ecmobile/?url=";
        //self.baseUrl = @"http://shop.ecmobile.me";
        //self.url = @"http://localhost/~leejustin/ecshop/upload/ECMobile/?url=";
        
        self.url = @"http://115.29.144.237/ECMobile/?url=";
        self.baseUrl = @"http://115.29.144.237";
	}
	return self;
}

- (void)dealloc
{
	self.url = nil;
    self.baseUrl = nil;

	[super dealloc];
}

@end
