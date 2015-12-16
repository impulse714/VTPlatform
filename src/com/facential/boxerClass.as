/****************************************************************************************************************************************/
/****               BigBox  class written by Tim Lanham  copyright 2015 Facential,LLC.  all rights reserved                          ****/
/****         This class is called from the lessonClass and contains the header, text and video for a given lesson.                  ****/
/****         This class is used for both the explaination and the prompt for a modified lesson. It takes in 4 variables             ****/
/****         the header text, the body text, theURL of thea type integer. It has 5 public functions for manipulating                ****/
/****         the visibility the widow, removal of all assets and dispatching the video state.                                       ****/
/****                                                                                                                                ****/
/****************************************************************************************************************************************/

package  com.facential{
	
	import flash.events.*;
	import fl.controls.*;
	import fl.data.DataProvider; 
	import flash.text.*
	import flash.media.*;
	import flash.display.*;
	import com.apdevblog.events.video.VideoControlsEvent;
	import com.apdevblog.examples.style.CustomStyleExample;
	import com.apdevblog.ui.video.ApdevVideoPlayer;
	import com.apdevblog.ui.video.ApdevVideoState;
	
	public class boxerClass extends MovieClip {

		public static const VIDEOCOMPLETE:String = "THE_VIDEO_IS_COMPLETE";  
		
		private var videoCompleteEvent:Event = new Event(VIDEOCOMPLETE);
		private var bkgdBox:Shape; // Main grey background box
		private var videoBkgdBox:Shape;	 // Video background box
		private var headerTextBox:TextField; // TextBox for header - The header loaded into this box
		private var header:String; // Actual text to be loaded into the headerTextbox
		private var bodyTextBox:TextField; // TextBox to hold the body - The body is loaded intothis box
		private var body:String; // Actual text to be loaded into the bodyTextBox
		private var boxSize:String;
		private var theVideo:ApdevVideoPlayer; // The video class
		private var theVideoURL:String; // The URL of the video to be loaded
		private var theVideoState:String; // State variable, mainly used to dispatch the complete event
		private var boxType:int;
		private var setCuePtBtn:Button;
		private var gotoCuePtBtn:Button;
		private var cueTextBox:TextField;
		private var cuePt:Number;
		private var clearCuePtBtn:Button;
		private var bodyTextSlider:Slider = new Slider();

						
		public function boxerClass (_header:String,_body:String,_theVideoURL:String,_boxType:int, _boxSize:String) {
			
			header = _header;
			body = _body;
			theVideoURL = _theVideoURL;  
			boxType = _boxType;
			boxSize = _boxSize;
			addEventListener(Event.ADDED_TO_STAGE, init);
					
		} // end of constructor 
		
	
		private function init (evt:Event):void {
			
			if (boxSize == "BIG") {
			
				var bkgdBoxH:int = 560; 
				var bkgdBoxW:int = 770; 
				var videoBkgdBoxH:int = 350; 
				var videoBkgdBoxW:int = 520; 
				var videoBkgdBoxX:int = 120;
				var videoBkgdBoxY:int = 200; 
				var headerTextBoxX:int = 125; 
				var headerTextBoxY:int = 10; 
				var cueX:int = 250; 
				var cueY:int = 520; 
				var cueBtnW:int = 60; 
				var headBodyW:int = 500; 
				var bodyTextBoxH:int = 150; 
				var bodyTextBoxX:int = 130; 
				var bodyTextBoxY:int = 57; 
				var videoH:int = 480; 
				var videoW:int = 270; 
				var videoX:int = 140; 
				var videoY:int = 220; 
			
			} else {
			
				var bkgdBoxH:int = 555;
				var bkgdBoxW:int = 370;
				var videoBkgdBoxH:int = 315;
				var videoBkgdBoxW:int = 350;
				var videoBkgdBoxX:int = 10;
				var videoBkgdBoxY:int = 235;
				var headerTextBoxX:int = 10;
				var headerTextBoxY:int = 20;
				var cueX:int = 50;
				var cueY:int = 522;
				var cueBtnW:int = 60;//60
				var headBodyW:int = 325;
				var bodyTextBoxH:int = 120;
				var bodyTextBoxX:int = 10;
				var bodyTextBoxY:int = 75;
				var videoH:int = 330;
				var videoW:int = 240;
				var videoX:int = 20;
				var videoY:int = 250;
			
			} // end of if else of size paramenters 
			
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
				
			var explainationBodyFormat:TextFormat = new TextFormat(); 
				explainationBodyFormat.size = 17;  
				explainationBodyFormat.font = "Arial";
				explainationBodyFormat.color = 0x000000;
				
			var promptBodyFormat:TextFormat = new TextFormat(); 
				promptBodyFormat.size = 25;  
				promptBodyFormat.font = "Arial";
				promptBodyFormat.color = 0x000000;
				promptBodyFormat.align = TextFormatAlign.CENTER;
				
			var headerFormat:TextFormat = new TextFormat();
 				headerFormat.size = 25;
				headerFormat.align = TextFormatAlign.CENTER;
		
				bkgdBox = new Shape; // initializing the first box
				bkgdBox.graphics.beginFill(0xcccccc); // choosing the colour for the fill (grey)
				bkgdBox.graphics.drawRoundRect(0, 0, bkgdBoxW, bkgdBoxH, 15, 15) // (x, y, width, height, )
				bkgdBox.graphics.endFill(); // not always needed but I like to put it in to end the fill
				addChild(bkgdBox);
				
				videoBkgdBox = new Shape; // initializing the first box
				videoBkgdBox.graphics.beginFill(0x666666); // choosing the colour for the fill (grey)
				videoBkgdBox.graphics.drawRoundRect(videoBkgdBoxX,videoBkgdBoxY, videoBkgdBoxW, videoBkgdBoxH, 15, 15) // (x, y, width, height, )
				videoBkgdBox.graphics.endFill(); // not always needed but I like to put it in to end the fill
				addChild(videoBkgdBox);
			
				headerTextBox = new TextField(); //  Header textBox
				headerTextBox.defaultTextFormat = headerFormat;
				headerTextBox.text = header; 
				headerTextBox.width = headBodyW;    
				headerTextBox.height = 35;    
				headerTextBox.x = headerTextBoxX;    
				headerTextBox.y = headerTextBoxY;
				headerTextBox.background = true;
				addChild(headerTextBox);
					
				bodyTextBox  = new TextField(); // textbox to display the exlanation scrollable.
				
				if (boxType == 0) bodyTextBox.defaultTextFormat =  explainationBodyFormat
				else bodyTextBox.defaultTextFormat = promptBodyFormat;
					
				bodyTextBox.scrollV = bodyTextBox.maxScrollV;
				bodyTextBox.text = body; 
				bodyTextBox.width = headBodyW;    
				bodyTextBox.height = bodyTextBoxH;    
				bodyTextBox.x = bodyTextBoxX;    
				bodyTextBox.y = bodyTextBoxY;
				bodyTextBox.wordWrap = true; 
				addChild(bodyTextBox);  
				
				bodyTextSlider.move(-10,65); // the slider to fade out the role model text
				bodyTextSlider.setSize(230,230); // both values have to be the same   (seems like a bug??)
				bodyTextSlider.minimum = 0;
				bodyTextSlider.maximum = 100;
				bodyTextSlider.value = 100;
				bodyTextSlider.direction = SliderDirection.VERTICAL;
				bodyTextSlider.liveDragging = true;
				bodyTextSlider.addEventListener(Event.CHANGE, sliderChanged);
				if (boxSize == "BIG") bodyTextSlider.visible = false;
				addChild(bodyTextSlider);
				
				theVideo = new ApdevVideoPlayer(videoH, videoW);
        		theVideo.controlsOverVideo = false;// position the videoplayer's controls at the bottom of the video
        		theVideo.controlsAutoHide = false;// controls should not fade out (when not in fullscreen mode)
				theVideo.autoPlay = true;// set video's autoplay to false
				theVideo.load(theVideoURL);// load video
				theVideo.x = videoX;
				theVideo.y = videoY;
				theVideo.addEventListener(VideoControlsEvent.STATE_UPDATE, videoStateUpdate, false, 0, true);
  				addChild(theVideo);				
			
				setCuePtBtn = new Button();
				setCuePtBtn.width = cueBtnW;
				setCuePtBtn.label = "Set Cue";
				setCuePtBtn.move(cueX, cueY);
				setCuePtBtn.addEventListener(MouseEvent.CLICK, cuePtBtnHandeler);
				addChild(setCuePtBtn);
				
				cueTextBox = new TextField;
				cueTextBox.text = "00:00"; 
				cueTextBox.width = 35;
				cueTextBox.height = 20;
				cueTextBox.background = true;
				cueTextBox.backgroundColor = 0xcccccc;
				cueTextBox.x = cueX +75;
				cueTextBox.y= cueY;
				addChild(cueTextBox);
				
				gotoCuePtBtn = new Button();
				gotoCuePtBtn.width = cueBtnW;
				gotoCuePtBtn.label = "Goto Cue";
				gotoCuePtBtn.move(cueX + 125, cueY);
				gotoCuePtBtn.addEventListener(MouseEvent.CLICK, gotoCuePtBtnHandeler);
				addChild(gotoCuePtBtn); 
				
				clearCuePtBtn = new Button();
				clearCuePtBtn.width = cueBtnW;
				clearCuePtBtn.label = "Clear Cue";
				clearCuePtBtn.move(cueX + 200, cueY);
				clearCuePtBtn.addEventListener(MouseEvent.CLICK, clearCuePtBtnHandeler);
				addChild(clearCuePtBtn);
				
		} // end of init


		private function sliderChanged(evt:Event):void {
						
			bodyTextBox.alpha = bodyTextSlider.value/100;// Set alpha value of txtOutput to be 1/100 the value of slAlpha.
			
 		} // end of	sliderChanged
		
		
		public function removeBoxer():void {  // function to remove the explaination video

			theVideo.clear();
			removeChild(theVideo);
			theVideo.removeEventListener(VideoControlsEvent.STATE_UPDATE, videoStateUpdate);
			removeChild(videoBkgdBox);
			removeChild(bodyTextBox);
			removeChild(headerTextBox);
			removeChild(bkgdBox);
			removeChild(bodyTextSlider);
			bodyTextSlider.removeEventListener(Event.CHANGE, sliderChanged);
			removeChild(setCuePtBtn);
			setCuePtBtn.removeEventListener(MouseEvent.CLICK, cuePtBtnHandeler);
			removeChild(gotoCuePtBtn);
			gotoCuePtBtn.removeEventListener(MouseEvent.CLICK, gotoCuePtBtnHandeler);
			removeChild(cueTextBox);
			removeChild(clearCuePtBtn);
			clearCuePtBtn.removeEventListener(MouseEvent.CLICK, clearCuePtBtnHandeler);
			
		} // end of removeBoxer
		
		
		public function minimizeBoxer():void { // function to minimize the explaination box 
			
			theVideo.visible = false;
			theVideo.pause();
			bkgdBox.visible = false;
			headerTextBox.visible = false;
			bodyTextBox.visible = false;
			videoBkgdBox.visible = false;
			setCuePtBtn.visible = false;
			bodyTextSlider.visible = false;
			gotoCuePtBtn.visible = false;
			cueTextBox.visible = false;
			clearCuePtBtn.visible = false;
			
		} // end of minimizeBoxer
		
		
		public function restoreBoxer():void { // function to restore the explaination box 
			
			bkgdBox.visible = true;
			theVideo.visible = true;
			headerTextBox.visible = true;
			bodyTextBox.visible = true;
			if (boxSize != "BIG") bodyTextSlider.visible = true;
			videoBkgdBox.visible = true;
			setCuePtBtn.visible = true;
			gotoCuePtBtn.visible = true;
			cueTextBox.visible = true;
			clearCuePtBtn.visible = true;
			
		} // end of restoreBoxer
		
		
		private function videoStateUpdate(event:VideoControlsEvent):void{
			
            theVideoState = event.data;
			if (event.data == "videoStateStopped")  dispatchEvent(videoCompleteEvent);
			
		} // end of videoStateUpdate


		public function getVideoState():String {
			
			return theVideoState;
			
		} // end of getVideoState


		public function stopVideo():void {
			
			theVideo.pause(); 
			
		} // end of stopVideo
		
		
		public function playVideo():void {
			
			theVideo.play();
			
		} // end of playVideo
		
		
		private function cuePtBtnHandeler(ev:MouseEvent):void {
				
			var duration:Number = Math.round(theVideo.videoDuration);
			var playtime:Number = theVideo.playTime;
			cuePt = (Math.round((playtime /duration)*100))/100;
			
			cueTextBox.text =HMconvert(theVideo.playTime); 
			cueTextBox.backgroundColor = 0xffff00;
     	
		} // end of cuePtBtnHandeler
		
		
		private function gotoCuePtBtnHandeler(ev:MouseEvent):void{
			
			theVideo.play();
			theVideo.seek(cuePt + .015,false);	
			
		} // end of gotoCuePtBtnHandeler
	
		
		private function HMconvert($seconds:Number):String {
		
    		var s:Number = $seconds % 60;
    		var m:Number = Math.floor(($seconds % 3600 ) / 60);
   			var h:Number = Math.floor($seconds / (60 * 60));
     
    		var hourStr:String = (h == 0) ? "" : doubleDigitFormat(h) + ":";
    		var minuteStr:String = doubleDigitFormat(m) + ":";
    		var secondsStr:String = doubleDigitFormat(s);
     
    		return hourStr + minuteStr + secondsStr;
			
		} // end of HMconvert
 
 
		private function doubleDigitFormat($num:uint):String {
		
   			if ($num < 10) {
			
        		return ("0" + $num);
    		}
		
    			return String($num);
				
		} // end of doubleDigitFormat
		
		
		private function clearCuePtBtnHandeler(ev:MouseEvent):void{

			cuePt = 0;
			cueTextBox.text = "00:00"; 
			cueTextBox.backgroundColor = 0xcccccc;
			
		} // end of clearCuePtBtnHandeler
		
		
	} // end of class explainationClass
	
	
} // end of package
