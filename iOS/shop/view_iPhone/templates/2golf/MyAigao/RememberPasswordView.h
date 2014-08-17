//
//  RememberPasswordView.h
//  2golf
//
//  Created by Lee Justin on 14-8-15.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RememberPasswordViewDelegate <NSObject>

- (void) rememberPasswordSelected:(BOOL)selected;

@end

@interface RememberPasswordView : UIView
@property (assign, nonatomic) id<RememberPasswordViewDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIButton *checkBtn;

@end
