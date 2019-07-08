public class DetailsController {
	public Product_Table__c product { get; set; }
	public String productId { get; set; }
    
    public DetailsController() {
    	productId = ApexPages.currentPage().getParameters().get('Id');
        product = [
            SELECT Id, Name, Product_Description__c, Added_Date__c, Image_Url__c, Unit_Price__c, Units_Available__c, Warehouse__c
        	FROM Product_Table__c
        	WHERE Id = :productId
        ];
    }
}