//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Rodion Baskakov on 30.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userInTheMiddleOfEnteringNumber;
@property (nonatomic) BOOL userPushedVariable;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSMutableDictionary *testVariableValues;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize dotButton = _dotButton;
@synthesize operationsLog = _operationsLog;
@synthesize userInTheMiddleOfEnteringNumber = _userInTheMiddleOfEnteringNumber;
@synthesize userPushedVariable = _userPushedVariable;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

- (NSMutableDictionary *)testVariableValues
{
    if(!_testVariableValues) _testVariableValues = [[NSMutableDictionary alloc] init];
    
    return _testVariableValues;
}

- (CalculatorBrain *)brain
{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.currentTitle;
    
    if(self.userPushedVariable) {
        [self enterPressed];
    }
    
    if(self.userInTheMiddleOfEnteringNumber) {
        self.display.text = [self.display.text stringByAppendingString: digit];
    } else {
        self.display.text = digit;
        self.userInTheMiddleOfEnteringNumber = YES;
    }
    
    NSRange range = [self.display.text rangeOfString: @"."];
    
    if (self.dotButton.enabled == NO && range.location == NSNotFound) { // if dot was pressed 
                                                                        // and we have no dot in display, 
                                                                        // divide the result by 10
        
        double num = [self.display.text doubleValue];
        self.display.text = [NSString stringWithFormat: @"%g", num/10];
    }
}

- (IBAction)dotPressed:(UIButton *)sender
{
    sender.enabled = NO;
}

- (IBAction)clear {
    [self.brain clearOperands];
    self.dotButton.enabled = YES;
    self.display.text = @"0";
    self.operationsLog.text = @"";
}

- (IBAction)variablePressed:(UIButton *)sender
{
    if (self.userInTheMiddleOfEnteringNumber) {
        [self enterPressed];
    }
    
    NSString *variable = [sender currentTitle];
    self.display.text = variable;
    self.userPushedVariable = YES;
    self.userInTheMiddleOfEnteringNumber = YES;

    [self.testVariableValues setValue: [NSNumber numberWithDouble: 0] forKey: variable];
}

- (IBAction)operandPressed:(UIButton *)sender
{
    if (self.userInTheMiddleOfEnteringNumber) [self enterPressed];

    double result = [self.brain performOperation: [sender currentTitle]];
    self.display.text = [NSString stringWithFormat: @"%g", result];
    
    self.userInTheMiddleOfEnteringNumber = NO;
    self.userPushedVariable = NO;
    self.dotButton.enabled = YES;
    
    [self logActivity: [sender currentTitle]];
    
}

- (IBAction)enterPressed
{
    if(self.userPushedVariable) {
        [self.brain pushVariable: self.display.text];
    } else {
        [self.brain pushOperand: [self.display.text doubleValue]];
    }
    self.userInTheMiddleOfEnteringNumber = NO;
    self.userPushedVariable = NO;
    self.dotButton.enabled = YES;
    [self logActivity: self.display.text];
    [self logActivity: @"E"];
}

- (void)logActivity: (NSString *) activity
{
    NSString *log = self.operationsLog.text;
    if ([log isEqualToString: @""]) {
        //self.operationsLog.text = activity; 
    } else {
        //self.operationsLog.text = [log stringByAppendingFormat: @" %@", activity];
    }
}

- (IBAction)invertSign
{
    double value = [self.display.text doubleValue] * -1;
    self.display.text = [NSString stringWithFormat: @"%g", value];
    
}

- (IBAction)testProgramWithVariables: (UIButton *)sender
{
    NSMutableArray *stack = [NSMutableArray arrayWithArray: [self.brain program]];
    if([sender.currentTitle isEqualToString: @"Test 1"]) {
        [self.testVariableValues setValue: [NSNumber numberWithDouble: 3] forKey:@"x"];
        [self.testVariableValues setValue: [NSNumber numberWithDouble: 15] forKey:@"z"];
        [self.testVariableValues setValue: [NSNumber numberWithDouble: 2.75] forKey:@"y"];
    } else if ([sender.currentTitle isEqualToString: @"Test 2"]) {
        [self.testVariableValues setValue: [NSNumber numberWithDouble: 4] forKey:@"x"];
        [self.testVariableValues setValue: [NSNumber numberWithDouble: 3] forKey:@"z"];
    } else if ([sender.currentTitle isEqualToString: @"Test 3"]) {
        [self.testVariableValues setValue: [NSNumber numberWithDouble: -7] forKey:@"x"];
        [self.testVariableValues setValue: [NSNumber numberWithDouble: 2.75] forKey:@"y"];
    }
    
    double result = [CalculatorBrain runProgram: stack usingVariableValues: self.testVariableValues];
    self.display.text = [NSString stringWithFormat: @"%g", result];
    self.operationsLog.text = [CalculatorBrain descriptionOfProgram: stack];

}

@end
