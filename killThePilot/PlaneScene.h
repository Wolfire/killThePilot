//
//  PlaneScene.h
//  killThePilot
//
//  Created by wolfire on 3/27/14.
//  Copyright (c) 2014 wolfire. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PlaneNode.h"

@interface PlaneScene : SKScene <SKPhysicsContactDelegate> {
    int smallPlaneTime;
    int mediumPlaneTime;
    int bigPlaneTime;
    
    int backgroundPosition;
    
    SKLabelNode *scoreLabel;
    SKLabelNode *levelLabel;
    SKSpriteNode *playerPlane;
    SKSpriteNode *background1;
    SKSpriteNode *background2;
    
    SKAction *hitSmallPlaneAction;
    SKAction *hitMediumPlaneAction;
    SKAction *hitBigPlaneAction;
    SKAction *blowupSmallPlaneAction;
    SKAction *blowupMediumPlaneAction;
    SKAction *blowupBigPlaneAction;
    
    PlayerLevel level;
}

@end
