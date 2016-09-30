//
//  MR3761SplitManager.h
//  数据拆分
//
//  Created by hl on 16/8/28.
//  Copyright © 2016年 hl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MR3761AddressField.h"
#import "MR3761ControlField.h"
#import "MR3761SEQField.h"
#import "MR3761Header.h"
#import "MR3761DADTRecord.h"

@interface MR3761SplitManager : NSObject

//@property (nonatomic, strong)NSMutableDictionary *MR3761Dic;

@property (nonatomic, retain)MR3761Header *header;
@property (nonatomic, retain)MR3761ControlField *controlField;
@property (nonatomic, retain)MR3761AddressField *addressField;

@property (nonatomic, assign)Byte AFN;
@property (nonatomic, retain)MR3761SEQField *SEQ;
@property (nonatomic, retain)NSArray *dadt;
@property (nonatomic, assign)Byte *userData;

//@property (nonatomic, retain)NSMutableDictionary *resultSet;
//@property (nonatomic, retain)NSMutableDictionary *finalSet;

@property (nonatomic, assign)NSInteger auxFieldLength;
@property (nonatomic, assign)NSInteger pos;
@property (nonatomic, assign)NSInteger userDataLength;
@property (nonatomic, assign)NSInteger ketCount;

@property (nonatomic, assign)BOOL isCompleted;

+(MR3761SplitManager *)shareMR3761SplitManager;

@end
