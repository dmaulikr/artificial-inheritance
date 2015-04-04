//
//  ArtificalInheritance.h
//  ArtificalInheritance
//
//  Created by Egor Chiglintsev on 03.04.15.
//  Copyright (c) 2015 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWInheritanceProxy : NSProxy
@property (atomic, strong) id identity;

- (instancetype)init;
+ (instancetype)new;

- (void)inherit:(id)parent;
- (void)setDesignatedTarget:(id)target forSelector:(SEL)selector;

@end
