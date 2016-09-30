//
//  MR3761BaseRequest.m
//  报文生成
//
//  Created by hl on 16/8/16.
//  Copyright © 2016年 hl. All rights reserved.
//

#import "MR3761BaseRequest.h"

//#import "MRSettingsManager.h"

@interface MR3761BaseRequest ()

@property (nonatomic, retain)NSString *notifyName;
//@property (nonatomic, retain)MRSettingsManager *setting;

@end

@implementation MR3761BaseRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"解析类：%@",[self class]);
        
        self.pos = 0;
        
        self.resultSet = [[NSMutableDictionary alloc]init];
        self.finalSet = [[NSMutableDictionary alloc]init];
        
//        self.addressField = [[MR3761AddressField alloc]init];
//        self.controlField = [MR3761ControlField new];
//        self.header = [MR3761Header new];
//        self.SEQ = [MR3761SEQField new];
        
//        self.setting = [MRSettingsManager sharedMRSettingsManager];
        
//        self.notifyName = [NSString stringWithFormat:@"%@NotigicationFor%@",[self class],self.setting.notifyPrefix];
        
    }
    return self;
}

#pragma mark - parse
dispatch_queue_t queue;
dispatch_group_t  group;


//解析用户数据区
-(void)parseUserData {

    //    group = dispatch_group_create();
    //    queue = dispatch_queue_create("com.x.x", NULL);
    //
    //    int i =0;
    //    while (i<10000) {
    //        dispatch_group_async(group,queue, ^{
    //            NSLog(@"Alive.......%d",i);
    //        });
    //        i++;
    //    }
    //
    //    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    //    [self sendResult];
    
    if (self.controlField.FCBOrACD) {
        self.auxFieldLength += 2;
    }
    
    if (self.SEQ.TpV) {
        self.auxFieldLength += 6;
    }
    
    if (self.dadt.count > 1) {
        [self parseCombineDADT];
    }else {
        [self parseNonComebineDADT];
    }
}

//解析组合DADT串行对垒顺序执行解析
-(void)parseCombineDADT {

    NSString *fnNumber;
    SEL fnMethod;
    group = dispatch_group_create();
    queue = dispatch_queue_create("COM.MRCOMBINE.QUEUE",DISPATCH_QUEUE_SERIAL);
    
    //循环执行分解得到的dadt 得到总的数据集
    for (MR3761DADTRecord *record in self.dadt){
        fnNumber = [NSString stringWithFormat:@"F%ld",record.fId];
        fnMethod = NSSelectorFromString(fnNumber);
        
        dispatch_block_t _block = ^(void) {
//            if (!self.setting.cancelSend) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored  "-Warc-performSelector-leaks"
                [self performSelector:fnMethod];
#pragma clang diagnostic pop
//            }
        };
        dispatch_group_async(group, queue, _block);
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
//    self.notifyName = [NSString stringWithFormat:@"%@Notification",self.notifyName];
    
    [self sendResult];
}

//适用于多个DADT散布于用户区串行队列顺序执行解析
-(void)parseNonComebineDADT {

    queue = dispatch_queue_create("COM.MRNOCOMBINE.QUEUE", DISPATCH_QUEUE_SERIAL);
    group = dispatch_group_create();
    
    NSString *fnNumber;
    SEL fnMethod;
    
    MR3761DADTRecord *record = (MR3761DADTRecord *)[self.dadt objectAtIndex:0];
    
    fnNumber = [NSString stringWithFormat:@"F%ld",record.fId];
    fnMethod = NSSelectorFromString(fnNumber);
    
    dispatch_group_async(group, queue, ^{
//        if(!self.setting.cancelSend){
#pragma clang diagnostic push
#pragma clang diagnostic ignored  "-Warc-performSelector-leaks"
//            [self performSelector:fnMethod];
#pragma clang diagnostic pop
//        }
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    [self shouldContinue];
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    //    self.notifyName = [NSString stringWithFormat:@"%@Notification",self.notifyName];
    
    [self sendResult];
}

/**
 *  递归解析
 */
-(void)shouldContinue {
    //检查用户数据是否解析完毕
    if ((self.pos + self.auxFieldLength + 12) < self.userDataLength) {
    
        NSInteger fN = *(Byte *)(self.userData  + self.pos + 2);
        NSInteger fNGroup = *(Byte *)(self.userData + self.pos + 3);
        NSInteger fNumber = [self parseFnwithGroup:fNGroup withNumber:fN];
        
        NSString *fnNumber = [NSString stringWithFormat:@"F%ld",fNumber];
        SEL fnMethod = NSSelectorFromString(fnNumber);
        
        self.pos += 4;
        
        dispatch_group_async(group, queue, ^{
//            if (!self.setting.cancelSend) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored  "-Warc-performSelector-leaks"
//                [self performSelector:fnMethod];
#pragma clang diagnostic pop
//            }
        });
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    }else {
        return;
    }
    
    [self shouldContinue];
}


-(NSInteger)parseFnwithGroup:(NSInteger)group withNumber:(NSInteger)number{
    
    NSInteger tNumber = 0 ;
    
    for (int i = 7; i >= 0 ; i --) {
        Byte mask;
        if (i >= 4) {
            mask = ((Byte)pow(2, i - 4))<<4 & 0xf0;
        } else {
            mask = (Byte)pow(2, i) & 0x0f;
        }
        if ((number & mask) >> i ) {
            tNumber = group *8 + 1 + i;
        }
    }
    return number;
}

#pragma mark - send
/**
 *  post DATA
 */
-(void)performNotificationWithnotifyName:(NSString *)notifyName
                                  object:(NSObject *)objc   
                                  resylt:(NSDictionary *)resultDic {
    [[NSNotificationCenter defaultCenter]postNotificationName:notifyName
                                                       object:objc
     userInfo:resultDic];
    NSLog(@"发出通知：%@",notifyName);
    
}

/**
 *  send发送
 */
-(void)sendResult {
    NSLog(@"wei 发送");
//    if (!self.setting.cancelSend) {
//        [self performNotificationWithnotifyName:self.notifyName
//                                         object:nil
//                                         resylt:self.finalSet];
//    }
}

/**
 *  BCD转为 Double
 */
-(double)bcdToDoubleWithBytes:(Byte *)bcdCode
                         blen:(NSInteger)bytesLength
                         dlen:(NSInteger)digitLength {

    if (![self checkNullValue:bcdCode withblen:bytesLength]) {
        return 999999;
    }
    double result = 0;
    double temp;
    
    for (NSInteger i = bytesLength - 1; i >= 0; i --) {
        temp = (*(bcdCode + i ) >> 4 & 0x0f) *10 + (*(bcdCode + i) & 0x0f);
        
        result += temp *pow(10, 2*i);
    }
    result = result /pow(10, digitLength);
    return result;
}

/**
 *  BCD转为 DOUBLE 带符号
 */
-(double)bcdToSignedDoubleWithBytes:(Byte *)bcdCode
                               blen:(NSInteger)bytesLength
                               dlen:(NSInteger)digitLength
                            signPos:(NSInteger)pos {
    if (![self checkNullValue:bcdCode withblen:bytesLength]) {
        return 999999;
    }
    double result = 0;
    double temp;
    NSInteger sign = 0;
    
    for (NSInteger i = bytesLength - 1; i >= 0; i --) {
        if (i == bytesLength - 1) {
            if (_pos == Left) {
                sign = *(bcdCode + i) >> 7 & 0x01;
                temp = (*(bcdCode + i) >> 4 & 0x07) *10 +
                (*(bcdCode + 1) & 0x0f);
            } else if (_pos == right) {
                sign = *(bcdCode + i) >> 4 & 0x01;
                temp = (*(bcdCode + i)>> 5 & 0x07) *10
                +(*(bcdCode + i ) & 0x0f);
            } else {
            
                temp = (*(bcdCode + i) >> 4 & 0x0f) *10
                + (*(bcdCode + i) & 0x0f);
                result += temp *pow(10, 2*i);
            }
        }
    }
    
    result = result / pow(10, digitLength);
    if (sign) {
        return  -result;
    }
    return result;
}


/**
 *  BCD转时间 A.17 etc
 */
-(NSString *)bcdToTimeWithBytes:(Byte *)bcdCode
                           blen:(NSInteger)bytesLength
                           type:(NSInteger)type {

    if (![self checkNullValue:bcdCode withblen:bytesLength]) {
        return @"N/A";
    }
    NSString *result = [[NSString alloc]init];
    NSString *temp ;
    
    for (NSInteger i = bytesLength - 1; i >= 0; i --) {
        temp = [NSString stringWithFormat:@"%d", *(bcdCode + i) >> 4 & 0x0f];
        result = [result stringByAppendingString:temp];
        
        temp = [NSString stringWithFormat:@"%d", *(bcdCode + i) & 0x0f];
        result = [result stringByAppendingString:temp];
        
        if (type == 1) {
            if (i == 4) {
                result = [result stringByAppendingString:@"年"];
            } else if (i == 3) {
                result = [result stringByAppendingString:@"月"];
            } else if (i == 2) {
                result = [result stringByAppendingString:@"日"];
            } else {
                if (i) result = [result stringByAppendingString:@":"];
            }
        } else {
            if (i)result = [result stringByAppendingString:@":"];
        }
    }
    return result;
}

/**
 *  ASCll to NSString
 */
-(NSString *)asciiToStringWithBytes:(Byte *)asciiCode
                               blen:(NSInteger)bytesLength {

    if (![self checkNullValue:asciiCode withblen:bytesLength]) {
        return @"N/A";
    }
    
    NSString *result = @"";
    NSString *temp;
    for (int i = 0; i < bytesLength; i ++) {
        temp = [NSString stringWithFormat:@"%c",*(Byte *)(asciiCode + i)];
        
        result = [result stringByAppendingString:temp];
    }
    return result;
}

/**
 *  BIN to NSString
 */
-(NSString *)binToStringWithBytes:(Byte *)bin
                             blen:(NSInteger)bytesLength {
    if (![self checkNullValue:bin withblen:bytesLength]) {
        return @"N/A";
    }
    
    NSString *result  = @"";
    NSString *temp;
    
    for (int i  = 0; i < bytesLength; i ++) {
        temp = [NSString stringWithFormat:@"%d",*(Byte *)(bin + i)];
        
        result = [result stringByAppendingString:temp];
    }
    return result;
}


-(BOOL)checkNullValue:(Byte*)userData withblen:(NSInteger)blen{

    BOOL flag = NO;
    
    for (int i = 0 ; i < blen; i ++) {
        if (userData[i] != 0xee && userData[i]!=0xff) {
            flag = YES;
        }
    }
    return flag;
}

/**
 *  总费率 1~M；decimal
 */
-(void)performGenericWithKey:(int)key
                      Length:(int)byteLength
                        Rate:(int)rate
                       Digit:(int)digit {

    [self.resultSet setValue:[NSNumber numberWithDouble:[self bcdToDoubleWithBytes:self.userData + self.pos
                                                                             blen:byteLength
                                                                             dlen:digit]]
                      forKey:[self getKeyString:key]];
    self.pos += byteLength;
    
    for (int i = 1; i <= rate; i ++) {
        [self.resultSet setValue:[NSNumber numberWithDouble:[self bcdToDoubleWithBytes:self.userData + self.pos
                                                                                 blen:byteLength
                                                                                 dlen:digit]]
                          forKey:[self getKeyString:key + i]];
        self.pos += byteLength;
    }
}

/**
 *  总费率 1~M；decimal time
 */
-(void)performGenericWithKey:(int)key
                        Key2:(int)key2
                     Length1:(int)byteLength1
                     Length2:(int)byteLength2
                        Rate:(int)rate
                       Digit:(int)digit {
[self.resultSet setValue:[NSNumber numberWithDouble:[self bcdToDoubleWithBytes:self.userData + self.pos
                                                                          blen:byteLength1
                                                                          dlen:digit]]
                  forKey:[self getKeyString:key]];
    self.pos += byteLength1;
    
    [self.resultSet setValue:[self bcdToTimeWithBytes:self.userData + self.pos
                                                 blen:byteLength2
                                                 type:2]
                      forKey:[self getKeyString:key2]];
    self.pos += byteLength2;
    
    for (int i = 1; i < rate; i ++) {
        [self.resultSet setValue:[NSNumber numberWithDouble:[self bcdToDoubleWithBytes:self.userData + self.pos
                                                                                  blen:byteLength1
                                                                                  dlen:digit]]
                          forKey:[self getKeyString:key +i]];
        self.pos += byteLength1;
        
        [self.resultSet setValue:[self bcdToTimeWithBytes:self.userData + self.pos
                                                    blen:byteLength2
                                                    type:2]
    forKey:[self getKeyString:key2 + i]];
        
        self.pos += byteLength2;
    }
}

/**
 *  总费率 1~M; time
 */
-(void)performGenericWithKey:(int)key
                      Length:(int)byteLength
                        Rate:(int)rate {
[self.resultSet setValue:[self bcdToTimeWithBytes:self.userData +self.pos
                                             blen:byteLength
                                             type:2]
                  forKey:[self getKeyString:key]];
    self.pos += byteLength;

    for (int i = 1; i < rate; i ++) {
        [self.resultSet setValue:[self bcdToTimeWithBytes:self.userData + self.pos
                                                     blen:byteLength
                                                     type:2]
                          forKey:[self getKeyString:key + i]];
        self.pos += byteLength;
    }
}

-(void)performGenericWithKey:(int)key
                      Length:(int)byteLength
                        Rate:(int)rate
                       Digit:(int)digit
                    isSigned:(BOOL)sign
                     signPos:(int)pos {
    for (int i = 0; i < rate; i ++) {
        if (sign) {
            [self.resultSet setValue:[NSNumber numberWithDouble:
                                      [self bcdToSignedDoubleWithBytes:self.userData + self.pos
                                                              blen:byteLength
                                                              dlen:digit
                                                           signPos:pos]]
                              forKey:[self getKeyString:key + i]];
        } else {
        [self.resultSet setValue:[NSNumber numberWithDouble:
                                  [self bcdToDoubleWithBytes:self.userData +self.pos
                                                        blen:byteLength
                                                        dlen:digit]]
                          forKey:[self getKeyString:key + i]];
        }
        self.pos += byteLength;
    }
}

-(void)performGenericWithKey:(int)key
                        Key2:(int)key2
                      Length:(int)byteLength
                   LoopTimes:(int)rate
                       Digit:(int)digit {
    self.pos += 2;
    
    for (int i = 0; i < rate; i ++) {
        [self.resultSet setValue:[NSNumber numberWithDouble:[self bcdToDoubleWithBytes:self.userData + self.pos
                                                                                  blen:byteLength
                                                                                  dlen:digit]]
                          forKey:[self getKeyString:key + i]];
        self.pos += byteLength;
        
        [self.resultSet setValue:[self bcdToTimeWithBytes:self.userData + self.pos
                                                     blen:byteLength
                                                     type:2]
                          forKey:[self getKeyString:key2 + i]];
        self.pos += byteLength;
    }
}

-(NSString *)getKeyString:(int)key {
    return [NSString stringWithFormat:@"%d",key];
}

//-(NSString *)description {
//return @"222";
//}

-(void)dealloc {
//    [super dealloc];
    free(_userData);
}

@end
