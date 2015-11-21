/***********************************************************************************************************************/
/*****                       Prodigy application written by Tim Lanham   latest mod  11/20/2015                     ****/
/*****                        Main document class for the application.                                              ****/
/*****                    Copyright  Facential, LLC   2015   all rights reserved                                    ****/
/*****                                                                                                              ****/
/***********************************************************************************************************************/

package  {
	
	import flash.display.*;
	import fl.data.DataProvider;
	import flash.filesystem.*;
	import com.facential.*;	
	import flash.net.*;
	import flash.events.*;
	import fl.controls.*;
	import flash.text.*;
	import flash.ui.*;
	import flash.media.*;
	import flash.utils.*;
	import com.apdevblog.events.video.VideoControlsEvent;
	import com.apdevblog.examples.style.CustomStyleExample;
	import com.apdevblog.ui.video.ApdevVideoPlayer;
	import com.apdevblog.ui.video.ApdevVideoState;
	import flash.desktop.NativeApplication;
	import air.net.*;

	[SWF(width=1280,height=760, frameRate='60',backgroundColor="0x999999")]	
	
	public class Document extends MovieClip {
		
		//  the  6 main classes used in the program 
        var lessons:lessonClass; 
		var webcamRecorder:videoClass;
		var login:loginClass;
		var playBack:playbackClass;
		var exitBox:messageBoxClass;
		var noLessonsMbx:messageBoxClass;
		
		var top:Sprite = new Sprite();
		var bottom:Sprite = new Sprite();
		var viewTopicX:Boolean = false;
		var viewLessonX:Boolean = false;
		
		var topicsCB:ComboBox = new ComboBox(); // ComboBox with list of lessons available
		var camMinMaxBtn:Button;
		var monitor:URLMonitor; // used for checking for an internet connection
		var topicNames:Array = new Array(); // array of topic names to fill combo box
		var cleanArray:Array = new Array(); // array of only .fac files 
		var availableTopics:Array;
		var directory:File = File.applicationStorageDirectory.resolvePath("lessons"); //directory of lessons subdirectory
		var FACdownLoader:fileGetter;
		var demo:fileGetter;
		var tArray:Array = new Array();
		var noNetworkMbx:messageBoxClass;
		var SB:sideBarClass;
											
	
	public function Document ():void {
		
    	this.addEventListener(Event.ADDED_TO_STAGE, init);
		
	} // end of the main Document class
		
		
	function init (e:Event) {
		
		this.removeEventListener(Event.ADDED_TO_STAGE, init);
		stage.nativeWindow.addEventListener(Event.CLOSING, closeApplication, false, 0, true);
			
		addChild(bottom);
		addChild(top);
			
		var facentialLogo:logo = new logo(); // places logo on stage  (jpg in library as movie clip)
		facentialLogo.x=20;
		facentialLogo.y=10;
		bottom.addChild(facentialLogo);
			
		checkInternetConnection(); // checks the Internet Connection and exits if it fails
	
	} // end of init  (the constructor)
	


	function loggedIN (e:Event):void{ 
	
			SB = new sideBarClass(login.returnArray);
			SB.x=1060;
			top.addChild(SB);
			
			camMinMaxBtn = new Button();
   			camMinMaxBtn.label = "Deactivate camera and playback"; 
			camMinMaxBtn.width = 300;
   			camMinMaxBtn.selected = true;    
			camMinMaxBtn.toggle = true;  
  			camMinMaxBtn.addEventListener(MouseEvent.CLICK,camMinMax);
			camMinMaxBtn.move(920,18);
			camMinMaxBtn.visible = false;
			bottom.addChild(camMinMaxBtn);
	
			if (!webcamRecorder) {
				
				webcamRecorder = new videoClass();
				webcamRecorder.addEventListener(Event.COMPLETE, onVideoSaved);
				webcamRecorder.addEventListener("RECORD", onRecord);
				webcamRecorder.addEventListener("SAVED", onFileSaved);
				webcamRecorder.x = 860;
				webcamRecorder.y = 50;
				webcamRecorder.visible = false;
				bottom.addChild(webcamRecorder);
				
			}  // end of if for adding the webcam
			
			if(directory.exists) {
				
				availableTopics = directory.getDirectoryListing(); // array of raw files from the lesson directory
				
				for (var i:String in availableTopics) { // cleans the array to contain only .fac files
				
					if (availableTopics[i].extension == "fac" ) cleanArray.push(availableTopics[i]);
				 	
				} // end of for loop for cleaning the array
				
				if (cleanArray.length != 0) {  // checks that there are lessons to process else message box is called
		
					for (var k:String in cleanArray) { // loop for parssing the clean array
				
						var actualFile:File = File.applicationStorageDirectory.resolvePath("lessons/" +cleanArray[k].name);
						var loadTopicFile:URLLoader = new URLLoader(); // creates instance of loader class
							loadTopicFile.dataFormat = URLLoaderDataFormat.VARIABLES; //  we are dealing with variables 
							loadTopicFile.addEventListener(Event.COMPLETE, processTopicFile); // function to process the lesson file
							loadTopicFile.load(new URLRequest(actualFile.url)); // name of the lesson file to process

					} // end of for loop for parsing the clean array
						
				} else {
					
					demo = new fileGetter(null);
					demo.addEventListener("DOWNLOAD_IS_COMPLETE",demoDownload);
					demo.x = 440;
					demo.y = 300;
					addChild(demo);
						
				} // end of if/else that lessons exist if not download the demo
		
			} else {

					directory.createDirectory();
					loggedIN(null);
				
 			} // end of if/else that the directory exists
			
		
		} // end of loggedIN
	
		
	private function processTopicFile (event:Event):void { // Processes the topic file 
  		
			topicNames.push(event.target.data.topicName); // keep adding the lesson name to the array  to be displayed

			if (topicNames.length == cleanArray.length)  { // when the lesson array is filled then load it in a combo box
		
				topicsCB.width = 350;     // fills lesson comboBox with the available lessons and puts it on the stage
				topicsCB.height = 25;
				topicsCB.dropdownWidth = 350; 		  
				topicsCB.dropdown.rowHeight = 22;
				topicsCB.textField.height = 32;
				topicsCB.move(400,30);
				topicsCB.prompt = "Select a Topic"; 
				topicsCB.dataProvider = new DataProvider(topicNames); 
				topicsCB.addEventListener(Event.CHANGE,topicHandeler); // calls lessonHandeler to parse and process the lesson file
				addChild(topicsCB); 

			} // end of if
				   
		} // end of processTopicFile
	
	
	private function topicHandeler (event:Event):void { 
	
			var loadTopic:URLLoader = new URLLoader(); // creates instance of loader class
				loadTopic.dataFormat = URLLoaderDataFormat.VARIABLES; // telling the loader that we are dealing with variables 
				loadTopic.addEventListener(Event.COMPLETE, processTopic); // calls the function to process the lesson file
				loadTopic.load(new URLRequest(cleanArray[event.target.selectedIndex].url)); // name of the lesson file to process
				
	} // end of function lessonHandeler
	
	
	private function processTopic (event:Event):void {
		
		if (lessons) lessons.killEverything();
		
			var dataObject:Object = {topicName:String,
									 isEditable:String,
									 viewTopicX:String,
									 viewLessonX:String,
									 topicType:String,
									 Xheader:String,
									 Xtext:String,
		                        	 Xvideo:String,
								 	lessons:Array,
								 	Qheader:String, 
								 	explanations:Array,
								 	Qmovies:Array,
								 	Pheader:String,
								 	prompts:Array, 
								 	Pmovies:Array,
								 	RMheader:String,
								 	responses:Array,
								 	RMmovies:Array,
								 	vrTakes:Array };
								 
		try {
			
			var _topicName:String = event.target.data.topicName;
				dataObject.topicName = _topicName;		
								
			var _topicType:String = event.target.data.topicType;
				dataObject.topicType = _topicType
							
			var _isEditable:String = event.target.data.isEditable;
				dataObject.isEditable = _isEditable;
				
			var _viewTopicX:String = event.target.data.viewTopicX;
				dataObject.viewTopicX = _viewTopicX;
				
				if (_viewTopicX == "yes") viewTopicX = true;
								
			var _viewLessonX:String = event.target.data.viewLessonX;
				dataObject.viewLessonX = _viewLessonX;
				
				if (_viewLessonX == "yes") viewLessonX = true;

			var _Xheader:String = event.target.data.Xheader;
				dataObject.Xheader = _Xheader;	
				
			var _Xtext = event.target.data.Xtext;
				dataObject.Xtext = _Xtext;
			
			var _Xvideo = event.target.data.Xvideo;
				dataObject.Xvideo = _Xvideo;
			
			var _lessons = event.target.data.lessons.split(",");
				 dataObject.lessons = _lessons;
			
			var _Pheader = event.target.data.Pheader;
				dataObject.Pheader = _Pheader;
		
			var _prompts = event.target.data.prompts.split(",");
				dataObject.prompts = _prompts;
				
			var _Pmovies = event.target.data.Pmovies.split(","); 
				dataObject.Pmovies = _Pmovies;			
				
			var _RMheader = event.target.data.RMheader;
				dataObject.RMheader = _RMheader;
				
			var _responses = event.target.data.responses.split(","); 
				dataObject.responses = _responses;
				
			var _RMmovies = event.target.data.RMmovies.split(",");  
				dataObject.RMmovies = _RMmovies;
					
			var _Qheader = event.target.data.Qheader;
				dataObject.Qheader = _Qheader;
				
			var _explanations = event.target.data.explanations.split(","); 
				dataObject.explanations = _explanations;
				
			var _Qmovies = event.target.data.Qmovies.split(",");  
				dataObject.Qmovies = _Qmovies;
				
			var _vrTakes = event.target.data.vrTakes.split(",");
				dataObject.vrTakes = _vrTakes;
					
			
 		} catch (err:Error){ 
		
 			var coruptLessonsMbx:messageBoxClass = new messageBoxClass("File error",
				"The lesson you are trying to load is corupt. The application will now close.","Retry","Exit", "Corupt");
				
			addChild(coruptLessonsMbx);
				
		} // end of try catch
		
		lessons = new lessonClass(dataObject);
 		bottom.addChild(lessons);
		
		camMinMaxBtn.visible = true;
		webcamRecorder.lessonGlobalPrefix = lessons.getLessonPrefix();
		webcamRecorder.visible = true;
		if(playBack){
        	playBack.killPlayback();
       	 	bottom.removeChild(playBack);
		}
		
		playBack = new playbackClass();
		playBack.visible = true;
		bottom.addChild(playBack);	
		playBack.addArray(lessons.getTakesArray());
		
		SB.add2list(_lessons);
		
	} // end of processTopic
	
		
	function demoDownload (e:Event):void{

		removeChild(demo);
		loggedIN(null);
		
	} // end of deomDownload
	
	
	private function checkInternetConnection (e:Event = null):void {
			
		var url:URLRequest = new URLRequest("http://www.google.com");
			url.method = "HEAD";
			monitor = new URLMonitor(url);
			monitor.pollInterval = 3000;
			monitor.addEventListener(StatusEvent.STATUS,onConnection);
			monitor.start();
			
	} // end of function checkInternetConnection
	
	
	private function onConnection (e:Event = null):void {
				
		if (monitor.available) {
		
			login = new loginClass(); // initializies the stage with initial login assets
			login.addEventListener("THE_USER_LOGGED_IN", loggedIN);
			login.addEventListener("OFFLINE_LOGIN", loggedIN);
			top.addChild(login);
		
				
		} else {
				
			noNetworkMbx = new messageBoxClass("Network error",
			"No Internet connection. Check your connection or select offline mode.","Retry","OK", "Network");
			noNetworkMbx.addEventListener("CANCEL",cancelNetwork);
			addChild(noNetworkMbx);
			login = new loginClass(); // initializies the stage with initial login assets
			login.addEventListener("THE_USER_LOGGED_IN", loggedIN);
			login.addEventListener("OFFLINE_LOGIN", loggedIN);
			top.addChild(login);
			}
			
		} // end of onConnection


	function onRecord (e:Event):void{
			
		playBack.clearVideo();
		
	} // end of onRecord
	
			
	function onVideoSaved (e:Event):void {

		playBack.addFile(webcamRecorder.getRecordedFile());

	} // end of onVideoSaved
		
		
	function onFileSaved (e:Event):void{
			
		playBack.addToDataprovider(webcamRecorder.getSavedFile().url);
	    
	} // end of onFileSaved
			
		
	function camMinMax (e:MouseEvent):void {

    	if(e.target.selected==true){  
					
			camMinMaxBtn.label = "Deactivate camera and playback";
			
			webcamRecorder.maximizeRecorderAssets();
			playBack.maximizePlaybackAssets();
			webcamRecorder.visible = true;
			playBack.visible = true;
			
    	} else {  
					
			camMinMaxBtn.label = "Activate camera and playback";
			
			webcamRecorder.minimizeRecorderAssets();
			if (playBack)playBack.minimizePlaybackAssets()
		
    	} // end of if / else
			
	} // end of camMinMax
		
		
	function closeApplication (e:Event):void{
				
		e.preventDefault(); 
		exitBox = new messageBoxClass("Exit","Are you sure you want to exit?      Your work will automatically be saved.",
				"Cancel", "Exit","Exit");
		exitBox.addEventListener("CANCEL", onCancel);
		addChild(exitBox);
				 
	} // end of closeApplication
	
		
	function onCancel (e:Event):void {
		
		removeChild(exitBox);
		
	} // end of onCancel
	
	
	function cancelNetwork (e:Event):void {
		
		removeChild(noNetworkMbx);
		
	} // end of cancelNetwork
	
	
	/*function onRelogin(e:Event):void{
		
		NativeApplication.nativeApplication.exit();
		
	} // end of onRelogin
	
		
	function loggedOUT (e:Event):void{
		
		e.preventDefault(); 
		exitBox = new messageBoxClass("Exit",
		"Are you sure you want to logout and exit?      Your work will automatically be saved.", "Cancel", "Logout","Logout");
		
		exitBox.addEventListener("CANCEL", onCancel);
		exitBox.addEventListener("RELOGIN", onRelogin);
		
		addChild(exitBox);
		
	} // end of loggedout
	
	
	private function downloadHandeler (ev:Event):void{

		cleanArray.splice(0,cleanArray.length);
		availableTopics.splice(0,availableTopics.length);
		topicNames.splice(0,topicNames.length);

		removeChild(topicsCB);
		removeChild(FACdownLoader);
		loggedIN(null);
			
	} // end of downloadHandeler*/


	} // end of class definition
	
}// end of package

