//
//  MR3761BaseRequest.h
//  报文生成
//
//  Created by hl on 16/8/16.
//  Copyright © 2016年 hl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MR3761AddressField.h"
#import "MR3761ControlField.h"
#import "MR3761SEQField.h"
#import "MR3761Header.h"
#import "MR3761DADTRecord.h"

#import "MRDataID.h"

#define Left 0
#define right 1

@interface MR3761BaseRequest : NSObject

@property (nonatomic, retain)MR3761Header *header;
@property (nonatomic, retain)MR3761ControlField *controlField;
@property (nonatomic, retain)MR3761AddressField *addressField;

@property (nonatomic, assign)Byte AFN;
@property (nonatomic, retain)MR3761SEQField *SEQ;
@property (nonatomic, retain)NSArray *dadt;
@property (nonatomic, assign)Byte *userData;

@property (nonatomic, retain)NSMutableDictionary *resultSet;
@property (nonatomic, retain)NSMutableDictionary *finalSet;

@property (nonatomic, assign)NSInteger auxFieldLength;
@property (nonatomic, assign)NSInteger pos;
@property (nonatomic, assign)NSInteger userDataLength;
@property (nonatomic, assign)NSInteger ketCount;

//@property (nonatomic, assign)dispatch_semaphore_t sem;

-(void)parseUserData; //---解析用户数据

-(void)performNotificationWithnotifyName:(NSString *)notifyName
                                  object:(NSObject *)objc
                                  resylt:(NSDictionary *)resultDic; //---解析通知

/***
 分解一般数据
 */
-(void)performGenericWithKey:(int)key
                  Length:(int)byteLength
                    Rate:(int)rate
                   Digit:(int)digit;

-(void)performGenericWithKey:(int)key
                    Key2:(int)key2
                 Length1:(int)byteLength1
                 Length2:(int)byteLength2
                    Rate:(int)rate
                   Digit:(int)digit;

-(void)performGenericWithKey:(int)key
                    Length:(int)byteLength
                    Rate:(int)rate;

-(void)performGenericWithKey:(int)key
                  Length:(int)byteLength
                    Rate:(int)rate
                   Digit:(int)digit
                    isSigned:(BOOL)sign
                     signPos:(int)pos;

-(void)performGenericWithKey:(int)key
                    Key2:(int)key2
                  Length:(int)byteLength
               LoopTimes:(int)rate
                   Digit:(int)digit;

//bcd （十进制）转double
-(double)bcdToDoubleWithBytes:(Byte *)bcdCode
                         blen:(NSInteger)bytesLength
                         dlen:(NSInteger)digitLength;

//bcd（十进制）转signed double
-(double)bcdToSignedDoubleWithBytes:(Byte *)bcdCode
                         blen:(NSInteger)bytesLength
                         dlen:(NSInteger)digitLength
                            signPos:(NSInteger)pos;
-(NSString *)bcdToTimeWithBytes:(Byte *)bcdCode
                           blen:(NSInteger)bytesLength
                           type:(NSInteger)type;

-(NSString *)asciiToStringWithBytes:(Byte *)asciiCode
                               blen:(NSInteger)bytesLength;

-(NSString *)binToStringWithBytes:(Byte *)bin
                             blen:(NSInteger)bytesLength;

-(NSString *)getKeyString:(int)key; //获取键字符串

-(void)sendResult;
-(void)shouldContinue;

@end
