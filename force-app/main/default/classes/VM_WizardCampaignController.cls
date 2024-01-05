public  class VM_WizardCampaignController {
    public VM_WizardCampaignController() {}

public class VM_WizardCampaignWrapper{
  @AuraEnabled
 public String Name{get;set;} 
 @AuraEnabled
 public String ParentId{get;set;}
 @AuraEnabled
 public String Status{get;set;}
 @AuraEnabled
 public String Type{get;set;}
 @AuraEnabled
 public Date StartDate{get;set;}
 @AuraEnabled
 public Date EndDate{get;set;}
 @AuraEnabled
        public List<GW_Volunteers__Volunteer_Job__c> Volunteer_Job { get; set; }

}

@AuraEnabled
public static void createCampaignWizard(String wrapperText){
    try {
        VM_WizardCampaignWrapper wrapper = (VM_WizardCampaignWrapper)JSON.deserialize(wrapperText, VM_WizardCampaignWrapper.class);
        if(wrapper!=null){
          Campaign campaign =new Campaign();
          campaign.Name=wrapper.Name;
          campaign.ParentId=wrapper.ParentId;

          insert campaign;

        }
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
}
    
}