//
//  WWInheritanceProxyTests.m
//  ArtificalInheritance
//
//  Created by Egor Chiglintsev on 03.04.15.
//  Copyright (c) 2015 Egor Chiglintsev. All rights reserved.
//

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
