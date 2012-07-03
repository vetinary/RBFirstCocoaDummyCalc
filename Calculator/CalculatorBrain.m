//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Rodion Baskakov on 01.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;


- (NSMutableArray *) operandStack
{
    if (!_operandStack) _operandStack = [[NSMutableArray alloc] init];
    
    return _operandStack;
}

- (void) pushOperand: (double)operand
{
    [self.operandStack addObject: [NSNumber numberWithDouble: operand]];
}

- (double) performOperation:(NSString *)operation
{
    double result = 0;
    
    if ([operation isEqualToString: @"+"]) {
        
        result = [self popOperand] + [self popOperand];
        [self pushOperand: result];
        
    } else if ([operation isEqualToString: @"–"]) {
        
        double subtractor = [self popOperand];
        result = [self popOperand] - subtractor;
        [self pushOperand: result];
        
    } else if ([operation isEqualToString: @"/"]) {
        
        double divider = [self popOperand];
        
        if (divider == 0) { // since we can't divide by zero, we return zero
            result = 0;
        } else {
            result = [self popOperand] / divider;
            [self pushOperand: result];
        }
        
    } else if ([operation isEqualToString: @"*"]) {
        result = [self popOperand] * [self popOperand];
        [self pushOperand: result];
        
    } else if ([operation isEqualToString: @"sin"]) {
        result = sin([self popOperand]);
        [self pushOperand: result];
        
    } else if ([operation isEqualToString: @"cos"]) {
        result = cos([self popOperand]);
        [self pushOperand: result];
        
    } else if ([operation isEqualToString: @"sqrt"]) {
        result = sqrt([self popOperand]);
        [self pushOperand: result];
        
    } else if ([operation isEqualToString: @"π"]) {
        [self pushOperand: M_PI];
        result = M_PI;
    }
    
    return result;
}

- (void) clearOperands 
{
    [self.operandStack setArray: [[NSMutableArray alloc] init]];
}

- (double) popOperand
{
    NSNumber *operand = [self.operandStack lastObject];
    
    if (operand) {
        [self.operandStack removeLastObject];
    } else { // if we don't have an operand, use zero instead
        return 0;
    }

    return [operand doubleValue];
}

@end
