//
//  MR3761Header.h
//  报文生成
//
//  Created by hl on 16/8/16.
//  Copyright © 2016年 hl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MR3761Header : NSObject

@property (nonatomic, assign)Byte *start1;
@property (nonatomic, assign)unsigned short *LengthL1;
@property (nonatomic, assign)unsigned short *LengthL2;
@property (nonatomic, assign)Byte *start2;
@property (nonatomic, assign) Byte *cs;
@property (nonatomic, assign)Byte *end;

-(id)initWithStart1:(Byte *)start1 length1:(unsigned short *)length1 length2:(unsigned short *)length2 strat2:(Byte *)start2 cs:(Byte *)cs end:(Byte *)end;

@end
