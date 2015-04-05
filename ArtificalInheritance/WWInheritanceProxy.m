//
//  ArtificalInheritance.m
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

#import "WWInheritanceProxy.h"

@interface WWInheritanceProxy()
@property (atomic, strong) NSDictionary *parents;
@property (atomic, strong) NSDictionary *designatedTargets;
@end

@implementation WWInheritanceProxy

+ (instancetype)new
{
    return [[WWInheritanceProxy alloc] init];
}

- (instancetype)init
{
    // NSProxy does not have -init
    // self = [super init];
    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat: @"WWInheritanceProxy: %@, parents: %@, designatedTargets: %@",
                self.identity, self.parents, self.designatedTargets];
}


#pragma mark - methods

- (void)inherit:(id)parent
{
    NSParameterAssert(parent != nil);
    if (parent == nil) {
        return;
    }
    
    NSMutableDictionary *parents = [self.parents mutableCopy] ?: [NSMutableDictionary new];
    NSString *className = NSStringFromClass([parent class]);
    
    NSParameterAssert(className != nil);
    if (className == nil) {
        return;
    }
    
    if (self.identity == nil) {
        self.identity = parent;
    }
    
    parents[className] = parent;
    self.parents = [parents copy];
}


- (void)setDesignatedTarget:(id)target forSelector:(SEL)selector
{
    NSParameterAssert(target != nil);
    if (target == nil) {
        return;
    }
    
    NSString *selectorString = NSStringFromSelector(selector);
    NSParameterAssert(selectorString != nil);
    if (selectorString == nil) {
        return;
    }
    
    NSMutableDictionary *designatedTargets = [self.designatedTargets mutableCopy] ?: [NSMutableDictionary new];
    designatedTargets[selectorString] = target;
    self.designatedTargets = [designatedTargets copy];
}


#pragma mark - identity

- (BOOL)isEqual:(id)object
{
    return (self.identity != nil) ? [self.identity isEqual: object] : [super isEqual: object];
}


- (NSUInteger)hash
{
    return (self.identity != nil) ? [self.identity hash] : [super hash];
}


#pragma mark - forwarding

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    for (id parent in self.parents.allValues) {
        if ([parent conformsToProtocol: aProtocol]) {
            return YES;
        }
    }
    return NO;
}


- (BOOL)isKindOfClass:(Class)aClass
{
    for (id parent in self.parents.allValues) {
        if ([parent isKindOfClass: aClass]) {
            return YES;
        }
    }
    return NO;
}


- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    BOOL didInvoke = [self forwardInvocationToDesignatedTarget: anInvocation];
    
    if (didInvoke == NO) {
        for (id parent in self.parents.allValues) {
            if ([parent respondsToSelector: anInvocation.selector]) {
                [anInvocation invokeWithTarget: parent];
                return;
            }
        }
    }
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *result = [self methodSignatureForDesignatedTargetForSelector: aSelector];
    
    if (result == nil) {
        for (id parent in self.parents.allValues) {
            NSMethodSignature *methodSignature = [parent methodSignatureForSelector: aSelector];
            
            if (methodSignature != nil) {
                result = methodSignature;
                break;
            }
        }
    }

    return result ?: [super methodSignatureForSelector: aSelector];
}


- (BOOL)respondsToSelector:(SEL)aSelector
{
    for (id parent in self.parents.allValues) {
        if ([parent respondsToSelector: aSelector]) {
            return YES;
        }
    }
    
    return NO;
}


#pragma mark - designated targets (resolve:with:)

- (NSMethodSignature *)methodSignatureForDesignatedTargetForSelector:(SEL)aSelector
{
    NSString *selectorString = NSStringFromSelector(aSelector);
    id designatedTarget = self.designatedTargets[selectorString];
    return [designatedTarget methodSignatureForSelector: aSelector];
}


- (BOOL)forwardInvocationToDesignatedTarget:(NSInvocation *)invocation
{
    NSString *selectorString = NSStringFromSelector(invocation.selector);
    id designatedTarget = self.designatedTargets[selectorString];
    
    BOOL didInvoke = NO;
    
    if (designatedTarget != nil) {
        [invocation invokeWithTarget: designatedTarget];
    }
    
    return didInvoke;
}

@end
