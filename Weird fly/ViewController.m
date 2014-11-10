//
//  ViewController.m
//  Weird fly
//
//  Created by Paolo furlan on 21/02/14.
//  Copyright (c) 2014 Paolo furlan. All rights reserved.
//

#import "ViewController.h"
#import "Score.h"
#import "FXBlurView.h"

@interface ViewController () {
    UIView *viewStart;
    UIView *viewInfo;
    
    UIView *viewLogoStart;
    
    UIImageView *imgLogo;
    AYUIButton *btnStart;
    AYUIButton *btnGameCenter;
    AYUIButton *btnRateUs;
    
    UIView * getReadyView;
    
    UIView *gameOverView;
    UIButton *btnNroHigh;
    UIButton *btnScoreGO;
    AYUIButton *btnHighscore;
    
    UIButton *btnScore;
    UIButton *btnScoreHigh;
    
    AYUIButton *btnRestart;
    AYUIButton *btnHome;
    ADBannerView *adView;


    AYUIButton *btnShare;
    AYUIButton *btnInfo;
    
    //INFO
    UIImageView *imgDescrizione;
}

@property (weak,nonatomic) IBOutlet SKView * gameView;

@property (weak,nonatomic) IBOutlet UIImageView * medalImageView;
@property (weak,nonatomic) IBOutlet UILabel * currentScore;
@property (weak,nonatomic) IBOutlet UILabel * bestScoreLabel;

@end

#define YOUR_APP_STORE_ID 828619915 // Change this one to your app ID

@implementation ViewController {
    HomeScene *homeScene;
    Scene *scene;
    UIView *flash;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


-(void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController {
    [self presentViewController:gameCenterLoginController animated:YES completion:^{
    }];
}

-(void)gameCenterManager:(GameCenterManager *)manager availabilityChanged:(NSDictionary *)availabilityInformation {
}


-(void)gameCenter {
    GKGameCenterViewController *leaderboardViewController = [[GKGameCenterViewController alloc] init];
    leaderboardViewController.viewState = GKGameCenterViewControllerStateDefault;
    leaderboardViewController.gameCenterDelegate = self;
    [self presentViewController:leaderboardViewController animated:YES completion:nil];
}
    
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSError *err;
    [[GANTracker sharedTracker] trackPageview:@"Home aperta" withError: &err];
    [[GANTracker sharedTracker] dispatch];

    [[GameCenterManager sharedManager] setDelegate:self];
    [[GameCenterManager sharedManager] initGameCenter];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    
    [self caricaHome];
    
//    schermata home con sfondo animato
    homeScene=[HomeScene sceneWithSize:self.gameView.bounds.size];
    homeScene.scaleMode=SKSceneScaleModeAspectFill;
    [self.gameView presentScene:homeScene];
    
//    schermata getReady con image taptap
    getReadyView=[[UIView alloc] initWithFrame:CGRectMake(125, 200, 70, 96)];
    getReadyView.alpha=0.0;
    UIImageView *imgtap=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 96)];
    [imgtap setImage:[UIImage imageNamed:@"taptap"]];
    [getReadyView addSubview:imgtap];
    [self.view addSubview:getReadyView];
    
    
//    schermata di gameover

    gameOverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view))];
    gameOverView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];
    gameOverView.alpha=0.0;
    [self.view addSubview:gameOverView];
    [self caricaGameOver];
    
//    schermata di gioco
    scene=[Scene sceneWithSize:self.gameView.bounds.size];
    scene.scaleMode=SKSceneScaleModeAspectFill;
    scene.delegate=self;
    

    btnScoreHigh=[UIButton buttonWithType:UIButtonTypeCustom];
    btnScoreHigh.frame=CGRectMake(10, 10, 60, 25);
    btnScoreHigh.layer.borderColor=[UIColor whiteColor].CGColor;
    btnScoreHigh.layer.borderWidth=0.5;
    btnScoreHigh.layer.cornerRadius=4.0;
    [btnScoreHigh.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11]];
    [btnScoreHigh setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnScoreHigh setTitle:F(@"%li",(long)[Score bestScore]) forState:UIControlStateNormal];
    btnScoreHigh.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    btnScoreHigh.contentEdgeInsets=UIEdgeInsetsMake(0, 23, 0, 0);
    btnScoreHigh.alpha=0.0;
    UIImageView *imgHighscore=[[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 13, 13)];
    [imgHighscore setImage:[UIImage imageNamed:@"iconHighscore"]];
    [btnScoreHigh addSubview:imgHighscore];
    [self.view addSubview:btnScoreHigh];

    btnScore=[UIButton buttonWithType:UIButtonTypeCustom];
    btnScore.frame=CGRectMake(250, 10, 60, 25);
    btnScore.layer.borderColor=[UIColor whiteColor].CGColor;
    btnScore.layer.borderWidth=0.5;
    btnScore.layer.cornerRadius=4.0;
    [btnScore.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11]];
    [btnScore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnScore setTitle:@"0" forState:UIControlStateNormal];
    btnScore.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    btnScore.alpha=0.0;
    [self.view addSubview:btnScore];
    
    if(!adView) {
        adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 50)];
        adView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:adView];
        adView.delegate=self;
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=adView.frame;
        frame.origin.y=self.view.frame.size.height-50;
        adView.frame=frame;
    }];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=adView.frame;
        frame.origin.y=self.view.frame.size.height;
        adView.frame=frame;
    }];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    BOOL shouldExecuteAction = YES;
    if (!willLeave && shouldExecuteAction)
    {
        
    }
    return shouldExecuteAction;
}


-(void)animazioneLogoHome {
    [UIView animateWithDuration:0.6 animations:^{
        if(viewLogoStart.frame.origin.y==70){
            CGRect frame=viewLogoStart.frame;
            frame.origin.y=40;
            viewLogoStart.frame=frame;
        }else{
            CGRect frame=viewLogoStart.frame;
            frame.origin.y=70;
            viewLogoStart.frame=frame;
        }
    } completion:^(BOOL finished) {
        [self animazioneLogoHome];
    }];
}

-(void)caricaHome {
    [viewStart removeFromSuperview];
    viewStart=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view))];
    viewStart.backgroundColor=[UIColor clearColor];
    [self.view addSubview:viewStart];
    
    viewLogoStart=[[UIView alloc] initWithFrame:CGRectMake(85, 40, 150, 80)];
    viewLogoStart.backgroundColor=[UIColor clearColor];
    UIImageView *imgLogoSt=[[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 75, 50)];
    NSArray *arrayImgs=[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"weirdHome1"],[UIImage imageNamed:@"weirdHome2"],[UIImage imageNamed:@"weirdHome3"], nil];
    imgLogoSt.animationImages=arrayImgs;
    imgLogoSt.animationDuration=0.6;
    [imgLogoSt startAnimating];
    [viewLogoStart addSubview:imgLogoSt];
    
    UILabel *lblWeirdFly=[[UILabel alloc] initWithFrame:CGRectMake(80, 0, 70, 80)];
    lblWeirdFly.textColor=[UIColor whiteColor];
    lblWeirdFly.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:24];
    lblWeirdFly.text=@"Weird Fly";
    lblWeirdFly.numberOfLines=-1;
    lblWeirdFly.lineBreakMode=NSLineBreakByWordWrapping;
    [viewLogoStart addSubview:lblWeirdFly];
    [viewStart addSubview:viewLogoStart];

    btnStart=[[AYUIButton alloc] initWithFrame:CGRectMake(10, 205, 300, 45)];
    btnStart.layer.borderWidth=0.5;
    [btnStart.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [btnStart setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btnStart setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [btnStart setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
    [btnStart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnStart.layer.borderColor=[[UIColor whiteColor] colorWithAlphaComponent:1.0].CGColor;
    btnStart.layer.cornerRadius=4.0;
    [btnStart addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    [viewStart addSubview:btnStart];

    btnRateUs=[[AYUIButton alloc] initWithFrame:CGRectMake(10, 260, 300, 45)];
    btnRateUs.layer.borderWidth=0.5;
    [btnRateUs.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [btnRateUs setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btnRateUs setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [btnRateUs setTitle:NSLocalizedString(@"Rate us", nil) forState:UIControlStateNormal];
    [btnRateUs setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRateUs.layer.borderColor=[[UIColor whiteColor] colorWithAlphaComponent:1.0].CGColor;
    btnRateUs.layer.cornerRadius=4.0;
    [btnRateUs addTarget:self action:@selector(rateUs) forControlEvents:UIControlEventTouchUpInside];
    [viewStart addSubview:btnRateUs];

    btnGameCenter=[[AYUIButton alloc] initWithFrame:CGRectMake(10, 315, 300, 45)];
    btnGameCenter.layer.borderWidth=0.5;
    [btnGameCenter.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [btnGameCenter setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btnGameCenter setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [btnGameCenter setTitle:NSLocalizedString(@"Game Center", nil) forState:UIControlStateNormal];
    [btnGameCenter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnGameCenter.layer.borderColor=[[UIColor whiteColor] colorWithAlphaComponent:1.0].CGColor;
    btnGameCenter.layer.cornerRadius=4.0;
    [btnGameCenter addTarget:self action:@selector(gameCenter) forControlEvents:UIControlEventTouchUpInside];
    [viewStart addSubview:btnGameCenter];
    
    
    if(self.view.frame.size.height>500){
        btnShare=[[AYUIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-29, self.view.frame.size.height-97, 19, 27)];
        btnInfo=[[AYUIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+10, self.view.frame.size.height-92, 22, 22)];
    }else{
        btnShare=[[AYUIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-29, 380, 19, 27)];
        btnInfo=[[AYUIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+10, 385, 22, 22)];
    }
    
    [btnShare setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [viewStart addSubview:btnShare];

    [btnInfo setImage:[UIImage imageNamed:@"informations"] forState:UIControlStateNormal];
    [btnInfo addTarget:self action:@selector(info) forControlEvents:UIControlEventTouchUpInside];
    [viewStart addSubview:btnInfo];

    [self animazioneLogoHome];
}

-(void)share {
    
    UIActionSheet *popupQuery;
    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=prova"]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Facebook", nil), NSLocalizedString(@"Twitter", nil),NSLocalizedString(@"Email", nil), NSLocalizedString(@"Message", nil), NSLocalizedString(@"Whatsapp", nil), nil];
    }else{
        popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Facebook", nil), NSLocalizedString(@"Twitter", nil),NSLocalizedString(@"Email", nil), NSLocalizedString(@"Message", nil), nil];
    }
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [popupQuery showInView:self.view];
}

-(void)rateUs {
    if([[UIDevice currentDevice] systemVersion].floatValue >= 7.0f)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/app/id%d", YOUR_APP_STORE_ID]]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%d&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8", YOUR_APP_STORE_ID]]];
}

-(void)caricaGameOver {
    
    UIImageView *imgGameOverLogo=[[UIImageView alloc] initWithFrame:CGRectMake(106, 43, 102, 47)];
    [imgGameOverLogo setImage:[UIImage imageNamed:@"imgGameover"]];
    [gameOverView addSubview:imgGameOverLogo];
    
    btnScoreGO=[[UIButton alloc] initWithFrame:CGRectMake(10, 140, 300, 45)];
    btnScoreGO.layer.borderWidth=0.5;
    [btnScoreGO.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [btnScoreGO setTitle:[NSString stringWithFormat:NSLocalizedString(@"Score: %d", nil), scene.score] forState:UIControlStateNormal];
    [btnScoreGO setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnScoreGO.layer.borderColor=[[UIColor whiteColor] colorWithAlphaComponent:1.0].CGColor;
    btnScoreGO.layer.cornerRadius=4.0;
    btnScoreGO.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [gameOverView addSubview:btnScoreGO];

    btnHighscore=[[AYUIButton alloc] initWithFrame:CGRectMake(10, 195, 300, 45)];
    btnHighscore.layer.borderWidth=0.5;
    [btnHighscore.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [btnHighscore setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btnHighscore setTitle:[NSString stringWithFormat:NSLocalizedString(@"Highscore:", nil)] forState:UIControlStateNormal];
    [btnHighscore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnHighscore.layer.borderColor=[[UIColor whiteColor] colorWithAlphaComponent:1.0].CGColor;
    btnHighscore.layer.cornerRadius=4.0;
    btnHighscore.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    btnHighscore.contentEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 120);
    [gameOverView addSubview:btnHighscore];
    btnNroHigh=[[UIButton alloc] initWithFrame:CGRectMake(190, 0, 100, 45)];
    [btnNroHigh.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [btnNroHigh setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnNroHigh.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    btnNroHigh.contentEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    UIImageView *imgHighscore=[[UIImageView alloc] initWithFrame:CGRectMake(0, 16, 13, 13)];
    [imgHighscore setImage:[UIImage imageNamed:@"iconHighscore"]];
    [btnNroHigh addSubview:imgHighscore];
    [btnHighscore addSubview:btnNroHigh];

    AYUIButton *btnGameCenterGO=[[AYUIButton alloc] initWithFrame:CGRectMake(10, 250, 300, 45)];
    btnGameCenterGO.layer.borderWidth=0.5;
    [btnGameCenterGO.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [btnGameCenterGO setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btnGameCenterGO setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [btnGameCenterGO setTitle:[NSString stringWithFormat:NSLocalizedString(@"Game Center", nil)] forState:UIControlStateNormal];
    [btnGameCenterGO setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnGameCenterGO.layer.borderColor=[[UIColor whiteColor] colorWithAlphaComponent:1.0].CGColor;
    btnGameCenterGO.layer.cornerRadius=4.0;
    btnGameCenterGO.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    btnGameCenterGO.contentEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    [btnGameCenterGO addTarget:self action:@selector(gameCenter) forControlEvents:UIControlEventTouchUpInside];
    [gameOverView addSubview:btnGameCenterGO];

    
    btnRestart=[[AYUIButton alloc] initWithFrame:CGRectMake(10, HEIGHT(self.view), 300, 45)];
    btnRestart.layer.borderWidth=0.5;
    [btnRestart.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [btnRestart setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btnRestart setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [btnRestart setTitle:[NSString stringWithFormat:NSLocalizedString(@"Restart", nil)] forState:UIControlStateNormal];
    [btnRestart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRestart.layer.borderColor=[[UIColor whiteColor] colorWithAlphaComponent:1.0].CGColor;
    btnRestart.layer.cornerRadius=4.0;
    btnRestart.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [btnRestart addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
    [gameOverView addSubview:btnRestart];

    
    btnHome=[[AYUIButton alloc] initWithFrame:CGRectMake(10, HEIGHT(self.view)+60, 300, 45)];
    btnHome.layer.borderWidth=0.5;
    [btnHome.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [btnHome setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btnHome setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [btnHome setTitle:[NSString stringWithFormat:NSLocalizedString(@"Home", nil)] forState:UIControlStateNormal];
    [btnHome setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnHome.layer.borderColor=[[UIColor whiteColor] colorWithAlphaComponent:1.0].CGColor;
    btnHome.layer.cornerRadius=4.0;
    btnHome.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [btnHome addTarget:self action:@selector(home) forControlEvents:UIControlEventTouchUpInside];
    [gameOverView addSubview:btnHome];

}

-(void)restart {
    [scene startGame];
    [UIView animateWithDuration:.2 animations:^{
        gameOverView.alpha = 0;
        flash.alpha = 0;
        getReadyView.alpha = 1;
        btnScoreHigh.alpha=1.0;
        btnScore.alpha=1.0;
    } completion:^(BOOL finished) {
        CGRect frame=btnRestart.frame;
        frame.origin.y=HEIGHT(self.view);
        btnRestart.frame=frame;
        frame=btnHome.frame;
        frame.origin.y=HEIGHT(self.view)+60;
        btnHome.frame=frame;
        [btnScoreGO setTitle:[NSString stringWithFormat:NSLocalizedString(@"Score: %d", nil), 0] forState:UIControlStateNormal];
        [flash removeFromSuperview];
    }];
}

-(void)home {
    [scene startGame];
    [UIView animateWithDuration:.2 animations:^{
        gameOverView.alpha=0.0;
        btnScore.alpha=0.0;
        btnScoreHigh.alpha=0.0;
        viewStart.alpha=1.0;
    } completion:^(BOOL finished) {
        CGRect frame=btnRestart.frame;
        frame.origin.y=HEIGHT(self.view);
        btnRestart.frame=frame;
        frame=btnHome.frame;
        frame.origin.y=HEIGHT(self.view)+60;
        btnHome.frame=frame;

        [flash removeFromSuperview];
        [btnScoreGO setTitle:[NSString stringWithFormat:NSLocalizedString(@"Score: %d", nil), 0] forState:UIControlStateNormal];
        [self.gameView presentScene:homeScene];
    }];

}

-(void)startGame {
    [self.gameView presentScene:scene];
    [UIView animateWithDuration:0.3 animations:^{
        viewStart.alpha=0.0;
        btnScore.alpha=1.0;
        btnScoreHigh.alpha=1.0;
        scene.alpha=1.0;
    } completion:^(BOOL finished) {
//        [viewStart removeFromSuperview];
        [homeScene removeFromParent];
        [btnScoreGO setTitle:[NSString stringWithFormat:NSLocalizedString(@"Score: %d", nil), 0] forState:UIControlStateNormal];
        [self start];
    }];
}

- (void)start {
    [UIView animateWithDuration:.2 animations:^{
        gameOverView.alpha = 0;
        flash.alpha = 0;
        btnScore.alpha=1.0;
        btnScoreHigh.alpha=1.0;
        getReadyView.alpha = 1;
    } completion:^(BOOL finished) {
        CGRect frame=btnRestart.frame;
        frame.origin.y=HEIGHT(self.view);
        btnRestart.frame=frame;
        frame=btnHome.frame;
        frame.origin.y=HEIGHT(self.view)+60;
        btnHome.frame=frame;
        [flash removeFromSuperview];
        [btnScoreGO setTitle:[NSString stringWithFormat:NSLocalizedString(@"Score: %d", nil), 0] forState:UIControlStateNormal];
    }];
}

- (void)play {
    [UIView animateWithDuration:.5 animations:^{
        btnScore.alpha=1.0;
        btnScoreHigh.alpha=1.0;
        getReadyView.alpha = 0;
    } completion:^(BOOL finished) {
        [btnScoreGO setTitle:[NSString stringWithFormat:NSLocalizedString(@"Score: %d", nil), 0] forState:UIControlStateNormal];
    }];
}

-(void)score:(int)sc {
//    PlaySoundEffect(Sound_Coins);
    [btnScoreGO setTitle:[NSString stringWithFormat:NSLocalizedString(@"Score: %d", nil), scene.score] forState:UIControlStateNormal];
    [btnScore setTitle:[NSString stringWithFormat:@"%d", sc] forState:UIControlStateNormal];
}

- (void)wasted {
    
//    PlaySoundEffect(Sound_Bonus2);

    [self shakeFrame];
 
    
    int sc=[btnScore.titleLabel.text intValue];
    if(sc>=[Score bestScore]){
        [btnScoreHigh setTitle:[NSString stringWithFormat:@"%d", sc] forState:UIControlStateNormal];
        [btnHighscore setTitle:NSLocalizedString(@"NEW Highscore", nil) forState:UIControlStateNormal];
        [btnNroHigh setTitle:F(@"%li",(long)[Score bestScore]) forState:UIControlStateNormal];
    }else{
        [btnHighscore setTitle:NSLocalizedString(@"Highscore:", nil) forState:UIControlStateNormal];
        [btnNroHigh setTitle:F(@"%li",(long)[Score bestScore]) forState:UIControlStateNormal];
    }

    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        btnScore.alpha=0.0;
        btnScoreHigh.alpha=0.0;
        
        gameOverView.alpha = 1;
        // Set medal
//        if(scene.score >= 40){
//            self.medalImageView.image = [UIImage imageNamed:@"medal_platinum"];
//        }else if (scene.score >= 30){
//            self.medalImageView.image = [UIImage imageNamed:@"medal_gold"];
//        }else if (scene.score >= 20){
//            self.medalImageView.image = [UIImage imageNamed:@"medal_silver"];
//        }else if (scene.score >= 10){
//            self.medalImageView.image = [UIImage imageNamed:@"medal_bronze"];
//        }else{
//            self.medalImageView.image = nil;
//        }
        
        // Set scores
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame=btnRestart.frame;
            frame.origin.y=HEIGHT(self.view)-175;
            btnRestart.frame=frame;
            
            frame=btnHome.frame;
            frame.origin.y=HEIGHT(self.view)-120;
            btnHome.frame=frame;
        } completion:^(BOOL finished) {
            [[GameCenterManager sharedManager] saveAndReportScore:(int)[Score bestScore] leaderboard:@"highscore" sortOrder:GameCenterSortOrderHighToLow];
        }];
        [btnScore setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
    }];
}


- (void) shakeFrame {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.05];
    [animation setRepeatCount:4];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([self.view  center].x - 4.0f, [self.view  center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([self.view  center].x + 4.0f, [self.view  center].y)]];
    [[self.view layer] addAnimation:animation forKey:@"position"];
}

-(void)info {
    viewInfo=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view))];
    viewInfo.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:viewInfo];
    
    UIView *viewLogoStartInfo=[[UIView alloc] initWithFrame:CGRectMake(85, 40, 150, 80)];
    viewLogoStartInfo.backgroundColor=[UIColor clearColor];
    UIImageView *imgLogoSt=[[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 75, 50)];
    [imgLogoSt setImage:[UIImage imageNamed:@"weirdHome1"]];
    [viewLogoStartInfo addSubview:imgLogoSt];
    
    UILabel *lblWeirdFly=[[UILabel alloc] initWithFrame:CGRectMake(80, 0, 70, 80)];
    lblWeirdFly.textColor=[UIColor whiteColor];
    lblWeirdFly.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:24];
    lblWeirdFly.text=@"Weird Fly";
    lblWeirdFly.numberOfLines=-1;
    lblWeirdFly.lineBreakMode=NSLineBreakByWordWrapping;
    [viewLogoStartInfo addSubview:lblWeirdFly];
    [viewInfo addSubview:viewLogoStartInfo];
    

    
    AYUIButton *btnBack;
    AYUIButton *btnLuan;
    AYUIButton *btnPaolo;
    
    
    UIImageView *imgDescrizioneInfo=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-120, 247, 240, 39)];
    [imgDescrizioneInfo setImage:[UIImage imageNamed:@"by"]];
    btnBack=[[AYUIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-165, self.view.frame.size.width-20, 45)];
    btnBack.layer.borderWidth=0.5;
    [btnBack.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    btnLuan=[[AYUIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-110, self.view.frame.size.width-20, 45)];
    btnLuan.layer.borderWidth=0.5;
    [btnLuan.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    btnPaolo=[[AYUIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-55, self.view.frame.size.width-20, 45)];
    btnPaolo.layer.borderWidth=0.5;
    [btnPaolo.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
   
    [viewInfo addSubview:imgDescrizioneInfo];
    
    [btnBack setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btnBack setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [btnBack setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnBack.layer.borderColor=[[UIColor whiteColor] colorWithAlphaComponent:1.0].CGColor;
    btnBack.layer.cornerRadius=4.0;
    [btnBack addTarget:self action:@selector(backInfo) forControlEvents:UIControlEventTouchUpInside];
    
    [btnLuan setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btnLuan setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [btnLuan setTitle:@"www.creative.al" forState:UIControlStateNormal];
    [btnLuan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLuan.layer.borderColor=[[UIColor whiteColor] colorWithAlphaComponent:1.0].CGColor;
    btnLuan.layer.cornerRadius=4.0;
    [btnLuan addTarget:self action:@selector(luan) forControlEvents:UIControlEventTouchUpInside];
    
    [btnPaolo setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btnPaolo setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [btnPaolo setTitle:@"www.pfdev.it" forState:UIControlStateNormal];
    [btnPaolo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnPaolo.layer.borderColor=[[UIColor whiteColor] colorWithAlphaComponent:1.0].CGColor;
    btnPaolo.layer.cornerRadius=4.0;
    [btnPaolo addTarget:self action:@selector(paolo) forControlEvents:UIControlEventTouchUpInside];
    
    [viewInfo addSubview:btnBack];
    [viewInfo addSubview:btnLuan];
    [viewInfo addSubview:btnPaolo];
    viewInfo.alpha=0.0;
    [self.view addSubview:viewInfo];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        viewStart.alpha=0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            viewInfo.alpha=1.0;
        } completion:nil];
    }];
}


-(void)backInfo {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        viewInfo.alpha=0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            viewStart.alpha=1.0;
        } completion:nil];
    }];
}

-(void)paolo {
    NSURL *target = [[NSURL alloc] initWithString:@"http://www.pfdev.it"];
    [[UIApplication sharedApplication] openURL:target];
}

-(void)luan {
    NSURL *target = [[NSURL alloc] initWithString:@"http://www.creative.al"];
    [[UIApplication sharedApplication] openURL:target];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self facebookShare];
    } else if (buttonIndex == 1) {
        [self twitterShare];
    } else if (buttonIndex == 2) {
        [self emailShare];
    } else if (buttonIndex == 3) {
        [self message];
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Whatsapp", nil)]){
        [self whatsapp];
    }
}

-(void)twitterShare {
    UIImageView *imageTw=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconShare"]];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [controller setInitialText:[NSString stringWithFormat:@"%@\n\nhttp://goo.gl/3CVUWD\n\n#WeirdFly",NSLocalizedString(@"I'm playing Weird Fly!", nil)]];
        [controller addImage:imageTw.image];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

-(void)emailShare {
    UIImageView *imageEmail=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconShare"]];
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Weird File"];
    
    NSString *emailBody =[NSString stringWithFormat:@"%@\n\n http://goo.gl/3CVUWD",NSLocalizedString(@"I'm playing Weird Fly!", nil)];
    
    [picker setMessageBody:emailBody isHTML:NO];
    
    NSData *data = UIImagePNGRepresentation(imageEmail.image);
    
    [picker addAttachmentData:data  mimeType:@"image/png" fileName:@"Weirdfly"];
    
    // Show email view
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued");
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail saved: you saved the email message in the Drafts folder");
            break;
        case MFMailComposeResultSent:
            //NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send the next time the user connects to email");
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail failed: the email message was nog saved or queued, possibly due to an error");
            break;
        default:
            //NSLog(@"Mail not sent");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)facebookShare {
    UIImageView *imageFb=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconShare"]];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:[NSString stringWithFormat:@"%@\n #Weirdfly\n\n",NSLocalizedString(@"I'm playing Weird Fly!", nil)]];
        [controller addURL:[NSURL URLWithString:@"http://goo.gl/3CVUWD"]];
        [controller addImage:imageFb.image];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }else{
        //
        //        NSMutableDictionary *params =
        //        [NSMutableDictionary dictionaryWithObjectsAndKeys:
        //         @"Weird Smile", @"name",
        //         @"", @"caption",
        //         NSLocalizedString(@"I'm playing Weird Smile!", nil), @"description",
        //         @"http://goo.gl/7b50t0", @"link",
        //         nil];
        //
        //        // Invoke the dialog
        //        [FBWebDialogs presentFeedDialogModallyWithSession:nil
        //                                               parameters:params
        //                                                  handler:
        //         ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
        //             if (error) {
        //                 // Error launching the dialog or publishing a story.
        //                 NSLog(@"Error publishing story.");
        //             } else {
        //                 if (result == FBWebDialogResultDialogNotCompleted) {
        //                     // User clicked the "x" icon
        //                     NSLog(@"User canceled story publishing.");
        //                 } else {
        //                     // Handle the publish feed callback
        //                     NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
        //                     if (![urlParams valueForKey:@"post_id"]) {
        //                         // User clicked the Cancel button
        //                         NSLog(@"User canceled story publishing.");
        //                     } else {
        //                         // User clicked the Share button
        //                         NSString *msg = [NSString stringWithFormat:
        //                                          @"Posted story on your Facebok Wall!"];
        //                         NSLog(@"%@", msg);
        //                         // Show the result in an alert
        //                         [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Facebook", nil)
        //                                                     message:msg
        //                                                    delegate:nil
        //                                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
        //                                           otherButtonTitles:nil]
        //                          show];
        //                     }
        //                 }
        //             }
        //         }];
    }
}

-(void)message {
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = [NSString stringWithFormat:NSLocalizedString(@"Hello! I'm playing Weird Fly! Download it here: %@", nil), @"http://goo.gl/3CVUWD"] ;
        controller.recipients = [NSArray arrayWithObjects:@"", nil];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

-(void)whatsapp {
    NSString *strMex = [NSString stringWithFormat:NSLocalizedString(@"Hello! I'm playing Weird Fly! Download it here: %@", nil), @"http://goo.gl/3CVUWD"];
    
    strMex = [strMex stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@", strMex]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    switch (result) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
            break;
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
