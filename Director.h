

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "SynthesizeSingleton.h"
#import "Common.h"
#import <UIKit/UIKit.h>

@class  EAGLView, AbstractScene, Image;

@interface Director : NSObject 
{
	EAGLView *glView;
	UIImageView *backgroundSpinner;
	UIImageView *indicatorSpinner;
	
	// The global Texture Sheet
	Image *textureAtlas;
	// The Texture XML
	NSDictionary *textureXML;
	// The Animation XML
	NSArray *animationXML;
	// Currently bound texture name
	GLuint currentlyBoundTexture;
	// Current game state
	GLuint gameMode;
	// Current scene
	AbstractScene *currentScene;
	// Dictionary of scenes
	NSMutableDictionary *_scenes;
	// Global alpha
	GLfloat globalAlpha;
    // Frames Per Second
    float framesPerSecond;
	// Frames Per Second
    float averageFramesPerSecond;
	// Gobal Background color
	Color4f globalBackgroundColor;
	// Holds the latest arguement values for the event
	ObjectEventArguements eventArgs;
	// Current screen mode; landscape or portrait
	GLuint screenMode;
	// Screen Bounds
	CGRect screenBounds;
	// Screen Scale
	float screenScale;
}
@property (nonatomic, retain) EAGLView* glView;
@property (nonatomic, retain) UIImageView* backgroundSpinner;
@property (nonatomic, retain) UIImageView* indicatorSpinner;

@property (nonatomic, retain) Image *textureAtlas;
@property (nonatomic, assign) GLuint currentlyBoundTexture;
@property (nonatomic, assign) GLuint gameMode;
@property (nonatomic, assign) GLuint screenMode;
@property (nonatomic, retain) AbstractScene *currentScene;
@property (nonatomic, assign) GLfloat globalAlpha;
@property (nonatomic, assign) Color4f globalBackgroundColor;
@property (nonatomic, assign) float framesPerSecond;
@property (nonatomic, assign) float averageFramesPerSecond;
@property (nonatomic, assign) ObjectEventArguements eventArgs;
@property (nonatomic, assign) NSDictionary *textureXML;
@property (nonatomic, retain) NSArray *animationXML;
@property (nonatomic) CGRect screenBounds;
@property (nonatomic) float screenScale;

+ (Director*)sharedDirector;

- (void) startLoading;
- (void) stopLoading;

- (void)addSceneWithKey:(NSString*)aSceneKey scene:(AbstractScene*)aScene;
- (BOOL)setCurrentSceneToSceneWithKey:(NSString*)aSceneKey;
- (BOOL)transitionToSceneWithKey:(NSString*)aSceneKey;
- (void) setCurrentSceneState:(uint)newSceneState;
@end
