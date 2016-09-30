//
//  MR3761AUXField.h
//  报文生成
//
//  Created by hl on 16/8/16.
//  Copyright © 2016年 hl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MR3761AUXField : NSObject

@property (nonatomic, assign)Byte *PW;
@property (nonatomic, assign)unsigned short *EC;
@property (nonatomic, assign)Byte *Tp;

@property (nonatomic, assign)BOOL hasPW;
@property (nonatomic, assign)BOOL hasEC;
@property (nonatomic, assign)BOOL hasTp;

@end
