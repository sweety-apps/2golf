//
//  MyOrderListTopSwitchViewController.h
//  2golf
//
//  Created by Lee Justin on 14-6-9.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderListTopSwitchViewController : UIViewController

@property (nonatomic,retain) IBOutlet UIButton* buttonCourse;
@property (nonatomic,retain) IBOutlet UIButton* buttonTaocan;

- (void) selectButtonCourse;
- (void) selectButtonTaocan;

@end
