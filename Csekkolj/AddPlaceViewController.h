//
//  AddPlaceViewController.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.07..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPlaceViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *cityInput;
@property (weak, nonatomic) IBOutlet UITextField *streetInput;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *city;

@property (strong, nonatomic) NSString *street;
@end
