//
//  CSShareMenu.h
//  CultureSphere
//
//  Created by Openxcell on 18/12/13.
//  Copyright (c) 2013 Openxcell. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BSShareMenuDelegate <NSObject>

-(void)shareMenuSelected:(int)index;
@end

@interface BSShareMenu : UIView

@property (nonatomic, retain) IBOutlet UIImageView *ivShare;
@property (weak) id<BSShareMenuDelegate> delegate;

-(id)initWithDelegate:(id<BSShareMenuDelegate>)objDelgate;
- (void)close;
- (void)show;
@end
