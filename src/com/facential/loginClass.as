/***********************************************************************************************************************/
/*****             This class places all login assetts on the stage and handles the                                 ****/
/*****             login functionality. The singleton is called from the main class on intital                      ****/
/*****             load and remains persistant throughout the session.                                              ****/              
/*****                    Copyright  Facential, LLC   2015   all rights reserved                                    ****/
/*****                                                                                                              ****/
/***********************************************************************************************************************/

package  com.facential {
	
	import flash.net.*;
	import flash.display.*;
	import flash.filesystem.*;
	import fl.controls.*;
	import flash.text.*;
	import flash.events.*;
	import flash.ui.*;
	import flash.media.*;
	import com.apdevblog.events.video.VideoControlsEvent;
	import com.apdevblog.examples.style.CustomStyleExample;
	import com.apdevblog.ui.video.ApdevVideoPlayer;
	import com.apdevblog.ui.video.ApdevVideoState;
	import flash.desktop.NativeApplication;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.net.URLRequestMethod;

	public class loginClass  extends MovieClip{
		
		public static const LOGINSUCCESS:String = "THE_USER_LOGGED_IN";  
		var logINsuccessEv:Event = new Event(LOGINSUCCESS);
		
		public static const OFFLINELOGIN:String = "OFFLINE_LOGIN";  
		var offlinelogINEv:Event = new Event(OFFLINELOGIN);
		
		public var userName:String;
		public var userPassword:String;
	    public var returnArray:Array;
		public var offLogin:Boolean = false;

		var loginLabelTextbox:TextField = new TextField(); // login label
		var loginTextbox:TextField = new TextField();  // login input textbox
		var passwordLabelTextbox:TextField = new TextField(); // password label
		var passwordTextbox:TextField = new TextField();  // password input textbox
		var headerText:TextField = new TextField();  
		var loginButton:Button;
		var loginFormat:TextFormat;
		var reLoginButton:Button = new Button;
		var loginBox:Shape;
		var loginSprite:Sprite;
		var offLineText:CheckBox;
		
 
		public function loginClass () {
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
		} // end of loginClass Constructor		
		
		
		private function init (e:Event):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if (loginSprite) removeChild(loginSprite);
			
			loginFormat = new TextFormat();
 			loginFormat.size = 16;	
			loginFormat.font = "Arial";
			loginFormat.color = 0x000000;
			
			loginSprite = new Sprite;
			loginSprite.x = 460;
			loginSprite.y = 220;
			addChild(loginSprite);
			
			loginBox = new Shape();
			loginBox.graphics.beginFill(0xcccccc); // choosing the colour for the fill (grey)
			loginBox.graphics.drawRoundRect(0,0, 350, 230, 25, 25) // (x spacing, y spacing, width, height, )
			loginBox.graphics.endFill(); // not always needed but I like to put it in to end the fill
			loginSprite.addChild(loginBox);
			
			offLineText = new CheckBox();
			offLineText.label = "Offline Mode";
			offLineText.x = 125;
			offLineText.y = 200;
			offLineText.width = 170;
			var directory:File = File.applicationStorageDirectory.resolvePath("lessons"); //directory of lessons subdirectory
			if(directory.exists) {offLineText.enabled = true;} else {offLineText.enabled = false;}
			loginSprite.addChild(offLineText);
			
			loginButton = new Button();
			loginButton.toggle = true;
			loginButton.mouseChildren = false;
			loginButton.buttonMode = true;
			loginButton.label = "Login";
			loginButton.width = 240;
			loginButton.height = 30;
			loginButton.move(60, 160);
			loginButton.addEventListener(MouseEvent.CLICK,logIn);
			loginSprite.addChild(loginButton);
		
			loginTextbox.defaultTextFormat = loginFormat;
			loginTextbox.tabIndex = 1;
			loginTextbox.type = "input";
			loginTextbox.text = " "; 
			loginTextbox.setSelection(loginTextbox.length,loginTextbox.length);
			loginTextbox.text = "";
			loginTextbox.width = 270;    
			loginTextbox.height = 30;    
			loginTextbox.x = 40;    
			loginTextbox.y = 55;
			loginTextbox.background = true;
			loginTextbox.backgroundColor = 0xffffff; 
			loginTextbox.addEventListener(KeyboardEvent.KEY_DOWN, userIDhandeler);
			loginSprite.addChild(loginTextbox);
			loginTextbox.stage.focus = loginTextbox; 
			
			passwordTextbox.defaultTextFormat = loginFormat;
			passwordTextbox.tabIndex = 2;
			passwordTextbox.type = "input";
			passwordTextbox.displayAsPassword = true;
			passwordTextbox.text = ""; 
			passwordTextbox.width = 270;    
			passwordTextbox.height = 30;    
			passwordTextbox.x = 40;    
			passwordTextbox.y = 120;
			passwordTextbox.background = true;
			passwordTextbox.backgroundColor = 0xffffff;
			passwordTextbox.addEventListener(KeyboardEvent.KEY_DOWN, passwordHandeler);
			loginSprite.addChild(passwordTextbox);
			
			headerText.defaultTextFormat = loginFormat;
			headerText.text = "Please Login"; 
			headerText.width = 125;    
			headerText.height = 35;    
			headerText.x = 125;    
			headerText.y = 8;
			loginSprite.addChild(headerText);
			
			loginLabelTextbox.defaultTextFormat = loginFormat;
			loginLabelTextbox.text = "User ID"; 
			loginLabelTextbox.width = 125;    
			loginLabelTextbox.height = 35;    
			loginLabelTextbox.x = 38;    
			loginLabelTextbox.y = 33;
			loginSprite.addChild(loginLabelTextbox);
	
			passwordLabelTextbox.defaultTextFormat = loginFormat;
			passwordLabelTextbox.text = "Password"; 
			passwordLabelTextbox.width = 125;    
			passwordLabelTextbox.height = 35;    
			passwordLabelTextbox.x = 38;    
			passwordLabelTextbox.y = 98;
			loginSprite.addChild(passwordLabelTextbox);
			
		} // end of init function
		
		
		private function userIDhandeler (event:KeyboardEvent):void { 
    
			if (event.keyCode == Keyboard.ENTER) stage.focus = passwordTextbox;  
		} 
			

		private function passwordHandeler (event:KeyboardEvent):void {
    
			if (event.keyCode == Keyboard.ENTER) logIn(null)
			
		}
				
		
		private function logIn (evt:Event):void {
			
			if (offLineText.selected == true) {
				
				offLogin = true;
				dispatchEvent(offlinelogINEv);
				killLogin();
			
			}else{
				
				var loader:URLLoader = new URLLoader();// create a URLLoader to POST data to the server
				var request:URLRequest = new URLRequest("http://www.facential.com/_scripts/facConn.php");
				var params:URLVariables = new URLVariables();// create and set the variables passed to the server script
					params.username = loginTextbox.text;
					params.password = passwordTextbox.text;
					params.action = "login";
					request.data = params;
					request.method = URLRequestMethod.POST; // set the request type to POST as it's more secure and can hold more data

				loader.addEventListener(Event.COMPLETE, onPostComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onPostFailed);
				loader.load(request);	
				
			} // end of if/else
			
	   }  // end of logIn
	   
	 
		private function onPostFailed (e:Event):void {

			trace("I/O Error when sending a POST request");// happens if the server is unreachable
		
		}


		private function onPostComplete (e:Event):void {

			var returnString:String = e.target.data;
			
				returnArray = returnString.split(",");
				
				if (returnArray[0] == "active") {
					
					dispatchEvent(logINsuccessEv);
					returnArray.shift();
					killLogin();
					
				} else { 
	
					init(null);
				
				} // end of if /else
		
		} // end of onPostComplete
		
		
		public function killLogin ():void {
			
			loginSprite.removeChild(passwordTextbox);
			loginSprite.removeChild(loginLabelTextbox);
			loginSprite.removeChild(loginTextbox);
			loginSprite.removeChild(passwordLabelTextbox);
			loginSprite.removeChild(loginButton);
			loginSprite.removeChild(loginBox);
			loginSprite.removeChild(headerText);
			loginSprite.removeChild(offLineText);
			
		} // end of killLogin
		
		
	}  // end of class
	
} // end of package
