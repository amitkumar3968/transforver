//
//  Localization.m
//  NavTab
//
//  Created by Brendonfish on 12/11/8.
//
//

#import "Localization.h"

@implementation Localization
+(void)prepareLocalizedStrings{
    
    //common
    LOC_TXT_BUTTON_CANCEL = NSLocalizedString(@"LOC_TXT_BUTTON_CANCEL", @"title for cancel button");
    LOC_TXT_BUTTON_SAVE = NSLocalizedString(@"LOC_TXT_BUTTON_SAVE", @"title for save button");

    //vwSettings
    LOC_TXT_SETTING_AUTH = NSLocalizedString(@"LOC_TXT_SETTING_AUTH", @"label for Authentication");
    LOC_TXT_SETTING_CLEAR_ALL_HIST = NSLocalizedString(@"LOC_TXT_SETTING_CLEAR_ALL_HIST ", @"button title for Clear All History");
    LOC_TXT_SETTING_LANG = NSLocalizedString(@"LOC_TXT_SETTING_LANG", @"label for Language");
    LOC_TXT_SETTING_SAVE_PASS = NSLocalizedString(@"LOC_TXT_SETTING_SAVE_PASS", @"label for Save VEM Password");
    LOC_TXT_SETTING_STORAGE = NSLocalizedString(@"LOC_TXT_SETTING_STORAGE", @"label for Device Storage");
    LOC_TXT_SETTING_SYNC_CONTACTS = NSLocalizedString(@"LOC_TXT_SETTING_ERASEHIST_SYNC_CONTACTS", @"label for Sync VEM Contacts");
    LOC_TXT_SETTING_TITLE= NSLocalizedString(@"LOC_TXT_SETTING_TITLE", @"title for Settings view");
    LOC_TXT_SETTING_ERASE_HIST= NSLocalizedString(@"LOC_TXT_SETTING_ERASE_HIST", @"label for Erase History");
    
    //vwSettings =>Erase History
    LOC_TXT_SETTING_ERASEHIST_EVERYTIME = NSLocalizedString(@"LOC_TXT_SETTING_ERASEHIST_EVERYTIME", nil);
    LOC_TXT_SETTING_ERASEHIST_5MINS = NSLocalizedString(@"LOC_TXT_SETTING_ERASEHIST_5MINS", nil);
    LOC_TXT_SETTING_ERASEHIST_1HOUR = NSLocalizedString(@"LOC_TXT_SETTING_ERASEHIST_1HOUR", nil);
    LOC_TXT_SETTING_ERASEHIST_1DAY = NSLocalizedString(@"LOC_TXT_SETTING_ERASEHIST_1DAY", nil);
    LOC_TXT_SETTING_ERASEHIST_1WEEK = NSLocalizedString(@"LOC_TXT_SETTING_ERASEHIST_1WEEK", nil);
    LOC_TXT_SETTING_ERASEHIST_1MONTH= NSLocalizedString(@"LOC_TXT_SETTING_ERASEHIST_1MONTH", nil);
    LOC_TXT_SETTING_ERASEHIST_3MONTHS = NSLocalizedString(@"LOC_TXT_SETTING_ERASEHIST_3MONTHS", nil);
    LOC_TXT_SETTING_ERASEHIST_NEVER = NSLocalizedString(@"LOC_TXT_SETTING_ERASEHIST_NEVER", nil);
    
    //vwSettings =>Language
    LOC_TXT_SETTING_LANG_CH_SIMP=NSLocalizedString(@"LOC_TXT_SETTING_LANG_CH_SIMP", nil);
    LOC_TXT_SETTING_LANG_CH_TRAD=NSLocalizedString(@"LOC_TXT_SETTING_LANG_CH_TRAD", nil);
    LOC_TXT_SETTING_LANG_ENG=NSLocalizedString(@"LOC_TXT_SETTING_LANG_ENG", nil);
    LOC_TXT_SETTING_LANG_FRENCH=NSLocalizedString(@"LOC_TXT_SETTING_LANG_FRENCH", nil);
    LOC_TXT_SETTING_LANG_GERMAN=NSLocalizedString(@"LOC_TXT_SETTING_LANG_GERMAN", nil);
    LOC_TXT_SETTING_LANG_ITALIAN=NSLocalizedString(@"LOC_TXT_SETTING_LANG_ITALIAN", nil);
    LOC_TXT_SETTING_LANG_JAPANESE=NSLocalizedString(@"LOC_TXT_SETTING_LANG_JAPANESE", nil);
    LOC_TXT_SETTING_LANG_KOREA=NSLocalizedString(@"LOC_TXT_SETTING_LANG_KOREA", nil);

    
    //vwSettings =>Auth
    LOC_TXT_SETTING_AUTH_PASS_SWITCH= NSLocalizedString(@"LOC_TXT_SETTING_AUTH_PASS_SWITCH", @"Program Password");
    LOC_TXT_SETTING_AUTH_PASS=NSLocalizedString(@"LOC_TXT_SETTING_AUTH_PASS", @"Password"); //uilbPassword;
    
    //MyContactsView
    LOC_TXT_CONTACT_ALLBUTTON=NSLocalizedString(@"LOC_TXT_CONTACT_ALLBUTTON", @"title of all phone contacts Button");
    LOC_TXT_CONTACT_VEMBUTTON=NSLocalizedString(@"LOC_TXT_CONTACT_VEMBUTTON", @"title of Messenger Button");
    
    //vwRecordController
    LOC_TXT_RECORD_AUTO_DEL = NSLocalizedString(@"LOC_TXT_RECORD_AUTO_DEL", @"label for Auto Delete"); //uilbAutoDel
    LOC_TXT_RECORD_PASS_LOCK =NSLocalizedString(@"LOC_TXT_RECORD_PASS_LOCK", @"label for password lock switch"); //uilbPassLock
    LOC_TXT_RECORD_PASSWORD = NSLocalizedString(@"LOC_TXT_RECORD_PASSWORD", @"label for Password"); //uilbPassword
    LOC_TXT_RECORD_ENCRYPTION_TYPE = NSLocalizedString(@"LOC_TXT_RECORD_ENCRYPTION_TYPE", @"label for Encryption Type"); //uilbSelectEncryType
    LOC_TXT_RECORD_REC_BUTTON_TITLE = NSLocalizedString(@"LOC_TXT_RECORD_BUTTON_TITLE", @"title for Rec Button"); //uibtRecord
    LOC_TXT_RECORD_RECEIVER_BUTTON_TITLE = NSLocalizedString(@"LOC_TXT_RECORD_RECEIVER_BUTTON_TITLE", @"title for Select Receiver Button"); //uibtSendToWho
    
}

@end
