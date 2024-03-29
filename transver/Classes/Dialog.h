//
//  Dialog.h
//  NavTab
//
//  Created by hank chen on 11/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Dialog : NSObject {
    int m_Dialog_ID;
    int m_Dialog_Type;
    NSString *m_Dialog_Message;
    NSString *m_Dialog_Voice;
    NSString *m_Dialog_Encrypt;
    NSString *m_Dialog_Password;
    int m_Dialog_SourceID;
    int m_Dialog_DstID;
    int m_Dialog_Read;
    int m_Dialog_Autodelete;
    NSString *m_Created_Time;
}


@property (nonatomic, assign) int m_Dialog_ID;
@property (nonatomic, assign) int m_Dialog_Type;
@property (nonatomic, assign) int m_Dialog_SourceID;
@property (nonatomic, assign) int m_Dialog_DstID;
@property (nonatomic, assign) int m_Dialog_Read;
@property (nonatomic, assign) int m_Dialog_Autodelete;
@property (nonatomic, retain) NSString *m_Dialog_Message;
@property (nonatomic, retain) NSString *m_Dialog_Voice;
@property (nonatomic, retain) NSString *m_Dialog_Encrypt;
@property (nonatomic, retain) NSString *m_Dialog_Password;
@property (nonatomic, retain) NSString *m_Created_Time;

@end
