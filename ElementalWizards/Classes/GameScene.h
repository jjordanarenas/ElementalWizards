#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "GameCenterHelper.h"
#import "MatchStatus.h"

@interface GameScene : CCScene <GameCenterHelperDelegate>{
    
}

+ (GameScene *)scene;
- (id)init;

@end
