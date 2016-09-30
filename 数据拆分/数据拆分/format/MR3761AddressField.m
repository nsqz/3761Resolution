//
//  MR3761AddressField.m
//  报文生成
//
//  Created by hl on 16/8/16.
//  Copyright © 2016年 hl. All rights reserved.
//

#import "MR3761AddressField.h"

@implementation MR3761AddressField

- (instancetype)initWithA1:(unsigned short *)A1 A2:(unsigned short *)A2 A3:(Byte *)A3
{
    self = [super init];
    if (self) {
        self.A1 = A1;
        self.A2 = A2;
        self.A3 = A3;
    }
    return self;
}

@end
