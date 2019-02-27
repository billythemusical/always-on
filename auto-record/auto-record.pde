//
written in Processing 3.5.3
using the Minim library and examples.
//

import ddf.minim.*;
import ddf.minim.ugens.*;
// we must import this package to create an AudioFormat object
import javax.sound.sampled.*;

int loopInterval; //recording loop time in ms
int recCount;  //to loop the recordings each time thru draw
int fileCount; //the number of recordings saved
int interval;

Minim minim;

// for recording
AudioInput in;
AudioRecorder recorder;

void setup() {

  size(512, 200, P3D);
  recCount = 0;
  fileCount = 0;
  interval = 200000; //200000 = 1:10 hr

  minim = new Minim(this);

  // get a mono line-in: sample buffer length of 2048
  // default sample rate is 44100, default bit depth is 16
  in = minim.getLineIn(Minim.MONO, 512, 44100, 16);

  // create an AudioRecorder that will record from in to the filename specified.
  // the file will be located in the sketch's main folder.
  recorder = minim.createRecorder(in, 
      year() + nf(month(), 2) + nf(day(), 2) + "_" + nf(hour(), 2) + "-" + nf(minute(), 2) + "-" + nf(second(), 2) + ".wav");
  recorder.beginRecord();
  textFont(createFont("Arial", 12));
}

void draw() {
  recCount++;
  if ( recorder.isRecording() == false ) 
  {
    recorder = minim.createRecorder(in, year() + nf(month(), 2) + nf(day(), 2) +
      "_" + nf(hour(), 2) + "-" + nf(minute(), 2) + "-" + nf(second(), 2) + ".wav");
    recorder.beginRecord();
  }
  
  background(0);
  stroke(255);
   //draw the waveforms
   //the values returned by left.get() and right.get() will be between -1 and 1,
   //so we need to scale them up to see the waveform
  for (int i = 0; i < in.left.size()-1; i++)
  {
    line(i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50);
    line(i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50);
  }

  if ( recCount > interval ) 
  {
    if ( recorder.isRecording() )
    {
      println(fileCount + " files saved.  Time..." + (nf(hour(), 2) + "-" + nf(minute(), 2) + "-" + nf(second(), 2)));
      recorder.endRecord();
      recorder.save();
      fileCount++;
      recCount = 0;
    }
  }


  if ( recorder.isRecording() )
  {
    pushMatrix();
    fill(255,0,0);
    text(fileCount, 5, 15);
    popMatrix();
  }
}
