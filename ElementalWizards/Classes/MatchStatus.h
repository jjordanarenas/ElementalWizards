#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Wizard.h"
#import "Card.h"

@interface MatchStatus : CCNode {
}

// Declare Wizard property for player1
@property (readwrite, nonatomic) Wizard *player1;

// Declare Wizard property for player2
@property (readwrite, nonatomic) Wizard *player2;

// Declare method to init MatchStatus with two wizards
-(id) initWithPlayer1:(Wizard *)player1 player2:(Wizard *)player2;

// Declare encode method
- (void)encodeWithCoder:(NSCoder *)coder;

// Declare decode method
- (id)initWithCoder:(NSCoder *)decoder;

@end