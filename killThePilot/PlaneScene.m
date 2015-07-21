//
//  PlaneScene.m
//  killThePilot
//
//  Created by wolfire on 3/27/14.
//  Copyright (c) 2014 wolfire. All rights reserved.
//

#import "PlaneScene.h"
#import "SharedAtles.h"

typedef NS_ENUM(uint32_t, RoleCategory){
    RoleCategoryBullet = 1,
    RoleCategoryEnemyPlane = 4,
    RoleCategoryPlayerPlane = 8
};

static BOOL isDevicePad = NO;

@implementation PlaneScene

- (instancetype)initWithSize:(CGSize)size{
    self = [super initWithSize:size];
    if (self) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            isDevicePad = YES;
        }

        [self initPhysicsWorld];
        [self initAction];
        [self initBackground];
        [self initScroe];
        [self initPlayerPlane];
        [self startFiring];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(restart) name:@"restartNotification" object:nil];
    }
    return self;
}

- (void)initPhysicsWorld {
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0, 0);
}

- (void)initAction {
    hitSmallPlaneAction = [SharedAtles hitActionWithPlaneType:PlaneTypeSmall];
    hitMediumPlaneAction = [SharedAtles hitActionWithPlaneType:PlaneTypeMedium];
    hitBigPlaneAction = [SharedAtles hitActionWithPlaneType:PlaneTypeBig];
    
    blowupSmallPlaneAction = [SharedAtles blowupActionWithPlaneType:PlaneTypeSmall];
    blowupMediumPlaneAction = [SharedAtles blowupActionWithPlaneType:PlaneTypeMedium];
    blowupBigPlaneAction = [SharedAtles blowupActionWithPlaneType:PlaneTypeBig];
}

- (void)initBackground {
    backgroundPosition = self.size.height;

    // background1 = [SKSpriteNode spriteNodeWithTexture:[SharedAtles textureWithType:TextureTypeBackground]];
    background1 = [SKSpriteNode spriteNodeWithImageNamed:@"phonebg"];
    if (isDevicePad) {
        background1 = [SKSpriteNode spriteNodeWithImageNamed:@"padbg"];
    }
    background1.position = CGPointMake(self.size.width / 2, 0);
    background1.anchorPoint = CGPointMake(0.5, 0);
    background1.zPosition = 0;
    
    // background2 = [SKSpriteNode spriteNodeWithTexture:[SharedAtles textureWithType:TextureTypeBackground]];
    background2 = [SKSpriteNode spriteNodeWithImageNamed:@"phonebg"];
    if (isDevicePad) {
        background2 = [SKSpriteNode spriteNodeWithImageNamed:@"padbg"];
    }
    background2.anchorPoint = CGPointMake(0.5, 0);
    background2.position = CGPointMake(self.size.width / 2, backgroundPosition - 1);
    background2.zPosition = 0;
    
    [self addChild:background1];
    [self addChild:background2];
    
    [self runAction:[SKAction repeatActionForever:[SKAction playSoundFileNamed:@"game_music.mp3" waitForCompletion:YES]]];
}

- (void)initScroe {
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Thin"];
    scoreLabel.text = @"0000";
    scoreLabel.zPosition = 2;
    scoreLabel.fontColor = [SKColor blackColor];
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    scoreLabel.position = CGPointMake(50 , self.size.height - 52);
    [self addChild:scoreLabel];
    
    levelLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Thin"];
    levelLabel.text = @"实习生";
    levelLabel.zPosition = 2;
    levelLabel.fontColor = [SKColor blackColor];
    levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    levelLabel.position = CGPointMake(500 , self.size.height - 52);
    [self addChild:levelLabel];
}

- (void)initPlayerPlane {
    playerPlane = [SKSpriteNode spriteNodeWithTexture:[SharedAtles textureWithType:TextureTypePlayerPlane]];
    playerPlane.position = CGPointMake(160, 50);
    if (isDevicePad) {
        playerPlane.position = CGPointMake(384, 50);
    }
    playerPlane.zPosition = 1;
    playerPlane.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:playerPlane.size];
    playerPlane.physicsBody.categoryBitMask = RoleCategoryPlayerPlane;
    playerPlane.physicsBody.collisionBitMask = RoleCategoryEnemyPlane;
    playerPlane.physicsBody.contactTestBitMask = RoleCategoryEnemyPlane;
    [self addChild:playerPlane];
    [playerPlane runAction:[SharedAtles playerPlaneAction]];
}

- (void)createEnemyPlane {
    smallPlaneTime++;
    mediumPlaneTime++;
    bigPlaneTime++;
    
    PlaneNode *(^create)(PlaneType) = ^(PlaneType type){
        int x = (arc4random() % 220) + 35;
        if (isDevicePad) {
            x = (arc4random() % 700) + 35;
        }

        PlaneNode *enemy = nil;
        
        switch (type) {
            case PlaneTypeBig:
                enemy = [PlaneNode addBigEnemyPlane];
                break;
            case PlaneTypeMedium:
                enemy = [PlaneNode addMediumEnemyPlane];
                break;
            case PlaneTypeSmall:
                enemy = [PlaneNode addSmallEnemyPlane];
                break;
            default:
                break;
        }
        enemy.zPosition = 1;
        enemy.physicsBody.categoryBitMask = RoleCategoryEnemyPlane;
        enemy.physicsBody.collisionBitMask = RoleCategoryBullet;
        enemy.physicsBody.contactTestBitMask = RoleCategoryBullet;
        enemy.position = CGPointMake(x, self.size.height);
        
        return enemy;
    };
    
    if (smallPlaneTime > 25) {
        float speed = (arc4random() % 3) + 2;
        PlaneNode *small = create(PlaneTypeSmall);
        [self addChild:small];
        [small runAction:[SKAction sequence:@[[SKAction moveToY:0 duration:speed],[SKAction removeFromParent]]]];
        
        smallPlaneTime = 0;
    }
    
    if (mediumPlaneTime > 400) {
        float speed = (arc4random() % 3) + 4;
        PlaneNode *medium = create(PlaneTypeMedium);
        [self addChild:medium];
        [medium runAction:[SKAction sequence:@[[SKAction moveToY:0 duration:speed],[SKAction removeFromParent]]]];
        
        mediumPlaneTime = 0;
    }
    
    if (bigPlaneTime > 700) {
        float speed = (arc4random() % 3) + 6;
        
        PlaneNode *big = create(PlaneTypeBig);
        [self addChild:big];
        [big runAction:[SKAction sequence:@[[SKAction moveToY:0 duration:speed],[SKAction removeFromParent]]]];
        [self runAction:[SKAction playSoundFileNamed:@"enemy2_out.mp3" waitForCompletion:NO]];
        
        bigPlaneTime = 0;
    }
}

- (void)createBullets {
    SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithTexture:[SharedAtles textureWithType:TextureTypeBullet]];
    bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bullet.size];
    bullet.physicsBody.categoryBitMask = RoleCategoryBullet;
    bullet.physicsBody.collisionBitMask = RoleCategoryEnemyPlane;
    bullet.physicsBody.contactTestBitMask = RoleCategoryEnemyPlane;
    bullet.zPosition = 1;
    bullet.position = CGPointMake(playerPlane.position.x, playerPlane.position.y + (playerPlane.size.height / 2));
    [self addChild:bullet];
    
    SKAction *actionMove = [SKAction moveTo:CGPointMake(playerPlane.position.x,self.size.height) duration:0.5];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    
    [bullet runAction:[SKAction sequence:@[actionMove,actionMoveDone]]];
    
    [self runAction:[SKAction playSoundFileNamed:@"bullet.mp3" waitForCompletion:NO]];
}

- (void)startFiring {
    SKAction *action = [SKAction runBlock:^{
        [self createBullets];
    }];
    SKAction *interval = [SKAction waitForDuration:0.2];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[action,interval]]]];
}

- (void)restart {
    [self removeAllChildren];
    [self removeAllActions];
    [self initBackground];
    [self initScroe];
    [self initPlayerPlane];
    [self startFiring];
}

- (void)scrollBackground {
    backgroundPosition--;
    float height = 568.0;
    if (isDevicePad) {
        height = 1024.0;
    }
    
    if (backgroundPosition <= 0) {
        backgroundPosition = height;
    }
    
    [background1 setPosition:CGPointMake(self.size.width / 2, backgroundPosition - height)];
    [background2 setPosition:CGPointMake(self.size.width / 2, backgroundPosition - 1)];
}

- (void)changeScore:(PlaneType)type {
    int gained = 0;             // score got this time
    switch (type) {
        case PlaneTypeBig:
            gained = 30000;
            break;
        case PlaneTypeMedium:
            gained = 6000;
            break;
        case PlaneTypeSmall:
            gained = 1000;
            break;
        default:
            break;
    }
    long score = scoreLabel.text.intValue + gained;
    [scoreLabel runAction:[SKAction runBlock:^{
        scoreLabel.text = [NSString stringWithFormat:@"%ld", score];
        if (score > 153600000) {
            level = PlayerLevelBeyond;
            levelLabel.text = [NSString stringWithFormat:@"超越神"];
        } else if (score > 76800000) {
            level = PlayerLevelGodLike;
            levelLabel.text = [NSString stringWithFormat:@"神一般"];
        } else if (score > 38400000) {
            level = PlayerLevelDevil;
            levelLabel.text = [NSString stringWithFormat:@"无人能挡"];
        } else if (score > 19200000) {
            level = PlayerLevelMonster;
            levelLabel.text = [NSString stringWithFormat:@"妖怪般杀戮"];
        } else if (score > 9600000) {
            level = PlayerLevelPsycho;
            levelLabel.text = [NSString stringWithFormat:@"变态杀戮"];
        } else if (score > 4800000) {
            level = PlayerLevelFlyKiller;
            levelLabel.text = [NSString stringWithFormat:@"杀人如麻"];
        } else if (score > 2400000) {
            level = PlayerLevelMaster;
            levelLabel.text = [NSString stringWithFormat:@"长空主宰"];
        } else if (score > 1200000) {
            level = PlayerLevelSpree;
            levelLabel.text = [NSString stringWithFormat:@"大杀特杀"];
        } else if (score > 600000) {
            level = PlayerLevelKiller;
            levelLabel.text = [NSString stringWithFormat:@"杀手"];
        } else if (score > 300000) {
            level = PlayerLevelFresh;
            levelLabel.text = [NSString stringWithFormat:@"新手"];
        } else if (score > 100000) {
            level = PlayerLevelTrainee;
            levelLabel.text = [NSString stringWithFormat:@"实习生"];
        }
    }]];
}

- (void)enemyPlaneCollisionAnimation:(PlaneNode *)sprite {
    if (![sprite actionForKey:@"dieAction"]) {
        
        SKAction *hitAction = nil;
        SKAction *blowupAction = nil;
        NSString *soundFileName = nil;
        switch (sprite.type) {
            case PlaneTypeBig:
            {
                sprite.hp--;
                hitAction = hitBigPlaneAction;
                blowupAction = blowupBigPlaneAction;
                soundFileName = @"enemy2_down.mp3";
            }
                break;
            case PlaneTypeMedium:
            {
                sprite.hp--;
                hitAction = hitMediumPlaneAction;
                blowupAction = blowupMediumPlaneAction;
                soundFileName = @"enemy3_down.mp3";
            }
                break;
            case PlaneTypeSmall:
            {
                sprite.hp--;
                hitAction = hitSmallPlaneAction;
                blowupAction = blowupSmallPlaneAction;
                soundFileName = @"enemy1_down.mp3";
            }
                break;
            default:
                break;
        }
        if (sprite.hp == 0) {
            [sprite removeAllActions];
            [sprite runAction:blowupAction withKey:@"dieAction"];
            [self changeScore:sprite.type];
            [self runAction:[SKAction playSoundFileNamed:soundFileName waitForCompletion:NO]];
        } else {
            [sprite runAction:hitAction];
        }
    }
}

- (void)playerPlaneCollisionAnimation:(SKSpriteNode *)sprite {
    [self removeAllActions];
    [sprite runAction:[SharedAtles playerPlaneBlowupAction] completion:^{
        [self runAction:[SKAction sequence:@[[SKAction playSoundFileNamed:@"game_over.mp3" waitForCompletion:YES],[SKAction runBlock:^{
            SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Thin"];
            label.text = @"GameOver";
            label.fontColor = [SKColor blackColor];
            label.position = CGPointMake(self.size.width / 2 , self.size.height / 2 + 20);
            [self addChild:label];
        }]]] completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"gameOverNotification" object:nil];
        }];
    }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if (location.x >= self.size.width - (playerPlane.size.width / 2)) {
            location.x = self.size.width - (playerPlane.size.width / 2);
        } else if (location.x <= (playerPlane.size.width / 2)) {
            location.x = playerPlane.size.width / 2;
        }
        
        if (location.y >= self.size.height - (playerPlane.size.height / 2)) {
            location.y = self.size.height - (playerPlane.size.height / 2);
        } else if (location.y <= (playerPlane.size.height / 2)) {
            location.y = (playerPlane.size.height / 2);
        }
        
        SKAction *action = [SKAction moveTo:CGPointMake(location.x, location.y) duration:0];
        [playerPlane runAction:action];
    }
}

- (void)update:(NSTimeInterval)currentTime {
    [self createEnemyPlane];
    [self scrollBackground];
}

#pragma mark -
- (void)didBeginContact:(SKPhysicsContact *)contact{
    if (contact.bodyA.categoryBitMask & RoleCategoryEnemyPlane || contact.bodyB.categoryBitMask & RoleCategoryEnemyPlane) {
        PlaneNode *sprite = (contact.bodyA.categoryBitMask & RoleCategoryEnemyPlane) ? (PlaneNode *)contact.bodyA.node : (PlaneNode *)contact.bodyB.node;
        
        if (contact.bodyA.categoryBitMask & RoleCategoryPlayerPlane || contact.bodyB.categoryBitMask & RoleCategoryPlayerPlane) {
            SKSpriteNode *player = (contact.bodyA.categoryBitMask & RoleCategoryPlayerPlane) ? (SKSpriteNode *)contact.bodyA.node : (SKSpriteNode *)contact.bodyB.node;
            [self playerPlaneCollisionAnimation:player];
        } else {
            SKSpriteNode *bullet = (contact.bodyA.categoryBitMask & RoleCategoryEnemyPlane) ? (PlaneNode *)contact.bodyB.node : (PlaneNode *)contact.bodyA.node;
            [bullet removeFromParent];
            [self enemyPlaneCollisionAnimation:sprite];
        }
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact{
    
}

@end
