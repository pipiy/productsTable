@isTest
public class DetailsControllerTest {
	@testSetup
    static void setup() {
        Product_Table__c product1 = new Product_Table__c(
            Name = 'Iphone 7s',
            Product_Description__c = 'Lorem Ipsum Dolor Sit Amet.',
            Unit_Price__c = 1000,
            Units_Available__c = 10,
            Added_Date__c = date.today()
        );
        insert product1;
    }
    
    @isTest
    private static void DetailsControllerTest() {
    	Product_Table__c product = [
            SELECT Id, Name, Product_Description__c, Added_Date__c, Image_Url__c, Unit_Price__c, Units_Available__c, Warehouse__c
        	FROM Product_Table__c
            WHERE Name = 'Iphone 7s'
        ];
        
        Test.startTest();
        PageReference pageRef = Page.DetailPage;
        pageRef.getParameters().put('id', String.valueOf(product.Id));
        test.setCurrentPage(pageRef);
        DetailsController detail = new DetailsController();
        detail.productId = product.Id;
        Test.stopTest();
        
        List<Product_Table__c> newProduct = [
            SELECT Id, Name, Product_Description__c, Added_Date__c, Image_Url__c, Unit_Price__c, Units_Available__c, Warehouse__c
        	FROM Product_Table__c
            WHERE Id = :product.Id
        ];
        System.assertEquals(1, newProduct.size());       
    }
}