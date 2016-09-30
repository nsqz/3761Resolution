//
//  MRFrameData.h
//  报文生成
//
//  Created by hl on 16/8/16.
//  Copyright © 2016年 hl. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "MR3761BaseRequest.h"
#import "MR3761SplitManager.h"


//3761协议标识
#define PROTOCOL   0x2
//帧起始符
#define FRAME_START_BYTE 0x68
//帧结束符
#define FRAME_END_BYTE   0x16

@interface MRFrameData : NSObject

@property (nonatomic, retain)NSData *receivedData;

//@property (nonatomic, strong)MR3761BaseRequest *baseRequest;


-(id)initWithData:(NSData *)recData;
-(void)parseUserData;


@end
