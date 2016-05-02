//
//  ViewController.m
//  AudioRecorder
//
//  Created by david roman on 5/1/16.
//  Copyright © 2016 davidsdemos. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //create button from button helper class. Per view we will want to assign the method logic on the view.
    
    buttonHelper *recordbutton = [[buttonHelper alloc] initWithRect:CGRectMake(75, 100, 100, 50) :self.view];
    [recordbutton setTitle:@"Record"];
    [recordbutton addTarget:self action:@selector(record:) forControlEvents:UIControlEventTouchDown];
    [recordbutton setBackgroundcolor:@"#62b3e3"];
    recordbutton.layer.name = @"record"; //a name will be assigned so we can use our iterator object later.
    
    

    buttonHelper *playbutton = [[buttonHelper alloc] initWithRect:CGRectMake(220, 100, 100, 50) :self.view];
    [playbutton setTitle:@"Play"];
    [playbutton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchDown];
    [playbutton setBackgroundcolor:@"#442369"];
    
    playbutton.layer.name = @"play";

    [self prepareAvRecorder];
    
    traversehelper = [[traverseHelper alloc] init]; // the single object also for us to loop through the buttons on the main view.
    
}

-(void)prepareAvRecorder{
    
    
    //return a array, while telling where in the app disk space will be saving our temp audio mp4 file.
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"recording.m4a",
                               nil];
    
    
    
    

    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    //our url object grabs the full path of our mp4 file.
    
    
    
    
    AVAudioSession *session = [AVAudioSession sharedInstance]; // grab the system singleton object, no matter if we continue to instance it, it will be the same shared object.
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    // the category we need is to record our voice and if we had audio over this it would record that as well.
    
    
    // Dictionary Config
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    // the required values for setting stereo mp4 audio
    
    
    
    
    // Initialate the recorder and prepare it so it's ready for when we need it.
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES; // will help with audio not peaking.
    [recorder prepareToRecord]; // recorder is now ready to use.
    
}

-(void)record:(UIButton *)_button{
    
    AVAudioSession *session = [AVAudioSession sharedInstance]; // grab the singleton
    [session setActive:YES error:nil]; //tell the session object that data is being written to the audio buffer.

    [_button setTitle:@"recording" forState:UIControlStateNormal];
    
    _button.userInteractionEnabled = NO;
    
    [recorder record]; //live record our audio.
    

    

}


-(void)play:(UIButton *)_button{
    if (recorder.recording){//if we are recording let's stop and playback our audio.
        
        [recorder stop];

        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play]; // load the audio save on the app disk and play now
        
        
        
        
        
        
        // below are functions that change the title of the button elements to indicate to the users what's happening visually.
        [[traversehelper getButtonByName:@"record" :self.view] setTitle:@"record" forState:UIControlStateNormal];
        
         [[traversehelper getButtonByName:@"record" :self.view] setUserInteractionEnabled:YES];
        
        
        [[traversehelper getButtonByName:@"play" :self.view] setTitle:@"playing" forState:UIControlStateNormal];

        
    }
    
    else{
        // if user decides to continue to hit play, just keep repeating the mp4 audio to the player.
        
        
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    }

}




-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSLog(@"audioRecorderDidFinishRecording");
    
    
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    [[traversehelper getButtonByName:@"play" :self.view] setTitle:@"play" forState:UIControlStateNormal];

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
