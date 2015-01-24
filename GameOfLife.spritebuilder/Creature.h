//
//  Creature.h
//  GameOfLife
//
//  Created by Yin Lin on 1/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Creature : CCSprite

// stores the current state of the creature
@property (nonatomic, assign) BOOL isAlive;

// stores the amount of living neighbors
@property (nonatomic, assign) NSInteger livingNeighbors;

- (id)initCreature;

@property (nonatomic, assign) int totalAlive;
@property (nonatomic, assign) int generation;

@end
