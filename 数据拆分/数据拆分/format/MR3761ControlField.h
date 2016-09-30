//
//  MR3761ControlField.h
//  报文生成
//
//  Created by hl on 16/8/16.
//  Copyright © 2016年 hl. All rights reserved.
//

#import <Foundation/Foundation.h>

//控制域

@interface MR3761ControlField : NSObject

@property (nonatomic, assign)NSInteger DIR; //传输方向位
@property (nonatomic, assign)NSInteger PRM; //启动标志位
@property (nonatomic, assign)NSInteger FCBOrACD; //帧计数位OR要求访问位
@property (nonatomic, assign)NSInteger FCV; //帧计数有效位
@property (nonatomic, assign)NSInteger CID; //功能码

-(instancetype)initWithDir:(NSInteger)dir prm:(NSInteger)prm fcdOrAcd:(NSInteger)fcdOrAcd fcv:(NSInteger)fcv cid:(NSInteger)cid;

@end
