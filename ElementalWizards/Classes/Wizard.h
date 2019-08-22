#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Card.h"

@interface Wizard : CCNode {
    
}

// Declare property for life points
@property (readwrite, nonatomic) int lifePoints;

// Declare property for element type
@property (readonly, nonatomic) ElementTypes elementType;

// Declare property for the array of cards
@property (readonly, nonatomic) NSMutableArray *cards;

// Declare property for card played
@property (readwrite, nonatomic) Card *cardPlayed;

// Declare method to init wizard with name, life points, element type, cards and played card
-(id) initWithLifePoints:(int)lifePoints type:(ElementTypes)type cards:(NSMutableArray *)cards cardPlayed:(Card *)cardPlayed;

// Declare encode method
- (void)encodeWithCoder:(NSCoder *)coder;

// Declare decode method
-	(id)initWithCoder:(NSCoder *)decoder;

@end
