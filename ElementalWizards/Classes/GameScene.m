#import "GameScene.h"
#import "Card.h"
#import "Wizard.h"

// Number of common deck cards
#define DECK_NUM_CARDS 24

// Number of wizard cards
#define NUM_CARDS 5

// Initial life points
#define INIT_LIFE_POINTS 12

// Number of participants in the match
#define NUM_PARTICIPANTS 2

@implementation GameScene {
    // Declare common deck of cards
    NSMutableArray *_deckOfCards;
    
    // Declare global variable for screen size
    CGSize _screenSize;
    
    // Declare current player instance
    Wizard *_currentPlayer;
    
    // Declare element buttons
    CCButton *_fireElementButton;
    CCButton *_airElementButton;
    CCButton *_waterElementButton;
    CCButton *_earthElementButton;
    
    // Declare label
    CCLabelBMFont *_label;
    
    // Declare card selected
    Card *_selectedCard;
    
    // Declare initial card position
    CGPoint _initialCardPosition;

    // Declare button to create a new game
    CCButton *_createGameButton;
    
    // Declare button to pass the turn
    CCButton *_passTurnButton;
    
    // Declare the match status variable
    MatchStatus *_matchStatus;
    
    // Declare opponent card
    Card *_opponentCard;
    
    // Declare player 1 label
    CCLabelBMFont *_currentPlayerLabel;
    
    // Declare player 2 label
    CCLabelBMFont *_opponentPlayerLabel;

}

+ (GameScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
   
    // Store the screen size for later calculations
    _screenSize = [CCDirector sharedDirector].viewSize;
    
    // Adding the background image
    CCSprite *background = [CCSprite spriteWithImageNamed:@"background.png"];
    background.position = CGPointMake(_screenSize.width / 2, _screenSize.height / 2);
    [self addChild:background z:-1];
    
    // Enabling user interaction
    self.userInteractionEnabled = TRUE;
    
    [self createPlayButton];
    
    // Initializing the delegate property
    [GameCenterHelper sharedGameCenterInstance].delegate = self;

    return self;
}

- (void)initializeCards {
    
    NSString *cardPrefix = @"card_";
    NSString *typeDescription;
    Card *card;
    
    _deckOfCards = [NSMutableArray arrayWithCapacity:DECK_NUM_CARDS];
    
    for (int type = fire; type <= earth; type++) {
        switch (type) {
            case fire:
                typeDescription = @"fire";
                break;
            case air:
                typeDescription = @"air";
                break;
            case water:
                typeDescription = @"water";
                break;
            case earth:
                typeDescription = @"earth";
                break;
            default:
                break;
        }
        
        card = [[Card alloc] initWithType:type attack:1 defense:2 image:[NSString stringWithFormat:@"%@%@_%@", cardPrefix, typeDescription, @"12.png"]];
        [_deckOfCards addObject:card];
        
        card = [[Card alloc] initWithType:type attack:2 defense:1 image:[NSString stringWithFormat:@"%@%@_%@", cardPrefix, typeDescription, @"21.png"]];
        [_deckOfCards addObject:card];
        
        card = [[Card alloc] initWithType:type attack:2 defense:3 image:[NSString stringWithFormat:@"%@%@_%@", cardPrefix, typeDescription, @"23.png"]];
        [_deckOfCards addObject:card];
        
        card = [[Card alloc] initWithType:type attack:3 defense:2 image:[NSString stringWithFormat:@"%@%@_%@", cardPrefix, typeDescription, @"32.png"]];
        [_deckOfCards addObject:card];
        
        card = [[Card alloc] initWithType:type attack:1 defense:3 image:[NSString stringWithFormat:@"%@%@_%@", cardPrefix, typeDescription, @"13.png"]];
        [_deckOfCards addObject:card];
        
        card = [[Card alloc] initWithType:type attack:3 defense:1 image:[NSString stringWithFormat:@"%@%@_%@", cardPrefix, typeDescription, @"31.png"]];
        [_deckOfCards addObject:card];
    }
}

-(void)initWizardWithTypeFire {
    [self initWizardWithType:fire];
}

-(void)initWizardWithTypeAir {
    [self initWizardWithType:air];
}

-(void)initWizardWithTypeWater {
    [self initWizardWithType:water];
}

-(void)initWizardWithTypeEarth {
    [self initWizardWithType:earth];
}

-(void)initWizardWithType:(ElementTypes)type {
    
    // Initialize current player
    int initialLifePoints = INIT_LIFE_POINTS;
    NSMutableArray *randomDeck = [self createRandomDeckOfCards];
    _currentPlayer = [[Wizard alloc] initWithLifePoints:initialLifePoints type:type cards:randomDeck cardPlayed:NULL];
    
    // Hide buttons and label
    [self hideElements];
    
    // Show current player cards
    [self dealCards];
    
    //Initialize pass turn button
    [self initializePassTurnButton];
    
    [self showLifePointsLabels:0];
}

-(NSMutableArray *) createRandomDeckOfCards {
    
    NSMutableArray *deck = [NSMutableArray arrayWithCapacity:NUM_CARDS];
    int randomCard;
    
    for (int i = 0; i < NUM_CARDS; i++) {
        randomCard = arc4random_uniform(DECK_NUM_CARDS);
        
        // Avoid adding a card multiple times
        Card *card = [_deckOfCards objectAtIndex:randomCard];
        [deck addObject:[[Card alloc] initWithCard:card]];
    }
 
    return deck;
}

-(void) hideElements {
    
    // Determine duration of interval actions
    float duration = ccpDistance(_label.position, CGPointMake(_label.position.x, _screenSize.height + _label.texture.contentSize.height / 2)) / 500;
    
    // Create move action for the label
    CCActionMoveTo *actionLabelMove = [CCActionMoveTo actionWithDuration:duration position:CGPointMake(_label.position.x, _screenSize.height + _label.texture.contentSize.height / 2)];
    // Combine move action with an ease action
    CCActionEaseBackInOut *easeLabel = [CCActionEaseBackInOut actionWithAction:actionLabelMove];
    
    // Create move action for the label
    CCActionMoveTo *actionFireMove = [CCActionMoveTo actionWithDuration:duration position:CGPointMake(_fireElementButton.position.x, -_fireElementButton.contentSize.height / 2)];
    // Combine move action with an ease action
    CCActionEaseSineIn *easeFire = [CCActionEaseSineIn actionWithAction:actionFireMove];
    
    // Create move action for the label
    CCActionMoveTo *actionAirMove = [CCActionMoveTo actionWithDuration:duration/2 position:CGPointMake(_screenSize.width + _airElementButton.contentSize.width/2, _airElementButton.position.y)];
    // Combine move action with an ease action
    CCActionEaseOut *easeAir = [CCActionEaseOut actionWithAction:actionAirMove];
    
    // Create move action for the label
    CCActionMoveTo *actionWaterMove = [CCActionMoveTo actionWithDuration:duration position:CGPointMake(_waterElementButton.position.x, -_waterElementButton.contentSize.height / 2)];
    // Combine move action with an ease action
    CCActionEaseBackIn *easeWater = [CCActionEaseBackIn actionWithAction:actionWaterMove];
    
    // Create move action for the label
    CCActionMoveTo *actionEarthMove = [CCActionMoveTo actionWithDuration:duration position:CGPointMake(_earthElementButton.position.x, -_earthElementButton.contentSize.height / 2)];
    // Combine move action with an ease action
    CCActionEaseElasticIn *easeEarth = [CCActionEaseElasticIn actionWithAction:actionEarthMove];
    
    // Execute actions in parallel
    [_label runAction:easeLabel];
    [_fireElementButton runAction:easeFire];
    [_airElementButton runAction:easeAir];
    [_waterElementButton runAction:easeWater];
    [_earthElementButton runAction:easeEarth];

    
}

-(void) dealCards {
    
    // Get an auxiliar card to get its width
    Card *cardAux = [_deckOfCards objectAtIndex:0];
    
    // Calculate gaps between cards to place them equidistantly
    float gapWidth = ((_screenSize.width - NUM_CARDS * cardAux.contentSize.width) / (NUM_CARDS + 1));
    
    // Initial x position for the cards
    float positionX = gapWidth + (cardAux.contentSize.width / 2);
    
    for (Card *card in _currentPlayer.cards){
        
        // Set the card position
        card.position = CGPointMake(_screenSize.width + card.contentSize.width/2, _screenSize.height - card.contentSize.height / 2);

        // Add the card to the scene
        [self addChild:card];
        
        // Generate a spin and displacement action
        CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:0.5 position:CGPointMake(positionX, card.contentSize.height / 2)];
        CCActionRotateBy *actionSpin = [CCActionRotateBy actionWithDuration:0.5 angle:720];
        
        // Axecute actions simultaneously
        [card runAction:actionSpin];
        [card runAction:actionMove];
        
        // Update next x position
        positionX += gapWidth + card.contentSize.width;
    }
    
    // Show player1 first card played
    if (_matchStatus.player1.cardPlayed) {
        _opponentCard = [[Card alloc] initWithCard:_matchStatus.player1.cardPlayed];
        _opponentCard.position = CGPointMake(_screenSize.width/2, 5 * _opponentCard.texture.contentSize.height / 2);
        [self addChild:_opponentCard];
    }
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    // Check what card has been touched
    CGPoint touchLocation = [touch locationInNode:self];
    [self checkCardTouched:touchLocation];
}

-(void) checkCardTouched:(CGPoint)touchLocation{
    for (Card *card in _currentPlayer.cards) {
        if (CGRectContainsPoint(card.boundingBox, touchLocation)) {
            // The touch location belongs to the card
            _selectedCard = card;
            
            // Store the initial card position
            _initialCardPosition = _selectedCard.position;
            
            // Scale the card and update its z-order value
            CCActionScaleTo *scale = [CCActionScaleTo actionWithDuration:0.5 scale:1.5];
            [_selectedCard runAction:scale];
            _selectedCard.zOrder = 1;
            
            break;
        }
    }
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Moving the card along the screen
    CGPoint touchLocation = [touch locationInNode:self];
    _selectedCard.position = touchLocation;
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    // Define area to drop the card
    CGRect boardRect = CGRectMake(0, _selectedCard.contentSize.height, _screenSize.width, 3 * _selectedCard.contentSize.height);
    
    // Only drop card inside the defined area
    if (CGRectContainsPoint(boardRect, [touch locationInNode:self])) {
        _selectedCard.position = CGPointMake(_screenSize.width / 2, (3 * _selectedCard.contentSize.height) / 2);
    } else {
        _selectedCard.position = _initialCardPosition;
    }
    
    // Revert scalation
    CCActionScaleTo *scale = [CCActionScaleTo actionWithDuration:0.15 scale:1.0];
    [_selectedCard runAction:scale];
 }

- (void)createPlayButton {
    _createGameButton = [CCButton buttonWithTitle:@"Play" fontName:@"Verdana-Bold" fontSize:28.0f];
    _createGameButton.positionType = CCPositionTypeNormalized;
    _createGameButton.position = ccp(0.5f, 0.5f);
    [_createGameButton setTarget:self selector:@selector(startMatch:)];
    [self addChild:_createGameButton];
}

- (void)startMatch:(id)sender
{
    [[GameCenterHelper sharedGameCenterInstance]
     createMatchWithMinPlayers:NUM_PARTICIPANTS maxPlayers:NUM_PARTICIPANTS viewController:[CCDirector sharedDirector]];
    
    [self removeChild:_createGameButton];
}

-(void) initializeNewGame:(GKTurnBasedMatch *)match {
    if(!_matchStatus){
        _matchStatus = [[MatchStatus alloc] init];
    }
    [self showInitScreen];

}

-(void) receiveTurn:(GKTurnBasedMatch *)match {
    if ([match.matchData bytes]) {
         if (!(match.status == GKTurnBasedMatchStatusEnded)) {
             // Decode the card played by the opponent
             _matchStatus = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
        
             // If its player 2 first turn
             if (match.currentParticipant.lastTurnDate == NULL) {
                 if ([match.currentParticipant.playerID
                      isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
                     [self showInitScreen];
                 } else {
                     // Not your turn
                     [self updateViewAsViewer:match];
                 }
                 
             } else {
                 
                 if ([match.currentParticipant.playerID
                      isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
                     // Your turn
                     [self updateViewWithMatch:match];
                 } else {
                     // Not your turn
                     [self updateViewAsViewer:match];
                 }
             }
         } else {
             [self updateViewAsViewer:match];
         }
     }
}

- (void)showInitScreen {
    // Create fire button
    _fireElementButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"element_fire.png"]];
    _fireElementButton.positionType = CCPositionTypeNormalized;
    _fireElementButton.position = ccp(0.2f, 0.30f);
    [_fireElementButton setTarget:self selector:@selector(initWizardWithTypeFire)];
    [self addChild:_fireElementButton];
    
    // Create air button
    _airElementButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"element_air.png"]];
    _airElementButton.positionType = CCPositionTypeNormalized;
    _airElementButton.position = ccp(0.4f, 0.30f);
    [_airElementButton setTarget:self selector:@selector(initWizardWithTypeAir)];
    [self addChild:_airElementButton];
    
    // Create water button
    _waterElementButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"element_water.png"]];
    _waterElementButton.positionType = CCPositionTypeNormalized;
    _waterElementButton.position = ccp(0.6f, 0.30f);
    [_waterElementButton setTarget:self selector:@selector(initWizardWithTypeWater)];
    [self addChild:_waterElementButton];
    
    // Create earth button
    _earthElementButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"element_earth.png"]];
    _earthElementButton.positionType = CCPositionTypeNormalized;
    _earthElementButton.position = ccp(0.8f, 0.30f);
    [_earthElementButton setTarget:self selector:@selector(initWizardWithTypeEarth)];
    [self addChild:_earthElementButton];
    
    // Create CCLabelBMFont label
    _label = [CCLabelBMFont labelWithString:@"Choose your element" fntFile:@"font.fnt"];
    _label.position = CGPointMake(_screenSize.width / 2, _screenSize.height * 2 / 3);
    [self addChild:_label];
    
    [self initializeCards];
}

-(void) initializePassTurnButton {
    // Add pass turn button to the scene
    _passTurnButton = [CCButton buttonWithTitle:@"Pass Turn" fontName:@"Verdana-Bold" fontSize:20.0f];
    _passTurnButton.position = CGPointMake(_screenSize.width - 70, _screenSize.height/2);
    [_passTurnButton setTarget:self selector:@selector(passTurn:)];
    
    [self addChild:_passTurnButton];
}

- (void) passTurn:(id)sender {
    if (_selectedCard != NULL){
        // Retrieve active match information
        GKTurnBasedMatch *currentMatch =
        [[GameCenterHelper sharedGameCenterInstance] activeMatch];
        
        // Player index
        NSUInteger currentPlayerIndex = [currentMatch.participants
                                         indexOfObject:currentMatch.currentParticipant];
        
        // If it's player 1 who pass the turn
        if((currentPlayerIndex + 1) % [currentMatch.participants count ] == 1) {
            _matchStatus.player1 = _currentPlayer;
            _matchStatus.player1.cardPlayed = _selectedCard;
                        
            [_matchStatus.player1.cards removeObjectAtIndex:[_matchStatus.player1.cards indexOfObject:_selectedCard]];
            
            CCLOG(@"Player 1 selected card - card type %u, card attack %d, card defense %d, card image %@", _matchStatus.player1.cardPlayed.elementType, _matchStatus.player1.cardPlayed.attack, _matchStatus.player1.cardPlayed.defense, _matchStatus.player1.cardPlayed.imageName);
        } else {
            _matchStatus.player2 = _currentPlayer;
            _matchStatus.player2.cardPlayed = _selectedCard;
            
            [_matchStatus.player2.cards removeObjectAtIndex:[_matchStatus.player2.cards indexOfObject:_selectedCard]];
            
            CCLOG(@"Player 2 selected card - card type %u, card attack %d, card defense %d, card image %@", _matchStatus.player2.cardPlayed.elementType, _matchStatus.player2.cardPlayed.attack, _matchStatus.player2.cardPlayed.defense, _matchStatus.player2.cardPlayed.imageName);
        }
        
        if (_matchStatus.player2.cardPlayed && _matchStatus.player1.cardPlayed && !((currentPlayerIndex + 1) % [currentMatch.participants count ] == 1)) {
            [self fightSelectedCard:_matchStatus.player2.cardPlayed againstOpponentCard:_matchStatus.player1.cardPlayed];
        }
        
        // End match
        if (_matchStatus.player1.cards.count <= 0 && _matchStatus.player2.cards.count <= 0){
            [self matchOver:currentMatch];
            
            // Encode turn data
            NSData *turnData = [NSKeyedArchiver archivedDataWithRootObject:_matchStatus];
            
            
            [currentMatch endMatchInTurnWithMatchData:turnData
                                    completionHandler:^(NSError *error) {
                                        if (error) {
                                            CCLOG(@"%@", error);
                                        }
                                    }];
            
        } else {
            // Encode turn data
            NSData *turnData = [NSKeyedArchiver archivedDataWithRootObject:_matchStatus];
        
            // Retrieving next player from participants
            GKTurnBasedParticipant *nextPlayer;
            nextPlayer = [currentMatch.participants objectAtIndex:
                      ((currentPlayerIndex + 1) % [currentMatch.participants count])];
            // End turn
            [currentMatch endTurnWithNextParticipant:nextPlayer
                                       matchData:turnData completionHandler:^(NSError *error) {
                                           if (error) {
                                               CCLOG(@"Some error happened passing the turn %@", error);
                                           }
                                       }];
            CCLOG(@"Passing the turn %@ to next player %@", turnData, nextPlayer);
            _passTurnButton.visible = FALSE;
        }
    }
}

-(void) updateViewWithMatch:(GKTurnBasedMatch *)match {
    
    [self initializePassTurnButton];
    
    // Player index
    NSUInteger currentPlayerIndex = [match.participants
                                     indexOfObject:match.currentParticipant];
    
    // Auxiliar Card to paint player cards
    Card *cardAux;
    
    // If it's player 1 turn
    if((currentPlayerIndex + 1) % [match.participants count ] == 1) {
        
        // Set player1 the current player
        _currentPlayer = _matchStatus.player1;
        _opponentCard = [[Card alloc] initWithCard:_matchStatus.player2.cardPlayed];
 
    } else {
        // Set player1 the current player
        _currentPlayer = _matchStatus.player2;
        _opponentCard = [[Card alloc] initWithCard:_matchStatus.player1.cardPlayed];
        
        _opponentCard.position = CGPointMake(_screenSize.width / 2, 5 * _opponentCard.contentSize.height / 2);
        
        // We only show the opponent card for player 2
        [self addChild:_opponentCard];
    }
    
    // Initialize the auxiliar card
    cardAux = _opponentCard;
    
    // Calculate gaps between cards to place them equidistantly
    float gapWidth = ((_screenSize.width - NUM_CARDS * cardAux.contentSize.width) / (NUM_CARDS + 1));
    
    // Initial x position for the cards
    float positionX = gapWidth + (cardAux.contentSize.width / 2);
    
    float positionY = cardAux.contentSize.height / 2;

    for(int i = 0; i < _currentPlayer.cards.count; i++) {
        cardAux = [[Card alloc] initWithCard:[_currentPlayer.cards objectAtIndex:i]];
        
        if (cardAux) {
            // Set the card position
            cardAux.position = CGPointMake(positionX, positionY);
            cardAux.imageName = [NSString stringWithFormat:@"card_%@_%d%d%@", [NSString stringWithFormat:@"%@", cardAux.element], cardAux.attack, cardAux.defense, @".png"];
            
            // Add the card to the scene
            [self addChild:cardAux];            
            
            [_currentPlayer.cards replaceObjectAtIndex:i withObject:cardAux];
        }
        // Update next x position
        positionX += gapWidth + cardAux.contentSize.width;
    }
    
    // Show life points labels
    [self showLifePointsLabels:(int)currentPlayerIndex];
}

-(void) fightSelectedCard:(Card *)selectedCard againstOpponentCard:(Card *)opponentCard {
     if ((selectedCard.defense > opponentCard.
         attack) || (selectedCard.defense == opponentCard.attack && [self oppositeElementType:_currentPlayer.elementType toType:opponentCard.elementType])) {
        // We win this turn
        _matchStatus.player1.lifePoints -= selectedCard.attack;
        [_opponentPlayerLabel setString:[NSString stringWithFormat:@"%d", _matchStatus.player1.lifePoints]];
     } else {
        // We win this turn
        _matchStatus.player2.lifePoints -= opponentCard.attack;
        [_currentPlayerLabel setString:[NSString stringWithFormat:@"%d", _matchStatus.player2.lifePoints]];
    }
}

-(BOOL) oppositeElementType:(ElementTypes *)attackerType toType:(ElementTypes *)defensorType {
    
    if(((int)attackerType == fire && (int)defensorType == air) || ((int)attackerType == water && (int)defensorType == fire) || ((int)attackerType == earth && (int)defensorType == water) || ((int)attackerType == air && (int)defensorType == earth)) {
        return true;
    } else {
        return false;
    }
}

-(void)showLifePointsLabels:(int)currentPlayerIndex {
    if (_matchStatus.player1 && _matchStatus.player2) {
        
        // If current player it's player 1
        if((currentPlayerIndex + 1) % NUM_PARTICIPANTS == 1) {
            // Set player 1 life points label
            _currentPlayerLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", _matchStatus.player1.lifePoints] fntFile:@"font.fnt"];
            
            // Set player 2 life points label
            _opponentPlayerLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", _matchStatus.player2.lifePoints] fntFile:@"font.fnt"];
        } else {
            // Set player 1 life points label
            _currentPlayerLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", _matchStatus.player2.lifePoints] fntFile:@"font.fnt"];
            
            // Set player 2 life points label
            _opponentPlayerLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", _matchStatus.player1.lifePoints] fntFile:@"font.fnt"];
        }
        
    } else { // It's a newly created match
        // Set player 1 life points label
        _currentPlayerLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", INIT_LIFE_POINTS] fntFile:@"font.fnt"];
        
        // Set player 2 life points label
        _opponentPlayerLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", INIT_LIFE_POINTS] fntFile:@"font.fnt"];
    }
    
    _currentPlayerLabel.position = CGPointMake(30, (_screenSize.height / 2) - 30);
    [self addChild:_currentPlayerLabel];
    
    _opponentPlayerLabel.position = CGPointMake(30, (_screenSize.height / 2) + 30);
    [self addChild:_opponentPlayerLabel];
}

-(void)matchOver:(GKTurnBasedMatch *)match {
    
    GKTurnBasedParticipant *player1;
    GKTurnBasedParticipant *player2;
    
    // Player index
    NSUInteger currentPlayerIndex = [match.participants
                                     indexOfObject:match.currentParticipant];
    
    // Current player is player 1
    if((_matchStatus.player1.lifePoints >= _matchStatus.player2.lifePoints) && ((currentPlayerIndex + 1) % [match.participants count ] == 1)) {
        // You win
        CCLOG(@"YOU WIN");
        // Create CCLabelBMFont label
        _label = [CCLabelBMFont labelWithString:@"YOU WIN" fntFile:@"font.fnt"];
        
        player1 = [match.participants objectAtIndex:0];
        player1.matchOutcome = GKTurnBasedMatchOutcomeWon;
        
        player2 = [match.participants objectAtIndex:1];
        player2.matchOutcome = GKTurnBasedMatchOutcomeLost;
        
        // Show life points labels
        [self showLifePointsLabels:0];
        
    } else if ((_matchStatus.player2.lifePoints > _matchStatus.player1.lifePoints) && ((currentPlayerIndex + 1) % [match.participants count ] == 0)) {
        // You win
        CCLOG(@"YOU WIN");
        // Create CCLabelBMFont label
        _label = [CCLabelBMFont labelWithString:@"YOU WIN" fntFile:@"font.fnt"];
        
        player2 = [match.participants objectAtIndex:1];
        player2.matchOutcome = GKTurnBasedMatchOutcomeWon;
        
        player1 = [match.participants objectAtIndex:0];
        player1.matchOutcome = GKTurnBasedMatchOutcomeLost;
        
        // Show life points labels
        [self showLifePointsLabels:1];
        
    } else if ((_matchStatus.player1.lifePoints < _matchStatus.player2.lifePoints) && ((currentPlayerIndex + 1) % [match.participants count ] == 1)){
        // Player 1 lose
        // You lose
        CCLOG(@"YOU LOSE");
        
        _label = [CCLabelBMFont labelWithString:@"YOU LOSE" fntFile:@"font.fnt"];
        
        player1 = [match.participants objectAtIndex:0];
        player1.matchOutcome = GKTurnBasedMatchOutcomeLost;
        
        player2 = [match.participants objectAtIndex:1];
        player2.matchOutcome = GKTurnBasedMatchOutcomeWon;
        
        // Show life points labels
        [self showLifePointsLabels:0];
        
    } else { // Player 2 lose
        // You lose
        CCLOG(@"YOU LOSE");
        _label = [CCLabelBMFont labelWithString:@"YOU LOSE" fntFile:@"font.fnt"];
        
        GKTurnBasedParticipant *player2 = [match.participants objectAtIndex:1];
        player2.matchOutcome = GKTurnBasedMatchOutcomeLost;
        
        GKTurnBasedParticipant *player1 = [match.participants objectAtIndex:0];
        player1.matchOutcome = GKTurnBasedMatchOutcomeWon;
        
        // Show life points labels
        [self showLifePointsLabels:1];
        
    }
    
    _label.position = CGPointMake(_screenSize.width / 2, _screenSize.height / 2);
    [self addChild:_label];
    
    [self removeChild:_selectedCard];
    [self removeChild:_opponentCard];
    [self removeChild:_passTurnButton];
}

-(void) updateViewAsViewer:(GKTurnBasedMatch *)match {
    
    if (!(match.status == GKTurnBasedMatchStatusEnded)) {
        
        // Auxiliar Card to paint player cards
        Card *cardAux;
        // Player index
        NSUInteger currentPlayerIndex = [match.participants
                                         indexOfObject:match.currentParticipant];
        
        // If it's player 2 the viewer
        if((currentPlayerIndex + 1) % [match.participants count ] == 1) {
            
            _currentPlayer = _matchStatus.player2;
            cardAux = [[Card alloc] initWithCard:_currentPlayer.cardPlayed];
            
            // Show life points labels
            [self showLifePointsLabels:1];
        } else {
            
            _currentPlayer = _matchStatus.player1;
            _selectedCard = [[Card alloc] initWithCard:_matchStatus.player1.cardPlayed];
            cardAux = _selectedCard;
            _selectedCard.position = CGPointMake(_screenSize.width / 2, (3 * _selectedCard.contentSize.height) / 2);
            
            [self addChild:_selectedCard];
            
            // Show life points labels
            [self showLifePointsLabels:0];
        }
        
        // Calculate gaps between cards to place them equidistantly
        float gapWidth = ((_screenSize.width - NUM_CARDS * cardAux.contentSize.width) / (NUM_CARDS + 1));
        // Initial x position for the cards
        float positionX = gapWidth + (cardAux.contentSize.width / 2);
        // y position
        float positionY = cardAux.contentSize.height / 2;
        
        for(int i = 0; i < _currentPlayer.cards.count; i++) {
            cardAux = [[Card alloc] initWithCard:[_currentPlayer.cards objectAtIndex:i]];
            
            if (cardAux) {
                // Set the card position
                cardAux.position = CGPointMake(positionX, positionY);
                cardAux.imageName = [NSString stringWithFormat:@"card_%@_%d%d%@", [NSString stringWithFormat:@"%@", cardAux.element], cardAux.attack, cardAux.defense, @".png"];
                
                // Add the card to the scene
                [self addChild:cardAux];
                [_currentPlayer.cards replaceObjectAtIndex:i withObject:cardAux];
            }
            // Update next x position
            positionX += gapWidth + cardAux.contentSize.width;
        }
    } 
}

@end