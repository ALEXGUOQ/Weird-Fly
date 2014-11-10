//
//  MyScene.h
//  Weird fly
//

//  Copyright (c) 2014 Paolo furlan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol SceneDelegate <NSObject>

-(void)start;
-(void)play;
-(void)wasted;
-(void)score:(int)sc;

@end

@interface Scene : SKScene <SKPhysicsContactDelegate>

@property (unsafe_unretained, nonatomic) id<SceneDelegate> delegate;
@property int score;

-(void)startGame;

@end
