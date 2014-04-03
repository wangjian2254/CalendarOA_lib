package util
{
	import control.LoginUser;
	
	import events.ChangeUserEvent;
	
	import httpcontrol.CHTTPService;
	import httpcontrol.HttpServiceUtil;
	
	import model.User;
	
	import mx.core.FlexGlobals;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class UserUtil
	{
		public function UserUtil()
		{
		}
		[Bindable]
		public static var user:User;
		
		
		[Bindable]
		public static var resultMsg:String="";
		
		public static var  currentUserFun:Function=null;
		public static var loginUser:LoginUser= new LoginUser();
		
		[Bindable]
		public static var sessionUser:Object=new Object();
		
		public static function sessionUserRefresh(fun:Function=null):void{
			//			RemoteUtil.getOperationAndResult("getAllUser",resultAllUser).send();
			if(fun==null){
				HttpServiceUtil.getCHTTPServiceAndResult("/ca/currentUser",resultFinduser,"POST").send()
				//				RemoteUtil.getOperationAndResult("",resultAllUser,false).send();
			}else{
				var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResultAndFault("/ca/currentUser",resultFinduser,failueFinduser,"POST");
				
				http.resultFunArr.addItem(fun);
				http.send();
				
			}
		}
		public static function resultFinduser(result:Object,e:ResultEvent):void{
			if(result.success==true){
				if(sessionUser["id"]!=result.result["id"]){
					FlexGlobals.topLevelApplication.dispatchEvent(new ChangeUserEvent(ChangeUserEvent.ChangeUser_EventStr,result.result,true));
				}
				sessionUser=result.result;
			}else{
				sessionUser=false;
			}
		}
		
		public static function failueFinduser(e:FaultEvent):void{
			
		}
	}
}