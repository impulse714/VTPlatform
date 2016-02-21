package  com.facential {
	
	import flash.display.*;
	import flash.events.*;
	import fl.controls.*;
	import flash.filesystem.*;
	import com.facential.*;	
	import fl.data.DataProvider; 
	
	public class sideBarClass extends MovieClip {
		
		var bkgdBox:Shape;
		var downloadBtn:Button;
		var spt:Sprite;
		var sbMinMaxBtn:Button;
		public var topicXbox:CheckBox;
		public var xBoxstatus:Boolean = true;
		public var lessonXbox:CheckBox;
		public var lBoxstatus:Boolean = true;
		public var sbLessonIndex:int;
		var clearDirectoryBtn:Button;
		var FACdownLoader:fileGetter;
		var dArray:Array
		var aList:List;
		

		public function sideBarClass (_dArray:Array) {
			
		 	addEventListener(Event.ADDED_TO_STAGE, init);
			dArray = _dArray;

		}// end of constructor
		
		
		public function init (evt:Event):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			spt = new Sprite();
			spt.visible = false;
			addChild(spt);
			
			bkgdBox = new Shape; // initializing the first box
			bkgdBox.graphics.beginFill(0xcccccc); // choosing the colour for the fill (grey)
			bkgdBox.graphics.drawRect(0, 0, 220, 760) // (x, y, width, height, )
			bkgdBox.graphics.endFill(); // not always needed but I like to put it in to end the fill
			spt.addChildAt(bkgdBox,0);
			
			topicXbox = new CheckBox();
			topicXbox.label = "View Topic Explaniation";
			topicXbox.x = 30;
			topicXbox.y = 550;
			topicXbox.width = 170;
			topicXbox.selected = true;
			topicXbox.addEventListener(MouseEvent.CLICK, TboxClick);
			spt.addChild(topicXbox);
			
			lessonXbox = new CheckBox();
			lessonXbox.label = "View Topic Explaniation";
			lessonXbox.x = 30;
			lessonXbox.y = 600;
			lessonXbox.width = 170;
			lessonXbox.selected = true;
			lessonXbox.addEventListener(MouseEvent.CLICK, LboxClick);
			spt.addChild(lessonXbox);
			
			clearDirectoryBtn = new Button();
			clearDirectoryBtn.toggle = true;
			clearDirectoryBtn.label = "Clear Directory";
			clearDirectoryBtn.width = 100;
			clearDirectoryBtn.move(50,705);
			clearDirectoryBtn.addEventListener(MouseEvent.CLICK, clearBtnHandeler);
			spt.addChild(clearDirectoryBtn);
			
			sbMinMaxBtn = new Button();
			sbMinMaxBtn.toggle = true;
			sbMinMaxBtn.label = "<";
			sbMinMaxBtn.width = 20;
			sbMinMaxBtn.height = 20;
			sbMinMaxBtn.move(200,0);
			sbMinMaxBtn.addEventListener(MouseEvent.CLICK, sbMinMaxBtnHandeler);
			addChild(sbMinMaxBtn);
			
			
			aList = new List();
			aList.dataProvider = new DataProvider(dArray);
			aList.setSize(180, 200); 
			aList.move(20,200); 
			spt.addChild(aList); 
			
			aList.addEventListener(Event.CHANGE, changeHandler); 
			


		} // end of init
		
		
		function changeHandler(event:Event):void { 
		
			sbLessonIndex = event.target.selectedIndex;
   				 
		}
		
		public function add2list(addLessons:Array):void {
			
			aList.dataProvider = new DataProvider(addLessons);
			
		}
		
		
		public function sbMinMaxBtnHandeler (evt:Event):void{
			
			if(evt.target.selected==false){
				spt.visible = false;
				sbMinMaxBtn.label = "<";
				sbMinMaxBtn.x = 200;
			
    		} else {
				
				spt.visible = true;
				sbMinMaxBtn.label = "X";
				sbMinMaxBtn.x = 0;
				
    		} // end of if
			
		}  // end of sbMinMaxBtnHandeler
		
			
		function TboxClick (e:Event):void {
				
			if (xBoxstatus) 
				xBoxstatus = false;
			else
				xBoxstatus = true;
				
		}// end of TboxClick
			
			
		function LboxClick (e:Event):void {
				
			if (lBoxstatus)
				lBoxstatus = false;
			else 
				lBoxstatus = true;
				
		}// end of LboxClick
			
			
		function clearBtnHandeler (e:MouseEvent):void{

			var prodigy:File = File.applicationStorageDirectory;
				prodigy.deleteDirectory(true);

		}// clearBtnHandeler
			
			
		function downloadHandeler (e:MouseEvent):void {
			
		    FACdownLoader = new fileGetter(dArray);
			FACdownLoader.addEventListener("DOWNLOAD_IS_COMPLETE", downloadComplete);
			FACdownLoader.x = 0;
			FACdownLoader.y = 0;
			addChild(FACdownLoader);
		
		} // end of downloadHandeler
			

		function downloadComplete (e:Event):void {
		
			removeChild(FACdownLoader);
			
		}// end of downloadComplete
		

	}// end of class
	
}// end of package
