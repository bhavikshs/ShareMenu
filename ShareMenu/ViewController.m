//
//  ViewController.m
//  ShareMenu
//
//  Created by Bhavik on 14/05/14.
//  Copyright (c) 2014 Bhavik. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    __weak IBOutlet UILabel *lblSelected;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
-(IBAction)btnSharePressed:(id)sender
{
    BSShareMenu *share = [[BSShareMenu alloc] initWithDelegate:self];
    [share show];
}
-(void)shareMenuSelected:(int)index
{
    switch (index) {
        case 1:
            [lblSelected setText:@"Twitter"];
            break;
        case 2:
            [lblSelected setText:@"Google"];
            break;
        case 3:
            [lblSelected setText:@"Mail"];
            break;
        case 4:
            [lblSelected setText:@"Dropbox"];
            break;
        case 5:
            [lblSelected setText:@"Pintrest"];
            break;
        case 6:
            [lblSelected setText:@"Facebook"];
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
