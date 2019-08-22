#import "MatchStatus.h"

@implementation MatchStatus

-(id) initWithPlayer1:(Wizard *)player1 player2:(Wizard *)player2 {
    self = [super init];
    
    if (!self) return(nil);
    
    _player1 = player1;
    _player2 = player2;
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:_player1 forKey:@"player1"];
    [coder encodeObject:_player2 forKey:@"player2"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _player1 = [decoder decodeObjectForKey:@"player1"];
        _player2 = [decoder decodeObjectForKey:@"player2"];
    }
    return self;
}

@end