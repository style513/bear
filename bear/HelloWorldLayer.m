//
//  HelloWorldLayer.m
//  bear
//
//  Created by yons on 13-6-25.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer {
    int direction ; //1 left 2:right
}

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithFile:@"flower-hd.pvr.ccz"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];
        
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
        
        CCSpriteBatchNode *bearSheet = [CCSpriteBatchNode batchNodeWithFile:@"bear.pvr.ccz"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bear.pv.plist"];
        
        [self addChild:bearSheet];
        

        
        _bearArr = [[NSMutableArray alloc] initWithCapacity:8];
        for (int i = 0; i < 8; i++) {
            NSString *imgStr = [NSString stringWithFormat:@"bear%d.png",i+1];
            CCSpriteFrame *sprite = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:imgStr];
            [_bearArr addObject:sprite];
        }
        
        _bear = [CCSprite spriteWithSpriteFrameName:@"bear1.png"];
        _bear.position = ccp(size.width / 2, size.height / 2);
        [bearSheet addChild:_bear];
        
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
        
        self.isTouchEnabled = YES;
	}
	return self;
}

- (void) registerWithTouchDispatcher {
    CCTouchDispatcher *touchDispatcher = [[CCDirector sharedDirector] touchDispatcher];
    [touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

    [_bear stopAllActions];
    
    CCAnimation *animation = [CCAnimation animationWithFrames:_bearArr delay:0.1f];
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
    [_bear runAction:[CCRepeatForever actionWithAction:animate]];
    
    return YES;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {

    CGPoint point = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    if (point.x > _bear.position.x ) {
        _bear.flipX = YES;
    } else {
        _bear.flipX = NO;
    }
    
//    float distance = sqrtf(pow(abs(point.x - _bear.position.x) , 2) + pow(abs(point.y - _bear.position.y) , 2));
    float distance = ccpLength(ccpSub(point, _bear.position));
    float time = distance / (size.width / 4);
    
    
    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:time position:point];
    CCCallBlockN *block = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [_bear stopAllActions];
    }];
    CCSequence *sequence = [CCSequence actions:moveTo,block, nil];
    [_bear runAction:sequence];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[_bearArr dealloc];
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
