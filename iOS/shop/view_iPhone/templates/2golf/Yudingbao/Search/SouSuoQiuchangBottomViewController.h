//
//  SouSuoQiuchangBottomViewController.h
//  2golf
//
//  Created by Lee Justin on 14-4-17.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

@interface SouSuoQiuchangBottomViewController : UIViewController

@property (nonatomic,retain) IBOutlet UIView* cellContainerView;
@property (nonatomic,retain) IBOutlet UIView* moreContainerView;
@property (nonatomic,retain) IBOutlet UIButton* moreBtn;
@property (nonatomic,retain) NSArray* dataArray;

- (IBAction)onPressedMore:(id)sender;

@end
