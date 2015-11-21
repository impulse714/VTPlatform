package  {
	
	import com.apdevblog.events.video.VideoControlsEvent;
	import com.apdevblog.examples.style.CustomStyleExample;
	import com.apdevblog.ui.video.ApdevVideoPlayer;
	import com.apdevblog.ui.video.ApdevVideoState;
	import flash.system.fscommand;
	import flash.events.*;
	import fl.controls.*;
	import flash.text.*
	import flash.media.*;
	import flash.display.*;
	
	public class main extends MovieClip {
		
		public function main() {
			
		var video:ApdevVideoPlayer = new ApdevVideoPlayer(360, 240);
        	video.controlsOverVideo = false;// position the videoplayer's controls at the bottom of the video
        	video.controlsAutoHide = false;// controls should not fade out (when not in fullscreen mode)
        	video.videostill = "pic.jpg";// load preview image
			video.autoPlay = false;// set video's autoplay to false
			video.load("video.mp4");// load video
			video.x = 10;
			video.y = 10;
  			addChild(video);
  
     	var myButton:Button = new Button();
			myButton.toggle = true;
			myButton.label = "click to remove";
			myButton.width = 350;
			myButton.move(15, 280);
			myButton.addEventListener(MouseEvent.CLICK, clickHandler);
			addChild(myButton);
			
		function clickHandler(evt:MouseEvent):void {
			
    		var btn:Button = evt.currentTarget as Button;
				btn.emphasized = btn.selected;
				 if (btn.emphasized) {
					video.clear();
					removeChild(video);
				} else trace("else")
		} // end of function clickHandler
		
	} // end of constructor
  } // end of class	
} // end of package
