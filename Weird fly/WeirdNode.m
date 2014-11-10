//
//  WeirdNode.m
//  Weird fly
//
//  Created by Paolo furlan on 21/02/14.
//  Copyright (c) 2014 Paolo furlan. All rights reserved.
//

#import "WeirdNode.h"

//#define VERTICAL_SPEED 1
#define VERTICAL_SPEED 0
#define VERTICAL_DELTA 100.0

@interface WeirdNode() {
    NSTimer *tim;
}
@property (nonatomic, strong) SKAction *flap;
@property (nonatomic, strong) SKAction *flapForever;
@end

@implementation WeirdNode

static CGFloat deltaPosY = 0;
static bool goingUp=false;

-(id)init {
    if(self = [super init]){
        
        SKTexture *weirdTexture1=[SKTexture textureWithImageNamed:@"weird1"];
        weirdTexture1.filteringMode=SKTextureFilteringNearest;
        SKTexture *weirdTexture2=[SKTexture textureWithImageNamed:@"weird2"];
        weirdTexture2.filteringMode=SKTextureFilteringNearest;
        SKTexture *weirdTexture3=[SKTexture textureWithImageNamed:@"weird3"];
        weirdTexture3.filteringMode=SKTextureFilteringNearest;
        SKTexture *weirdTexture4=[SKTexture textureWithImageNamed:@"weird2"];
        weirdTexture4.filteringMode=SKTextureFilteringNearest;
        
        self = [WeirdNode spriteNodeWithTexture:weirdTexture1];
        
        self.flap=[SKAction animateWithTextures:@[weirdTexture1, weirdTexture2, weirdTexture3, weirdTexture4] timePerFrame:0.2];
        self.flapForever=[SKAction repeatActionForever:self.flap];
        
        [self setTexture:weirdTexture1];
        [self runAction:self.flapForever withKey:@"flapForever"];
        
    }
    return self;
}


-(void)update:(NSUInteger)currentTime {
    if(!self.physicsBody){
        if(deltaPosY > VERTICAL_DELTA){
            goingUp=false;
        }
        if(deltaPosY < VERTICAL_DELTA){
            goingUp=true;
        }
        
        float displacement= (goingUp) ? VERTICAL_SPEED : -VERTICAL_SPEED;
        self.position=CGPointMake(self.position.x, self.position.y + displacement);
        deltaPosY += displacement;
    }
    
    //Rotate body based on Y velocity (front toward direction)
    self.zRotation = M_PI * self.physicsBody.velocity.dy * 0.0005;
}

-(void)startPlaying {
    deltaPosY=0;
    [self setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(26, 18)]];
    self.color=[UIColor redColor];
    self.physicsBody.categoryBitMask=birdBitMask;
    self.physicsBody.mass=0.1;
    [self removeActionForKey:@"flapForever"];
}

-(void)bounce {
    [self.physicsBody setVelocity:CGVectorMake(0, 0)];
    [self.physicsBody applyImpulse:CGVectorMake(0, 38)];
    [self runAction:self.flap];
}

@end
