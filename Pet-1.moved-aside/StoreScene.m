

#import "StoreScene.h"
#import "ButtonControl.h"

@implementation StoreScene
-(id) init
{
	if(self = [super init]) 
	{
		sharedDirector = [Director sharedDirector];
		sharedResourceManager = [ResourceManager sharedResourceManager];
		sharedSoundManager = [SoundManager sharedSoundManager];
        
        sceneFadeSpeed = 1.0f;
        sceneAlpha = 0.0f;
        [sharedDirector setGlobalAlpha:sceneAlpha];
		font = [[AngelCodeFont alloc] initWithFontImageNamed:@"GillSans16.png" controlFile:@"GillSans16" scale:1.5f filter:GL_LINEAR];
		titleBar = [[Image alloc] initWithImageNamed:@"Test_StoreTitle.png"];
		menuEntities = [[NSMutableArray alloc] init];
		menuBackground = [[Image alloc] initWithImageNamed:@"BackgroundImage.png"];
		[self setSceneState:SceneState_TransitionIn];
		storeList = [[NSMutableArray alloc] init];
		nextSceneKey = nil;
		[self initStoreItems];
	}
	return self;
}

- (void)initStoreItems 
{

}

- (void)goToStoreItem
{
	NSLog(@"Item Selected");
	sceneState = SceneState_TransitionOut;
	nextSceneKey = @"costume";
}

- (void)updateWithDelta:(GLfloat)aDelta 
{
	switch (sceneState) 
	{
		case SceneState_Running:

			break;
			
		case SceneState_TransitionOut:
			sceneAlpha -= sceneFadeSpeed * (aDelta * 2);
            [sharedDirector setGlobalAlpha:sceneAlpha];
			if(sceneAlpha < 0)
                // If the scene being transitioned to does not exist then transition
                // this scene back in
				if(![sharedDirector setCurrentSceneToSceneWithKey:nextSceneKey])
                    sceneState = SceneState_TransitionIn;
			break;
			
		case SceneState_TransitionIn:
			
			// I'm not using the delta value here as the large map being loaded causes
            // the first delta to be passed in to be very big which takes the alpha
            // to over 1.0 immediately, so I've got a fixed delta for the fade in.
            sceneAlpha += sceneFadeSpeed * (0.02f * 2);
            [sharedDirector setGlobalAlpha:sceneAlpha];
			if(sceneAlpha >= 1.0f) {
				sceneState = SceneState_Running;
			}
			break;
		default:
			break;
	}
	
}


- (void)setSceneState:(uint)theState 
{
	sceneState = theState;
	if(sceneState == SceneState_TransitionOut)
		sceneAlpha = 1.0f;
	if(sceneState == SceneState_TransitionIn)
		sceneAlpha = 0.0f;
}

- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView 
{
    UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
	[menuEntities makeObjectsPerformSelector:@selector(updateWithLocation:) withObject:NSStringFromCGPoint(location)];
}


- (void)updateWithMovedLocation:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
    UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
	[menuEntities makeObjectsPerformSelector:@selector(updateWithLocation:) withObject:NSStringFromCGPoint(location)];	
}


- (void)transitionToSceneWithKey:(NSString*)theKey {
	sceneState = SceneState_TransitionOut;
	sceneAlpha = 1.0f;
}


- (void)render 
{
	[menuBackground renderAtPoint:CGPointMake(0, 0) centerOfImage:NO];
	//[titleBar renderAtPoint:CGPointMake(0,430) centerOfImage:NO];
	[menuEntities makeObjectsPerformSelector:@selector(render)];
	[storeList makeObjectsPerformSelector:@selector(render)];
	[font drawStringAt:CGPointMake(5, 450) text:[NSString stringWithFormat:@"Bad Bad Monkey Chest"]];
	// Draw each of the labels with the font here.
}

@end
