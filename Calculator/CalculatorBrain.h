//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Rodion Baskakov on 01.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushOperand: (double) operand;
- (void) pushVariable: (NSString *) variableName;

- (double) performOperation: (NSString *) operation;
- (void) clearOperands;

@property (readonly) id program;

+ (NSString *) descriptionOfProgram: (id) program;
+ (double) runProgram: (id) program;
+ (double) runProgram: (id) program 
  usingVariableValues: (NSDictionary *) variableValues;

@end
