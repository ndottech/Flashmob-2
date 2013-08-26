//
//  Settings.h
//  FlashMob
//
//  Created by APPLE on 8/1/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface Settings : UIViewController<MFMailComposeViewControllerDelegate>

@property(nonatomic,retain) IBOutlet UITextField *update_current_txt;
@property(nonatomic,retain) IBOutlet UITextField *updatelocation_txt;

@property(nonatomic,retain) IBOutlet UILabel *dis_no_lbl;
@property(nonatomic,retain) IBOutlet UILabel *updates_no_lbl;


@property(nonatomic, retain) UITabBarItem *item1;
@property(nonatomic, retain) UITabBarItem *item2;
@property(nonatomic, retain) IBOutlet UITabBar *tabBar;

-(IBAction)ratethisapp:(id)sender;

-(IBAction)emailsupport:(id)sender;
-(IBAction)event_btn:(id)sender;


-(IBAction)back_btn:(id)sender;



-(IBAction)updateBtn:(id)sender;


-(IBAction)ditance_recenter:(id)sender;
-(IBAction)updates_map:(id)sender;

@end




