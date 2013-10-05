//
//  RegularString.m
//  AKTestFreamework
//
//  Created by P.I.akura on 2013/09/20.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "RegularString.h"
#import "RandString.h"

@interface RegularBase : NSObject
@end
@interface RegularOneString : RegularBase
@end
@interface RegularWord : RegularBase
+ (RegularBase *)generat;
@end
@interface RegularAlphabet : RegularWord
@end
@interface RegularAll : RegularWord
@end


@implementation RegularBase {
    NSMutableArray *str;
}
+ (RegularBase *)generat:(NSMutableString *)string {
    return [[self alloc] initWithRegular:string];
}
- (id)initWithRegular:(NSMutableString *)regular {
    self = [super init];
    if (self) {
        str = [NSMutableArray array];
        while (regular.length != 0) {
            NSMutableString *s = [self push:regular].mutableCopy;
            if ([s isEqualToString:@"\\"]) {
                NSMutableString *next = [self push:regular].mutableCopy;
                if ([next isEqualToString:@"w"]) {
                    [str addObject:[RegularAlphabet generat]];
                } else {
                    [str addObject:[RegularOneString generat:s]];
                    [str addObject:[RegularOneString generat:next]];
                }
            } else if ([s isEqualToString:@"."]){
                [str addObject:[RegularAll generat]];
            } else {
                [str addObject:[RegularOneString generat:s]];
            }
        }
    }
    return self;
}
- (NSString *)push:(NSMutableString *)string {
    NSString *result = [string substringToIndex:1];
    [string deleteCharactersInRange:(NSRange){0, 1}];
    return result;
}

- (NSString *)string {
    NSMutableString *string = [NSMutableString string];
    for (RegularBase *rb in str) {
        [string appendString:[rb string]];
    }
    return string;
}
@end

@implementation RegularOneString {
    NSString *string;
}
+ (RegularBase *)generat:(NSMutableString *)string {
    return [[self alloc] initWithRegular:string];
}
- (id)initWithRegular:(NSMutableString *)regular {
    self = [super init];
    if (self) {
        string = regular;
    }
    return self;
}

- (NSString *)string {
    return string;
}
@end
@implementation RegularWord {
@protected
    RandString *rand;
}
+ (RegularBase *)generat {
    return [[self alloc] init];
}
- (NSString *)string {
    return [rand nextString];
}
@end
#define RWord(class, randClass) @implementation class \
- init { self = [super init]; if (self) { rand = [randClass alloc]; } return self; }\
@end
RWord(RegularAlphabet, Alphabet)
RWord(RegularAll, AsciiWord)

@implementation RegularString

- (NSString *)stringForRefular:(NSString *)reg {
    return [[RegularBase generat:reg.mutableCopy] string];
}

@end
