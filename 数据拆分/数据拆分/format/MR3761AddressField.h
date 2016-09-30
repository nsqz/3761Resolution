//
//  MR3761AddressField.h
//  报文生成
//
//  Created by hl on 16/8/16.
//  Copyright © 2016年 hl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MR3761AddressField : NSObject

@property (nonatomic, assign)unsigned short *A1; // 行政地址
@property (nonatomic, assign)unsigned short *A2; //终端地址
@property (nonatomic, assign)Byte *A3; //主站地址和组地址标志

-(instancetype)initWithA1:(unsigned short *)A1 A2:(unsigned short *)A2 A3:(Byte *)A3;


@end
