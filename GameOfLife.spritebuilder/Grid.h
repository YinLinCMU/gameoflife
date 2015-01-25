//
//  Grid.h
//  GameOfLife
//
//  Created by Yin Lin on 1/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Grid : CCSprite
@property (nonatomic, assign) int totalAlive;
@property (nonatomic, assign) int generation;
-(id)evolveStep;
-(id)countNeighbors;
-(id)updateCreatures;
@end
