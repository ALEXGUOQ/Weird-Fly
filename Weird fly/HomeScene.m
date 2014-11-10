//
//  HomeScene.m
//  Weird fly
//
//  Created by Paolo furlan on 22/02/14.
//  Copyright (c) 2014 Paolo furlan. All rights reserved.
//

#import "HomeScene.h"
#import "SKScrollingNode.h"
#import "WeirdNode.h"
#import "Score.h"

#define BACK_SCROLLING_SPEED .0
#define FLOOR_SCROLLING_SPEED 2.5

// Obstacles
#define VERTICAL_GAP_SIZE 150
#define FIRST_OBSTACLE_PADDING 100
#define OBSTACLE_MIN_HEIGHT 100
#define OBSTACLE_INTERVAL_SPACE 130

@implementation HomeScene {
    SKScrollingNode *floor;
    SKScrollingNode *back;
    SKScrollingNode *backFloor;
    
    float scrollBackground;
    float scrollFloor;
}

static bool wasted=NO;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [self startGame];
    }
    return self;
}

-(void)startGame {
    wasted = NO;
    
    [self removeAllChildren];
    [self createBackground];
    [self createUnderFloor];
    [self createFloor];
}

-(void)createBackground {
    if(self.frame.size.height>500){
        back=[SKScrollingNode scrollingNodeWithImageNamed:@"backHome5" inContainerWidth:WIDTH(self)];
    }else{
        back=[SKScrollingNode scrollingNodeWithImageNamed:@"backHome4" inContainerWidth:WIDTH(self)];
    }
    [back setScrollingSpeed:BACK_SCROLLING_SPEED];
    [back setAnchorPoint:CGPointZero];
    [back setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];
    back.physicsBody.categoryBitMask=backBitMask;
    back.physicsBody.contactTestBitMask=birdBitMask;
    [self addChild:back];
}

-(void)createUnderFloor {
    backFloor=[SKScrollingNode scrollingNodeWithImageNamed:@"backFloor" inContainerWidth:WIDTH(self)];
    [backFloor setScrollingSpeed:BACK_SCROLLING_SPEED];
    [backFloor setAnchorPoint:CGPointZero];
    [backFloor setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];
    [self addChild:backFloor];
}


-(void)createFloor {
    floor=[SKScrollingNode scrollingNodeWithImageNamed:@"floor" inContainerWidth:WIDTH(self)];
    [floor setScrollingSpeed:FLOOR_SCROLLING_SPEED];
    floor.position=CGPointMake(0, 128);
    [floor setAnchorPoint:CGPointZero];
    [floor setName:@"floor"];
    [floor setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, HEIGHT(self.view)-128, 320, 126)]];
//    floor.physicsBody.categoryBitMask=floorBitMask;
//    floor.physicsBody.contactTestBitMask=birdBitMask;
    [self addChild:floor];
}



-(void)update:(CFTimeInterval)currentTime {
    
    if(wasted){
        return;
    }
    
    [back update:currentTime];
    [floor update:currentTime];
    [backFloor update:currentTime];
}

@end
