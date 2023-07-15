import { LightningElement, wire } from "lwc";
import getSearchedAccount from "@salesforce/apex/AccountController.getSearchedAccount";

export default class SafeAccountSearch extends LightningElement {
  searchTerm = "";
  error = "";
  tabCols = [
    { label: "Name", fieldName: "Name", type: "string" },
    { label: "Annual Revenue", fieldName: "AnnualRevenue", type: "currency" },
    { label: "Priority", fieldName: "CustomerPriority__c", type: "string" }
  ];
  searchedAccList;

  @wire(getSearchedAccount, { searchName: "$searchTerm" }) wiredSearchedAccList(
    value
  ) {
    if (value.data) {
      this.searchedAccList = value.data;
    } else if (value.error) {
      this.error = value.error;
    }
  }

  handleSearchTermChange(event) {
    window.clearTimeout(this.delayTimeout);
    const userInput = event.target.value;
    this.delayTimeout = setTimeout(() => (this.searchTerm = userInput), 300);
  }
}
