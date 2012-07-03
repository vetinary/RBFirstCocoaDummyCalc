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
@property (nonatomic, strong) CalculatorBrain *brain;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize dotButton = _dotButton;
@synthesize operationsLog = _operationsLog;
@synthesize userInTheMiddleOfEnteringNumber = _userInTheMiddleOfEnteringNumber;
@synthesize brain = _brain;

- (IBAction)digitPressed:(UIButton *)sender
{
    
    NSString *digit = sender.currentTitle;
    
    if(self.userInTheMiddleOfEnteringNumber) {
        self.display.text = [self.display.text stringByAppendingString: digit];
    } else {
        self.display.text = digit;
        self.userInTheMiddleOfEnteringNumber = YES;
    }
    
    if (self.dotButton.enabled == NO) { // if dot was pressed, divide the result by 10
        double num = [self.display.text floatValue];
        self.display.text = [NSString stringWithFormat: @"%g", num/10];
    }
}

- (CalculatorBrain *)brain
{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    
    return _brain;
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

- (IBAction)operandPressed:(UIButton *)sender
{
    if (self.userInTheMiddleOfEnteringNumber) [self enterPressed];

    double result = [self.brain performOperation: [sender currentTitle]];
    self.userInTheMiddleOfEnteringNumber = NO;
    self.display.text = [NSString stringWithFormat: @"%g", result];
    self.dotButton.enabled = YES;
    [self logActivity: [sender currentTitle]];
    
}

- (IBAction)enterPressed
{
    [self.brain pushOperand: [self.display.text doubleValue]];
    self.userInTheMiddleOfEnteringNumber = NO;
    self.dotButton.enabled = YES;
    [self logActivity: self.display.text];
}


- (void)logActivity: (NSString *) activity
{
    NSString *log = self.operationsLog.text;
    if ([log isEqualToString: @""]) {
        self.operationsLog.text = activity; 
    } else {
        self.operationsLog.text = [log stringByAppendingFormat: @" %@", activity];
    }
}

@end
