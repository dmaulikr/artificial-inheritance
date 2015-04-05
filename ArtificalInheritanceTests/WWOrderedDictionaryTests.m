//
//  WWOrderedDictionaryTests.m
//  ArtificalInheritance
//
//  Created by Egor Chiglintsev on 05.04.15.
//  Copyright (c) 2015  Egor Chiglintsev
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "WWOrderedDictionary.h"

@interface WWOrderedDictionaryTests : XCTestCase
@end

@implementation WWOrderedDictionaryTests

- (void)testThatIsKindOfDictionary
{
    WWOrderedDictionary *dict = [[WWOrderedDictionary alloc] initWithDictionary: @{}];
    XCTAssertTrue([dict isKindOfClass: [NSDictionary class]], @"WWOrderedDictionary should be a kind of NSDictionary");
}


- (void)testThatIsKindOfNSArray
{
    WWOrderedDictionary *dict = [[WWOrderedDictionary alloc] initWithDictionary: @{}];
    XCTAssertTrue([dict isKindOfClass: [NSArray class]], @"WWOrderedDictionary should be kind of NSArray");
}


- (void)testObjectForKeyWorks
{
    NSDictionary *dict = (id)[[WWOrderedDictionary alloc] initWithDictionary: @{ @1 : @"value_1",
                                                                                 @2 : @"value_2" }];
    XCTAssertEqualObjects([dict objectForKey: @1], @"value_1");
    XCTAssertEqualObjects([dict objectForKey: @2], @"value_2");
}


- (void)testObjectAtIndexWorks
{
    NSArray *dict = (id)[[WWOrderedDictionary alloc] initWithDictionary: @{ @2 : @"value_2",
                                                                            @1 : @"value_1" }];
    XCTAssertEqualObjects([dict objectAtIndex: 0], @1);
    XCTAssertEqualObjects([dict objectAtIndex: 1], @2);
}


- (void)testArrayMethodsWork
{
    NSArray *dict = (id)[[WWOrderedDictionary alloc] initWithDictionary: @{ @2 : @"value_2",
                                                                            @3 : @"value_3",
                                                                            @1 : @"value_1" }];
    XCTAssertEqualObjects([dict firstObject], @1);
    XCTAssertEqualObjects([dict lastObject], @3);
    XCTAssertEqual([dict indexOfObject: @2], 1u);

}


- (void)testFastEnumeration
{
    NSDictionary *dict = (id)[[WWOrderedDictionary alloc] initWithDictionary: @{ @3 : @"value_3",
                                                                                 @1 : @"value_1",
                                                                                 @2 : @"value_2" }];
    NSMutableArray *enumerated = [NSMutableArray new];
    
    for (id key in dict) {
        [enumerated addObject: key];
    }
    
    XCTAssertEqualObjects(enumerated, (@[@1, @2, @3]));
}


- (void)testMutation
{
    NSMutableDictionary *dict = (id)[[WWOrderedDictionary alloc] initWithDictionary: [NSMutableDictionary new]];
    dict[@3] = @"value_3";
    dict[@1] = @"value_1";
    dict[@2] = @"value_2";
    
    XCTAssertEqualObjects(dict.allKeys, (@[@1, @2, @3]));
}

@end
