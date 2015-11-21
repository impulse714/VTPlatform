/***********************************************************************************************************************/
/*****             This class is the main recording class. It contains the buttons to record, save and submit       ****/
/*****             The singleton is called from the main class on when the user logs in                             ****/
/*****             and remains persistant throughout the session.                                                   ****/              
/*****                    Copyright  Facential, LLC   2015   all rights reserved                                    ****/
/*****                                                                                                              ****/
/***********************************************************************************************************************/

package com.facential {

	import flash.display.MovieClip;
	import fl.controls.Button;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;	
	import flash.events.IOErrorEvent;		
	import flash.events.KeyboardEvent;
	import flash.net.Responder;
	import flash.display.Sprite;
	import flash.media.Video;
	import flash.media.Camera;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.events.StatusEvent;	
	import fl.data.DataProvider; 
	import flash.geom.Rectangle;	
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.media.CameraPosition;
	import flash.geom.*;
	import flash.display.Shape;
	import com.apdevblog.events.video.VideoControlsEvent;
	import com.apdevblog.examples.style.CustomStyleExample;
	import com.apdevblog.ui.video.ApdevVideoPlayer;
	import com.apdevblog.ui.video.ApdevVideoState;
	import flash.utils.*;
	import com.rainbowcreatures.*;
	import com.rainbowcreatures.swf.*;	
	import flash.ui.*;
	
	public class videoClass extends MovieClip {
		
		public static const RECORD:String = "RECORD";  //custom event fired when record is pressed
		var recordEv:Event = new Event(RECORD);
				
		public static const SAVED:String = "SAVED";  //custom event fired when file is saved by the user
		var savedEv:Event = new Event(SAVED);	
		
		// app recording state
		private var mode:String = "record";
		private var state:String = "none";
		private const w:int = 330;
		private const h:int = 240;		
		private var myEncoder:FWVideoEncoder;		
		private var stageVideo:StageVideo;
		private var camera:Camera;
		private var video:Video;
		public var recordStopButton:Button; 
		private var minMaxButton:Button;
		private var circle:Sprite;
		private var recordPlaybackBox:Shape;
		private var lessonPrefix:String;
		private var rehersalVideo:ApdevVideoPlayer;
		private var saveVideoBtn:Button;
		private var submitVideoBtn:Button;
		private var newFile:File;
		var camError:cameraError;
		var recordPlaybackAccentBox:Shape;
		var PlaybackAccentBox:Shape;
		var RPsprite:Sprite;

		// some public class vars
		public var useStageVideo:Boolean = false;
		public var saveFile:File = File.applicationStorageDirectory.resolvePath("videoTake.mp4");
		public var lessonGlobalPrefix:String;

		
		public function videoClass() {
			
			addEventListener(Event.ADDED_TO_STAGE, init);					
		
		} // end of videoClass
				
				
		private function init(e:Event):void {			
		
			removeEventListener(Event.ADDED_TO_STAGE, init);								
			addEventListener(Event.REMOVED_FROM_STAGE, dispose);					
			myEncoder = FWVideoEncoder.getInstance(this);// Always hand over the root DisplayObject in the getInstance constructor			
			myEncoder.addEventListener(StatusEvent.STATUS, onStatus);			
			myEncoder.load("../../../lib/FlashPlayer/");
			if (useStageVideo) {																		
				stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, availabilityChanged);
			}
			prepareForRecording();
			setRecordingAssets();
			//addChild(new FPSCounter());
		
		} // end of init
		
		
		protected function setRecordingAssets(): void {
			
			RPsprite = new Sprite();
			addChildAt(RPsprite,0);
			
			          		
			recordPlaybackBox = new Shape;
			recordPlaybackBox.graphics.beginFill(0xcccccc); // choosing the colour for the fill (grey)
			recordPlaybackBox.graphics.drawRoundRect(0, 0, 390,690,25,25); // (x spacing, y spacing, width, height , rounding x and y)
			recordPlaybackBox.graphics.endFill(); 
			RPsprite.addChild(recordPlaybackBox);
			
			recordPlaybackAccentBox = new Shape;
			recordPlaybackAccentBox.graphics.beginFill(0x666666); // choosing the colour for the fill (grey)
			recordPlaybackAccentBox.graphics.drawRoundRect(15, 17, 360,310,25,25); // (x spacing, y spacing, width, height , rounding x and y)
			recordPlaybackAccentBox.graphics.endFill(); 
			RPsprite.addChild(recordPlaybackAccentBox);
				
			PlaybackAccentBox = new Shape;
			PlaybackAccentBox.graphics.beginFill(0x666666); // choosing the colour for the fill (grey)
			PlaybackAccentBox.graphics.drawRoundRect(15, 377, 360,298,25,25); // (x spacing, y spacing, width, height , rounding x and y)
			PlaybackAccentBox.graphics.endFill(); 
			RPsprite.addChild(PlaybackAccentBox);	
				
			camError = new cameraError(); // places error box on stage in case camera is not avauilable
			camError.x=30;
			camError.y=34;
			RPsprite.addChild(camError);
			
			recordStopButton = new Button();
   			recordStopButton.label = "RECORD"; 
   			recordStopButton.selected = true;    
			recordStopButton.toggle = true; 
			recordStopButton.width = 90;
  			recordStopButton.addEventListener(MouseEvent.CLICK,recordStopClick);
			recordStopButton.addEventListener (KeyboardEvent.KEY_DOWN, recordStopKeyboard)
			recordStopButton.move(30,290);
			RPsprite.addChild(recordStopButton);
				
			circle = new Sprite();
         	circle.graphics.beginFill(0x000000);
         	circle.graphics.drawCircle(145,301, 9);
         	circle.graphics.endFill();
         	RPsprite.addChild(circle);
						
			saveVideoBtn = new Button();
   			saveVideoBtn.label = "SAVE"; 
			saveVideoBtn.width = 90;
   			saveVideoBtn.selected = true;      
  			saveVideoBtn.addEventListener(MouseEvent.CLICK,saveTake);
			saveVideoBtn.move(170,290);
			saveVideoBtn.visible= true;
			RPsprite.addChild(saveVideoBtn);
				
			submitVideoBtn = new Button();
   			submitVideoBtn.label = "SUBMIT"; 
			submitVideoBtn.width = 90;
   			submitVideoBtn.selected = true;    
			submitVideoBtn.toggle = true;  
  			submitVideoBtn.addEventListener(MouseEvent.CLICK,submitTake);
			submitVideoBtn.move(270,290);
			submitVideoBtn.visible = true;
			RPsprite.addChild(submitVideoBtn);
			
    	} // setRecordingAssets
		
		

		protected function availabilityChanged(e:StageVideoAvailabilityEvent):void {
            
			trace("StageVideo => " + e.availability);
            if(e.availability == StageVideoAvailability.AVAILABLE){
                stageVideo = stage.stageVideos[0];
                attachCamera();
            }
        }
		

		protected function attachCamera():void {
			
            trace("Camera.isSupported => " + Camera.isSupported);
            if(Camera.isSupported){
                camera = tryGetFrontCamera();
				if (camera == null) {
					throw new Error("Camera is needed");
				}
				camera.setMode(stage.stageWidth, stage.stageHeight, 25);
				camera.setQuality(0, 100);
                stageVideo.addEventListener(StageVideoEvent.RENDER_STATE, onRenderState);
                stageVideo.attachCamera(camera);
            }
        }
		

		protected function onRenderState(e:StageVideoEvent):void {
			
            stageVideo.viewPort = new Rectangle(0, 0, w, h);
        }
				
		
		
		private function initRecord():void { // reinitialize recording (notice the myEncoder.init is there)
		
			// initialize FW with microphone recording

			myEncoder.setDimensions(w, h);
			myEncoder.start(20, FWVideoEncoder.AUDIO_MICROPHONE);
		}
		

		
		private function onStatus(e:StatusEvent):void { // FlashyWrappers status event handler
				
			// the encoder class is loaded (this is triggered only once)
			if (e.code == "ready") {					
					
				myEncoder.askMicPermission();
				
				if (!useStageVideo) {
					// add webcam view
					video = new Video(w, h);
					video.x = 30;
					video.y = 35;
					addChild(video);
					var camera:Camera = tryGetFrontCamera();
					if (camera == null) throw new Error("Camera is needed");
					
					camera.setMode(w, h, 60);
					camera.setQuality(0, 100);
					video.attachCamera(camera);
					
				}// end of if	
				
				addEventListener(Event.ENTER_FRAME, onFrame);
				
			} // end of ready
												
												
			// video was encoded
			if (e.code == "encoded") {				
		
				// get the final video
				var bo:ByteArray = myEncoder.getVideo();									
				trace("Saving " + bo.length + " bytes...");
				/*if (myEncoder.platform != "IOS" && myEncoder.platform != "ANDROID") {
					var saveFile:FileReference = new FileReference();
				saveFile.addEventListener(Event.COMPLETE, saveCompleteHandler);
				saveFile.addEventListener(IOErrorEvent.IO_ERROR, saveIOErrorHandler);
				saveFile.save(bo, filename);
				} else {*/
				
				// AIR only
				var file:File;
				
				// for iOS
				if (myEncoder.platform == FWVideoEncoder.PLATFORM_IOS) {
					
					myEncoder.iOS_saveToCameraRoll();				
				
				} else {
								
   					var fileStream:FileStream = new FileStream();
   						fileStream.open(saveFile, FileMode.WRITE);
  						fileStream.writeBytes(bo, 0, bo.length);
   						fileStream.close();
						dispatchEvent(new Event(Event.COMPLETE));
				} 
			
				// on iOS we saved to cameraroll and we will prepareForRecording only after we know 
				// that the video finished saving
				if (myEncoder.platform != FWVideoEncoder.PLATFORM_IOS) {
					prepareForRecording();
				}									
			} // end of encoded
			
			
			if (e.code == "stopped") {
				trace("Encoding was forced to stop. Please try again.");
				state = "none";
				prepareForRecording();
				
			} // end of stopped
			
			// for mobile
			if (e.code == "cameraroll_saved") {
				prepareForRecording();
			}
			
			// for mobile
			if (e.code == "encoding_cancel") {
				trace("Encoding cancelled.");
			}
			
			// for mobile			
			if (e.code == "cameraroll_failed") {
	    trace("Saving to camera roll has failed, permissions for access to camera roll are probably not enabled correctly for this app");
				prepareForRecording();
			}
		} // end of onStatus


		
		private function tryGetFrontCamera ():Camera {  // utility function trying to get front camera, otherwise get the standard one
    		
			var numCameras:uint = (Camera.isSupported) ? Camera.names.length : 0;
    		for (var i:uint = 0; i < numCameras; i++) {
        		var cam:Camera = Camera.getCamera(String(i));
        		if (cam && cam.position == CameraPosition.FRONT) {
            		return cam;
        		}
   			} 
    		return Camera.getCamera();
		}
		

		private function onFrame(e:Event):void {
			
			// record mode - this records the animation
			if (state == "record") {
				myEncoder.capture(video);
			}
						
			// finish recording
			if (state == "finish") {				
				// send the "finish" command - this doesn't guarantee instant finishing as some background threads need to be stopped yet
				myEncoder.finish();
				// thats why we switch to "finishing" state and we're there until we get 'encoded' status event. During "finishing" 
				// we can still try to display progress
				// because on iOS it is finalizing the movie and actually returns the progress of that(it might take several seconds)
				state = "finishing";
			}					
			
			// show encoding progress if needed
			if (state == "finishing") {				
			}
			
		} // end of onFrame
		
		
		private function prepareForRecording ():void {

			mode = "record";			
		}
		
		
		private function saveCompleteHandler(e:Event):void {// file was saved - right now this just dispatches complete event
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		private function saveIOErrorHandler(e:IOErrorEvent):void {  // some error happened, oops
		
			dispatchEvent(e);
		}		
		
		
		
		private function recordStopClick (e:MouseEvent):void {

    		if(e.target.selected==true){
					
			// code to start encoding/saving the video
			
				var stopColor:ColorTransform = new ColorTransform();
 					stopColor.color = 0x000000;
 					circle.transform.colorTransform = stopColor;
					recordStopButton.label = "RECORD";
						
					if (mode == "stop") state = "finish";	
					saveVideoBtn.visible = true;
					submitVideoBtn.visible = true;
						
    		} else {
				
			// code to start recording the video
			
				dispatchEvent(recordEv);
				var red:ColorTransform = new ColorTransform();
 					red.color = 0xFF0000;
 					circle.transform.colorTransform = red;
        			recordStopButton.label = "STOP";
					
					if (mode == "record") {
							state = "record";
							initRecord();
							mode = "stop";
					}
						
    		} // end of main if
			
	  	} // end of recordStop	
		
		
		private function recordStopKeyboard (e:KeyboardEvent):void {
					
					if(e.keyCode == 32) {

    		if(e.target.selected==true){
					
			// code to start encoding/saving the video
			
				var stopColor:ColorTransform = new ColorTransform();
 					stopColor.color = 0x000000;
 					circle.transform.colorTransform = stopColor;
					recordStopButton.label = "RECORD";
						
					if (mode == "stop") state = "finish";	
					saveVideoBtn.visible = true;
					submitVideoBtn.visible = true;
						
    		} else {
				
			// code to start recording the video
			
				dispatchEvent(recordEv);
				var red:ColorTransform = new ColorTransform();
 					red.color = 0xFF0000;
 					circle.transform.colorTransform = red;
        			recordStopButton.label = "STOP";
					
					if (mode == "record") {
							state = "record";
							initRecord();
							mode = "stop";
					}
						
    		} // end of main if
			
		  }
					
	  	} // end of recordStop	
			
		
		public function getRecordedFile():File {
			
			return saveFile;
		}
		
		
		public function minimizeRecorderAssets ():void{
			
			video.visible = false;
			circle.visible = false;
			recordStopButton.visible = false;
			recordPlaybackBox.visible = false;
			saveVideoBtn.visible = false;
			submitVideoBtn.visible = false;
			camError.visible = false;
			recordPlaybackAccentBox.visible = false;
			PlaybackAccentBox.visible = false;
			
		} // end of minimizeRecorderAssets
		
		
		public function maximizeRecorderAssets ():void{
			
			video.visible = true;
			circle.visible = true;
			recordStopButton.visible = true;
			recordPlaybackBox.visible = true;
			saveVideoBtn.visible = true;
			submitVideoBtn.visible = true;
			camError.visible = true;
			recordPlaybackAccentBox.visible = true;
			PlaybackAccentBox.visible = true;
			
			
		} // end of maximizeRecorderAssets
		
		
		private function saveTake(evt:Event):void {
			
			var green:ColorTransform = new ColorTransform();
 					green.color = 0x00FF00;
 					circle.transform.colorTransform = green;
					
			var timer:Timer = new Timer(400,1);

			timer.addEventListener(TimerEvent.TIMER, onTick);		
			timer.start();
			function onTick():void {
				var black:ColorTransform = new ColorTransform();
 					black.color = 0x000000;
 					circle.transform.colorTransform = black;
			}
					
			var d:Date = new Date();
			var months:Array = ["January","February","March","April","May","June","July","August","September","October",
								"November","December"];
			var makeDate:String = months[d.month]+"."+(d.date + 1)+"."+d.fullYear+ "."+d.hours+"."+d.minutes+"."+d.seconds;
	
			newFile = File.applicationStorageDirectory.resolvePath("lessons/" + lessonGlobalPrefix + makeDate + ".mp4"); 
			saveFile.copyTo(newFile, true);
			dispatchEvent(savedEv);
			
			
			var file:File = File.applicationStorageDirectory.resolvePath("lessons/"+lessonGlobalPrefix + ".fac");
			var stream:FileStream = new FileStream();
				stream.open(file, FileMode.APPEND);
				stream.writeUTFBytes( lessonGlobalPrefix + makeDate + ".mp4" + ",");
				stream.close();
				
		} // end of saveTake
			
	   
	    public function submitTake(evt:Event):void {
			
			var blue:ColorTransform = new ColorTransform();
 					blue.color = 0x0000FF;
 					circle.transform.colorTransform = blue;
					
			var timer:Timer = new Timer(500,1);

			timer.addEventListener(TimerEvent.TIMER, onTick);		
			timer.start();
			
			function onTick():void {
				var black:ColorTransform = new ColorTransform();
 					black.color = 0x000000;
 					circle.transform.colorTransform = black;
			}
			
		}
		
		
		public function getSavedFile():File {
			
			return newFile;
		}
		
		
		private function dispose(e:Event):void {// after removed from stage, erase all event listeners
		
			removeEventListener(Event.REMOVED_FROM_STAGE, dispose);											
			removeEventListener(Event.ENTER_FRAME, onFrame);
			
		} // end of dispose		
		
	} // end of class defination
	
} // end of package
