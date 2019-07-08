public class PurchaseController {
    public String getId { get; set; }
    public Product_Table__c purchPage { get; set; }
    public String getEmail { get; set; }
    public String getFirstName { get; set; }
    public String getLastName { get; set; }
    public Decimal getUnitsAvailable { get; set; }

    public PurchaseController() {
        getId = ApexPages.currentPage().getParameters().get('Id');
        purchPage = [
            SELECT Id, Name, Product_Description__c, Image_Url__c, Unit_Price__c, Units_Available__c, Warehouse__c
            FROM Product_Table__c
            WHERE ID = :getId
        ];
    }

    public void makePurchase() {
        if (getEmail != null && getLastName != null) {
            List<Contact> reWriteContact = [
                SELECT Id, FirstName, LastName, Email
                FROM Contact 
                WHERE Email = :getEmail
            ];
            Order_Table__c order = new Order_Table__c();

            if (reWriteContact != null && !reWriteContact.isEmpty()) {
                reWriteContact[0].FirstName = getFirstName;
                reWriteContact[0].LastName = getLastName;
                update reWriteContact;
                
                purchPage.Units_Available__c = purchPage.Units_Available__c - getUnitsAvailable;
                update purchPage;
                
                order.Contact__c = reWriteContact[0].Id;
                insertOrder(order);

                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, label.SuccessMessage));
            } else {
                Contact newContact = new Contact(
                    FirstName = getFirstName,
                    LastName = getLastName,
                    Email = getEmail
                );
                insert newContact;
                purchPage.Units_Available__c = purchPage.Units_Available__c - getUnitsAvailable;
                update purchPage;
                
                order.Contact__c = newContact.Id;
                insertOrder(order);

                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, label.SuccessMessage));
            }
        }
    }

    public void insertOrder(Order_Table__c order) {
        order.Product__c = getId;
        order.Units__c = getUnitsAvailable;
        order.Order_Amount__c = purchPage.Unit_Price__c * getUnitsAvailable;
        insert order;
    }
}