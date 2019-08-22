#import "GameCenterHelper.h"

@implementation GameCenterHelper

static GameCenterHelper *singletonHelper = nil;

+ (GameCenterHelper *) sharedGameCenterInstance {
    if (!singletonHelper) {
        // Create singleton of GameCenterHelper
        singletonHelper = [[GameCenterHelper alloc] init];
    }
    return singletonHelper;
}

- (id)init {
    if ((self = [super init])) {
        [self checkGameCenterAvailable];
        
        // If authenticated user changes
        if (_isGameCenterAvailable) {
            NSNotificationCenter *nc =
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}

- (BOOL) checkGameCenterAvailable {
    // Check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    _isGameCenterAvailable = (gcClass && osVersionSupported);
    
    CCLOG(@"Game Center is available: %@ ", _isGameCenterAvailable ? @"Yes" : @"No");
    
    return _isGameCenterAvailable;
}

- (void) authenticateLocalPlayer {
    
    if (!_isGameCenterAvailable) return;
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if (localPlayer.isAuthenticated)
        {
            CCLOG(@"The player %@ has successfully authenticated", localPlayer.alias);
        }
    }];
}

- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated &&
        !_isPlayerAuthenticated) {
        CCLOG(@"Now player is authenticathed");
        _isPlayerAuthenticated = TRUE;
    } else if (![GKLocalPlayer localPlayer].isAuthenticated &&
               _isPlayerAuthenticated) {
        CCLOG(@"Player has logged off");
        _isPlayerAuthenticated = FALSE;
    }
}

- (void)createMatchWithMinPlayers:(int)minPlayers
                       maxPlayers:(int)maxPlayers
                   viewController:(UIViewController *)viewController {
    if (!_isGameCenterAvailable) return;
    
    // Set the view to show the Game Center screen
    gameCenterViewController = viewController;
    
    // Create the match request
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = minPlayers;
    request.maxPlayers = maxPlayers;
    
    // Show the Game Center screen
    GKTurnBasedMatchmakerViewController *turnBasedViewController =
    [[GKTurnBasedMatchmakerViewController alloc]
     initWithMatchRequest:request];
    turnBasedViewController.turnBasedMatchmakerDelegate = self;
    turnBasedViewController.showExistingMatches = YES;
    
    [gameCenterViewController presentModalViewController:turnBasedViewController
                                                animated:YES];
}

-(void)turnBasedMatchmakerViewController:
(GKTurnBasedMatchmakerViewController *)viewController
                            didFindMatch:(GKTurnBasedMatch *)match {
    [gameCenterViewController
     dismissModalViewControllerAnimated:YES];
    CCLOG(@"Match %@ found", match);
    
    _activeMatch = match;
    
    // Get first participant last turn date
    GKTurnBasedParticipant *firstParticipant =
    [match.participants objectAtIndex:0];
    
    if (firstParticipant.lastTurnDate) {
        [_delegate receiveTurn:match];
    } else {
        [_delegate initializeNewGame:match];
    }
}


-(void)turnBasedMatchmakerViewController:
(GKTurnBasedMatchmakerViewController *)viewController
                      playerQuitForMatch:(GKTurnBasedMatch *)match {
    CCLOG(@"Player %@ has quit from the match %@",
          match.currentParticipant, match);
}

-(void)turnBasedMatchmakerViewController:
(GKTurnBasedMatchmakerViewController *)viewController
                        didFailWithError:(NSError *)error {
    [gameCenterViewController
     dismissModalViewControllerAnimated:YES];
    CCLOG(@"Error trying to find a match: %@", error.localizedDescription);
}

-(void)turnBasedMatchmakerViewControllerWasCancelled:
(GKTurnBasedMatchmakerViewController *)viewController {
    [gameCenterViewController
     dismissModalViewControllerAnimated:YES];
    CCLOG(@"Match has been cancelled");
}


@end
