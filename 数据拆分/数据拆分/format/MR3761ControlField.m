//
//  MR3761ControlField.m
//  报文生成
//
//  Created by hl on 16/8/16.
//  Copyright © 2016年 hl. All rights reserved.
//

#import "MR3761ControlField.h"


@implementation MR3761ControlField


- (instancetype)initWithDir:(NSInteger)dir prm:(NSInteger)prm fcdOrAcd:(NSInteger)fcdOrAcd fcv:(NSInteger)fcv cid:(NSInteger)cid
{
    self = [super init];
    if (self) {
        self.DIR = dir;
        self.PRM = prm;
        self.FCBOrACD = fcdOrAcd;
        self.FCV = fcv;
        self.CID = cid;
    }
    return self;
}

@end
