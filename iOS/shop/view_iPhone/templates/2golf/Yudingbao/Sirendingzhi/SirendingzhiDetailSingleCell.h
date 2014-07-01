//
//  SirendingzhiDetailSingleCell.h
//  2golf
//
//  Created by Lee Justin on 14-6-29.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

@interface SirendingzhiDetailSingleCell : BeeUICell
@property (retain, nonatomic) IBOutlet UIButton *bgBtn;
@property (retain, nonatomic) IBOutlet UILabel *leftLabel;
@property (retain, nonatomic) IBOutlet UILabel *rightLabel;
@property (retain, nonatomic) IBOutlet UIImageView *rightArrowImageView;

- (void)setH;
- (void)setM;
- (void)setB;

@end
