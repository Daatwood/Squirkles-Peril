

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
//#import "CharacterActor.h"
//@class AbstractEntity;
@class CharacterActor;
@class ForegroundActor;
@class BackgroundActor;
@class ButtonControl;
@class ButtonFrame;
@class AchievementsViewController;
// This class is the core game scene.  It is responsible for game rendering, logic, user
// input etc.

@interface GameScene : AbstractScene 
{	
	/* Game specific items */
  @private    
    AngelCodeFont *font;
	ParticleEmitter *explosionEmitter;
	
	// Game Actors
	CharacterActor *characterActor;
	//CharacterActor *monkey;
	//ForegroundActor *foreground;
	//BackgroundActor *background;
	
	// Game Controls
	ButtonFrame *costumeButtonBar;
	ButtonFrame *sceneryButtonBar;
	ButtonFrame *menuButtonBar;
	ButtonControl *menuButton;
	
	BOOL touchMoved;
}

- (void) goToStore;

// Save the Game State
- (void) saveGameState;

// Load the Game State
- (void) loadGameState;

@end
