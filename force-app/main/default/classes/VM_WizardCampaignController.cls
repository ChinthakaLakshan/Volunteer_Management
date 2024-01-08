public  class VM_WizardCampaignController {
    public VM_WizardCampaignController() {}

public class VM_WizardCampaignWrapper{
  @AuraEnabled
  public String name {get;set;} 
	public List<Vounteer_Progarm> Vounteer_Progarm {get;set;} 
    public String ParentId {get;set;} 
}

public class Vounteer_Progarm {
    public String proName {get;set;} 
    public String startdate {get;set;} 
    public Boolean recurring {get;set;} 
}
 
        
@AuraEnabled
public static void createCampaignWizard(String wrapperText){
    wrapperText = '{"Name":"wedding","ParentId":"sfgfdgfd"}';
    try {
        VM_WizardCampaignWrapper wrapper = (VM_WizardCampaignWrapper)JSON.deserialize(wrapperText, VM_WizardCampaignWrapper.class);
        if(wrapper!=null){
            
             //System.debug(wrapper.Name);
            // System.debug(wrapper.ParentId);
         Campaign campaign =new Campaign();
         campaign.Name=wrapper.Name;
            
            
          //campaign.ParentId=wrapper.ParentId;
             
         
         

        }
    } catch (Exception e) {
       System.debug(e);
    }
}
    
}