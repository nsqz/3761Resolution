//
//  MRFrameData.m
//  报文生成
//
//  Created by hl on 16/8/16.
//  Copyright © 2016年 hl. All rights reserved.
//

#import "MRFrameData.h"


#import "MR3761AddressField.h"
#import "MR3761ControlField.h"
#import "MR3761SEQField.h"
#import "MR3761Header.h"
#import "MR3761DADTRecord.h"

@interface MRFrameData ()
@property (nonatomic, assign)NSInteger frameLength; //帧总长

@property (nonatomic, assign)Byte *frameData; //帧数据

@property (nonatomic, assign)int userDateLength; //用户数据长度


-(Byte)getCheckSum:(Byte *)userData :(int)length;     //获取校验和

-(int) parseUserDataLength;                           //解析用户数据长度

-(BOOL)frameCheck;                                    //帧检查

-(void)initBaseRequest;

-(void)parseControlField;                             //解析控制域

-(void)parseAddressField;                             //解析地址域

-(void)parseSEQField;

-(void)parseDADT;

-(void)parseAUXField;

-(NSString*)getHexString:(Byte)byte;

-(Byte)getMaskByte:(NSInteger)i;

@end

@implementation MRFrameData

/**
 *  初始化
 */
- (instancetype)initWithData:(NSData *)recData
{
    self = [super init];
    if (self) {
        self.receivedData = recData;
        _frameLength = [self.receivedData length];
        
        _frameData = malloc(_frameLength);
        
        memcpy(_frameData, (Byte *)[self.receivedData bytes], _frameLength);

//            self.baseRequest = [[MR3761BaseRequest alloc] init];
        /**
         *  新添加
         */
        [MR3761SplitManager shareMR3761SplitManager];
    }
    return self;
}

/**
 *  帧检查
 */
-(BOOL)frameCheck {
    if (self.receivedData.length != 0) {
        _userDateLength = [self parseUserDataLength];
        
        if (_userDateLength == -1) {
            return NO;
        }
        /**
         *  检查起始位结束位
         */
        if (*(_frameData)             != FRAME_START_BYTE ||
            *(_frameData + 5)           !=FRAME_START_BYTE ||
            *(_frameData + _frameLength - 1) != FRAME_END_BYTE ) {
            
            NSLog(@"开始位结束位出错");
            return NO;
        }
        
        /**
         *  检查校验和
         */
        if([self getCheckSum:_frameData + 6 :_userDateLength] != *(_frameData + _frameLength - 2)) {
            NSLog(@"校验和检查出错");
            return NO;
        }
    } else {
        return NO;
    }
    
    return YES;
}

/**
 *  获取校验和
 */
-(Byte)getCheckSum:(Byte *)userData :(int)length {
    Byte *pos = userData;
    Byte total = 0;
    
    for (int i = 0 ; i  < length; ++ i) {
        total += *pos;
        ++ pos;
    }
    
    return  total;
}

/**
 *  解析用户数据长度
 */
-(int)parseUserDataLength {
//#warning 没加14.11 加了 
    unsigned short *lengthField = (unsigned short *)(_frameData +1);
    
    //检测协议类型
    if ((*lengthField & 0x0003)!= PROTOCOL) {
        return -1;
    }
    NSLog(@"用户数据长度：%d",(*lengthField) >> 2);
    
    return (*lengthField) >> 2;
}

#pragma mark - frame parse
/**
 *  解析固定字节
 */
-(void)initBaseRequest {
 
//    self.baseRequest = [[MR3761BaseRequest alloc] init];

//#warning 删除*
//    _baseRequest.userDataLength = _userDateLength;
    [self parseControlField];
    [self parseAddressField];
    [self parseSEQField];
    [self parseDADT];
    
    
//    _baseRequest.userData = malloc(_userDateLength - 11);
//    memcpy(_baseRequest.userData, _frameData + 18, _userDateLength);
//    memcpy(_baseRequest.userData, _frameData + 18, _userDateLength);
    
//    free(_frameData);
}

/**
 *  解析信息点信息类
 */
-(void)parseDADT {

    NSMutableArray*dadtArray = [[NSMutableArray alloc]init];
    NSMutableArray *fNArray = [[NSMutableArray alloc]init];
    NSMutableArray *pNArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    Byte pN  = *(Byte *)(_frameData + 14);
    NSInteger pNGroup = *(Byte *)(_frameData + 15);

    Byte fN = *(Byte *)(_frameData + 16);
    NSInteger fNGroup = *(Byte *)(_frameData + 17);
    
    NSInteger tNumber = 0;
    
    for (int i = 7 ; i >= 0; i --) {
        Byte mask = [self getMaskByte:i];
        
        if ((fN & mask) >> i) {
            tNumber = fNGroup *8 + 1 + i;
            [fNArray addObject:[NSNumber numberWithInteger:tNumber]];
        }
        
        if ((pN & mask) >> i) {
            tNumber = pNGroup *8 -(7 -i);
            [pNArray addObject:[NSNumber numberWithInteger:tNumber]];
        }
    }
    
    pNArray = (NSMutableArray *)[[pNArray reverseObjectEnumerator]allObjects];
    
    for (NSNumber *fNumber in fNArray) {
        if (![pNArray count]) {
            MR3761DADTRecord *record = [[MR3761DADTRecord alloc]initWithPId:0 fId:[fNumber intValue]];
            [dadtArray addObject:record];
        }else {
            for (NSNumber *pNumber in pNArray) {
                MR3761DADTRecord *record  = [[MR3761DADTRecord alloc]initWithPId:[pNumber integerValue] fId:[fNumber integerValue]];
                [dadtArray addObject:record];
            }
        }
    }
//    _baseRequest.dadt = dadtArray;
    [MR3761SplitManager shareMR3761SplitManager].dadt = dadtArray;
}

/**
 *  解析SEQ
 */
-(void)parseSEQField {
    MR3761SEQField *seqField =[[MR3761SEQField alloc]initWithTpV:(*(Byte*)(_frameData) + 13 &0x80)>>7
                                                             fir:(*(Byte *)(_frameData + 13) & 0x40) >>6
                                                             fin:(*(Byte *)(_frameData + 13) & 0x20) >>5
                                                             con:(*(Byte *)(_frameData + 13) & 0x10) >>4
                                                      pseqOrRseq:(*(Byte *)(_frameData + 13) & 0x0f)];
    
    [MR3761SplitManager shareMR3761SplitManager].SEQ = seqField;
//    _baseRequest.SEQ = seqField;
}

/**
 *  解析链路用户数据控制域
 */
-(void)parseControlField {
    
    MR3761ControlField *controlField = [[MR3761ControlField alloc]initWithDir:(*(Byte*)(_frameData+6) & 0x80)>>7
                                                                      prm:(*(Byte*)(_frameData+6) & 0x40)>>6
                                                                 fcdOrAcd:(*(Byte*)(_frameData+6) & 0x20)>>5
                                                                      fcv:(*(Byte*)(_frameData+6) & 0x10)>>4
                                                                      cid:(*(Byte*)(_frameData+6) & 0x0f)];
    
    [MR3761SplitManager shareMR3761SplitManager].controlField = controlField;
//    _baseRequest.controlField = controlField;
}

/**
 *  解析链路用户数据地址域
 */
-(void)parseAddressField {
    MR3761AddressField *addressField = [[MR3761AddressField alloc]initWithA1:(unsigned short *)(_frameData + 7)
                                                                          A2:(unsigned short *)(_frameData + 9)
                                                                          A3:(unsigned char*)(_frameData + 11)];
//    [MR3761SplitManager shareMR3761SplitManager].addressField = addressField;
    
    [MR3761SplitManager shareMR3761SplitManager].addressField = addressField;
//    _baseRequest.addressField = addressField;
}

/**
 *  解析AUX域
 */
-(void)parseAUXField {

}

/**
 *  获得MASK BYTE ps:校验和?
 */
-(Byte)getMaskByte:(NSInteger)i {
    Byte mask;
    if (i >= 4) {
        mask = ((Byte)pow(2, i - 4)) << 4 & 0xf0;
    }else {
        mask = (Byte)pow(2, i) & 0x0f;
    }
    return mask;
}

/**
 *  HEX 4 Class Name ps:转换为大写？
 */
-(NSString *)getHexString:(Byte)byte {
    return [[NSString stringWithFormat:@"%x",byte] uppercaseString];
}

#pragma mark - frames hand out
/**
 *  PARSE
 */
-(void)parseUserData {
    if (![self frameCheck]) {
        return;
    }
//    _baseRequest.AFN = *(Byte *)(_frameData + 12);
    [MR3761SplitManager shareMR3761SplitManager].AFN = *(Byte *)(_frameData + 12);

    NSString *afnClass = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"CLASS_PREFIX", nil),
                          [self getHexString:*(Byte *)(_frameData + 12)]];
    
//    _baseRequest = [[NSClassFromString(afnClass) alloc]init];
    
    [self initBaseRequest];
    
    //校验是否完成
    [MR3761SplitManager shareMR3761SplitManager].isCompleted = YES;
    
//    [self.baseRequest parseUserData];
}



@end
