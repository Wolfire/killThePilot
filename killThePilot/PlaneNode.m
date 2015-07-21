//
//  PlaneNode.m
//  killThePilot
//
//  Created by wolfire on 3/27/14.
//  Copyright (c) 2014 wolfire. All rights reserved.
//

#import "PlaneNode.h"
#import "SharedAtles.h"

@implementation PlaneNode

+ (instancetype)addBigEnemyPlane {
    PlaneNode *plane = (PlaneNode *)[PlaneNode spriteNodeWithTexture:[SharedAtles textureWithType:TextureTypeBigPlane]];
    plane.hp = 7;       // can take 7 shoots in all
    plane.type = PlaneTypeBig;
    plane.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:plane.size];
    return plane;
}

+ (instancetype)addMediumEnemyPlane {
    PlaneNode *plane = (PlaneNode *)[PlaneNode spriteNodeWithTexture:[SharedAtles textureWithType:TextureTypeMediumPlane]];
    plane.hp = 4;       // can take 4 shoots in all
    plane.type = PlaneTypeBig;
    plane.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:plane.size];
    return plane;
}

+ (instancetype)addSmallEnemyPlane {
    PlaneNode *plane = (PlaneNode *)[PlaneNode spriteNodeWithTexture:[SharedAtles textureWithType:TextureTypeSmallPlane]];
    plane.hp = 1;       // can take only 1 shoot
    plane.type = PlaneTypeBig;
    plane.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:plane.size];
    return plane;
}

@end
