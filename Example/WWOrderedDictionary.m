//
//  WWOrderedDictionary.m
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

#import "WWOrderedDictionary.h"

@interface WWOrderedDictionary()
@property (nonatomic, strong, readonly) NSDictionary *dictionary;
@property (nonatomic, strong, readonly) NSMutableArray *orderedKeys;
@end

@implementation WWOrderedDictionary
@synthesize orderedKeys = _orderedKeys;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    NSParameterAssert(dictionary != nil);
    if (dictionary == nil) {
        return nil;
    }
    
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    _dictionary = dictionary;
    _orderedKeys = [dictionary.allKeys mutableCopy];
    [_orderedKeys sortUsingSelector: @selector(compare:)];
    
    [self inherit: dictionary];
    [self inherit: _orderedKeys];
    
    [self setDesignatedTarget: dictionary forSelector: @selector(count)];
    [self setDesignatedTarget: _orderedKeys forSelector: @selector(countByEnumeratingWithState:objects:count:)];
    
    return self;
}


#pragma mark - NSDictionary

- (NSArray *)allKeys
{
    return [self.orderedKeys copy];
}


#pragma mark - NSMutableDictionary

- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    NSParameterAssert(anObject != nil);
    NSParameterAssert(aKey != nil);
    if ((anObject == nil) || (aKey == nil)) {
        return;
    }
    
    [(NSMutableDictionary *)self.dictionary setObject: anObject forKey: aKey];
    if ([self.orderedKeys containsObject: aKey] == NO) {
        [self.orderedKeys addObject: aKey];
        [self.orderedKeys sortUsingSelector: @selector(compare:)];
    }
}


- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
    NSParameterAssert(key != nil);
    if (key == nil) {
        return;
    }
    
    if (obj != nil) {
        [self setObject: obj forKey: key];
    }
    else {
        [self removeObjectForKey: key];
    }
}


- (void)removeObjectForKey:(id)aKey
{
    [(NSMutableDictionary *)self.dictionary removeObjectForKey: aKey];
    [self.orderedKeys removeObject: aKey];
}


#pragma mark - <NSCoding>

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: self.dictionary];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSDictionary *dictionary = [aDecoder decodeObject];
    return [self initWithDictionary: dictionary];
}


#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    return [[WWOrderedDictionary alloc] initWithDictionary: [self.dictionary copy]];
}


#pragma mark - <NSMutableCopying>

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return [[WWOrderedDictionary alloc] initWithDictionary: [self.dictionary copy]];
}

@end
