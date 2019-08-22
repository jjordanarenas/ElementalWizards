#import "Card.h"

@implementation Card

-(id) initWithType:(int)type attack:(unsigned int)attack defense:(unsigned int)defense image:(NSString *)image{
    self = [super initWithImageNamed:image];
    
    if (!self) return(nil);
    
    _elementType = type;
    _attack = attack;
    _defense = defense;
    _imageName = image;
    
    switch (type) {
        case fire:
            _element = @"fire";
            break;
        case air:
            _element = @"air";
            break;
        case water:
            _element = @"water";
            break;
        case earth:
            _element = @"earth";
            break;
        default:
            break;
    }
    
    return self;
}

-(id) initWithCard:(Card *)card {
    self = [self initWithType:card.elementType attack:card.attack defense:card.defense image:card.imageName];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeInteger:_elementType forKey:@"elementType"];
    [coder encodeInteger:_attack forKey:@"attack"];
    [coder encodeInteger:_defense forKey:@"defense"];
    [coder encodeObject:_element forKey:@"element"];
    [coder encodeObject:_imageName forKey:@"imageName"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _elementType = [decoder decodeIntForKey:@"elementType"];
        _attack = [decoder decodeIntForKey:@"attack"];
        _defense = [decoder decodeIntForKey:@"defense"];
        _element = [decoder decodeObjectForKey:@"element"];
        _imageName = [decoder decodeObjectForKey:@"imageName"];
    }
    return self;
}

@end