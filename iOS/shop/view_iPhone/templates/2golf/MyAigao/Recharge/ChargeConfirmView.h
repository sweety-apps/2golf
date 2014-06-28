//
//  ChargeConfirmView.h
//  2golf
//
//  Created by Lee Justin on 14-6-28.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChargeConfirmView : UIView
@property (retain, nonatomic) IBOutlet UITextField *valueTextField;
- (IBAction)comfirmCharge:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *confirmBtn;

@end
