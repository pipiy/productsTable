@isTest
public class PurchaseControllerTest {
	@testSetup
    static void setup() {
        Integer periodTerm = 20;
        Org_Configuration__c orgConfiguration = new Org_Configuration__c (
            Period_Term__c = periodTerm
        );     
        insert orgConfiguration;
        
        Product_Table__c product = new Product_Table__c (
            Name = 'Iphone 7s',
            Units_Available__c = 10,
            Unit_Price__c = 1000,
            Added_Date__c = date.today()
        );
        insert product;

        Contact contact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'johndoe@gmail.com'
        );
        insert contact;
    }
    
    @isTest
    private static void buyProductForExistCon() {
        Product_Table__c product = [
            SELECT Id, Name, Product_Description__c, Image_Url__c, Unit_Price__c, Units_Available__c, Warehouse__c
            FROM Product_Table__c
        ];
        
        Contact contact = [
            SELECT Id, FirstName, LastName, Email
            FROM Contact
        ];
        
        Test.startTest();
        PageReference pageRef = Page.PurchasePage;
        pageRef.getParameters().put('id', String.valueOf(product.Id));
        test.setCurrentPage(pageRef);
        PurchaseController purchase = new PurchaseController();
        purchase.getFirstName = contact.FirstName;
        purchase.getLastName = contact.LastName;
        purchase.getEmail = contact.Email;
        purchase.getUnitsAvailable = product.Units_Available__c;
        purchase.makePurchase();
        Test.stopTest();
        
        Contact newCon = [
            SELECT Id, FirstName, LastName, Email
            FROM Contact
            WHERE Email = 'johndoe@gmail.com'
        ];     
        system.assertEquals(contact.Email, newCon.Email);
        system.assertEquals(contact.FirstName, newCon.FirstName);
        system.assertEquals(contact.LastName, newCon.LastName);
    }
    
    @isTest
    private static void buyProductForNewCon() {
        Product_Table__c product = [
            SELECT Id, Name, Product_Description__c, Image_Url__c, Unit_Price__c, Units_Available__c, Warehouse__c
            FROM Product_Table__c
        ];
        
        Contact newCon = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'johndoe@gmail.com'
        );
        
        Org_Configuration__c orgConfiguration = [
            SELECT Period_Term__c
            FROM Org_Configuration__c
        ];
        
        Test.startTest();
        PageReference pageRef = Page.PurchasePage;
        pageRef.getParameters().put('id', String.valueOf(product.Id));
        test.setCurrentPage(pageRef);
        PurchaseController purchase = new PurchaseController();
        purchase.getFirstName = newCon.FirstName;
        purchase.getLastName = newCon.LastName;
        purchase.getEmail = newCon.Email;
        purchase.getUnitsAvailable = product.Units_Available__c - orgConfiguration.Period_Term__c;
       
        purchase.makePurchase();
        Test.stopTest();
        
        Product_Table__c newProd = [
            SELECT Id, Name, Unit_Price__c, Units_Available__c
            FROM Product_Table__c
            WHERE Id = :product.Id
        ];
        system.assertEquals((product.Units_Available__c - purchase.getUnitsAvailable), newProd.Units_Available__c);          
    }
}