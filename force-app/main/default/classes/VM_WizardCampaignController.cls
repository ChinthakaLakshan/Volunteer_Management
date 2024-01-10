public  class VM_WizardCampaignController {
    public VM_WizardCampaignController() {}
    
    public class VM_WizardCampaignWrapper{
        @AuraEnabled
        public String campaignName {get;set;}
        @AuraEnabled
        public String campaignDescription {get;set;}
        @AuraEnabled
        public String campaignstartDate {get;set;}
        @AuraEnabled
        public String campaignendDate {get;set;}
        @AuraEnabled
        public Integer noOfVolunteerProgrammes {get;set;}
        
        @AuraEnabled
        public List<VolunteerProgramme> Volunteer_Programme {get;set;}
        
        
        
    }
    
    public class VolunteerProgramme {
        @AuraEnabled
        public String volunteerProgrammeName {get;set;} 
        @AuraEnabled
        public String volunteerProgrammeStartDate {get;set;} 
        @AuraEnabled
        public Boolean Recurring {get;set;}
        @AuraEnabled
        public String skills {get;set;} 
        @AuraEnabled
        public String volunteerProgrammeEndDate {get;set;} 
        
        @AuraEnabled
        public String volunteerProgrammeFrequency {get;set;} 
        
    }
    
    
    
    
    
    @AuraEnabled
    public static void createCampaignWizard(String wrapperText){
        wrapperText = '{"campaignName":"Car washing","campaignDescription":"cleaning surface","Volunteer_Programme":[{"volunteerProgrammeName":"cleaning", "skills":"Manual labour"} , {"volunteerProgrammeName":"washing", "skills":"writing"}]}';
        
        List<GW_Volunteers__Volunteer_Job__c> volunteerprogramme = new List<GW_Volunteers__Volunteer_Job__c>();
        
        try {
            VM_WizardCampaignWrapper wrapper = (VM_WizardCampaignWrapper)JSON.deserialize(wrapperText, VM_WizardCampaignWrapper.class);
            if(wrapper!=null){
                
                
                Campaign campaign =new Campaign();
                campaign.Name=wrapper.campaignName;
                
                //insert campaign;
                System.debug('campaign id'+campaign.Id); 
                
                if(wrapper.Volunteer_Programme!=null){
                    
                    
                    System.debug('programme list'+wrapper.Volunteer_Programme);
                    
                    for(VolunteerProgramme vp:wrapper.Volunteer_Programme){
                        GW_Volunteers__Volunteer_Job__c c = new GW_Volunteers__Volunteer_Job__c();
                        c.GW_Volunteers__Campaign__c =campaign.Id;
                        c.Name=vp.volunteerProgrammeName;
                        c.GW_Volunteers__Skills_Needed__c=vp.skills;
                        
                        volunteerprogramme.add(c);
                        
                        
                    }
                    //insert  volunteerprogramme;
                    
                }
                
                
            }
            if(!volunteerprogramme.isEmpty()) {}
            
        } catch (Exception e) {
            System.debug(e);
        }
    }
    
    public void createJobReccurenceShedule(String daysOfWeek /*,String weeklyOccurrence*/,DateTime sheduledStartdate ,DateTime sheduledEndDate ){
         List<GW_Volunteers__Volunteer_Shift__c> shifts = new List<GW_Volunteers__Volunteer_Shift__c>();
        
       
        Integer saturdayCount =0;
        while(sheduledStartdate<=sheduledEndDate){
            
   
            
            if(sheduledStartdate.format('EEEE').toLowerCase() ==daysOfWeek){
              saturdayCount++;
            }
            sheduledStartdate=sheduledStartdate.addDays(1);
        }
         System.debug(saturdayCount);
        
        
    } 
    
    
}