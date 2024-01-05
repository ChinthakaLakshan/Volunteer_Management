

@isTest
private class VM_WizardCampaignControllerTest {

    @isTest
    static void myUnitTest() {
        String sampleWrapperText = '{ "Name":"Sample Campaign", "ParentId":"001xxxxxxxxxxx"}';
    VM_WizardCampaignController.createCampaignWizard(sampleWrapperText);
    }
}