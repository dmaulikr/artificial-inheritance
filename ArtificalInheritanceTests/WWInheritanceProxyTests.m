//
//  WWInheritanceProxyTests.m
//  ArtificalInheritance
//
//  Created by Egor Chiglintsev on 03.04.15.
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
#import "WWInheritanceProxy.h"

@interface WWInheritanceProxyTests : XCTestCase
{
    id proxy;
}
@end

@implementation WWInheritanceProxyTests

- (void)setUp
{
    proxy = [WWInheritanceProxy new];
}


- (void)testThatEqualsToInheritedString
{
    NSString *string = @"Parent string";
    [proxy inherit: string];
    
    XCTAssertEqualObjects(proxy, string, @"Proxy should be equal to the string it has inherited");
}


- (void)testThatInheritsStringIntegerValue
{
    [proxy inherit: @"3"];
    
    XCTAssertEqual([proxy integerValue], 3, @"Proxy should inherit NSString properties");
}


- (void)testThatInheritsNumberIntegerValue
{
    [proxy inherit: @4];
    XCTAssertEqual([proxy integerValue], [@4 integerValue], @"Proxy should inherit NSNumber values properly");
}


- (void)testThatResolvingWorks
{
    [proxy inherit: @4];
    [proxy inherit: @"3"];
    [proxy setDesignatedTarget: @4 forSelector: @selector(integerValue)];
    XCTAssertEqual([proxy integerValue], [@4 integerValue], @"Proxy should use the designated target with multiple inheritance if provided");
}

@end
