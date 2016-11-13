
#import "SettingsScene.h"


@implementation SettingsScene

- (id)init {
	
	if(self = [super init]) {
		sharedDirector = [Director sharedDirector];
		sharedResourceManager = [ResourceManager sharedResourceManager];
		sharedSoundManager = [SoundManager sharedSoundManager];
		sceneFadeSpeed = 0.2f;

        // Init anglecode font and message
		font = [[AngelCodeFont alloc] initWithFontImageNamed:@"test.png" controlFile:@"test" scale:1.0f filter:GL_LINEAR];

	}
	
	return self;
}


- (void)updateWithDelta:(GLfloat)aDelta {
    switch (sceneState) {
		case SceneState_Running:

			break;
			
		case SceneState_TransitionOut:
			sceneAlpha-= sceneFadeSpeed * aDelta;
            [sharedDirector setGlobalAlpha:sceneAlpha];
			if(sceneAlpha <= 0.0f)
                // If the scene being transitioned to does not exist then transition
                // this scene back in
				if(![sharedDirector setCurrentSceneToSceneWithKey:nextSceneKey])
                    sceneState = SceneState_TransitionIn;
			break;
			
		case SceneState_TransitionIn:
			sceneAlpha += sceneFadeSpeed * aDelta;
            [sharedDirector setGlobalAlpha:sceneAlpha];
			if(sceneAlpha >= 1.0f) {
				sceneState = SceneState_Running;
			}
			break;
		default:
			break;
	}
    
}


- (void)updateWithTouchLoctionBegan:(NSString*)aTouchLocation {
}


- (void)updateWithMovedLocation:(NSString*)aTouchLocation {
}


- (void)transitionToSceneWithKey:(NSString*)aKey {
}

- (void)render {
    [font drawStringAt:CGPointMake(20, 450) text:@"Settings"];
}

@end
