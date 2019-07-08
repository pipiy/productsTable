public class WarehouseController {
    public List<Warehouse__c> warehouses { get; set; }
    
    public WarehouseController() {
        warehouses = [SELECT Id, Name, Period_End__c, Period_Start__c, Owner.Name FROM Warehouse__c];
    }
}