#import "Wizard.h"

@implementation Wizard

-(id) initWithLifePoints:(int)lifePoints type:(ElementTypes)type cards:(NSMutableArray *)cards cardPlayed:(Card *)cardPlayed {
    
    self = [super init];
    
    if (!self) return(nil);
    
    _lifePoints = lifePoints;
    _elementType = type;
    _cards = cards;
    _cardPlayed = cardPlayed;
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeInteger:_lifePoints forKey:@"lifePoints"];
    [coder encodeInteger:_elementType forKey:@"elementType"];
    [coder encodeObject:_cards forKey:@"cards"];
    [coder encodeObject:_cardPlayed forKey:@"cardPlayed"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _name = [decoder decodeObjectForKey:@"name"];
        _lifePoints = [decoder decodeIntForKey:@"lifePoints"];
        _elementType = [decoder decodeIntForKey:@"elementType"];
        _cards = [decoder decodeObjectForKey:@"cards"];
        _cardPlayed = [decoder decodeObjectForKey:@"cardPlayed"];
    }
    return self;
}

@end
