#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"

@protocol GameCenterHelperDelegate
- (void) initializeNewGame:(GKTurnBasedMatch *)match;
- (void) receiveTurn:(GKTurnBasedMatch *)match;
@end

@interface GameCenterHelper : NSObject <GKTurnBasedMatchmakerViewControllerDelegate> {
    // Declare view controller to load Game Center
    UIViewController *gameCenterViewController;
}

// Property to store Game Center availability
@property (assign, readonly) BOOL isGameCenterAvailable;

// Property to know whether the player is authenticated or not
@property (assign, readonly) BOOL isPlayerAuthenticated;

// Property to keep the information of the match
@property (retain) GKTurnBasedMatch *activeMatch;

// Delegate property
@property (nonatomic, retain) id <GameCenterHelperDelegate> delegate;

// Method that retrieves the singleton instance
+ (GameCenterHelper *)sharedGameCenterInstance;

// Check Game Center availability
- (BOOL) checkGameCenterAvailable;

// Authenticate local player
- (void) authenticateLocalPlayer;

// Create a turn-based match
- (void)createMatchWithMinPlayers:(int)minPlayers
                       maxPlayers:(int)maxPlayers
                   viewController:(UIViewController *)viewController;

@end
