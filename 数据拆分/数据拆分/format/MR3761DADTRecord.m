//
//  MR3761DADTRecord.m
//  报文生成
//
//  Created by hl on 16/8/16.
//  Copyright © 2016年 hl. All rights reserved.
//

#import "MR3761DADTRecord.h"

@implementation MR3761DADTRecord
//@synthesize fId;
- (instancetype)initWithPId:(NSInteger)pId fId:(NSInteger)fId
{
    self = [super init];
    if (self) {
        self.pId = pId;
        self.fId = fId;
    }
    return self;
}

@end
