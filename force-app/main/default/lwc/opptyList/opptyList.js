import { LightningElement, api, wire } from "lwc";
import getRecords from "@salesforce/apex/OpportunityController.getRecords";
import { refreshApex } from "@salesforce/apex";
import { updateRecord } from "lightning/uiRecordApi";

export default class OpptyList extends LightningElement {
  @api recordId;
  @wire(getRecords, { accountId: "$recordId" }) oppList;
  draftValues = [];
  tabCols = [
    { fieldName: "Name", label: "Deal Name", type: "text", editable: "true" },
    {
      fieldName: "Amount",
      label: "TCV Amount",
      type: "currency",
      editable: "true"
    }
  ];
  saveHandler(event) {
    const fields = {};
    fields.Id = event.detail.draftValues[0].Id;
    fields.Name = event.detail.draftValues[0].Name;
    fields.Amount = event.detail.draftValues[0].Amount;

    const recordInput = { fields };
    updateRecord(recordInput).then(() => {
      //Refresh datatable Rows
      return refreshApex(this.oppList).then(() => {
        //Reset draft values in the datatable
        this.draftValues = [];
      });
    });
  }
}