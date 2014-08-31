//
//  RootViewController.m
//  testnav
//
//  Created by zw-mac on 11-11-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController


#pragma mark -
#pragma mark View lifecycle

- (IBAction) confirmPay {
	UIViewController *viewCtrl = nil;
	//////////////////////////
	
	//testnavAppDelegate *delegate = (testnavAppDelegate*)[UIApplication sharedApplication].delegate;
	self.hidesBottomBarWhenPushed = YES;
//	NSString * order = @"<?xml version=\'1.0\' encoding=\'UTF-8\'?>\
//	<upomp application=\"LanchPay.Req\" version=\'1.0.0\'>\
//	<merchantId>898000000000002</merchantId>\
//	<merchantOrderId>201206261509021</merchantOrderId>\
//	<merchantOrderTime>20120626150902</merchantOrderTime>\
//	<merchantOrderAmt>1</merchantOrderAmt>\
//	<sign>SznBRkvLCAziexRbfaBm7GMv4WPNUevEuPlw6vG+jxbG9PKfNBkdchTUWjFoYlgc4fcG/YNMj+JTYDjW8gyczaQWj5+pYiAkOtCDnEwnGxNUIrqZ47Xk6jbtr1b9d3rQLp8tlBYgcPa6Kzwmyv+IJgjTHxEqIw4f72fzRq5pRvY=</sign>\
//	</upomp>";
	order = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<upomp application=\"LanchPay.Req\" version=\"1.0.0\"><merchantId>898000000000002</merchantId><merchantOrderId>187-000001032</merchantOrderId><merchantOrderTime>20140831225331</merchantOrderTime><sign>dFMnj7ji1uO+WOEGbxz6cMOalejHKlgLxGCjxB82dMYQfirU4cpqtDbqRpqA4kRmcjqEa5In0p9wneWvgLEv8CVqCEcP4aEF1YWm6JD3WbBIBEtZmhdOzWor0DjS5ASMhDcs8dXEXpVTiV2KWT+lT+XMrrbOnQNYRUwdl3o8m3Q=</sign></upomp>\n";
	viewCtrl = [LTInterface getHomeViewControllerWithType:1 strOrder:order andDelegate:self];
	[self.navigationController pushViewController:viewCtrl animated:YES];
	//[viewCtrl release];		

}
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

