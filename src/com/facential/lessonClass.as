﻿/**********************************************************************************************************************************/
/******           Class written by Tim Lanham   copyright Facential,LLC   2016  all rights reserved                           *****/
/******           This is the main class file that controls the lessons. Most stage assetts are called                        *****/
/******           from this class.      Last edit 1/10/16                                                                    *****/
/******                                                                                                                       *****/
/**********************************************************************************************************************************/

package  com.facential{

	import flash.display.*;
	import flash.events.*;
	import fl.controls.*;
	import fl.data.DataProvider; 
	import flash.filesystem.*;
	import com.facential.*;
	import flash.net.*;
	import flash.text.*
	import flash.media.*;
	import com.apdevblog.events.video.VideoControlsEvent;
	import com.apdevblog.examples.style.CustomStyleExample;
	import com.apdevblog.ui.video.ApdevVideoPlayer;
	import com.apdevblog.ui.video.ApdevVideoState;
	
	public class lessonClass extends MovieClip {
		
		var xPlain:boxerClass;
		var loadBox1:boxerClass;
		var loadBox2:boxerClass;
		var loadBox3:boxerClass;
		var Tobj:Object;
		var modulesCB:ComboBox; 
		var convertedTakesArray:Array = new Array;
		var lessonPrefix:String;
		var explainationBoxButton:Button;
		var rehearseButton:Button;	
		var nextButton:Button;	
		var prevButton:Button;
		var afile:File;
		var bfile:File;
		var cfile:File;
		var lessonNumberSelected:int;
		var rehearseMode:Boolean = false;
		var lessonProgressBar:ProgressBar;
		var lessonText:TextField = new TextField();
		var Xviewer:Boolean;
		var Lviewer:Boolean;

		
	public function lessonClass (_Tobj:Object,_Xviewer:Boolean,_Lviewer:Boolean) { // lessonClass constructor
		   
		Tobj = _Tobj;
		Xviewer = _Xviewer;
		Lviewer = _Lviewer;
		
		addEventListener(Event.ADDED_TO_STAGE, init);

	} // end of constructor
			
			
		private function init (evt:Event):void {
				
			removeEventListener(Event.ADDED_TO_STAGE, init);

			lessonPrefix = Tobj.Xvideo.substr(0,3);
			convertedTakesArray.length = 0;
	
			for (var l:String in Tobj.vrTakes) { // converts takes to appPath 
				
				var tkfile:File = File.applicationStorageDirectory.resolvePath("lessons/" + Tobj.vrTakes[l]);
				if (Tobj.vrTakes[l] !="")  convertedTakesArray.push(tkfile.url);
				
			} // end of for

			modulesCB = new ComboBox();
			modulesCB.width = 350;  //  fills modules comboBox with the available modules within each lessons
			modulesCB.height = 25;
			modulesCB.dropdownWidth = 350; 		  
			modulesCB.dropdown.rowHeight = 22;
			modulesCB.textField.height = 32;
			modulesCB.move(400, 75);
			modulesCB.prompt = "Select a Lesson"; 
			modulesCB.dataProvider = new DataProvider(Tobj.lessons); 
			modulesCB.addEventListener(Event.CHANGE,lessonHandeler); 
			addChild(modulesCB);
			
			explainationBoxButton = new Button();
			explainationBoxButton.toggle = true;
			explainationBoxButton.label = "Click to minimize explaination";
			explainationBoxButton.width = 350;
			
			explainationBoxButton.move(400, 125);
			explainationBoxButton.addEventListener(MouseEvent.CLICK, explainationButtonHandler);
			explainationBoxButton.enabled = false;
			addChild(explainationBoxButton);
		
		
			/*rehearseButton = new Button();
			rehearseButton.toggle = true;
			rehearseButton.width = 156;
			rehearseButton.height = 20;
			rehearseButton.label = "Rehearse";
			rehearseButton.move(538, 730);
			rehearseButton.addEventListener(MouseEvent.CLICK, rehearseButtonHandler);
			rehearseButton.enabled = false;
			addChild(rehearseButton);*/
			
			
						
			lessonText.border = true;
 			lessonText.borderColor = 0x000000;
			lessonText.x = 40;
			lessonText.y = 730;
			lessonText.width = 150;		
			lessonText.height = 18;		
			lessonText.background = true;
			lessonText.backgroundColor = 0Xffffff;
			addChild(lessonText);
			
			nextButton = new Button();
			nextButton.width = 120;
			nextButton.height = 20;
			nextButton.label = "Next Lesson";
			nextButton.move(210, 730);
			nextButton.addEventListener(MouseEvent.CLICK, nextButtonHandler);
			nextButton.enabled = false;
			addChild(nextButton);
			
			prevButton = new Button();
			prevButton.width = 120;
			prevButton.height = 20;
			prevButton.label = "Previous Lesson";
			prevButton.move(350, 730);
			prevButton.addEventListener(MouseEvent.CLICK, prevButtonHandler);
			prevButton.enabled = false;
			addChild(prevButton);
			
			lessonProgressBar = new ProgressBar();
        	lessonProgressBar.x = 480;
        	lessonProgressBar.y = 730;
			lessonProgressBar.height = 18;
			lessonProgressBar.width = 350;
			lessonProgressBar.mode = ProgressBarMode.MANUAL;
			lessonProgressBar.setStyle("barSkin", mySkin);
        	addChild(lessonProgressBar);
		
	        var xfile:File = File.applicationStorageDirectory.resolvePath("lessons/" + Tobj.Xvideo);
			xPlain = new boxerClass(Tobj.Xheader,Tobj.Xtext,xfile.url,0,"BIG"); // add new explaination to the stage
			xPlain.x = 40;
			xPlain.y = 160;
			addChild(xPlain);
			/*if(viewer) {
				xPlain.visible = false;
				xPlain.stopVideo();
				lessonHandeler(null);
			}*/
     
		}// end of init			
			

		private function lessonHandeler (event:Event):void {
			
			xPlain.stopVideo(); // stops the explaination video
			xPlain.minimizeBoxer(); // minimizes xPlaination box
            explainationBoxButton.label = "Click to view explaination";
			explainationBoxButton.selected = false;
			explainationBoxButton.enabled = true;
			nextButton.enabled = true;
			
			if (modulesCB.selectedIndex == 0) 
				prevButton.enabled = false; 
			else
				prevButton.enabled = true;

			if(loadBox1)loadBox1.removeBoxer();
			if(loadBox2)loadBox2.removeBoxer();
			if(loadBox3)loadBox3.removeBoxer();
			
			lessonNumberSelected = modulesCB.selectedIndex;
            lessonMover(lessonNumberSelected);
			lessonProgressBar.setProgress(lessonNumberSelected+1,Tobj.lessons.length);
			lessonText.text =Tobj.lessons[lessonNumberSelected];
			if (lessonNumberSelected +1 == Tobj.lessons.length) nextButton.enabled = false;
				
		}  // end of moduleHandeler			
		
		
		public function getTakesArray():Array{
			
			return convertedTakesArray;
		}
			
			
		public function getLessonPrefix():String {
			
			return lessonPrefix;
		}
							
						
		private function explainationButtonHandler(e:MouseEvent):void {

    		if(e.target.selected==false){

				explainationBoxButton.label = "Click to view explaination";
				xPlain.minimizeBoxer();
				if (xPlain.getVideoState() == "videoStatePlaying")
				xPlain.stopVideo();
				if (loadBox1) loadBox1.restoreBoxer();
				if (loadBox2) loadBox2.restoreBoxer();
				if (loadBox3) loadBox3.restoreBoxer(); 

				
    		} else {
				 
				explainationBoxButton.label = "Click to minimize explaination"
                xPlain.restoreBoxer();
				xPlain.playVideo();
				if (loadBox1){
                	loadBox1.minimizeBoxer();
					if (loadBox1.getVideoState() == "videoStatePlaying")
					loadBox1.stopVideo();
				}
				if (loadBox2) {
					loadBox2.minimizeBoxer();
					if (loadBox2.getVideoState() == "videoStatePlaying")
					loadBox2.stopVideo();
				}
				if (loadBox3) {
					loadBox3.minimizeBoxer();
					if (loadBox3.getVideoState() == "videoStatePlaying")
					loadBox3.stopVideo();
				}
				
    		} // end of if
			
	  	} // end of explainationButtonHandler	
		
	
		public function killEverything ():void {
			
			xPlain.removeBoxer();
			removeChild(xPlain);
			if(loadBox1){loadBox1.removeBoxer();
			removeChild(loadBox1);}
			if(loadBox2){loadBox2.removeBoxer();
			removeChild(loadBox2);}
			if(loadBox3){loadBox3.removeBoxer();
			removeChild(loadBox3);}
			removeChild(modulesCB);
			removeChild(explainationBoxButton);
			removeChild(lessonProgressBar);
			removeChild(nextButton);
			removeChild(prevButton);
			removeChild(lessonText);
			
		} // end of killEverything
		
	   
	   	public function rehearseButtonHandler (evt:Event):void{
			
			if(evt.target.selected==false){
				rehearseMode = false;
				loadBox2.visible = true;
				loadBox1.x = 30;

    		} else {
				
				rehearseMode = true;
				loadBox2.visible = false;
				loadBox1.x = 460;
				
    		} // end of if
			
		}  // end of rehearseButtonHandler
		
		 
		public function nextButtonHandler (evt:Event):void{
	
			if (Tobj.lessons.length == (lessonNumberSelected +2)) nextButton.enabled = false;
			prevButton.enabled = true;
			if(loadBox1)loadBox1.removeBoxer();
			if(loadBox2)loadBox2.removeBoxer();
			if(loadBox3)loadBox3.removeBoxer();
			lessonMover(lessonNumberSelected +1);
			lessonNumberSelected++;
			lessonProgressBar.setProgress((lessonNumberSelected+1),Tobj.lessons.length);
			modulesCB.prompt = Tobj.lessons[lessonNumberSelected]; 
			lessonText.text =Tobj.lessons[lessonNumberSelected];

	 	} // end of nextButtonHandler
		
		 	 
		public function prevButtonHandler (evt:Event):void{ 
		
			if (lessonNumberSelected == 1) prevButton.enabled = false; else prevButton.enabled = true;
			nextButton.enabled = true;
		    if(loadBox1)loadBox1.removeBoxer();
			if(loadBox2)loadBox2.removeBoxer();
			if(loadBox3)loadBox3.removeBoxer();
		 	lessonMover(lessonNumberSelected -1);
			lessonNumberSelected--;
			lessonProgressBar.setProgress((lessonNumberSelected+1),Tobj.lessons.length);
			modulesCB.prompt = Tobj.lessons[lessonNumberSelected]; 
			lessonText.text =Tobj.lessons[lessonNumberSelected];
			
		}// end of prevButtonHandler

		
		private function lessonMover (lessonIndex:int):void {
			
			
			if (Tobj.topicType == "multi"){
				
				afile = File.applicationStorageDirectory.resolvePath("lessons/" + Tobj.Qmovies[lessonIndex]);
            	loadBox1 = new boxerClass(Tobj.Qheader,Tobj.explanations[lessonIndex],afile.url,1,"SMALL");
				loadBox1.x = 30;
				loadBox1.y = 165;
				loadBox1.addEventListener("THE_VIDEO_IS_COMPLETE", playLoadBox2);
				addChild(loadBox1);
				
				bfile = File.applicationStorageDirectory.resolvePath("lessons/" + Tobj.Pmovies[lessonIndex]);
            	loadBox2 = new boxerClass(Tobj.Pheader,Tobj.prompts[lessonIndex],bfile.url,1,"SMALL");
				loadBox2.x = 30;
				loadBox2.y = 165;
				loadBox2.addEventListener("THE_VIDEO_IS_COMPLETE", playLoadBox3);
				addChild(loadBox2);
				loadBox2.visible = false;
				loadBox2.stopVideo();
				
                cfile = File.applicationStorageDirectory.resolvePath("lessons/" + Tobj.RMmovies[lessonIndex]);
                loadBox3 = new boxerClass(Tobj.RMheader,Tobj.responses[lessonIndex],cfile.url,1,"SMALL");
				loadBox3.x = 460;
				loadBox3.y  = 165;
				addChild(loadBox3);
				loadBox3.stopVideo();
				
				
			} else if (Tobj.topicType == "dual"){
			
				afile = File.applicationStorageDirectory.resolvePath("lessons/" + Tobj.Pmovies[lessonIndex]);
            	loadBox1 = new boxerClass(Tobj.Pheader,Tobj.prompts[lessonIndex],afile.url,1,"SMALL");
				loadBox1.x = 30;
				loadBox1.y = 165;
				loadBox1.addEventListener("THE_VIDEO_IS_COMPLETE", playLoadBox2);
				addChild(loadBox1);
				
				bfile = File.applicationStorageDirectory.resolvePath("lessons/" + Tobj.RMmovies[lessonIndex]);
            	loadBox2 = new boxerClass(Tobj.RMheader,Tobj.responses[lessonIndex],bfile.url,1,"SMALL");
				loadBox2.x = 460;
				loadBox2.y = 165;
				addChild(loadBox2);
				loadBox2.stopVideo();
				
			} else {
			
				afile = File.applicationStorageDirectory.resolvePath("lessons/" + Tobj.Pmovies[lessonIndex]);
            	loadBox1 = new boxerClass(Tobj.Pheader,Tobj.prompts[lessonIndex],afile.url,1,"BIG");
				loadBox1.x = 40;
				loadBox1.y = 160;
				addChild(loadBox1);
				
			} // end of if / else
			
		} // end of lessonMover
				


		function playLoadBox2 (e:Event):void {
			
			if (rehearseMode == false){
				
			loadBox2.playVideo();
			loadBox2.visible = true;
			}
		}
		
		
		function playLoadBox3 (e:Event):void {
			
			if (rehearseMode == false) {
				
				if (loadBox3) {	
					loadBox3.playVideo();
					loadBox1.visible = false;
					
				}
			}

		} // end of playLoadBox3
		
		
    } // end of lessonsClass definition


} // end of package