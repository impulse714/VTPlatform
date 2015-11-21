package com.facential {
	
	import flash.display.*;
	import flash.filesystem.File;
	import flash.text.*;
	import air.net.*;
	import flash.events.*;
	import flash.net.*;
	import fl.controls.*;
	import flash.geom.*;
	import fl.data.DataProvider;
	import com.facential.util.*;

	
	public class fileGetter extends MovieClip {
		
		public static const DOWNLOADCOMPLETE:String = "DOWNLOAD_IS_COMPLETE";  
		
		private var downloadCompleteEvent:Event = new Event(DOWNLOADCOMPLETE);
		
		var file:File;
		var bkgdBox:Shape;
		var outerBkgdBox:Shape;
		var fileIndex:int;
		var FDLstring:String;
		var FDLarray:Array;
		var DLdir:String;
		var DLarray:Array;
		var downloadButton:Button;
		var completedText:TextField;
		var progressBar:ProgressBar;
		var chooseDownload:ComboBox;
		var fileDownload:Sprite;
		var CBdata:Array;
		var directoryString = "http://www.hotshotrecords.us/downloads/";
		var tempStringFile:String;
		var inArray:Array = new Array();
		var _DLdirectory:String;
		var array:Array = new Array();
										  
		var demoArray:Array = new Array ("pst.fac","pstExplanation.mp4","pstPrompt1.mp4",
										"pstPrompt2.mp4","pstPrompt3.mp4","pstPrompt4.mp4","pstPrompt5.mp4","brain.jpg");				   
		  
							
		public function fileGetter (_array:Array) {
		
			array = _array;
			outerBkgdBox = new Shape; // initializing the first box
			outerBkgdBox.graphics.beginFill(0x666666); // choosing the colour for the fill (grey)
			outerBkgdBox.graphics.drawRoundRect(0, 0, 390, 130, 5, 5) // (x, y, width, height, )
			outerBkgdBox.graphics.endFill(); 
			addChild(outerBkgdBox);
			
			bkgdBox = new Shape; // initializing the first box
			bkgdBox.graphics.beginFill(0xcccccc); // choosing the colour for the fill (grey)
			bkgdBox.graphics.drawRoundRect(5, 5, 380, 120, 5, 5) // (x, y, width, height, )
			bkgdBox.graphics.endFill(); 
			addChild(bkgdBox);
			
			completedText = new TextField();
			completedText.width = 300;
			completedText.x = 110;
			completedText.y = 60;
 			addChild(completedText);	
			
			progressBar = new ProgressBar();
        	progressBar.x = 85;
        	progressBar.y = 90;
			progressBar.height = 10;
			progressBar.width = 200;
			progressBar.visible = false;
        	addChild(progressBar);
			
		
			if (array !=null){
				
				
				for (var k:int = 0; k < _array.length; k++) { 
          
					var downLoader2:Downloader = new Downloader();
   					file = File.applicationStorageDirectory.resolvePath( _array[k].toLowerCase() + ".fac");			
					tempStringFile = directoryString + _array[k] + "/" + _array[k].toLowerCase() +".fac";
					downLoader2.download(tempStringFile, file);
			    	inArray.push(tempStringFile);
					if (k == _array.length - 1) downloadComplete2();
				
				} // end of for
			
			
				chooseDownload = new ComboBox();
				chooseDownload.width = 350;     
				chooseDownload.dropdownWidth = 300; 		  
				chooseDownload.move(20,30);
				chooseDownload.prompt = "Select a Topic to Download"; 
				chooseDownload.addEventListener(Event.CHANGE,downloadHandeler); 
				addChild(chooseDownload); 
			
			} else {
		      
			  	completedText.text = "The demo files are downloading";
			 	FDLstring = "PST"; 
			 	FDLarray = demoArray;
				fileIndex = 0;
				getFiles();
				fileIndex++
				
			} // end of if else
	
		} // end of constructor
		
		
		private function downloadComplete2():void {
			
			for (var j:String in inArray) {
			
				var loadTemp:URLLoader = new URLLoader(); // creates instance of loader class
					loadTemp.dataFormat = URLLoaderDataFormat.VARIABLES; // telling the loader that we are dealing with variables 
					loadTemp.addEventListener(Event.COMPLETE, processTemp); // calls the function to process the lesson file
					loadTemp.load(new URLRequest(inArray[j])); // name of the lesson file to process
			}
			
		} // end of downloadComplete2
		
		
		private function processTemp (e:Event):void {
			
			var finalArray:Array;
			var temp:Array;
			var _topicType:String = e.target.data.topicType;
		    var _Xvideo:String = e.target.data.Xvideo;
				_DLdirectory = _Xvideo.slice(0,3); 	
			var _topicName:String = e.target.data.topicName;
			var _Pmovies = e.target.data.Pmovies.split(","); 

			if (_topicType == "multi") {
				
				var _Qmovies = e.target.data.Qmovies.split(",");
				temp = _Pmovies.concat(_Qmovies);
				
				var _RMmovies = e.target.data.RMmovies.split(",");
				finalArray = temp.concat(_RMmovies);
				finalArray.push(_Xvideo);
				
			} else if (_topicType == "dual") {
				
				var _Qmovies = e.target.data.Qmovies.split(",");
				finalArray = _Pmovies.concat(_Qmovies);
				finalArray.push(_Xvideo);
				
			} else {
				finalArray = _Pmovies;
				finalArray.push(_Xvideo);
			}
			
			
			chooseDownload.addItem ({label:_topicName,DLdir:_DLdirectory.toUpperCase(),DLarray:finalArray});
			
		} // end of processTemp
		
		
		private function getFiles ():void {
			
			var downLoader:Downloader = new Downloader();
			downLoader.addEventListener(DownloadEvent.DOWNLOAD_COMPLETE,downloadComplete);
   			file = File.applicationStorageDirectory.resolvePath("lessons/" + FDLarray[fileIndex]);
			downLoader.download(directoryString +  FDLstring +"/" + FDLarray[fileIndex], file);

		} // end of function getFiles
		
		
		private function downloadComplete (event:DownloadEvent):void{
			
			completedText.text = "Your files are downloading";
	        if (FDLarray.length != fileIndex){ 
			
			 	getFiles(); 
			 	fileIndex++;
			 	progressBar.visible = true;
			 	progressBar.mode = ProgressBarMode.MANUAL;
    		 	progressBar.setProgress(fileIndex -1,FDLarray.length);
			 
			} else {
			
				progressBar.visible = false;
				completedText.text =  fileIndex-1 + "    files were successfully downloaded";
				
				if(array != null){
					var original:File = File.applicationStorageDirectory.resolvePath(FDLstring.toLowerCase() + ".fac"); 
					var newFile:File = File.applicationStorageDirectory.resolvePath("lessons/" +FDLstring.toLowerCase()+ ".fac"); 
					original.copyTo(newFile, true); 
				}
				
				dispatchEvent(downloadCompleteEvent);
				
			} // end of if / else
			
		} // end of downloadComplete


        private function downloadHandeler (ev:Event):void {
		
			 	completedText.text = "";
			 	FDLstring = ev.target.selectedItem.DLdir; 
			 	FDLarray = ev.target.selectedItem.DLarray; 
				fileIndex = 0;
				getFiles();
				fileIndex++
			 
		} // end of downloadHandeler


	} // end of class definition
	
} // end of package