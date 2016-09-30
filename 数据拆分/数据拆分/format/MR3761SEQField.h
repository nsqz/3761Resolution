//
//  MR3761SEQField.h
//  报文生成
//
//  Created by hl on 16/8/16.
//  Copyright © 2016年 hl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MR3761SEQField : NSObject

@property (nonatomic, assign)NSInteger TpV; //帧时间标签有效位
@property (nonatomic, assign)NSInteger FIR;  //首帧标志
@property (nonatomic, assign)NSInteger FIN; //末帧标志
@property (nonatomic, assign)NSInteger CON; //请求确认标志位
@property (nonatomic, assign)NSInteger PSEQOrRSEQ; //启动帧序号/响应者序号

-(instancetype)initWithTpV:(NSInteger)tpv fir:(NSInteger)fir fin:(NSInteger)fin con:(NSInteger)con pseqOrRseq:(NSInteger)pseqOrRseq;

@end
