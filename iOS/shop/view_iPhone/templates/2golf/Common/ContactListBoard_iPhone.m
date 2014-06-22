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
//  ContactListBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-5-22.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "ContactListBoard_iPhone.h"
#import "CommonSharedData.h"
#import "ContactListCellBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import <AddressBook/AddressBook.h>

#pragma mark -

@interface ContactListBoard_iPhone() <UITextFieldDelegate>
{
	BeeUIScrollView* _scroll;
    CGRect _oldInputViewFrame;
}

@property (nonatomic,retain) NSMutableArray* allNames;

@end

@implementation ContactListBoard_iPhone

- (void)load
{
	[super load];
    self.allNames = [NSMutableArray array];
    [self _registerForKeyboardNotifications];
}

- (void)unload
{
    [self _unregisterForKeyboardNotifications];
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];
    
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"添加打球人"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        CGRect rect;
        
        rect = self.viewBound;
        rect.origin.y+=6;
        rect.size.height-=6+self.handInputView.frame.size.height-70;
        _scroll = [[BeeUIScrollView alloc] initWithFrame:rect];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
        _scroll.backgroundColor = [UIColor clearColor];
        //_scroll.bounces = NO;
		[_scroll showHeaderLoader:NO animated:NO];
		[self.view insertSubview:_scroll belowSubview:self.handInputView];
        
        [self.handInputConfirmBtn addTarget:self action:@selector(_pressedConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        SAFE_RELEASE_SUBVIEW( _scroll );
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        [_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, [AppBoard_iPhone sharedInstance].tabbar.height, 0)];
		CGRect rect = self.viewBound;
        rect.origin.y+=6;
        rect.size.height-=6+self.handInputView.frame.size.height-70;
        _scroll.frame =rect;
        
        /*
        CGRect rectInputView = self.handInputView.frame;
        rectInputView.origin.y = self.viewBound.size.height - rectInputView.size.height;
        self.handInputView.frame = rectInputView;
        */
        
        _oldInputViewFrame = self.handInputView.frame;
        
        [self resetCells];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
	{
        [self.stack popBoardAnimated:YES];
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
	}
}

ON_SIGNAL2( ContactListCell_iPhone, signal )
{
    if([signal.source isKindOfClass:[ContactListCell_iPhone class]])
    {
        ContactListCell_iPhone* cell = signal.source;
        int index = cell.tag;
        BOOL selected = [self.allNames[index][@"selected"] boolValue];
        if (!selected)
        {
            self.allNames[index][@"selected"] = @YES;
            cell.ctrl.checkImg.hidden = NO;
        }
        else
        {
            self.allNames[index][@"selected"] = @NO;
            cell.ctrl.checkImg.hidden = YES;
        }
    }
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	return [self.allNames count];
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    BeeUICell * cell = nil;
    
    cell = [scrollView dequeueWithContentClass:[ContactListCell_iPhone class]];
    cell.data = (self.allNames[index]);
    cell.tag = index;
    
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return CGSizeMake(320, 30);
}

#pragma mark -

- (void)resetCells
{
    [self _getContactDatas];
    [self _checkLastCheckedNames];
    [_scroll reloadData];
}

- (void)_pressedConfirmBtn
{
    NSMutableArray* selectedNames = [NSMutableArray array];
    for (NSDictionary* dict in self.allNames)
    {
        if ([dict[@"selected"] boolValue])
        {
            [selectedNames addObject:dict[@"name"]];
        }
    }
    if ([self.handInputField.text length] > 0)
    {
        [selectedNames addObject:self.handInputField.text];
    }
    [[CommonSharedData sharedInstance] setContactListNames:selectedNames];
    [self.stack popBoardAnimated:YES];
}

- (void) _checkLastCheckedNames
{
    NSArray* selP = [[CommonSharedData sharedInstance] getContactListNames];
    
    for (NSMutableDictionary* dict in self.allNames)
    {
        for (NSString* name in selP)
        {
            if ([name isEqualToString:dict[@"name"]])
            {
                dict[@"selected"] = @YES;
            }
        }
    }
}

- (void) _getContactDatas
{
    [self.allNames removeAllObjects];
    
    // Create addressbook data model
    ABAddressBookRef addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
    //获取通讯录权限
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_release(sema);

    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    
    for (NSInteger i = 0; i < nPeople; i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        
        NSString *nameString = (NSString *)abName;
        NSString *lastNameString = (NSString *)abLastName;
        
        if ((id)abFullName != nil) {
            nameString = (NSString *)abFullName;
        } else {
            if ((id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        dict[@"selected"] = @NO;
        dict[@"name"] = nameString;
        self.allNames[i] = dict;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        //addressBook.tel = [(NSString*)value telephoneWithReformat];
                        break;
                    }
                    case 1: {// Email
                        //addressBook.email = (NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    
    CFRelease(allPeople);
    CFRelease(addressBooks);
}

- (void) _registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(_keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void) _unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) _keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSLog(@"keyBoard:%f", keyboardSize.height);
    
    CGRect rect = _oldInputViewFrame;
    rect.origin.y -= keyboardSize.height;
    self.handInputView.frame = rect;
}

- (void) _keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
        
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    
    self.handInputView.frame = _oldInputViewFrame;
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
