@isTest
private class WarehouseControllerTest {
	@isTest
    private static void WarehouseControllerTest() {
        WarehouseController warehouseCon = new WarehouseController();
        
        List<Warehouse__c> warehouses = [SELECT Id, Name, Period_End__c, Period_Start__c, Owner.Name FROM Warehouse__c];
        
        Test.startTest();
        System.assertEquals(warehouses, warehouseCon.warehouses);
        System.assertEquals(warehouses.size(), warehouseCon.warehouses.size());
        Test.stopTest();
    }
}