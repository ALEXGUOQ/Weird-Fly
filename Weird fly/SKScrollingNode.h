//
//  SKScrollingNode.h
//  Weird fly
//
//  Created by Paolo furlan on 21/02/14.
//  Copyright (c) 2014 Paolo furlan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKScrollingNode : SKSpriteNode

@property (nonatomic) CGFloat scrollingSpeed;

+(id)scrollingNodeWithImageNamed:(NSString *)name inContainerWidth:(float)width;
-(void)update:(NSTimeInterval)currentTime;

@end
