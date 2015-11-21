/*****************************************************************************************************************************************/
/****                                                                                                                                 ****/
/****              Message box class. This is used to display various errors.  YOu pass in the header message and                     ****/
/****              the body of the message and it is displayed in the stage. This is not modal!!                                      ****/
/****                   Written by Tim Lanham   copyright Facential 2015  all rights reserved.                                        ****/
/****                                                                                                                                 ****/
/*****************************************************************************************************************************************/

package  com.facential {
	
	import flash.display.*;
	import flash.text.*;
	import fl.controls.Button;
	import flash.events.*;
	import flash.desktop.NativeApplication;  
	import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
	
	public class messageBoxClass extends Sprite{
		
		public static const CANCEL:String = "CANCEL";  //use this to define 
		var cancelEv:Event = new Event(CANCEL);
		public static const RELOGIN:String = "RELOGIN";  //use this to define 
		var reloginEv:Event = new Event(RELOGIN);
		public static const CORUPT:String = "CORUPT";  //use this to define 
		var coruptEv:Event = new Event(CORUPT);
		
		var eb:errorBox;
		var errorHeader:String;
		var errorMessage:String;
		var button1Label:String;
		var button2Label:String;
		var functionType:String;
		var message1Button:Button;
		var message2Button:Button;

		public function messageBoxClass (_errorHeader:String,_errorMessage:String,_button1Label:String,_button2Label:String,_functionType:String){
						
			addEventListener(Event.ADDED_TO_STAGE, init);
			errorHeader = _errorHeader;
			errorMessage = _errorMessage;
			button1Label = _button1Label;
			button2Label = _button2Label;
			functionType = _functionType;
		}
			
		function init(e:Event):void{
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
				eb = new errorBox();
				eb.x = 450;
				eb.y = 200;
				addChild(eb);
						
			var ebFormat:TextFormat = new TextFormat(); 
				ebFormat.size = 16;  
				ebFormat.font = "Arial";
				ebFormat.color = 0x000000;	
				
			var hFormat:TextFormat = new TextFormat(); 
				hFormat.size = 18;  
				hFormat.font = "Arial";
				hFormat.align = TextFormatAlign.CENTER;
				hFormat.color = 0xffffff;	
				
			var _header:TextField = new TextField();
				_header.defaultTextFormat = hFormat;
			    _header.text = errorHeader;
				_header.width = 200;
				_header.x = 120;
				_header.y = 0;
				eb.addChild(_header);
				
			var _message:TextField = new TextField();
				_message.defaultTextFormat = ebFormat;
				_message.text = errorMessage;
				_message.wordWrap = true;
				_message.width = 250;
				_message.height = 200;
				_message.x = 130;
				_message.y = 60;
				eb.addChild(_message);
				
			    message1Button = new Button();  // add camera toggle button
			    if (functionType == "Download") message1Button.visible = false;
				if (functionType == "Network") message1Button.visible = false;
				message1Button.move(150, 150);
				message1Button.label = button1Label;
				message1Button.width = 60;
				message1Button.height = 30;
				message1Button.addEventListener(MouseEvent.CLICK,messageButton1ClickHandler);
				eb.addChild(message1Button);
				
			    message2Button = new Button();  // add camera toggle button
			 	if (functionType == "Download") message2Button.visible = false;
				if (functionType == "Network") message2Button.move(190, 150); 
				else message2Button.move(230, 150);
				message2Button.label = button2Label;
				message2Button.width = 60;
				message2Button.height = 30;
				message2Button.addEventListener(MouseEvent.CLICK,messageButton2ClickHandler);
				eb.addChild(message2Button);
			
		} // end of function init 
		
		
		function messageButton2ClickHandler(event:MouseEvent):void {
				
			switch (functionType){

 			case "Exit":
 	  
				NativeApplication.nativeApplication.exit();
 				break;

 			case "Logout":
				
 				dispatchEvent(reloginEv);
 				break; 
				
			case "Corupt":

				dispatchEvent(coruptEv);
				NativeApplication.nativeApplication.exit();
				break;
				
			case "Download":
				dispatchEvent(cancelEv);
				break;
				
			 case "Network":
 	  dispatchEvent(cancelEv);
				//NativeApplication.nativeApplication.exit();
 				break;	
				
				
				} // end of switch
				
		} // end of function messageButton2ClickHandler
			
		function messageButton1ClickHandler(event:MouseEvent):void {
				
				
			switch (functionType){

 			case "Exit":
			
 	 			dispatchEvent(cancelEv);
 				break;

 				case "Logout":
				
 				dispatchEvent(cancelEv);
 				break; 
				
				case "Corupt":

				dispatchEvent(coruptEv);
				NativeApplication.nativeApplication.exit();
				break;
				
				case "Download":
				
				
				break;
				
			} // end of Switch
			
		} // end of function messageButton1ClickHandler
		
 
		public function removeMessageBox():void{
			
			removeChild(eb);
		}
		
	} // end of class
	 
} // end of package
