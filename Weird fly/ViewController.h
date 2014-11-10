//
//  ViewController.h
//  Weird fly
//

//  Copyright (c) 2014 Paolo furlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "Scene.h"
#import "HomeScene.h"
#import "GameCenterManager.h"
#import "SoundEffects.h"
#import <iAd/iAd.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface ViewController : UIViewController <SceneDelegate, GameCenterManagerDelegate, GKGameCenterControllerDelegate, ADBannerViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@end
