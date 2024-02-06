public  class VM_WizardCampaignController {
  //  public VM_WizardCampaignController() {}
    
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
        
   /*    @AuraEnabled
        public List<RecurrenceShedule> Recurrence_Shedule {get;set;}*/
          
        
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
        
        
        @AuraEnabled
        public List<RecurrenceShedule> Recurrence_Shedule {get;set;}
        
        
        
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
    
    public class RecurrenceShedule{
        @AuraEnabled
        public String daysOfWeek {get;set;} 
        
        @AuraEnabled
        public String weeklyOccurrence {get;set;} 
        
        @AuraEnabled
        public String startDateTime {get;set;} 
        
        @AuraEnabled
        public String Duration {get;set;} 
    }
    
    
    
    
    @AuraEnabled
    public static void createCampaignWizard(String wrapperText){
        wrapperText = '{"campaignName":"Car washing","campaignstartDate":"2024-12-31" ,"campaignendDate":"2025-12-31","campaignDescription":"cleaning surface","Volunteer_Programme":[{"volunteerProgrammeName":"cleaning", "skills":"Manual labour" ,"Volunteer_Shift":[{"shiftStartDate":"2024-01-20 14:30:00.000" , "shiftDuration":"3" ,"shiftDescription":"first shift"} , {"shiftStartDate":"2024-01-30 14:30:00.000" , "shiftDuration":"35" ,"shiftDescription":"2shift"}]} , {"volunteerProgrammeName":"washing", "skills":"writing" ,"Recurring":true , "Recurrence_Shedule":[{"daysOfWeek":"Monday;Tuesday","weeklyOccurrence":"Everyday","startDateTime":"2024-01-15 14:30:00.000","Duration":"2"}]}]}';
        
      // wrapperText='{"campaignName":"Community Cleanup","campaignstartDate":"2024-10-01","campaignendDate":"2024-10-31","campaignDescription":"Beautifying the community","Volunteer_Programme":[{"volunteerProgrammeName":"Street Cleaning","skills":"Physical fitness","Volunteer_Shift":[{"shiftStartDate":"2024-10-05 09:00:00.000","shiftDuration":"4","shiftDescription":"Morning Cleanup"},{"shiftStartDate":"2024-10-15 13:00:00.000","shiftDuration":"3","shiftDescription":"Afternoon Cleanup"}]},{"volunteerProgrammeName":"Park Beautification","skills":"Gardening","Recurring":true,"Recurrence_Shedule":[{"daysOfWeek":"Wednesday;Friday","weeklyOccurrence":"1st" ,"startDateTime":"2024-01-10 10:00:00.000","Duration":"2"}]}]}';
           
        
        
        List<GW_Volunteers__Volunteer_Job__c> volunteerprogramme = new List<GW_Volunteers__Volunteer_Job__c>();
        List<GW_Volunteers__Volunteer_Shift__c> Volunteershift = new List<GW_Volunteers__Volunteer_Shift__c>();
        List<GW_Volunteers__Job_Recurrence_Schedule__c> recshedulelist = new  List<GW_Volunteers__Job_Recurrence_Schedule__c>();
        Map <String , List<GW_Volunteers__Job_Recurrence_Schedule__c>> mapProgrammeNameRec = new  Map <String , List<GW_Volunteers__Job_Recurrence_Schedule__c>>();
        Map <String , List<GW_Volunteers__Volunteer_Shift__c>> mapProgrammeNameShift = new  Map <String , List<GW_Volunteers__Volunteer_Shift__c>>();
        
        List<GW_Volunteers__Volunteer_Shift__c> allShifts = new List<GW_Volunteers__Volunteer_Shift__c>();
        
        try {
            VM_WizardCampaignWrapper wrapper = (VM_WizardCampaignWrapper)JSON.deserialize(wrapperText, VM_WizardCampaignWrapper.class);
            if(wrapper!=null){
                
                
                Campaign campaign =new Campaign();
                campaign.Name=wrapper.campaignName;
                campaign.Description=wrapper.campaignDescription;
                
                Date convertedStartDate = Date.valueOf(wrapper.campaignstartDate);
                campaign.StartDate=convertedStartDate;
                
                Date convertedEndDate = Date.valueOf(wrapper.campaignendDate);
                campaign.EndDate=convertedEndDate;
                
                if (campaign != null) {
                    insert campaign;
                }
                
                
                if(wrapper.Volunteer_Programme!=null){
                    
                    
                    System.debug('programme list'+wrapper.Volunteer_Programme);
                    
                    
                    
                    for(VolunteerProgramme vp:wrapper.Volunteer_Programme){
                        GW_Volunteers__Volunteer_Job__c c = new GW_Volunteers__Volunteer_Job__c();
                        c.GW_Volunteers__Campaign__c =campaign.Id;
                        
                        c.Name=vp.volunteerProgrammeName;
                        c.GW_Volunteers__Skills_Needed__c=vp.skills;
                        
                        System.debug(vp.volunteerProgrammeName);
                        
                        volunteerprogramme.add(c);
                        
                        if(vp.Recurring==true && vp.Recurrence_Shedule != null && !vp.Recurrence_Shedule.isEmpty() ){
                            
                            RecurrenceShedule firstRecurrence = vp.Recurrence_Shedule[0];
                            
                            GW_Volunteers__Job_Recurrence_Schedule__c rs = new  GW_Volunteers__Job_Recurrence_Schedule__c();
                            rs.GW_Volunteers__Weekly_Occurrence__c =firstRecurrence.weeklyOccurrence;
                            rs.GW_Volunteers__Days_of_Week__c = firstRecurrence.daysOfWeek;
                            
                            // System.debug('startDateTime: ' + firstRecurrence.startDateTime);
                            Datetime myDatetime = Datetime.valueOf(firstRecurrence.startDateTime);
                            rs.GW_Volunteers__Schedule_Start_Date_Time__c = myDatetime;
                            
                            
                            Decimal myDecimal = Decimal.valueOf(firstRecurrence.Duration);
                            rs.GW_Volunteers__Duration__c=myDecimal;
                            
                            
                            recshedulelist.add(rs);
                            mapProgrammeNameRec.put(vp.volunteerProgrammeName , recshedulelist );
                            
                        }
                        
                        
                        
                        if(vp.Volunteer_Shift != null && !vp.Volunteer_Shift.isEmpty() ){
                            
                            
                            
                            for( VolunteerShift vs : vp.Volunteer_Shift){
                                GW_Volunteers__Volunteer_Shift__c s = new GW_Volunteers__Volunteer_Shift__c();
                                s.GW_Volunteers__Description__c =vs.shiftDescription;
                                
                                Datetime myDatetime = Datetime.valueOf(vs.shiftStartDate);
                                s.GW_Volunteers__Start_Date_Time__c=myDatetime;
                                
                                Decimal decimalValue = Decimal.valueOf(vs.shiftDuration);
                                s.GW_Volunteers__Duration__c = decimalValue;
                                
                                
                                Volunteershift.add(s);
                                mapProgrammeNameShift.put(vp.volunteerProgrammeName , Volunteershift );
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    
                    if (!volunteerprogramme.isEmpty()) {
                        insert volunteerprogramme;
                    } 
                    
                    
                    
                    for(GW_Volunteers__Volunteer_Job__c  c:volunteerprogramme){
                        
                        GW_Volunteers__Job_Recurrence_Schedule__c rj = new GW_Volunteers__Job_Recurrence_Schedule__c();
                        if( mapProgrammeNameRec.keyset().contains(c.Name)){
                            System.debug('mapProgrammeNameRec'+mapProgrammeNameRec.get(c.Name)[0]);
                            mapProgrammeNameRec.get(c.Name)[0].GW_Volunteers__Volunteer_Job__c = c.Id;
                            
                            System.debug(' map values'+mapProgrammeNameRec.values());
                            
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                    for (GW_Volunteers__Volunteer_Job__c c : volunteerprogramme) {
                        
                        if (mapProgrammeNameShift.containsKey(c.Name)) {
                            List<GW_Volunteers__Volunteer_Shift__c> shifts = mapProgrammeNameShift.get(c.Name);
                            
                            for (List<GW_Volunteers__Volunteer_Shift__c> shiftsList : mapProgrammeNameShift.values()) {
                                for (GW_Volunteers__Volunteer_Shift__c shift : shiftsList) {
                                    shift.GW_Volunteers__Volunteer_Job__c = c.Id;
                                    allShifts.add(shift);
                                }
                            } 
                            
                        }
                    }
                    
                    
                    if (!allShifts.isEmpty()) {
                        insert allShifts;
                    }
                    
                    
                    
                    if(mapProgrammeNameRec != null && !mapProgrammeNameRec.values().isEmpty()){
                        
                        insert mapProgrammeNameRec.values()[0];
                        System.debug(' map values'+mapProgrammeNameRec.values().size());    
                    }
                    
                    
                }
                
                
            }
            
            
        } 
        
        catch (Exception e) {
            System.debug(e);
        }
    }
    
    
    
    
}