
#import "TableviewScene.h"


@implementation TableviewScene

- (id)init 
{
	if(self == [super init]) 
	{
		sharedDirector = [Director sharedDirector];
		sharedResourceManager = [ResourceManager sharedResourceManager];
		sharedSoundManager = [SoundManager sharedSoundManager];
		sharedSettingManager = [SettingManager sharedSettingManager];
	
        sceneFadeSpeed = 1.0f;
        sceneAlpha = 0.0f;
        [sharedDirector setGlobalAlpha:sceneAlpha];
		
		[self setSceneState:SceneState_TransitionIn];
		nextSceneKey = nil;
	}
	return self;
}
- (void)updateWithDelta:(GLfloat)aDelta 
{
	
}

- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	
}

- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	
}

- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
	
}

- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration 
{
	
}

- (void)transitionToSceneWithKey:(NSString*)aKey 
{
	
}

- (void)render 
{
	
}

@end
