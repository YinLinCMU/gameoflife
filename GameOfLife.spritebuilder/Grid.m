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
    int column = touchPosition.x / _cellWidth;
    int row = touchPosition.y / _cellHeight;
    
    //get the row and column that was touched, return the Creature inside the corresponding cell
    return _gridArray[row][column];
}

- (void)evolveStep
{
    //update each creature's neighbor count
    [self countNeighbors];
    
    //update each creature stat
    [self updateCreatures];
    
    //update the generation   when totalAlive==0, generation should stop
    _generation++;
}

- (void) countNeighbors
{
    //iterate through the rows
    //nsarray has a method count that return array's element
    for (int i = 0; i<[_gridArray count]; i++) {
        //iterate through all the columns for a given row
        for (int j = 0; j < [_gridArray[i] count ]; j++) {
            //access creature
            Creature *currentCreature = _gridArray[i][j];
            currentCreature.livingNeighbors = 0;
            //now examine every cell around the current one
            //
            for (int x = (i-1); x<=(i+1); x++) {
                for (int y = (j-1); y<=(j+1); y++) {
                    BOOL isIndexValid;
                    isIndexValid = [self isIndexValidForX: x andY: y];
                    
                    //skip over all cells that are off screen and the cell that
                    //contains the creature we are currently updating
                    if (!((x == i ) && (y == j)) && isIndexValid) {
                        Creature *neighbor = _gridArray[x][y];
                        if (neighbor.isAlive) {
                            currentCreature.livingNeighbors += 1;
                        }
                    }
                }
            }
        }
    }
}

- (BOOL)isIndexValidForX:(int)x andY:(int)y
{
    BOOL isIndexValid = YES;
    if (x < 0 || y < 0 || x >= GRID_ROWS || y >= GRID_COLUMNS) {
        isIndexValid = NO;
    }
    return isIndexValid;
}

-(void) updateCreatures{
    int numAlive = 0;
    for (int i = 0; i<[_gridArray count]; i++) {
        //iterate through all the columns for a given row
        for (int j = 0; j < [_gridArray[i] count ]; j++) {
            //access creature
            Creature *currentCreature = _gridArray[i][j];
            if (currentCreature.livingNeighbors == 3) {
                currentCreature.isAlive = YES;
            }
            
            else if (currentCreature.livingNeighbors <= 1 || currentCreature.livingNeighbors >= 4){
                
                currentCreature.isAlive = NO;
            }
            if (currentCreature.isAlive == YES) {
                numAlive++;
            }
        }
    }
    _totalAlive = numAlive;
}
@end
