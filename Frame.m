

#import "Frame.h"


@implementation Frame

@synthesize frameDelay;
@synthesize frameImage;

- (id)initWithImage:(Image*)image delay:(float)delay 
{
	self = [super init];
	if(self != nil) 
	{
		frameImage = image;
		frameDelay = delay;
	}
	return self;
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"delay:%f %@", frameDelay, [frameImage description]];
}

- (void)dealloc 
{
    [frameImage release];
	[super dealloc];
}

@end
