//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  SearchKeywordsListBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-4-15.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface SearchKeywordsListBoard_iPhone : BeeUIBoard <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,retain) IBOutlet UITableView* tableView;
@property (nonatomic,retain) IBOutlet UITextField* textField;

- (IBAction)onPressedSearch:(id)sender;

@end
