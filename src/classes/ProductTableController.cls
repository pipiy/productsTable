public class ProductTableController {
    public List<Product_Table__c> products { get; set; }
    public String warehouseId { get; set; }
    public String warehouseName { get; set; }
    
    public ProductTableController() {
    	warehouseId = ApexPages.currentPage().getParameters().get('Id');
    	getWarehouseName();
        products = [
            SELECT Id, Name, Product_Description__c, Added_Date__c, Image_Url__c, Unit_Price__c, Units_Available__c
        	FROM Product_Table__c
        	WHERE Warehouse__c = :warehouseId
        ];
    }

    public String getWarehouseName() {
    	List<Warehouse__c> warehouses = [
    		SELECT Id, Name
    		FROM Warehouse__c
    		WHERE Id = :warehouseId
		];

		for (Warehouse__c warehouse : warehouses) {
			warehouseName =	warehouse.Name;
		}

		return warehouseName;
    }
}