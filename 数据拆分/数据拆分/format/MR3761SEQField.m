//
//  MR3761SEQField.m
//  报文生成
//
//  Created by hl on 16/8/16.
//  Copyright © 2016年 hl. All rights reserved.
//

#import "MR3761SEQField.h"

@implementation MR3761SEQField

- (instancetype)initWithTpV:(NSInteger)tpv fir:(NSInteger)fir fin:(NSInteger)fin con:(NSInteger)con pseqOrRseq:(NSInteger)pseqOrRseq
{
    self = [super init];
    if (self) {
        self.TpV = tpv;
        self.FIR = fir;
        self.FIN = fin;
        self.CON = con;
        self.PSEQOrRSEQ = pseqOrRseq;
    }
    return self;
}

@end
