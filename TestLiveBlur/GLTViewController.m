//
//  GLTViewController.m
//  TestLiveBlur
//
//  Created by Kai Zou on 2014-03-19.
//  Copyright (c) 2014 com.personal. All rights reserved.
//

#import "GLTViewController.h"

#import <GPUImage/GPUImage.h>

#import "BlurView.h"

@interface GLTViewController () {
    
}
@property (strong, nonatomic) GPUImageView *videoOutputView;
@property (strong, nonatomic) GPUImageVideoCamera *videoCamera;


@property (strong, nonatomic) GPUImageiOSBlurFilter *blurFilter;
@property (strong, nonatomic) GPUImageBuffer *videoBuffer;
@property (strong, nonatomic) BlurView *blurredView;

@end

@implementation GLTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //note:
    // videoCamera --> videoBuffer --> blurFilter --> blurredView
    //                     |--> videoOutputView
    
    //1. create the blur filter
    self.blurFilter = [[GPUImageiOSBlurFilter alloc] init];
    self.blurFilter.blurRadiusInPixels = 1;
    
    //2. create a video buffer
    self.videoBuffer = [[GPUImageBuffer alloc] init];
    [self.videoBuffer setBufferSize:1];
    
    //3. create the view to display from video buffer
    CGRect frame = self.view.frame;
    self.videoOutputView = [[GPUImageView alloc] initWithFrame:frame];
    [self.view insertSubview:self.videoOutputView atIndex:0];
    
    //4. create the view that is suppose to display blur
    frame = CGRectMake(100, 100, 100, 75);
    self.blurredView = [[BlurView alloc] initWithFrame:frame];
    [self.view addSubview:self.blurredView];
    
    //5. initiate live camera
    [self useLiveCamera];
}

-(void)useLiveCamera {
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No camera detected" message:@"The current device does not have a camera to record from." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    [self.videoCamera addTarget:self.videoBuffer];
    [self.videoBuffer addTarget:self.videoOutputView];
    [self.videoBuffer addTarget:self.blurFilter];
    [self.blurFilter addTarget:self.blurredView];
    
    [self.videoCamera startCameraCapture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
