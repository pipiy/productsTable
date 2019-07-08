@isTest
public class ProductTableControllerTest {
	@testSetup
    static void setup() {
        List<Warehouse__c> warehouses = new List<Warehouse__c>();
        Warehouse__c warehouse1 = new Warehouse__c(Name = 'Apple');
        warehouses.add(warehouse1);
        Warehouse__c warehouse2 = new Warehouse__c(Name = 'Xiaomi');
        warehouses.add(warehouse2);
        insert warehouses;
        
        List<Product_Table__c> products = new List<Product_Table__c>();
        Product_Table__c product1 = new Product_Table__c(
            Name = 'Iphone 7s',
            Product_Description__c = 'Lorem Ipsum Dolor Sit Amet.',
            Unit_Price__c = 1000,
            Units_Available__c = 10,
            Warehouse__c = warehouse1.Id
        );
        products.add(product1);
        Product_Table__c product2 = new Product_Table__c(
            Name = 'Xiaomi Mi A1',
            Product_Description__c = 'Lorem Ipsum Dolor Sit Amet.',
            Unit_Price__c = 500,
            Units_Available__c = 5,
            Warehouse__c = warehouse2.Id
        );
        products.add(product2);
        insert products;
    }
    @isTest
    private static void ProductTableControllerTest() {
        ProductTableController product = new ProductTableController();
        
        Warehouse__c warehouse = [
            SELECT Id, Name
        	FROM Warehouse__c
            WHERE Name = 'Apple'
        ];
        
        List<Product_Table__c> products = [
            SELECT Id, Name, Product_Description__c, Unit_Price__c, Units_Available__c
        	FROM Product_Table__c
            WHERE Warehouse__c = :warehouse.Id
        ];
        
        Test.startTest();
        product.warehouseId = warehouse.Id;
        product.getWarehouseName();
        Test.stopTest();
        System.assertEquals(1, products.size());
        System.assertEquals(product.warehouseName, warehouse.Name);
        
    }
}