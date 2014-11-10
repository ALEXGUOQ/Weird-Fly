//
//  WeirdNode.h
//  Weird fly
//
//  Created by Paolo furlan on 21/02/14.
//  Copyright (c) 2014 Paolo furlan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface WeirdNode : SKSpriteNode
-(void)update:(NSUInteger)currentTime;
-(void)startPlaying;
-(void)bounce;
@end
