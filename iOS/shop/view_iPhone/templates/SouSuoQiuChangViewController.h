//
//  SouSuoQiuChangViewController.h
//  2golf
//
//  Created by Lee Justin on 14-3-29.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bee.h"

@interface SouSuoQiuChangViewController : UIViewController
{
    BeeUIStack* _uiStack;
}
@property (nonatomic,retain) BeeUIStack* uiStack;

- (IBAction)onPressedLocal:(id)sender;
- (IBAction)onPressedDate:(id)sender;
- (IBAction)onPressedTime:(id)sender;
- (IBAction)onPressedSearch:(id)sender;

@end
