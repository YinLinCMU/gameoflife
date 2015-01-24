//
//  Grid.m
//  GameOfLife
//
//  Created by Yin Lin on 1/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Creature.h"

// these are variables that cannot be changed
static const int GRID_ROWS = 8;
static const int GRID_COLUMNS = 10;

@implementation Grid{
    NSMutableArray *_gridArray;// 2d array
    float _cellWidth;
    float _cellHeight;
}

- (void)onEnter
{
    [super onEnter];
    
    [self setupGrid];
    
    // accept touches on the grid
    self.userInteractionEnabled = YES;
}

- (void)setupGrid
{
    // divide the grid's size by the number of columns/rows to figure out the right width and height of each cell
    _cellWidth = self.contentSize.width / GRID_COLUMNS;
    _cellHeight = self.contentSize.height / GRID_ROWS;
    
    float x = 0;
    float y = 0;
    
    // init the array as a blank nsmutable array
    _gridArray = [NSMutableArray array];
    
    //init creatures
    for (int i = 0; i < GRID_ROWS; i++) {
        //this is how you creat 2d arrays in oc. you put arrays into arrays
        _gridArray[i] = [NSMutableArray array];
        x = 0;
        
        for (int j = 0; j < GRID_COLUMNS; j++) {
            Creature *creature = [[Creature alloc] initCreature];
            creature.anchorPoint = ccp(0, 0);
            creature.position = ccp(x, y);
            [self addChild:creature];
            
            //this is shorthand to access an array inside an array
            _gridArray[i][j] = creature;
            
            //make creatures visible to test this method, remove this once we know we have filled the grid properly
            //creature.isAlive = YES;
            
            x += _cellWidth;
        }
        y += _cellHeight;
        }
    }
    
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    //get the x, y coordinates of the touch
     CGPoint touchLocation = [touch locationInNode:self];
    //get the creature at that locaiton
    Creature *creature = [self creatureForTouchPosition:touchLocation];
    //invert its stat - kill it if its alive, biring it to life if its dead
    creature.isAlive = !creature.isAlive;
}

- (Creature *)creatureForTouchPosition:(CGPoint)touchPosition
{
    int row = _cellHeight / touchPosition.y;
    int column = _cellWidth / touchPosition.x;
    //get the row and column that was touched, return the Creature inside the corresponding cell
    return _gridArray[row][column];
}

@end
