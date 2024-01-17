public with sharing class sample {
    public sample() {

    }

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
        // @AuraEnabled
        //public List<VolunteerShift> Volunteer_Shift {get;set;}
 
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
        @AuraEnabled
        public List<VolunteerShift> Volunteer_Shift {get;set;}
 
    }
    public class VolunteerShift{
        @AuraEnabled
        public String shiftStartDate {get;set;}
        @AuraEnabled
        public String shiftStartTime {get;set;}
        @AuraEnabled
        public String shiftDuration {get;set;}
        @AuraEnabled
        public String shiftDescription {get;set;}
    }
 
 
    @AuraEnabled
    public static void createCampaignWizard(String wrapperText){
        wrapperText = '{"campaignName":"Car washing","campaignDescription":"cleaning surface","Volunteer_Programme":[{"volunteerProgrammeName":"cleaning", "skills":"Manual labour" ,"Volunteer_Shift":[{"shiftStartDate":"2023-01-15T14:30:00.000Z" , "shiftDuration":"3" ,"shiftDescription":"first shift"}]} , {"volunteerProgrammeName":"washing", "skills":"writing"}]}';
        List<GW_Volunteers__Volunteer_Job__c> volunteerprogList = new List<GW_Volunteers__Volunteer_Job__c>();
        List<GW_Volunteers__Volunteer_Shift__c> Volunteershift = new List<GW_Volunteers__Volunteer_Shift__c>();
        List<Recurrence_Schedule__c> recScheduleList = new  List<Recurrence_Schedule__c>();
        Map<String, List<Recurrence_Schedule__c>> mapProNameRecc = new Map<String, List<Recurrence_Schedule__c>>();
 
        try {
            VM_WizardCampaignWrapper wrapper = (VM_WizardCampaignWrapper)JSON.deserialize(wrapperText, VM_WizardCampaignWrapper.class);
            if(wrapper!=null){
 
                Campaign campaign =new Campaign();
                campaign.Name=wrapper.campaignName;
                insert campaign;
               
 
                if(wrapper.Volunteer_Programme!=null){
                 
                    System.debug('programme list'+wrapper.Volunteer_Programme);
                   
                    for(VolunteerProgramme vp:wrapper.Volunteer_Programme){
                        GW_Volunteers__Volunteer_Job__c c = new GW_Volunteers__Volunteer_Job__c();
                        c.GW_Volunteers__Campaign__c =campaign.Id;
                        c.Name = vp.volunteerProgrammeName;
                        c.GW_Volunteers__Skills_Needed__c=vp.skills;
                        System.debug(vp.volunteerProgrammeName);
                        volunteerprogList.add(c);
                        if(vp.Recurring){
                            //Recurrence_Schedule__c - program --1
                            recScheduleList.add(new Recurrence_Schedule__c(Name = '',  
                                                                            Days_of_Week__c ='Monday;Tuesday'
                                                                             ));
                                 if(mapProNameRecc.get() !== null){
                                               mapProNameRecc.put(vp.volunteerProgrammeName,recScheduleList);  
                                 }                      
 
                        } else {
                            volunteershift.add(new GW_Volunteers__Volunteer_Shift__c(name=''));
                            
                            if(mapProNameShift.get() !== null){
                                          mapProNameShift.put(vp.volunteerProgrammeName,volunteershift);  
                            }  
 
                        }
 
                    }
 
                    insert  volunteerprogList;
 
                    for(GW_Volunteers__Volunteer_Job__c c: volunteerprogList ) {
                        if(mapProNameRecc.keyset().contains(c.Name))
                        mapProNameRecc.get(c.Name).Volunteer_Program__c = c.Id;
                        /// update Id on shift
 
                    }
 
                    // insert reccuring
                    insert mapProNameRecc.values();
 
                    insert mapProNameRecc.values();
 
 
                //         if (vp.Volunteer_Shift!=null){
                //             System.debug('shift list' + vp.Volunteer_Shift);
 
                //             for(VolunteerShift vs:vp.Volunteer_Shift){
 
                //                 GW_Volunteers__Volunteer_Shift__c s =new GW_Volunteers__Volunteer_Shift__c();
                //                 s.GW_Volunteers__Volunteer_Job__c=c.Id;
                //                 System.debug('job id'+c.Id);
                //                 s.GW_Volunteers__Description__c=vs.shiftDescription;
                //                 Date convertedDate=Date.valueof(vs.shiftStartDate);
                //                 s.GW_Volunteers__Start_Date_Time__c=convertedDate;
                //                 Decimal decimalValue =Decimal.valueOf(vs.shiftDuration);
                //                 s.GW_Volunteers__Duration__c=decimalValue;
 
                //                 Volunteershift.add(s);
 
                //             }
 
                //         }
 
 
                //     }
                //     insert  volunteerprogramme;              
                //     insert   Volunteershift;    
                // }
 
            }
 
        } catch (Exception e) {
            System.debug(e);
        }
    }
}