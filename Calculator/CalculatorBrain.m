//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Rodion Baskakov on 01.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSMutableDictionary *variablesStack;

@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize variablesStack = _variablesStack;


- (NSMutableArray *) programStack
{
    if (!_programStack) _programStack = [[NSMutableArray alloc] init];
    
    return _programStack;
}

- (NSMutableDictionary *) variablesStack
{
    if(!_variablesStack) _variablesStack = [[NSMutableDictionary alloc] init];
    
    return _variablesStack;
}

- (void) pushOperand: (double)operand
{
    [self.programStack addObject: [NSNumber numberWithDouble: operand]];
}

- (void) pushVariable: (NSString *)variableName
{
    [self.programStack addObject: variableName];
    [self.variablesStack setObject: [NSNumber numberWithDouble: 0] forKey: variableName];
}

- (double) performOperation:(NSString *)operation
{
    [self.programStack addObject: operation];
    return [CalculatorBrain runProgram: self.programStack];
}

- (id)program
{
    return [self.programStack copy];
}

- (void) clearOperands 
{
    [self.programStack setArray: [[NSMutableArray alloc] init]];
    [self.variablesStack setDictionary: [[NSMutableDictionary alloc] init]];
}

+ (double) runProgram:(id)program
{
    NSMutableArray *stack;
    if([program isKindOfClass: [NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    return [self popOperandOffStack: stack];
}

+(double) runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;

    if([program isKindOfClass: [NSArray class]]) {
        stack = [program mutableCopy];
    }

    for(int i = 0; i < [stack count]; i++) {
        id object = [stack objectAtIndex: i];
        if(![object isKindOfClass: [NSString class]]) continue;
        
        id var = [variableValues objectForKey: object];
        
        if([var isKindOfClass: [NSNumber class]]) {
            double variableValue = [var doubleValue];
            [stack replaceObjectAtIndex: i withObject: [NSNumber numberWithDouble:variableValue]];
        }
    }

    return [self popOperandOffStack: stack];
}

+(double) popOperandOffStack: (NSMutableArray *) stack
{
    double result = 0;
    id topOfStack = [stack lastObject];
    if(topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass: [NSNumber class]]) {
        
        result = [topOfStack doubleValue];

    } else if ([topOfStack isKindOfClass: [NSString class]]) {
        
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString: @"+"]) {
            result = [self popOperandOffStack: stack] + [self popOperandOffStack: stack];
            
        } else if ([operation isEqualToString: @"–"]) {
            double subtractor = [self popOperandOffStack: stack];
            result = [self popOperandOffStack: stack] - subtractor;
            
        } else if ([operation isEqualToString: @"/"]) {
            
            double divider = [self popOperandOffStack: stack];
            
            if (divider == 0) { // since we can't divide by zero, we return zero
                result = 0;
            } else {
                result = [self popOperandOffStack: stack] / divider;
            }
            
        } else if ([operation isEqualToString: @"*"]) {
            result = [self popOperandOffStack: stack] * [self popOperandOffStack: stack];
            
        } else if ([operation isEqualToString: @"sin"]) {
            result = sin([self popOperandOffStack: stack]);
            
        } else if ([operation isEqualToString: @"cos"]) {
            result = cos([self popOperandOffStack: stack]);
            
        } else if ([operation isEqualToString: @"sqrt"]) {
            result = sqrt([self popOperandOffStack: stack]);
            
        } else if ([operation isEqualToString: @"π"]) {
            result = M_PI;
        }
    }
    
    return result;
}

+ (NSString *) descriptionOfTopOfStack: (NSMutableArray *)stack
{
    NSString *result = @"";
    NSSet *pairedOperations = [NSSet setWithObjects: @"+", @"-", @"*", "/", nil];
    NSSet *bracketedOperations = [NSSet setWithObjects: @"sin", @"cos", @"sqrt", nil];
    
    id lastObject = [stack lastObject];
    if (lastObject) [stack removeLastObject];
    
    if ([lastObject isKindOfClass: [NSNumber class]]) {
        NSLog(@"Digit called");
        result = [NSString stringWithFormat: @"%@", lastObject]; 
    } else if ([lastObject isKindOfClass: [NSString class]]) {
        if([pairedOperations containsObject: lastObject]) {
            NSLog(@"Paired operation called");
        } else if ([bracketedOperations containsObject: lastObject]) {
            NSLog(@"Bracketed operation called");
        } else {
            NSLog(@"Just a variable or PI called");
        }
    }
    
    return result;
}



+ (NSString *) descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    
    NSString *description = @"";
    
    if([program isKindOfClass: [NSArray class]]) {
        stack = [program mutableCopy];
        description = [description stringByAppendingString: [CalculatorBrain descriptionOfTopOfStack: stack]];
    }
    
    return description;
}

@end
