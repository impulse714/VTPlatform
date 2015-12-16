/***********************************************************************************************************************/
/*****             This class places the record / playback assteets on the stage                                    ****/
/*****             The singleton is called from the main class on intital load                                      ****/
/*****             and remains persistant throughout the session.                                                   ****/              
/*****                    Copyright  Facential, LLC   2015   all rights reserved                                    ****/
/*****                                                                                                              ****/
/***********************************************************************************************************************/

package  com.facential{
	
	import flash.display.*;
	import flash.events.*;
	import fl.controls.*;
	import fl.data.DataProvider;
	import com.apdevblog.events.video.VideoControlsEvent;
	import com.apdevblog.examples.style.CustomStyleExample;
	import com.apdevblog.ui.video.ApdevVideoPlayer;
	import com.apdevblog.ui.video.ApdevVideoState;
	import flash.filesystem.*;
	
	public class playbackClass extends MovieClip {

		var rehersalVideo:ApdevVideoPlayer = new ApdevVideoPlayer(330, 240);
		var playbackCB:ComboBox = new ComboBox();
		var saveVideoButton:Button;
		var stillFile:File = File.applicationStorageDirectory.resolvePath("lessons/brain.jpg");
		var _takerArray:Array;
		
		
		public function playbackClass() {

			addEventListener(Event.ADDED_TO_STAGE, init);

		} // end of constructor


		private function init(evt:Event):void  {
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			playbackCB.width = 330;     //*******   fills lesson comboBox with the available lessons
			playbackCB.height = 25;
			playbackCB.dropdownWidth = 330; 		  
			playbackCB.dropdown.rowHeight = 22;
			playbackCB.textField.height = 32;
			playbackCB.move(890,367);
			playbackCB.prompt = "Select a your playback"; 
			playbackCB.addEventListener(Event.CHANGE,playbackHandeler); 
			addChild(playbackCB); // places the comboBox of all available lessons on the stage */
			
			
			rehersalVideo.x = 890;
			rehersalVideo.y = 425;
			addChild(rehersalVideo);
			rehersalVideo.addEventListener(VideoControlsEvent.STATE_UPDATE, onStateUpdate, false, 0, true);
        	rehersalVideo.controlsOverVideo = false;// position the videoplayer's controls at the bottom of the video
        	rehersalVideo.controlsAutoHide = false;// controls should not fade out (when not in fullscreen mode)
			rehersalVideo.autoPlay = true;// set video's autoplay to false
			rehersalVideo.videostill = stillFile.url;
			
		} // end of init
		
				
		private function playbackHandeler(e:Event):void{
				
        	rehersalVideo.load(_takerArray[e.target.selectedIndex]);// load video
		} 
		
	
        public function addFile(aFile:File):void{

			rehersalVideo.load(aFile.url);// load video
		}
		
		
		public function clearVideo():void{
			
			rehersalVideo.clear();
		}
		
		
		public function addArray(takerArray:Array):void{
			
			_takerArray = takerArray;
			playbackCB.dataProvider = new DataProvider(takerArray);
		}
		
		
		public function addToDataprovider(itemToAdd:String){
			
			_takerArray.push(itemToAdd);
			playbackCB.addItem({label : itemToAdd});
		}
		
		
		public function minimizePlaybackAssets():void {
			
			rehersalVideo.visible = false;
			playbackCB.visible = false;
			
		}
		
		
		public function maximizePlaybackAssets():void {
			
			rehersalVideo.visible = true;
			playbackCB.visible = true;
			
		}
		
		public function killPlayback():void {
	
			rehersalVideo.clear();
			playbackCB.removeEventListener(Event.CHANGE,playbackHandeler); 
			removeChild(playbackCB);
			removeChild(rehersalVideo);
			rehersalVideo.removeEventListener(VideoControlsEvent.STATE_UPDATE, onStateUpdate);
		} 
			
		
		public function onStateUpdate(evt:VideoControlsEvent):void  {
       
	   		//trace("onStateUpdate() >>> " + evt.data);
		}
	
	} // end of class

} // end of package
