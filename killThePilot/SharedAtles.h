//
//  SharedAtles.h
//  killThePilot
//
//  Created by wolfire on 3/27/14.
//  Copyright (c) 2014 wolfire. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PlaneNode.h"

typedef NS_ENUM(int, TextureType) {
    TextureTypeBackground = 1,
    TextureTypeBullet = 2,
    TextureTypePlayerPlane = 3,
    TextureTypeSmallPlane = 4,
    TextureTypeMediumPlane = 5,
    TextureTypeBigPlane = 6,
};

@interface SharedAtles : SKTextureAtlas

// 
+ (SKTexture *)textureWithType:(TextureType)type;
+ (SKAction *)playerPlaneAction;
+ (SKAction *)playerPlaneBlowupAction;
+ (SKAction *)hitActionWithPlaneType:(PlaneType)type;
+ (SKAction *)blowupActionWithPlaneType:(PlaneType)type;

@end
