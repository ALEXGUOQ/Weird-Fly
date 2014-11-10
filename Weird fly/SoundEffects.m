
#import "SoundEffects.h"

static struct SoundEffect soundEffectTable[] = {
	{ Sound_Bonus,		  "bonus",		0 },
	{ Sound_Coins,			  "coins",		0 },
	{ Sound_Eat,		      "eat",		    0 },
	{ Sound_GameOver,		  "gameover",	0 },
	{ Sound_Highscore,		      "highscore",		    0 }
};


static SoundEffects* g_instance;

void InitializeSoundEffects()
{
	[SoundEffects sharedInstance];
}

void PlaySoundEffect(GameSoundEffects soundID)
{
	[[SoundEffects sharedInstance] playSoundEffect:soundID];
}

@implementation SoundEffects 

+ (SoundEffects*)sharedInstance {
	if (g_instance == nil) {
		g_instance = [SoundEffects new];
		[g_instance initializeSoundEffects];
	}
	return g_instance;
}

void AudioInterruptionListener(void *inClientData, UInt32 inInterruptionState) {
}

- (BOOL)createSoundWithName:(NSString*)name idPtr:(SystemSoundID*)idPtr {
	NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@"wav"];

	NSURL* url = [NSURL fileURLWithPath:path];
	OSStatus status = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, idPtr);
	return (status == 0);
}

- (void)initializeSoundEffects {
	AudioSessionInitialize(NULL, NULL, AudioInterruptionListener, (__bridge void *)(self));
	
    
	for (unsigned int i = 0; i < sizeof(soundEffectTable)/sizeof(struct SoundEffect); i++) {
		NSString* soundName = [NSString stringWithUTF8String:soundEffectTable[i].soundResourceName];
		[self createSoundWithName:soundName idPtr:&soundEffectTable[i].systemSoundID];
	}
}

- (void)playSoundEffect:(GameSoundEffects)soundID {
	if (soundID > 0 && soundID < Sound_COUNT) {
		AudioServicesPlaySystemSound(soundEffectTable[soundID].systemSoundID);
	}
}


@end
