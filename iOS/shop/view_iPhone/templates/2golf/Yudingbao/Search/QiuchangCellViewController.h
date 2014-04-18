//
//  QiuchangCellViewController.h
//  2golf
//
//  Created by Lee Justin on 14-4-16.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

@interface QiuchangCellViewController : UIViewController

@property (nonatomic,retain) IBOutlet BeeUIImageView* iconImageView;
@property (nonatomic,retain) IBOutlet UILabel* nameLabel;
@property (nonatomic,retain) IBOutlet UILabel* distanceLabel;
@property (nonatomic,retain) IBOutlet UILabel* descriptionLabel;
@property (nonatomic,retain) IBOutlet UILabel* valueLabel;
@property (nonatomic,retain) IBOutlet UIImageView* huiIcon;
@property (nonatomic,retain) IBOutlet UIImageView* guanIcon;
@property (nonatomic,retain) IBOutlet UIButton* btn;


@end
