//
//  ViewController.m
//  数据拆分
//
//  Created by hl on 16/8/28.
//  Copyright © 2016年 hl. All rights reserved.
//

#import "ViewController.h"

#import "MRFrameData.h"

@interface ViewController ()
/**
 *  主体
 */
@property (weak, nonatomic) IBOutlet UITextField *bodyTF;
/**
 *  长度
 */
@property (weak, nonatomic) IBOutlet UITextField *lengthTF;
/**
 *  控制 十六进制
 */
@property (weak, nonatomic) IBOutlet UITextField *controlHEXTF;
/**
 *  控制 二进制
 */
@property (weak, nonatomic) IBOutlet UITextField *controlBitTF;
@property (weak, nonatomic) IBOutlet UITextField *AFNTF;
@property (weak, nonatomic) IBOutlet UITextField *SEQTF;
@property (weak, nonatomic) IBOutlet UITextField *DATAIDTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
/**
 *  数据项
 */
@property (weak, nonatomic) IBOutlet UITextView *dataItemTV;
@property (weak, nonatomic) IBOutlet UITextField *PnTF;
@property (weak, nonatomic) IBOutlet UITextField *FnTF;
/**
 *  拆分
 */
@property (weak, nonatomic) IBOutlet UIButton *splitBtn;

@end

@implementation ViewController

- (IBAction)splitBtn:(id)sender {
    
    if (_bodyTF.text.length != 0) {

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSData *data =  [self convertHexStrToData:_bodyTF.text];

       MRFrameData *frame =   [[MRFrameData alloc]initWithData:data];
        [frame parseUserData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([MR3761SplitManager shareMR3761SplitManager].isCompleted) {
                NSLog(@"%d",*[MR3761SplitManager shareMR3761SplitManager].addressField.A1);
                NSString *a1 = [self cover4withStr:[NSString stringWithFormat:@"%x",*[MR3761SplitManager shareMR3761SplitManager].addressField.A1]];
                NSString *a2 = [self cover4withStr:[NSString stringWithFormat:@"%x",*[MR3761SplitManager shareMR3761SplitManager].addressField.A2 ]];
                NSString *a3 = [NSString stringWithFormat:@"%x",*[MR3761SplitManager shareMR3761SplitManager].addressField.A3];
                self.addressTF.text = [NSString stringWithFormat:@"%@%@%@",a1,a2,a3];
                
            }
        });
    });
    } else {
    
    }
}

//byte 转data
-(NSString *)byteToStr:(Byte *)byte {
    NSData *data = [NSData dataWithBytes:byte  length: sizeof(byte)];
    NSString *string = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
    return string;
}

-(unsigned long) HexToStr:(NSString *)str {
    
    NSString *hexstr = [NSString stringWithFormat:@"0x%@",str];
    unsigned long red = strtoul([hexstr UTF8String], 0, 16);
    NSLog(@"%lx",red);
    return red;
    
}

//16转data
- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    NSLog(@"hexdata: %@", hexData);
    return hexData;
}

-(NSString *)cover4withStr:(NSString *)str {
    switch (str.length) {
        case 1:
             return [NSString stringWithFormat:@"000%@",str];
//            return [NSString stringWithFormat:@"0000000%@",str];
            break;
        case 2:
             return [NSString stringWithFormat:@"00%@",str];
//            return [NSString stringWithFormat:@"000000%@",str];
            break;
        case 3:
             return [NSString stringWithFormat:@"0%@",str];
//            return [NSString stringWithFormat:@"00000%@",str];
            break;
        case 4:
            return str;
//            return [NSString stringWithFormat:@"0000%@",str];
            break;
//        case 5:
//            return [NSString stringWithFormat:@"000%@",str];
//            break;
//        case 6:
//            return [NSString stringWithFormat:@"00%@",str];
//            break;
//        case 7:
//            return [NSString stringWithFormat:@"0%@",str];
//            break;
//        case 8:
//            return str;
//            break;
        default:
            return [NSString stringWithFormat:@"00000000"];
            break;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
