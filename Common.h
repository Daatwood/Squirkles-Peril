
#import <OpenGLES/ES1/gl.h>

#define MTIKS_KEY @"e319632fa022ef512a2fd2afc"
#define OF_KEY @"a5X0BACNGMkOLeIaU2sA"
#define OF_SECRET @"dNUI0uPoxEcy5SeBgd8uINIyqwwQGRsweETrNn2s"

// Scene Keys

#define LANDSCAPE_MODE 0
#define PORTRATE_MODE 1

#define FONT16 @"AndaleMono21"
#define FONT21 @"AndaleMono24"
#define FONT_LARGE @"AndaleMono32"


// Scene Keys
#define SCENEKEY_LOADING @"LOADING"
#define SCENEKEY_STYLIZE @"STYLIZE"
#define SCENEKEY_MENU @"MENU"
#define SCENEKEY_OPTIONS @"OPTIONS"
#define SCENEKEY_STORE @"STORE"
#define SCENEKEY_ARCADE @"ARCADE"
#define GAMEKEY_ESCAPE @"ESCAPE"
#define GAMEKEY_SKY @"SKY"
#define GAMEKEY_CRYSTAL @"CRYSTAL"
#define SCENEKEY_CHARACTER @"CHARACTER"


#define LEVEL_UNLOCK 6

#define PointsPerSecond 45
#define DistancePerStage (PointsPerSecond * 60)

#pragma mark -
#pragma mark Debug

#define DEBUG 0
#define MDEBUG 0
#pragma mark -
#pragma mark Macros

#define RANDOM(__RND__) (arc4random() % __RND__)

// Macro which returns a random value between -1 and 1
#define RANDOM_MINUS_1_TO_1() ((random() / (GLfloat)0x3fffffff )-1.0f)

// MAcro which returns a random number between 0 and 1
#define RANDOM_0_TO_1() ((random() / (GLfloat)0x7fffffff ))

// Macro which converts degrees into radians
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)

#pragma mark -
#pragma mark Constants

#define tapsMaxMonkey 16
#define BACKGROUND_ACTOR_INDEX 0
#define FOREGROUND_ACTOR_INDEX 1
#define CHARACTER_ACTOR_INDEX 2

#pragma mark -
#pragma mark Enumeration


// Defines Shape_type as a value
// Use Shape_Type when talking about level.
typedef enum _Shape_Level
{
	Shape_Circle = 1,
	Shape_Triangle = 2,
	Shape_Square = 3,
	Shape_Octagon = 4,
	Shape_HoneyComb = 5,
	Shape_Diamond = 6,
	Shape_Star = 7,
	Shape_Oddity = 8
} Shape_Level;

enum 
{	
	SceneState_Idle,
	SceneState_TransitionIn,
	SceneState_TransitionOut,
	SceneState_Running,
	SceneState_Paused,
	SceneState_GameOver
};

enum 
{	
	Button_Action = 100,
	Button_Cancel = 101,
	Button_Store = 102,
	Button_Stylize = 103,
	Button_Options = 104,
	Button_Sound = 105,
	Button_Music = 106
};

enum ItemType
{
	// Stylize Scene
	ItemType_Invalid = -1,
	ItemType_Topper = 0,
	ItemType_Eyes = 1,
	ItemType_Body_Type = 2,
	ItemType_Body_Pattern = 3,
	// Stage Items
	ItemType_Background = 10,
	ItemType_Foreground = 11,
	ItemType_Display = 12,
	ItemType_Overlay = 13,
	// Other
	ItemType_Treat = 20,
	ItemType_Minigame = 21,
	ItemType_Sky_Level = 22,
	ItemType_Escape_Level = 23,
	ItemType_Crystal_Level = 24,
	// Currency
	ItemType_Currency = 100
};

enum CurrencyType
{
	CurrencyType_Coin = 0,
	CurrencyType_Treat = 1,
	CurrencyType_Boost = 2,
	CurrencyType_Point = 3
};
/*
enum ProfileKey
{
	ProfileKey_Name = 0,
	ProfileKey_Time = 1,
	ProfileKey_Vibrate = 2,
	ProfileKey_Effects = 3,
	ProfileKey_Music = 4,
	ProfileKey_Coins = 5,
	ProfileKey_Treats = 6,
	ProfileKey_Boost = 7,
	ProfileKey_Pet_Color = 8,
	Profilekey_Pet_Antenna = 9,
	ProfileKey_Pet_Eyes = 10,
	ProfileKey_Sky_HiScore = 11,
	ProfileKey_Sky_Level1 = 12,
	ProfileKey_Sky_Level2 = 13,
	ProfileKey_Sky_Level3 = 14,
	ProfileKey_Sky_Level4 = 15,
	ProfileKey_Sky_Level5 = 16,
	ProfileKey_Escape_HiScore = 17,
	ProfileKey_Escape_Level1 = 18,
	ProfileKey_Escape_Level2 = 19,
	ProfileKey_Escape_Level3 = 20,
	ProfileKey_Escape_Level4 = 21,
	ProfileKey_Escape_Level5 = 22,
	ProfileKey_Crystal_HiScore = 23,
	ProfileKey_Crystal_Level1 = 24,
	ProfileKey_Crystal_Level2 = 25,
	ProfileKey_Crystal_Level3 = 26,
	ProfileKey_Crystal_Level4 = 27,
	ProfileKey_Crystal_Level5 = 28
};
 */

typedef enum _SettingsFileType
{
	FileType_Application = 0,
	FileType_Player = 1,
	FileType_Character = 2
} SettingsFileType;

typedef enum _ApplicationKey
{
	ProfileKey_Effects = 0,
	ProfileKey_Music = 1
} ApplicationKey;

typedef enum _PlayerKey
{
	ProfileKey_Coins = 0,
	ProfileKey_Boost = 1,
	ProfileKey_Character = 2
} PlayerKey;

typedef enum _CharacterKey
{
	ProfileKey_Cost = 0,
	ProfileKey_Color = 1,
	ProfileKey_Part1 = 2, // Body
	ProfileKey_Part2 = 3, // Antenna
	ProfileKey_Part3 = 4, // Eyes
	ProfileKey_Power = 5,
	ProfileKey_Experience = 6,
	ProfileKey_Level = 7,
	ProfileKey_Stage = 8,
	ProfileKey_Distance = 9
} CharacterKey;

enum ItemKey
{
	ItemKey_Character = 0,
	ItemKey_Antenna = 1,
    ItemKey_Eyes = 2
};

enum ItemBin
{
	ItemBin_All = 0,
	ItemBin_Equipped = 1,
	ItemBin_Stored = 2
};

enum ControlState
{
	ControlState_Normal = 0,
	ControlState_Disabled = 1,
	ControlState_Selected = 2,
	ControlState_Highlighted = 3,
	ControlState_Showing = 4,
	ControlState_Hiding = 5
};

enum ControlType
{
	ControlType_Icon = 0,
	ControlType_Menu = 1,
	ControlType_Hybrid = 2,
};

enum ActorState
{
	ActorState_Normal = 0,
	ActorState_Disabled = 1,
	ActorState_Selected = 2,
	ActorState_Highlighted = 3,
	ActorState_Showing = 4,
	ActorState_Hiding = 5,
	ActorState_MovingUp = 6,
	ActorState_MovingDown = 7,
	ActorState_MovingLeft = 8,
	ActorState_MovingRight = 9
};

enum ObjectEventState
{
	ObjectEventStateIdle = 0,
	ObjectEventStateTap = 1,
	ObjectEventStateSwipe = 2,
	ObjectEventStateShake = 3,
	ObjectEventStateTilt = 4
};

enum EventPriority
{
	EventPriorityNone = 0,
	EventPriorityLow = 1,
	EventPriorityHigh = 2,
	EventPriorityImmediate = 3
};

enum EventDirection
{
	EventDirectionUp = 0,
	EventDirectionDown = 1,
	EventDirectionLeft = 2,
	EventDirectionRight = 3,
};

#pragma mark -
#pragma mark Types

// MINI GAMES ENUMERATION

enum PlatformType
{
	PlatformType_Normal = 0,
	PlatformType_Dissolve = 1,
	PlatformType_Fake = 2,
	PlatformType_Bouncy = 3,
	PlatformType_FlyThru = 4,
	PlatformType_Absorb = 5
};

// Side scroller minigame

enum ItemEffect
{
	ItemEffectNone = -1,
	ItemEffectPoint = 0,
	ItemEffectRunIncrease = 1,
	ItemEffectJumpIncrease = 2,
	ItemEffectProtect = 3,
	ItemEffectDebuff = 4,
	ItemEffectRunDecrease = 5,
	ItemEffectJumpDecrease = 6,
	ItemEffectInvulnerable = 7,
	ItemEffectDeath = 8,
};

typedef struct _ItemBoost 
{
	uint boostEffect;
	uint boostModifier;
	uint boostLength;
} ItemBoost;


#define POINT_TIME_MIN 0
#define POINT_TIME_MAX 100

#define BASIC_TIME_MIN 25
#define BASIC_TIME_MAX 250

#define ADVANCED_TIME_MIN 100
#define ADVANCED_TIME_MAX 500

typedef struct _ItemBoostSpawn 
{
	// The current time passed since last spawn
	float currentTime;
	// The time required for the next spawn
	uint requiredTime;
	// The itemBoost that will spawn
	uint itemBoostType;
} ItemBoostSpawn;

typedef struct  _ObjectComponent
	{
		// The priority of this component
		GLuint priority;
		// The Amount of taps is required to activate
		GLuint triggerTaps;
		// A speical tag assocaited to this component
		GLuint triggerTag;
		// The time the event must be active first
		CFTimeInterval triggerTime;
		// The direction needed to become active
		GLuint triggerDirection;
		// The area it is triggered by
		CGRect triggerBox;
		// Defines if the object will increase it tap count
		short int causeTap;
		// The animation this component is assigned to
		CFStringRef causeAnimation;
		// Callback function
		//int (*callback)(int);
	} ObjectComponent;

typedef struct _Vector2f {
	GLfloat x;
	GLfloat y;
} Vector2f;

typedef struct _ObjectEventArguements 
	{
		uint touchCount;
		CFTimeInterval startTime;
		CFTimeInterval endTime;
		CGPoint startPoint;
		CGPoint movedPoint;
		CGPoint endPoint;
		CGPoint acceleration;
        BOOL needsCalibrate;
        CGPoint calibration;
		BOOL particleEmitterNeeded;
		CGPoint particleEmitterPosition;
		
	} ObjectEventArguements;

typedef struct _TileVert {
	GLfloat v[2];
	GLfloat uv[2];
} TileVert;

typedef struct _Color4f {
	GLfloat red;
	GLfloat green;
	GLfloat blue;
	GLfloat alpha;
} Color4f;

typedef struct _Quad2f {
	GLfloat bl_x, bl_y;
	GLfloat br_x, br_y;
	GLfloat tl_x, tl_y;
	GLfloat tr_x, tr_y;
} Quad2f;

typedef struct _Particle {
	Vector2f position;
	Vector2f direction;
	Color4f color;
	Color4f deltaColor;
	GLfloat particleSize;
	GLfloat timeToLive;
} Particle;

typedef struct _ForegroundObject 
{
	Vector2f position;
    GLfloat distance;
	GLfloat alpha;
	GLfloat size;
    GLfloat deltaSize;
	GLfloat timeToLive;
} ForegroundObject;


typedef struct _PointSprite {
	GLfloat x;
	GLfloat y;
	GLfloat size;
} PointSprite;


typedef struct PercentPoint
{
	float x;
	float y;
} PercentPoint;

static const PercentPoint PercentPointZero = {0.0f, 0.0f};

static inline PercentPoint PercentPointFromCGPoint(CGPoint a)
{
	return (PercentPoint) {a.x, a.y};
}

static inline PercentPoint PercentPointMake(float x, float y)
{
	return (PercentPoint) {x, y};
}
#pragma mark CGPoint Additions
static inline CGPoint CGPointPortraitToLandscape(CGPoint p)
{
	return (CGPoint) {p.y, 480 - p.x};
}

static inline CGPoint CGPointSub(CGPoint v1, CGPoint v2)
{
	return (CGPoint) {v1.x - v2.x, v1.y - v2.y};
}

static inline CGPoint CGPointAdd(CGPoint v1, CGPoint v2)
{
	return (CGPoint) {v1.x + v2.x, v1.y + v2.y};
}

static inline CGPoint CGPointMultiply(CGPoint v, GLfloat s)
{
	return (CGPoint) {v.x * s, v.y * s};
}

static inline CGPoint CGPointDivide(CGPoint v, GLfloat s)
{
	return (CGPoint) {v.x / s, v.y / s};
}

static inline GLfloat CGPointDot(CGPoint v1, CGPoint v2)
{
	return (GLfloat) v1.x * v2.x + v1.y * v2.y;
}

static inline GLfloat CGPointLength(CGPoint v)
{
	return (GLfloat) sqrtf(CGPointDot(v, v));
}

static inline CGPoint CGPointNormalize(CGPoint v)
{
	return CGPointMultiply(v, 1.0f/CGPointLength(v));
}

static inline float CGPointDistance(CGPoint v1, CGPoint v2)
{
	return sqrtf((v2.x - v1.x) * (v2.x - v1.x) - (v2.y - v1.y) * (v2.y - v1.y));
}

#pragma mark Other Additions 
static const Color4f Color4fInit = {1.0f, 1.0f, 1.0f, 1.0f};

static const Color4f Color4fZero = {0.0f, 0.0f, 0.0f, 0.0f};

static const Vector2f Vector2fZero = {0.0f, 0.0f};

static inline Vector2f Vector2fMakeFromRect(CGPoint a)
{
	return (Vector2f) {a.x, a.y};
}

static inline Vector2f Vector2fMake(GLfloat x, GLfloat y)
{
	return (Vector2f) {x, y};
}

static inline Color4f Color4fMake(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha)
{
	return (Color4f) {red, green, blue, alpha};
}

static inline Vector2f Vector2fMultiply(Vector2f v, GLfloat s)
{
	return (Vector2f) {v.x * s, v.y * s};
}

static inline Vector2f Vector2fAdd(Vector2f v1, Vector2f v2)
{
	return (Vector2f) {v1.x + v2.x, v1.y + v2.y};
}

static inline Vector2f Vector2fSub(Vector2f v1, Vector2f v2)
{
	return (Vector2f) {v1.x - v2.x, v1.y - v2.y};
}

static inline GLfloat Vector2fDot(Vector2f v1, Vector2f v2)
{
	return (GLfloat) v1.x * v2.x + v1.y * v2.y;
}

static inline GLfloat Vector2fLength(Vector2f v)
{
	return (GLfloat) sqrtf(Vector2fDot(v, v));
}

static inline GLfloat Vector2fDistance(Vector2f v1, Vector2f v2)
{
	return (GLfloat) sqrtf(Vector2fDot(v1, v2));
}

static inline Vector2f Vector2fNormalize(Vector2f v)
{
	return Vector2fMultiply(v, 1.0f/Vector2fLength(v));
}


// Returns the Assigned Color based on Shape
static inline Color4f Color4fFromShapeLevel(Shape_Level n)
{
	switch (n) 
	{
		case Shape_Circle:
			return Color4fMake(0.0, 1.0, 0.0, 1.0);
			
		case Shape_Triangle:
			return Color4fMake(1.0, 1.0, 0.0, 1.0);
			
		case Shape_Square:
			return Color4fMake(1.0, 0.0, 0.0, 1.0);
			
		case Shape_Octagon:
			return Color4fMake(1.0, 0.5, 0.0, 1.0);
			
		case Shape_HoneyComb:
			return Color4fMake(1.0, 0.0, 1.0, 1.0);
			
		case Shape_Diamond:
			return Color4fMake(0.0, 1.0, 1.0, 1.0);
			
		case Shape_Star:
			return Color4fMake(1.0, 1.0, 0.85, 1.0);
			
		case Shape_Oddity:
			return Color4fMake(0.85, 1.0, 1.0, 1.0);
			
		default:
			return Color4fMake(1.0, 1.0, 1.0, 1.0);
	}
}

// Returns the Assigned Image based on Shape
static inline NSString* NSStringFromShapeLevel(Shape_Level n)
{
	switch (n) 
	{
		case Shape_Circle:
			return @"Circle32";
			
		case Shape_Triangle:
			return @"Triangle32";
			
		case Shape_Square:
			return @"Square32";
			
		case Shape_Octagon:
			return @"Octagon32";
			
		case Shape_HoneyComb:
			return @"Honeycomb32";
			
		case Shape_Diamond:
			return @"Diamond32";
			
		case Shape_Star:
			return @"Star32";
			
		case Shape_Oddity:
			return @"Oddity32";
			
		default:
		{
			NSLog(@"Invalid Shape Level");
			return @"";
		}
	}
}
