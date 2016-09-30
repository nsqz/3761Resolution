//
//  MR3761Header.m
//  报文生成
//
//  Created by hl on 16/8/16.
//  Copyright © 2016年 hl. All rights reserved.
//

#import "MR3761Header.h"

@implementation MR3761Header

- (instancetype)initWithStart1:(Byte *)start1 length1:(unsigned short *)length1 length2:(unsigned short *)length2 strat2:(Byte *)start2 cs:(Byte *)cs end:(Byte *)end
{
    self = [super init];
    if (self) {
        self.start1 = start1;
        self.start2 = start2;
        self.LengthL1 = length1;
        self.LengthL2 = length2;
        self.cs = cs;
        self.end = end;
    }
    return self;
}

-(NSString *)description {
    NSLog(@"就是这个");
    return @"xx";
}

@end
