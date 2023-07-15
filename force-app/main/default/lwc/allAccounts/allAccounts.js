import { LightningElement, wire } from "lwc";
import getAllAccounts from "@salesforce/apex/AccountController.getAllAccounts";
import { refreshApex } from "@salesforce/apex";

export default class AllAccounts extends LightningElement {
  allAccounts;
  @wire(getAllAccounts) wiredAllAccounts(value) {
    const { data, error } = value;
    if (data) {
      this.allAccounts = value.data;
    }
  }

  tabCols = [
    { fieldName: "Name", label: "Customer", type: "text" },
    { fieldName: "Industry", label: "Industry", type: "text" },
    { fieldName: "Rating", label: "Rating", type: "text" },
    { fieldName: "BillingCity", label: "City", type: "text" }
  ];
  refreshTable() {
    refreshApex(this.allAccounts);
  }
}