public class getdistances {
    
    public  Double startlat  {get;set;}
    public  Double startlong {get;set;}
    public  Double stoplat   {get;set;}
    public  Double stoplong  {get;set;}
    public  Double dist      {get;set;}
    
    public getdistances(){
        //startlat=0;
        //startlong=0;
        //stoplat=0;
        //stoplong=0;
    }
    public  PageReference  getDist(){
        
        System.debug('startlat'+startlat +'startlong'+startlong);
        Location loc1 = Location.newInstance(startlat,startlong);
        Location loc2 = Location.newInstance(stoplat,stoplong);
        User objUser = [SELECT distance__c from user where Id =: UserInfo.getUserId() limit 1 ];
        Double dist1;
        if(objUser.distance__c != null){
            dist1 =objUser.distance__c;
        }else{
            dist1 = 0;
        }
        dist = Location.getDistance(loc1, loc2, 'mi');
        
        dist1 = dist1 + dist;
        objUser.distance__c = 0;
        System.debug('update');
        update objUser;

        
        dist = dist1;
        System.debug('location1'+loc1 +'location2'+loc2);
        return null;
    }
    public void startlocation(){
        startlat  = double.valueof(Apexpages.currentPage().getParameters().get('node'));
        startlong = double.valueof(Apexpages.currentPage().getParameters().get('node1')); 
        
    }
    public void stoplocation(){
        //integer.valueof(s);
        stoplat= double.valueof(Apexpages.currentPage().getParameters().get('node'));
        stoplong= double.valueof(Apexpages.currentPage().getParameters().get('node1')); 
        
    }
    public void savedistance(){
        //UserInfo.getUserId()
        System.debug('inside save distance');
        stoplat= double.valueof(Apexpages.currentPage().getParameters().get('node'));
        stoplong= double.valueof(Apexpages.currentPage().getParameters().get('node1')); 
        
        User objUser = [SELECT distance__c from user where Id =: UserInfo.getUserId() limit 1 ];
        Double dist1;
        if(objUser.distance__c != null){
            dist1 =objUser.distance__c;
        }else{
            dist1 = 0;
        }
               
        Location loc1 = Location.newInstance(startlat,startlong);
        Location loc2 = Location.newInstance(stoplat,stoplong);
        dist = Location.getDistance(loc1, loc2, 'mi');
        
        startlat = stoplat;
        startlong = stoplong;
        
        dist1 = dist1 + dist;
        objUser.distance__c = dist1;
        System.debug('asasasa');
        update objUser;
        
    }
    
    
}