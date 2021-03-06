//
//  RegularStringTest.m
//  AKTestFreamework
//
//  Created by P.I.akura on 2013/10/05.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "AKURegularString.h"

@interface RegularStringTest : XCTestCase
@end

@implementation RegularStringTest

- (BOOL)isMatch:(NSString *)string reg:(NSString *)pattern {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:string];
}
- (void)testRegularTest {
    NSString *sample = @"hoge";
    NSString *result = [[AKURegularString alloc] stringForRegular:sample];
    XCTAssertEqualObjects(result, sample, @"eq");
}
- (void)testRegularTestW {
    NSString *sample = @"hoge\\w";
    NSString *result = [[AKURegularString alloc] stringForRegular:sample];
    XCTAssertNotEqualObjects(result, sample, @"\\wはパターン");
    XCTAssertTrue(result.length == 5, @"length 5");
    XCTAssertTrue([self isMatch:result reg:sample], @"pattern match");
}
- (void)testRegularTestDot {
    NSString *sample = @"hoge.";
    NSString *result = [[AKURegularString alloc] stringForRegular:sample];
    XCTAssertTrue(result.length == 5, @"length 5");
    XCTAssertTrue([self isMatch:result reg:sample], @"pattern match");
}
- (void)testRegularTestNewline {
    NSString *sample = @"hoge\\n";
    NSString *result = [[AKURegularString alloc] stringForRegular:sample];
    XCTAssertEqualObjects(result, @"hoge\n", @"\\nを\nに変換");
    XCTAssertTrue([self isMatch:result reg:sample], @"pattern match");
}
- (void)testRegularBackslash {
    NSString *sample = @"hoge\\\\";
    NSString *result = [[AKURegularString alloc] stringForRegular:sample];
    XCTAssertEqualObjects(result, @"hoge\\", @"\\\\を\\に変換");
    XCTAssertTrue([self isMatch:result reg:sample], @"pattern match");
}
- (void)testRegularAst {
    NSString *sample = @"\\\\*";
    NSString *result = [[AKURegularString alloc] stringForRegular:sample];
    XCTAssertNotEqualObjects(result, @"\\\\*", @"そのままではない");
    XCTAssertTrue(0 <= result.length && result.length <= 16, @"repeat");
    XCTAssertTrue([self isMatch:result reg:sample], @"pattern match");
}
- (void)testRegularPlus {
    NSString *sample = @"\\\\+";
    NSString *result = [[AKURegularString alloc] stringForRegular:sample];
    XCTAssertNotEqualObjects(result, @"\\\\+", @"そのままではない");
    XCTAssertTrue(1 <= result.length && result.length <= 16, @"repeat");
    XCTAssertTrue([self isMatch:result reg:sample], @"pattern match");
}
- (void)testRegularQes {
    NSString *sample = @"h?";
    NSString *result = [[AKURegularString alloc] stringForRegular:sample];
    XCTAssertNotEqualObjects(result, @"h?", @"そのままではない");
    XCTAssertTrue(0 <= result.length && result.length <= 1, @"repeat");
    XCTAssertTrue([self isMatch:result reg:sample], @"pattern match");
}
- (void)testRegularGroup {
    NSString *sample = @"(ho)+";
    NSString *result = [[AKURegularString alloc] stringForRegular:sample];
    XCTAssertNotEqualObjects(result, @"(ho)+", @"そのままではない");
    XCTAssertTrue(2 <= result.length && result.length <= 32, @"repeat");
    XCTAssertTrue([self isMatch:result reg:sample], @"pattern match");
}
- (void)testRegular {
    NSString *sample = @"\\\\*";
    NSString *result = @"k";
    XCTAssertFalse([self isMatch:result reg:sample], @"pattern match");
}
- (void)testOr {
    NSString *sample = @"a|b";
    NSString *result = [[AKURegularString alloc] stringForRegular:sample];
    XCTAssertTrue([result isEqual:@"a"] || [result isEqual:@"b"], @"a|b");
}

@end
