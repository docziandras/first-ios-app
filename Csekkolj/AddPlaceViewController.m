//
//  AddPlaceViewController.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.07..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "AddPlaceViewController.h"
#import "Place.h"

@implementation AddPlaceViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == self.nameInput) || (textField == self.cityInput) || (textField == self.streetInput)) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ReturnPlaceAddingInput"]) {
        if ([self.nameInput.text length] && [self.cityInput.text length] && [self.streetInput.text length]) {
        
            self.name = self.nameInput.text;
            self.city = self.cityInput.text;
            self.street = self.streetInput.text;
  
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }
}

@end
