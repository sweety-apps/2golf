//
//  CitySelectCell.h
//  2golf
//
//  Created by Lee Justin on 14-4-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

@interface CitySelectCell : UIView

@property (nonatomic,retain) IBOutlet UIButton* cellBg;
@property (nonatomic,retain) IBOutlet UILabel* cellTitle;
@property (nonatomic,retain) IBOutlet UIImageView* rightPullBtn;

- (void)setBeHeaderH;
- (void)setBeHeaderM;
- (void)setBeHeaderB;
- (void)setBeHeaderS;

- (void)setBeContentH;
- (void)setBeContentM;
- (void)setBeContentB;
- (void)setBeContentS;

- (void)setBeContentExpH;
- (void)setBeContentExpM;
- (void)setBeContentExpB;
- (void)setBeContentExpS;

- (void)setExpand:(BOOL)exp;

@end
