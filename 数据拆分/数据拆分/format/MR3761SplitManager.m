//
//  MR3761SplitManager.m
//  数据拆分
//
//  Created by hl on 16/8/28.
//  Copyright © 2016年 hl. All rights reserved.
//

#import "MR3761SplitManager.h"

static MR3761SplitManager *manager = nil;
@implementation MR3761SplitManager


+(MR3761SplitManager *)shareMR3761SplitManager {
        @synchronized(self) {
            if (manager == nil) {
                manager = [[MR3761SplitManager alloc]init];
            }
        }
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.MR3761Dic = [NSMutableDictionary dictionary];
        
        self.addressField = [[MR3761AddressField alloc]init];
                self.controlField = [[MR3761ControlField alloc]init];
                self.header = [[MR3761Header alloc]init];
                self.SEQ = [[MR3761SEQField alloc]init];
        self.isCompleted = NO;
    }
    return self;
}

@end
