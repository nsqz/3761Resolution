//
//  MR3761DADTRecord.h
//  报文生成
//
//  Created by hl on 16/8/16.
//  Copyright © 2016年 hl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MR3761DADTRecord : NSObject

@property (nonatomic, assign)NSInteger pId;
@property (nonatomic, assign)NSInteger fId;

-(instancetype)initWithPId:(NSInteger)pId fId:(NSInteger)fId;

@end
