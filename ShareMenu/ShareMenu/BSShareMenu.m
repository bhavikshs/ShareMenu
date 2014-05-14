//
//  CSShareMenu.m
//  CultureSphere
//
//  Created by Openxcell on 18/12/13.
//  Copyright (c) 2013 Openxcell. All rights reserved.
//

#import "BSShareMenu.h"

@interface BSShareMenu ()

@end

@implementation BSShareMenu
CGPoint point;
@synthesize ivShare;
@synthesize delegate;

-(id)initWithDelegate:(id<BSShareMenuDelegate>)objDelgate
{
    self = [super init];
    if (self)
    {
        self.delegate = objDelgate;
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOpacity:0.8];
        [self.layer setShadowRadius:3.0];
        [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        UIButton *btn = [[UIButton alloc] initWithFrame:self.frame];
        [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"BSShareMenu" owner:self options:nil];
        BSShareMenu *vw = [arr objectAtIndex:0];
        [vw.layer setCornerRadius:vw.frame.size.height/2];
        [self addSubview:vw];
        [vw setCenter:self.center];
        for (UIButton *btn in [vw subviews]) {
            if ([btn isKindOfClass:[UIButton class]]) {
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
                [btn addGestureRecognizer:pan];
            }
        }
    }
    return self;
}
- (void)show
{
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
#if (defined(__IPHONE_7_0))
    if (1) {
        [self applyMotionEffects];
    }
#endif
    
    self.layer.opacity = 0.5f;
    self.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         self.layer.opacity = 1.0f;
                         self.layer.transform = CATransform3DMakeScale(1, 1, 1);
					 }
					 completion:NULL
     ];
}
- (void)applyMotionEffects {
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return;
    }
    
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-10);
    horizontalEffect.maximumRelativeValue = @( 10);
    
    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-10);
    verticalEffect.maximumRelativeValue = @( 10);
    
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];
    
    [self addMotionEffect:motionEffectGroup];
}
- (void)close
{
    CATransform3D currentTransform = self.layer.transform;
    
    CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
    
    self.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    self.layer.opacity = 1.0f;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         self.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         self.layer.opacity = 0.0f;
					 }
					 completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
					 }
	 ];
}
-(void)panned:(UIPanGestureRecognizer *)sender
{
    BSShareMenu *vwSuper = (BSShareMenu *)[[sender view] superview];
    CGPoint translatedPoint = [sender translationInView:vwSuper];
    
    if ([sender state] == UIGestureRecognizerStateBegan)
    {
        [self btnPressed:(UIButton *)[sender view]];
        point = [sender view].center;
    }
    else if ([sender state] == UIGestureRecognizerStateChanged)
    {
        CGRect recognizerFrame = sender.view.frame;
        recognizerFrame.origin.x += translatedPoint.x;
        recognizerFrame.origin.y += translatedPoint.y;
        if (CGRectContainsRect(vwSuper.bounds, recognizerFrame))
        {
            float alpha = [self getRGBAFromImage:[(UIImageView *)[vwSuper viewWithTag:53] image] atx:[sender view].center.x atY:[sender view].center.y];
            if (alpha != 0)
            {
                sender.view.frame = recognizerFrame;
            }
            
        }else {
            float alpha = [self getRGBAFromImage:[(UIImageView *)[vwSuper viewWithTag:53] image] atx:[sender view].center.x atY:[sender view].center.y];
            if (alpha != 0)
            {
                
                if (recognizerFrame.origin.y < vwSuper.bounds.origin.y)
                {
                    recognizerFrame.origin.y = 0;
                }
                else if (recognizerFrame.origin.y + recognizerFrame.size.height > vwSuper.bounds.size.height) {
                    recognizerFrame.origin.y = vwSuper.bounds.size.height - recognizerFrame.size.height;
                }
                if (recognizerFrame.origin.x < vwSuper.bounds.origin.x) {
                    recognizerFrame.origin.x = 0;
                }
                else if (recognizerFrame.origin.x + recognizerFrame.size.width > vwSuper.bounds.size.width) {
                    recognizerFrame.origin.x = vwSuper.bounds.size.width - recognizerFrame.size.width;
                }
                sender.view.frame = recognizerFrame;
                
                UIButton *btn = (UIButton *)[sender view];
                
                if (CGRectContainsRect(vwSuper.ivShare.frame, [sender view].frame))
                {
                    //NSLog(@"%d",[sender view].tag);
                }else{
                    [btn setTitleColor:[UIColor whiteColor] forState:0];
                }
            }
        }
        [sender setTranslation:CGPointMake(0, 0) inView:vwSuper];
        
    }
    else if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
    {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        if (CGRectContainsRect(vwSuper.ivShare.frame, [sender view].frame))
        {
            [self close];
            [self.delegate shareMenuSelected:[sender view].tag/60];
        }
        if (CGRectContainsRect(vwSuper.ivShare.frame, [sender view].frame)) {
            [[self viewWithTag:53] setHidden:YES];
        }
        UIButton *btn = (UIButton *)[sender view];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        
        [[sender view] setCenter:point];
        [UIView commitAnimations];
    }
}
-(float)getRGBAFromImage:(UIImage*)image atx:(int)xp atY:(int)yp
{
    xp += xp;
    yp += yp;
    CGImageRef imageRef = [image CGImage];
    
    NSUInteger width = CGImageGetWidth(imageRef);
    
    NSUInteger height = CGImageGetHeight(imageRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    
    
    NSUInteger bytesPerPixel = 4;
    
    NSUInteger bytesPerRow = bytesPerPixel * width;
    
    NSUInteger bitsPerComponent = 8;
    
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    CGContextRelease(context);
    
    int byteIndex = (bytesPerRow * yp) + xp * bytesPerPixel;
    
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) /255.0;
    
    byteIndex += 4;
    
    free(rawData);
    
    return alpha;
}
-(IBAction)btnPressed:(UIButton *)sender
{
    UIImageView *iv = (UIImageView *)[self viewWithTag:53];
    [iv setHidden:NO];
    [iv setImage:[self imageRotatedByRadians:M_PI * sender.tag / 180.0 Image:[UIImage imageNamed:@"img_Arc.png"]]];
}
- (UIImage *)imageRotatedByRadians:(CGFloat)radians Image:(UIImage *)image
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians*90);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //Rotate the image context
    CGContextRotateCTM(bitmap, radians);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
