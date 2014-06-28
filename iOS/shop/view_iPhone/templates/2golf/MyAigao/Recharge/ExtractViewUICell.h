//
//  ExtractViewUICell.h
//  2golf
//
//  Created by Lee Justin on 14-6-28.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee_UICell.h"

@class ExtractViewUICell;

@protocol ExtractViewUICellDelegate <NSObject>

- (void)extractViewUICell:(ExtractViewUICell*)cell
           confirmedValue:(NSNumber*)value;

@end

@interface ExtractViewUICell : BeeUICell

@property (nonatomic,assign) id<ExtractViewUICellDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *yueLabel;
@property (retain, nonatomic) IBOutlet UILabel *shouxufeiLabel;
@property (retain, nonatomic) IBOutlet UILabel *zongjineLabel;
@property (retain, nonatomic) IBOutlet UITextField *kaihuhangTextField;
@property (retain, nonatomic) IBOutlet UITextField *yinhangzhanghaoTextField;
@property (retain, nonatomic) IBOutlet UITextField *humingTextField;
@property (retain, nonatomic) IBOutlet UITextField *tixianjineTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwordField;

@property (retain, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)pressedConfirmBtn:(id)sender;

@end
