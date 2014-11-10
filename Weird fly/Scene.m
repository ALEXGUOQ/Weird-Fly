//
//  MyScene.m
//  Weird fly
//
//  Created by Paolo furlan on 21/02/14.
//  Copyright (c) 2014 Paolo furlan. All rights reserved.
//

#import "Scene.h"
#import "SKScrollingNode.h"
#import "WeirdNode.h"
#import "Score.h"

#define BACK_SCROLLING_SPEED .0
#define BACK_SCROLLING_SPEED_NUVOLE .6
#define FLOOR_SCROLLING_SPEED 2.5

// Obstacles
#define VERTICAL_GAP_SIZE 150
#define FIRST_OBSTACLE_PADDING 100
#define OBSTACLE_MIN_HEIGHT 120
#define OBSTACLE_INTERVAL_SPACE 130

@implementation Scene {
    SKScrollingNode *floor;
    SKScrollingNode *back;
    SKScrollingNode *backNuvole;
    SKScrollingNode *backFloor;
    SKLabelNode *scoreLabel;
    SKLabelNode *scoreLabelHighscore;
    WeirdNode *weird;
    
    int nObstacles;
    NSMutableArray *topPipes;
    NSMutableArray *bottomPipes;
    
    float scrollBackground;
    float scrollFloor;
}

@synthesize score;

static bool wasted=NO;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.physicsWorld.contactDelegate=self;
        [self startGame];
    }
    return self;
}

-(void)startGame {
    wasted = NO;

    [self removeAllChildren];
    [self createBackground];
    [self createBackgroundNuvole];
    
    [self createObstacles];
    
    [self createUnderFloor];
    
    [self createFloor];
    
    [self createScore];
    [self createWeird];
}

-(void)createBackground {
    back=[SKScrollingNode scrollingNodeWithImageNamed:@"backN" inContainerWidth:WIDTH(self)];
    [back setScrollingSpeed:BACK_SCROLLING_SPEED];
    [back setAnchorPoint:CGPointZero];
    [self addChild:back];
}

-(void)createBackgroundNuvole {
    backNuvole=[SKScrollingNode scrollingNodeWithImageNamed:@"backNuvole" inContainerWidth:WIDTH(self)];
    [backNuvole setScrollingSpeed:BACK_SCROLLING_SPEED_NUVOLE];
    [backNuvole setAnchorPoint:CGPointZero];
    [self addChild:backNuvole];
}


-(void)createUnderFloor {
    backFloor=[SKScrollingNode scrollingNodeWithImageNamed:@"backFloor" inContainerWidth:WIDTH(self)];
    [backFloor setScrollingSpeed:BACK_SCROLLING_SPEED];
    [backFloor setAnchorPoint:CGPointZero];
    [backFloor setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:backFloor.frame]];
    backFloor.physicsBody.categoryBitMask=floorBitMask;
    backFloor.physicsBody.contactTestBitMask=birdBitMask;
    [self addChild:backFloor];
}

-(void)createScore {
//    self.score=0;
//    scoreLabel=[SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Light"];
//    scoreLabel.text=@"0";
//    scoreLabel.fontSize=20;
//    scoreLabel.position=CGPointMake(0, HEIGHT(self.view));
//    scoreLabel.alpha=1.0;
//    [self addChild:scoreLabel];
//
//    scoreLabelHighscore=[SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Light"];
//    scoreLabelHighscore.text=@"0";
//    scoreLabelHighscore.fontSize=20;
//    scoreLabelHighscore.position=CGPointMake(20, 20);
//    scoreLabelHighscore.alpha=1.0;
//    [self addChild:scoreLabelHighscore];
}

-(void)createFloor {
    floor=[SKScrollingNode scrollingNodeWithImageNamed:@"floor" inContainerWidth:WIDTH(self)];
    [floor setScrollingSpeed:FLOOR_SCROLLING_SPEED];
    floor.position=CGPointMake(0, 128);
    [floor setAnchorPoint:CGPointZero];
    [floor setName:@"floor"];
    [floor setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, HEIGHT(self.view)-108, 320, 126)]];
//    floor.physicsBody.categoryBitMask=floorBitMask;
//    floor.physicsBody.contactTestBitMask=birdBitMask;
    [self addChild:floor];
}

-(void)createWeird {
    weird=[WeirdNode new];
    [weird setPosition:CGPointMake(100, CGRectGetMidY(self.frame)+50)];
    [weird setName:@"weird"];
    [self addChild:weird];
}

-(void)createObstacles {
    nObstacles=ceil(WIDTH(self)/(OBSTACLE_INTERVAL_SPACE));
    CGFloat lastBlockPos=0;
    
    topPipes=[[NSMutableArray alloc] init];
    bottomPipes=[[NSMutableArray alloc] init];
    for(int i=0; i<nObstacles; i++){
        
        SKSpriteNode *topPipe=[SKSpriteNode spriteNodeWithImageNamed:@"pipe_top"];
        [topPipe setAnchorPoint:CGPointZero];
        [self addChild:topPipe];
        [topPipes addObject:topPipe];
        
        SKSpriteNode *bottomPipe=[SKSpriteNode spriteNodeWithImageNamed:@"pipe_bottom"];
        [bottomPipe setAnchorPoint:CGPointZero];
        [self addChild:bottomPipe];
        [bottomPipes addObject:bottomPipe];
        
        if(0 == i){
            [self place:bottomPipe and:topPipe atX:WIDTH(self)+FIRST_OBSTACLE_PADDING];
        }else{
            [self place:bottomPipe and:topPipe atX:lastBlockPos + WIDTH(bottomPipe) +OBSTACLE_INTERVAL_SPACE];
        }
        lastBlockPos = topPipe.position.x;
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if(wasted){
        if([self.delegate respondsToSelector:@selector(start)]){
            [self.delegate start];
        }
        [self startGame];
    }else{
        if(!weird.physicsBody){
            [weird startPlaying];
            if([self.delegate respondsToSelector:@selector(play)]){
                [self.delegate play];
            }
        }
        [weird bounce];
    }
}

-(void)update:(CFTimeInterval)currentTime {

    if(wasted){
        return;
    }
    
    [back update:currentTime];
    [backNuvole update:currentTime];
    [floor update:currentTime];
    [backFloor update:currentTime];
    
    [weird update:currentTime];
    [self updateObstacles:currentTime];
    [self updateScore:currentTime];
}

- (void) updateObstacles:(NSTimeInterval)currentTime
{
    if(!weird.physicsBody){
        return;
    }
    
    for(int i=0;i<nObstacles;i++){
        
        // Get pipes bby pairs
        SKSpriteNode * topPipe = (SKSpriteNode *) topPipes[i];
        SKSpriteNode * bottomPipe = (SKSpriteNode *) bottomPipes[i];
        
        // Check if pair has exited screen, and place them upfront again
        if (X(topPipe) < -WIDTH(topPipe)){
            SKSpriteNode * mostRightPipe = (SKSpriteNode *) topPipes[(i+(nObstacles-1))%nObstacles];
            [self place:bottomPipe and:topPipe atX:X(mostRightPipe)+WIDTH(topPipe)+OBSTACLE_INTERVAL_SPACE];
        }
        
        // Move according to the scrolling speed
        topPipe.position = CGPointMake(X(topPipe) - FLOOR_SCROLLING_SPEED, Y(topPipe));
        bottomPipe.position = CGPointMake(X(bottomPipe) - FLOOR_SCROLLING_SPEED, Y(bottomPipe));
    }
}


- (void) place:(SKSpriteNode *) bottomPipe and:(SKSpriteNode *) topPipe atX:(float) xPos
{
    // Maths
    float availableSpace = HEIGHT(self) - HEIGHT(floor);
    float maxVariance = availableSpace - (50+OBSTACLE_MIN_HEIGHT) - VERTICAL_GAP_SIZE;
    float variance = [Math randomFloatBetween:0 and:maxVariance];
    
    // Bottom pipe placement
    float minBottomPosY = HEIGHT(floor) + OBSTACLE_MIN_HEIGHT - HEIGHT(self);
    float bottomPosY = minBottomPosY + variance;
    bottomPipe.position = CGPointMake(xPos,bottomPosY+50);
    bottomPipe.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0,0, WIDTH(bottomPipe) , HEIGHT(bottomPipe))];
    bottomPipe.physicsBody.categoryBitMask = blockBitMask;
    bottomPipe.physicsBody.contactTestBitMask = birdBitMask;
    
    // Top pipe placement
    topPipe.position = CGPointMake(xPos,bottomPosY + HEIGHT(bottomPipe) + VERTICAL_GAP_SIZE);
    topPipe.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0,0, WIDTH(topPipe), HEIGHT(topPipe))];
    
    topPipe.physicsBody.categoryBitMask = blockBitMask;
    topPipe.physicsBody.contactTestBitMask = birdBitMask;
}


- (void) updateScore:(NSTimeInterval) currentTime
{
    for(int i=0;i<nObstacles;i++){
        
        SKSpriteNode * topPipe = (SKSpriteNode *) topPipes[i];
        
        // Score, adapt font size
        if(X(topPipe) + WIDTH(topPipe)/2 > weird.position.x &&
           X(topPipe) + WIDTH(topPipe)/2 < weird.position.x + FLOOR_SCROLLING_SPEED){
            self.score +=1;
            [self.delegate score:self.score];
//            scoreLabel.text = [NSString stringWithFormat:@"%d",self.score];
//            if(self.score>=10){
//                scoreLabel.fontSize = 340;
//                scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), 120);
//            }
        }
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    if(wasted) {
        return;
    }
    
    wasted = true;
    [Score registerScore:self.score];
    
    self.score=0;
    
    if([self.delegate respondsToSelector:@selector(wasted)]){
        [self.delegate wasted];
    }
}

@end
