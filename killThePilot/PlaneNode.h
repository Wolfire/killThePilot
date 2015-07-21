//
//  PlaneNode.h
//  killThePilot
//
//  Created by wolfire on 3/27/14.
//  Copyright (c) 2014 wolfire. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(int, PlaneType) {
    PlaneTypeBig = 1,
    PlaneTypeMedium = 2,
    PlaneTypeSmall = 3,
    PlaneTypePlayer = 4
};

typedef NS_ENUM(int, PlayerLevel) {
    PlayerLevelTrainee = 1,
    PlayerLevelFresh = 2,
    PlayerLevelKiller = 3,
    PlayerLevelSpree = 4,
    PlayerLevelMaster = 5,
    PlayerLevelFlyKiller = 6,
    PlayerLevelPsycho = 7,
    PlayerLevelMonster = 8,
    PlayerLevelDevil = 9,
    PlayerLevelGodLike = 10,
    PlayerLevelBeyond = 11
};

@interface PlaneNode : SKSpriteNode

@property (nonatomic, assign) int hp;
@property (nonatomic, assign) PlaneType type;
@property (nonatomic, assign) PlayerLevel level;

// add a new big plane
+ (instancetype)addBigEnemyPlane;
// add a medium big plane
+ (instancetype)addMediumEnemyPlane;
// add a small big plane
+ (instancetype)addSmallEnemyPlane;

@end
