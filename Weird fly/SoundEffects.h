
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

typedef enum {
	Sound_Bonus,
	Sound_Bonus2,
	Sound_Coins,
	Sound_Eat,
	Sound_GameOver,
	Sound_Highscore,
	
	Sound_COUNT
	
} GameSoundEffects;

struct SoundEffect {
	GameSoundEffects	gameSoundID;
	const char*			soundResourceName;
	SystemSoundID		systemSoundID;
};

void InitializeSoundEffects();
void PlaySoundEffect(GameSoundEffects soundID);

@interface SoundEffects : NSObject {
}

+ (SoundEffects*)sharedInstance;
- (void)initializeSoundEffects;
- (void)playSoundEffect:(GameSoundEffects)soundID;

@end
