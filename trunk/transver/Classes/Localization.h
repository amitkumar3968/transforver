//
//  Localization.h
//  NavTab
//
//  Created by Brendonfish on 12/11/8.
//
//

#import <Foundation/Foundation.h>
//common
NSString*  LOC_TXT_BUTTON_CANCEL;
NSString*  LOC_TXT_BUTTON_SAVE;


//vwSettings
NSString*  LOC_TXT_SETTING_SYNC_CONTACTS;
NSString*  LOC_TXT_SETTING_TITLE;  //uilbLocTxtSettingTitle;
NSString*  LOC_TXT_SETTING_AUTH; //uilbLocTxtSettingAuch;
NSString*  LOC_TXT_SETTING_SAVE_PASS; //uilbLocTxtSettingSavePass;
NSString*  LOC_TXT_SETTING_ERASE_HIST; //uilbLocTxtSettingEraseHist;
NSString*  LOC_TXT_SETTING_STORAGE; //uilbLocTxtSettingStorage;
NSString*  LOC_TXT_SETTING_LANG;//uilbLocTxtSettingLanguage;
NSString*  LOC_TXT_SETTING_CLEAR_ALL_HIST; //uibtClearAllHistory;

//vwSettingsEraseHistory
NSString*  LOC_TXT_SETTING_ERASEHIST_1DAY;
NSString*  LOC_TXT_SETTING_ERASEHIST_1HOUR;
NSString*  LOC_TXT_SETTING_ERASEHIST_1MONTH;
NSString*  LOC_TXT_SETTING_ERASEHIST_1WEEK;
NSString*  LOC_TXT_SETTING_ERASEHIST_3MONTHS;
NSString*  LOC_TXT_SETTING_ERASEHIST_5MINS;
NSString*  LOC_TXT_SETTING_ERASEHIST_EVERYTIME;
NSString*  LOC_TXT_SETTING_ERASEHIST_NEVER;
NSString*  LOC_TXT_SETTING_ERASEHIST_TITLE;

//vwSettings =>Language
NSString* LOC_TXT_SETTING_LANG_CH_TRAD; // uilbLangChTrad;
NSString* LOC_TXT_SETTING_LANG_CH_SIMP; //uilbLangChSimp;
NSString* LOC_TXT_SETTING_LANG_ENG; // uilbLangEng;
NSString* LOC_TXT_SETTING_LANG_ITALIAN; // uilbLangItalian;
NSString* LOC_TXT_SETTING_LANG_FRENCH; // uilbLangFrech;
NSString* LOC_TXT_SETTING_LANG_JAPANESE; //uilbLangJapansed;
NSString* LOC_TXT_SETTING_LANG_KOREA; // uilbLangKorean;
NSString* LOC_TXT_SETTING_LANG_GERMAN; //uilbLangGerman;

//vwSettings =>Auth
NSString* LOC_TXT_SETTING_AUTH_PASS_SWITCH; // uilbProgramAuth;
NSString* LOC_TXT_SETTING_AUTH_PASS; //uilbPassword;

//MycontactsView
NSString* LOC_TXT_CONTACT_ALLBUTTON; // allButton.titleText;
NSString* LOC_TXT_CONTACT_VEMBUTTON; //filterButton.titleText;

//vwRecordController
NSString* LOC_TXT_RECORD_AUTO_DEL; //uilbAutoDel
NSString* LOC_TXT_RECORD_PASS_LOCK; //uilbPassLock
NSString* LOC_TXT_RECORD_PASSWORD; //uilbPassword
NSString* LOC_TXT_RECORD_ENCRYPTION_TYPE; //uilbSelectEncryType
NSString* LOC_TXT_RECORD_REC_BUTTON_TITLE; //uibtRecord
NSString* LOC_TXT_RECORD_RECEIVER_BUTTON_TITLE; //uibtSendToWho

@interface Localization : NSObject
+(void)prepareLocalizedStrings;

@end
