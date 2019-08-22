#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    
    fire = 0,
    air,
    water,
    earth
    
} ElementTypes;

@interface Card : CCSprite {
    
}

// Declare property for attack value
@property (readonly, nonatomic) unsigned int attack;

// Declare property for defense value
@property (readonly, nonatomic) unsigned int defense;

// Declare property for element type
@property (readonly, nonatomic) ElementTypes elementType;

// Declare property for element type
@property (readwrite, nonatomic) NSString *element;

// Declare property for element type
@property (readwrite, nonatomic) NSString *imageName;

// Declare method to init card with element type, attack and defense
-(id) initWithType:(int)type attack:(unsigned int)attack defense:(unsigned int)defense image:(NSString *)image;

// Declare method to init card by match card
-(id) initWithCard:(Card *)card;

// Declare encode method
- (void)encodeWithCoder:(NSCoder *)coder;

// Declare decode method
- (id)initWithCoder:(NSCoder *)decoder;
@end