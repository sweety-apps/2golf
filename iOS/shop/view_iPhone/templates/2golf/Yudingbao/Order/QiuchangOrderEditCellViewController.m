//
//  QiuchangOrderEditCellViewController.m
//  2golf
//
//  Created by Lee Justin on 14-4-18.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangOrderEditCellViewController.h"

#pragma mark -

@interface QiuchangOrderEditCell_iPhone () <UITextFieldDelegate>

@end

#pragma mark -

@implementation QiuchangOrderEditCell_iPhone

DEF_SIGNAL( TOUCHED )

- (void)load
{
    [super load];
    
    self.ctrl = [[QiuchangOrderEditCellViewController alloc] initWithNibName:@"QiuchangOrderEditCellViewController" bundle:nil];
    self.frame = self.ctrl.view.frame;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.ctrl.view];
    
    [self.ctrl.contactBtn addTarget:self action:@selector(onPressedContact:) forControlEvents:UIControlEventTouchUpInside];
    [self.ctrl.numDecreaseBtn addTarget:self action:@selector(onPressedDecreasePeople:) forControlEvents:UIControlEventTouchUpInside];
    [self.ctrl.numIncreaseBtn addTarget:self action:@selector(onPressedIncreasePeople:) forControlEvents:UIControlEventTouchUpInside];
    [self.ctrl.confirmBtn addTarget:self action:@selector(onPressedConfirm:) forControlEvents:UIControlEventTouchUpInside];
    
    //self.ctrl.phoneTextField.delegate = self;
}

- (void)unload
{
    self.ctrl = nil;
    
	[super unload];
}

- (void)layoutDidFinish
{
    
}

- (void)dataDidChanged
{
    if (self.data)
    {
        NSDictionary* dict = self.data;
    }
}

#pragma mark -

- (void)setNormalH
{
    QiuchangOrderEditCellViewController* ctrl = self.ctrl;
    
    CGFloat moveDown = 8;
    CGRect rect = CGRectMake(0, 0, 320, 40);
    rect.origin = CGPointZero;
    rect.size.height += moveDown;
    ctrl.view.frame = rect;
    self.frame = rect;
    
    rect.size.height -= moveDown;
    rect.origin.y +=moveDown;
    //ctrl.baseView.frame = rect;
    ctrl.view.frame = rect;
    
    ctrl.cellTitle.hidden = NO;
    ctrl.normalRightTitle.hidden = NO;
    
    ctrl.contactArrow.hidden = YES;
    ctrl.contactBtn.hidden = YES;
    ctrl.contactRightTitle.hidden = YES;
    
    ctrl.numIncreaseBtn.hidden = YES;
    ctrl.numDecreaseBtn.hidden = YES;
    ctrl.numLabel.hidden = YES;
    
    ctrl.phoneTextField.hidden = YES;
    
    ctrl.confirmBtn.hidden = YES;
    
    ctrl.cellBg.image = [__IMAGE(@"normallist_content_bg_h") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f];
}

- (void)setNormalM
{
    QiuchangOrderEditCellViewController* ctrl = self.ctrl;
    
    CGFloat moveDown = 0;
    CGRect rect = CGRectMake(0, 0, 320, 40);
    rect.origin = CGPointZero;
    rect.size.height += moveDown;
    ctrl.view.frame = rect;
    self.frame = rect;
    
    rect.size.height -= moveDown;
    rect.origin.y +=moveDown;
    //ctrl.baseView.frame = rect;
    ctrl.view.frame = rect;
    
    ctrl.cellTitle.hidden = NO;
    ctrl.normalRightTitle.hidden = NO;
    
    ctrl.contactArrow.hidden = YES;
    ctrl.contactBtn.hidden = YES;
    ctrl.contactRightTitle.hidden = YES;
    
    ctrl.numIncreaseBtn.hidden = YES;
    ctrl.numDecreaseBtn.hidden = YES;
    ctrl.numLabel.hidden = YES;
    
    ctrl.phoneTextField.hidden = YES;
    
    ctrl.confirmBtn.hidden = YES;
    
    ctrl.cellBg.image = [__IMAGE(@"normallist_content_bg_m") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f];
}

- (void)setNormalB
{
    QiuchangOrderEditCellViewController* ctrl = self.ctrl;
    
    CGFloat moveDown = 0;
    CGRect rect = CGRectMake(0, 0, 320, 40);
    rect.origin = CGPointZero;
    rect.size.height += moveDown;
    ctrl.view.frame = rect;
    self.frame = rect;
    
    rect.size.height -= moveDown;
    rect.origin.y +=moveDown;
    //ctrl.baseView.frame = rect;
    ctrl.view.frame = rect;
    
    ctrl.cellTitle.hidden = NO;
    ctrl.normalRightTitle.hidden = NO;
    
    ctrl.contactArrow.hidden = YES;
    ctrl.contactBtn.hidden = YES;
    ctrl.contactRightTitle.hidden = YES;
    
    ctrl.numIncreaseBtn.hidden = YES;
    ctrl.numDecreaseBtn.hidden = YES;
    ctrl.numLabel.hidden = YES;
    
    ctrl.phoneTextField.hidden = YES;
    
    ctrl.confirmBtn.hidden = YES;
    
    ctrl.cellBg.image = [__IMAGE(@"normallist_content_bg_t") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f];
}

- (void)setContact
{
    QiuchangOrderEditCellViewController* ctrl = self.ctrl;
    
    CGFloat moveDown = 8;
    CGRect rect = CGRectMake(0, 0, 320, 40);
    rect.origin = CGPointZero;
    rect.size.height += moveDown;
    ctrl.view.frame = rect;
    self.frame = rect;
    
    rect.size.height -= moveDown;
    rect.origin.y +=moveDown;
    //ctrl.baseView.frame = rect;
    ctrl.view.frame = rect;
    
    ctrl.cellTitle.hidden = NO;
    ctrl.normalRightTitle.hidden = YES;
    
    ctrl.contactArrow.hidden = NO;
    ctrl.contactBtn.hidden = NO;
    ctrl.contactRightTitle.hidden = NO;
    
    ctrl.numIncreaseBtn.hidden = YES;
    ctrl.numDecreaseBtn.hidden = YES;
    ctrl.numLabel.hidden = YES;
    
    ctrl.phoneTextField.hidden = YES;
    
    ctrl.confirmBtn.hidden = YES;
    
    ctrl.cellBg.image = [__IMAGE(@"normallist_content_bg_h") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f];
}

- (void)setContactM
{
    QiuchangOrderEditCellViewController* ctrl = self.ctrl;
    
    CGFloat moveDown = 0;
    CGRect rect = CGRectMake(0, 0, 320, 40);
    rect.origin = CGPointZero;
    rect.size.height += moveDown;
    ctrl.view.frame = rect;
    self.frame = rect;
    
    rect.size.height -= moveDown;
    rect.origin.y +=moveDown;
    //ctrl.baseView.frame = rect;
    ctrl.view.frame = rect;
    
    ctrl.cellTitle.hidden = NO;
    ctrl.normalRightTitle.hidden = YES;
    
    ctrl.contactArrow.hidden = NO;
    ctrl.contactBtn.hidden = NO;
    ctrl.contactRightTitle.hidden = NO;
    
    ctrl.numIncreaseBtn.hidden = YES;
    ctrl.numDecreaseBtn.hidden = YES;
    ctrl.numLabel.hidden = YES;
    
    ctrl.phoneTextField.hidden = YES;
    
    ctrl.confirmBtn.hidden = YES;
    
    ctrl.cellBg.image = [__IMAGE(@"normallist_content_bg_m") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f];
}

- (void)setPhoneNum
{
    QiuchangOrderEditCellViewController* ctrl = self.ctrl;
    
    CGFloat moveDown = 0;
    CGRect rect = CGRectMake(0, 0, 320, 40);
    rect.origin = CGPointZero;
    rect.size.height += moveDown;
    ctrl.view.frame = rect;
    self.frame = rect;
    
    rect.size.height -= moveDown;
    rect.origin.y +=moveDown;
    //ctrl.baseView.frame = rect;
    ctrl.view.frame = rect;
    
    ctrl.cellTitle.hidden = NO;
    ctrl.normalRightTitle.hidden = YES;
    
    ctrl.contactArrow.hidden = YES;
    ctrl.contactBtn.hidden = YES;
    ctrl.contactRightTitle.hidden = YES;
    
    ctrl.numIncreaseBtn.hidden = YES;
    ctrl.numDecreaseBtn.hidden = YES;
    ctrl.numLabel.hidden = YES;
    
    ctrl.phoneTextField.hidden = NO;
    
    ctrl.confirmBtn.hidden = YES;
    
    ctrl.cellBg.image = [__IMAGE(@"normallist_content_bg_m") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f];
}

- (void)setPeopleNum
{
    QiuchangOrderEditCellViewController* ctrl = self.ctrl;
    
    CGFloat moveDown = 0;
    CGRect rect = CGRectMake(0, 0, 320, 40);
    rect.origin = CGPointZero;
    rect.size.height += moveDown;
    ctrl.view.frame = rect;
    self.frame = rect;
    
    rect.size.height -= moveDown;
    rect.origin.y +=moveDown;
    //ctrl.baseView.frame = rect;
    ctrl.view.frame = rect;
    
    ctrl.cellTitle.hidden = NO;
    ctrl.normalRightTitle.hidden = YES;
    
    ctrl.contactArrow.hidden = YES;
    ctrl.contactBtn.hidden = YES;
    ctrl.contactRightTitle.hidden = YES;
    
    ctrl.numIncreaseBtn.hidden = NO;
    ctrl.numDecreaseBtn.hidden = NO;
    ctrl.numLabel.hidden = NO;
    
    ctrl.phoneTextField.hidden = YES;
    
    ctrl.confirmBtn.hidden = YES;
    
    ctrl.cellBg.image = [__IMAGE(@"normallist_content_bg_t") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f];
}

- (void)setPeopleNumM
{
    QiuchangOrderEditCellViewController* ctrl = self.ctrl;
    
    CGFloat moveDown = 0;
    CGRect rect = CGRectMake(0, 0, 320, 40);
    rect.origin = CGPointZero;
    rect.size.height += moveDown;
    ctrl.view.frame = rect;
    self.frame = rect;
    
    rect.size.height -= moveDown;
    rect.origin.y +=moveDown;
    //ctrl.baseView.frame = rect;
    ctrl.view.frame = rect;
    
    ctrl.cellTitle.hidden = NO;
    ctrl.normalRightTitle.hidden = YES;
    
    ctrl.contactArrow.hidden = YES;
    ctrl.contactBtn.hidden = YES;
    ctrl.contactRightTitle.hidden = YES;
    
    ctrl.numIncreaseBtn.hidden = NO;
    ctrl.numDecreaseBtn.hidden = NO;
    ctrl.numLabel.hidden = NO;
    
    ctrl.phoneTextField.hidden = YES;
    
    ctrl.confirmBtn.hidden = YES;
    
    ctrl.cellBg.image = [__IMAGE(@"normallist_content_bg_m") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f];
}

- (void)setConfirm
{
    QiuchangOrderEditCellViewController* ctrl = self.ctrl;
    
    CGFloat moveDown = 0;
    CGRect rect = CGRectMake(0, 0, 320, 40);
    rect.origin = CGPointZero;
    rect.size.height += moveDown;
    ctrl.view.frame = rect;
    self.frame = rect;
    
    rect.size.height -= moveDown;
    rect.origin.y +=moveDown;
    //ctrl.baseView.frame = rect;
    ctrl.view.frame = rect;
    
    ctrl.cellTitle.hidden = YES;
    ctrl.normalRightTitle.hidden = YES;
    
    ctrl.contactArrow.hidden = YES;
    ctrl.contactBtn.hidden = YES;
    ctrl.contactRightTitle.hidden = YES;
    
    ctrl.numIncreaseBtn.hidden = YES;
    ctrl.numDecreaseBtn.hidden = YES;
    ctrl.numLabel.hidden = YES;
    
    ctrl.phoneTextField.hidden = YES;
    
    ctrl.confirmBtn.hidden = NO;
    
    ctrl.cellBg.image = [__IMAGE(@"normallist_content_bg_t") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f];
}

- (void)setLeftText:(NSString*)text
{
    QiuchangOrderEditCellViewController* ctrl = self.ctrl;
    ctrl.cellTitle.text = text;
}

- (void)setRightText:(NSString*)text color:(UIColor*)color
{
    QiuchangOrderEditCellViewController* ctrl = self.ctrl;
    ctrl.normalRightTitle.text = text;
    ctrl.normalRightTitle.textColor = color;
    
    ctrl.contactRightTitle.text = text;
    ctrl.contactRightTitle.textColor = color;
    
    ctrl.numLabel.text = text;
    ctrl.numLabel.textColor = color;
}

- (void)resizeSelfWithRightText
{
    UIFont*  font = self.ctrl.normalRightTitle.font;
    NSString* text = self.ctrl.normalRightTitle.text;
    CGSize size = self.ctrl.normalRightTitle.frame.size;
    size.height = 9999999;
    size = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByTruncatingTail];
    CGFloat height = self.ctrl.normalRightTitle.frame.size.height;
    if (size.height > self.ctrl.normalRightTitle.frame.size.height)
    {
        height = size.height + 2;
    }
    
    CGRect rect = self.ctrl.normalRightTitle.frame;
    rect.size.height = size.height;
    self.ctrl.normalRightTitle.frame = rect;
    
    rect = self.ctrl.contactRightTitle.frame;
    rect.size.height = size.height;
    self.ctrl.contactRightTitle.frame = rect;
    
    rect = self.ctrl.cellBg.frame;
    rect.size.height = height;
    self.ctrl.cellBg.frame = rect;
    
    rect = self.ctrl.view.frame;
    rect.size.height = height;
    self.ctrl.view.frame = rect;
    
    rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

#pragma mark -

- (void)onPressedContact:(UIButton*)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPressedContact:)])
    {
        [self.delegate onPressedContact:self];
    }
}

- (void)onPressedConfirm:(UIButton*)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPressedConfirm:)])
    {
        [self.delegate onPressedConfirm:self];
    }
}

- (void)onPressedIncreasePeople:(UIButton*)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPressedIncreasePeople:)])
    {
        [self.delegate onPressedIncreasePeople:self];
    }
}

- (void)onPressedDecreasePeople:(UIButton*)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPressedDecreasePeople:)])
    {
        [self.delegate onPressedDecreasePeople:self];
    }
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.ctrl.phoneTextField resignFirstResponder];
    return YES;
}

@end


#pragma mark -

@interface QiuchangOrderEditCellViewController ()

@end

@implementation QiuchangOrderEditCellViewController

//common
@synthesize baseView;
@synthesize cellBg;
@synthesize cellTitle;
@synthesize normalRightTitle;

//联系人
@synthesize contactRightTitle;
@synthesize contactArrow;
@synthesize contactBtn;

//人数
@synthesize numDecreaseBtn;
@synthesize numIncreaseBtn;
@synthesize numLabel;

//联系电话
@synthesize phoneTextField;

//确认按钮
@synthesize confirmBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.baseView = nil;
    self.cellBg = nil;
    self.cellTitle = nil;
    self.normalRightTitle = nil;
    
    //联系人
    self.contactRightTitle = nil;
    self.contactArrow = nil;
    self.contactBtn = nil;
    
    //人数
    self.numDecreaseBtn = nil;
    self.numIncreaseBtn = nil;
    self.numLabel = nil;
    
    //联系电话
    self.phoneTextField = nil;
    
    //确认按钮
    self.confirmBtn = nil;
    
    [super dealloc];
}

@end
