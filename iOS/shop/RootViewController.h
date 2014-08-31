//
//  RootViewController.h
//  testnav
//
//  Created by zw-mac on 11-11-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTInterface.h"
@interface RootViewController : UIViewController<LTInterfaceDelegate> {
    NSString* order;
}
- (IBAction) confirmPay;
@end
