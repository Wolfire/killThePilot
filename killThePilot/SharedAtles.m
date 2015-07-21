//
//  SharedAtles.m
//  killThePilot
//
//  Created by wolfire on 3/27/14.
//  Copyright (c) 2014 wolfire. All rights reserved.
//

#import "SharedAtles.h"

static SharedAtles *atles = nil;

@implementation SharedAtles

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        atles = (SharedAtles *)[SharedAtles atlasNamed:@"gameArts-hd"];
    });
    return atles;
}

+ (SKTexture *)textureWithType:(TextureType)type {
    switch (type) {
        case TextureTypeBackground:
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                return [[[self class] shared] textureNamed:@"padbg.png"];
            }
            return [[[self class] shared] textureNamed:@"phonebg.png"];
            break;
        case TextureTypeBullet:
            return [[[self class] shared] textureNamed:@"bullet1.png"];
            break;
        case TextureTypePlayerPlane:
            return [[[self class] shared] textureNamed:@"hero_fly_1.png"];
            break;
        case TextureTypeSmallPlane:
            return [[[self class] shared] textureNamed:@"enemy1_fly_1.png"];
            break;
        case TextureTypeMediumPlane:
            return [[[self class] shared] textureNamed:@"enemy3_fly_1.png"];
            break;
        case TextureTypeBigPlane:
            return [[[self class] shared] textureNamed:@"enemy2_fly_1.png"];
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark -
+ (SKTexture *)playerPlaneTextureWithIndex:(int)index{
    return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"hero_fly_%d.png", index]];
}

+ (SKTexture *)playerPlaneBlowupTextureWithIndex:(int)index{
    return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"hero_blowup_%d.png", index]];
}

#pragma mark -
+ (SKTexture *)hitTextureWithPlaneType:(int)type animatonIndex:(int)animatonIndex{
    return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"enemy%d_hit_%d.png", type, animatonIndex]];
}

+ (SKTexture *)blowupTextureWithPlaneType:(int)type animatonIndex:(int)animatonIndex{
    return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"enemy%d_blowup_%i.png", type, animatonIndex]];
}

+ (SKAction *)playerPlaneAction {
    NSMutableArray *textures = [[NSMutableArray alloc]init];
    for (int i= 1; i <= 2; i++) {
        SKTexture *texture = [[self class] playerPlaneTextureWithIndex:i];
        [textures addObject:texture];
    }
    return [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
}
+ (SKAction *)playerPlaneBlowupAction {
    NSMutableArray *textures = [[NSMutableArray alloc]init];
    for (int i = 1; i <= 4; i++) {
        SKTexture *texture = [[self class] playerPlaneBlowupTextureWithIndex:i];
        [textures addObject:texture];
    }
    SKAction *dieAction = [SKAction animateWithTextures:textures timePerFrame:0.1];
    
    return [SKAction sequence:@[dieAction,[SKAction removeFromParent]]];
}

+ (SKAction *)hitActionWithPlaneType:(PlaneType)type {
    switch (type) {
        case PlaneTypeBig:
        {
            NSMutableArray *textures = [[NSMutableArray alloc]init];
            
            SKTexture *texture1 = [[self class] hitTextureWithPlaneType:PlaneTypeMedium animatonIndex:1];
            SKAction *action1 = [SKAction setTexture:texture1];
            
            SKTexture *texture2 = [[self class] textureWithType:TextureTypeBigPlane];
            SKAction *action2 = [SKAction setTexture:texture2];
            
            [textures addObject:action1];
            [textures addObject:action2];
            
            return [SKAction sequence:textures];
        }
            break;
        case PlaneTypeMedium:
        {
            NSMutableArray *textures = [[NSMutableArray alloc]init];
            for (int i = 1; i <= 2; i++) {
                SKTexture *texture = [[self class] hitTextureWithPlaneType:PlaneTypeSmall animatonIndex:i];
                SKAction *action = [SKAction setTexture:texture];
                [textures addObject:action];
            }
            
            return [SKAction sequence:textures];
        }
            break;
        case PlaneTypeSmall:
        {
            
        }
            break;
        case PlaneTypePlayer:
        {
            
        }
            break;
        default:
            break;
    }
    return nil;
}

+ (SKAction *)blowupActionWithPlaneType:(PlaneType)type {
    switch (type) {
        case PlaneTypeBig:
        {
            NSMutableArray *textures = [[NSMutableArray alloc]init];
            for (int i = 1; i <= 7; i++) {
                SKTexture *texture = [[self class] blowupTextureWithPlaneType:PlaneTypeMedium animatonIndex:i];
                [textures addObject:texture];
            }
            SKAction *dieAction = [SKAction animateWithTextures:textures timePerFrame:0.1];
            
            return [SKAction sequence:@[dieAction, [SKAction removeFromParent]]];
        }
            break;
        case PlaneTypeMedium:
        {
            NSMutableArray *textures = [[NSMutableArray alloc]init];
            for (int i = 1; i <= 4; i++) {
                SKTexture *texture = [[self class] blowupTextureWithPlaneType:PlaneTypeSmall animatonIndex:i];
                [textures addObject:texture];
            }
            SKAction *dieAction = [SKAction animateWithTextures:textures timePerFrame:0.1];
            
            return [SKAction sequence:@[dieAction, [SKAction removeFromParent]]];
        }
            break;
        case PlaneTypeSmall:
        {
            NSMutableArray *textures = [[NSMutableArray alloc]init];
            for (int i = 1; i <= 4; i++) {
                SKTexture *texture = [[self class] blowupTextureWithPlaneType:PlaneTypeBig animatonIndex:i];
                [textures addObject:texture];
            }
            SKAction *dieAction = [SKAction animateWithTextures:textures timePerFrame:0.1];
            
            return [SKAction sequence:@[dieAction, [SKAction removeFromParent]]];
        }
            break;
        case PlaneTypePlayer:
        {
            
        }
            break;
        default:
            break;
    }
    return nil;
}

@end
