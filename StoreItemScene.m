

#import "StoreItemScene.h"

@interface StoreItemScene (Private)
- (void)initStoreItems;
- (void)reloadStoreItems;
@end

@implementation StoreItemScene


-(id) initWithCategory:(NSString*)category products:(NSArray*)products
{
	if(self = [super init]) 
	{
		sharedDirector = [Director sharedDirector];
		sharedResourceManager = [ResourceManager sharedResourceManager];
		sharedSoundManager = [SoundManager sharedSoundManager];
        
        sceneFadeSpeed = 1.0f;
        sceneAlpha = 0.0f;
        [sharedDirector setGlobalAlpha:sceneAlpha];
		
		menuEntities = [[NSMutableArray alloc] init];
		//menuBackground = [[Image alloc] initWithImage:@"Default.png"];
		[self setSceneState:SceneState_TransitionIn];
		nextSceneKey = nil;
		[self initStoreItems];
		[self reloadStoreItems];
	}
	return self;
}


- (void)initStoreItems 
{

}

- (void)reloadStoreItems 
{

}

- (void)updateWithDelta:(GLfloat)aDelta 
{	
	switch (sceneState) 
	{
		case SceneState_Running:

			break;
			
		case SceneState_TransitionOut:
			sceneAlpha -= sceneFadeSpeed * aDelta;
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
            sceneAlpha += sceneFadeSpeed * 0.02f;
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
	[menuEntities makeObjectsPerformSelector:@selector(render)];
	// Draw each of the labels with the font here.
}
@end
