import { LightningElement, api, wire } from "lwc";
import getOpenCasesWithId from "@salesforce/apex/storeControllerExt.getOpenCasesWithId";
// import { getRecord } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { subscribe, onError } from "lightning/empApi";

const tabCols = [
  { fieldName: "Subject", label: "Subject", type: "string" },
  { fieldName: "Status", label: "Status", type: "string" },
  { fieldName: "Priority", label: "Priority", type: "string" },
  { fieldName: "CreatedDate", label: "Created Date", type: "date" }
];

export default class StoreCaseDetails extends LightningElement {
  greeting = "Namaste! Store Visitors";
  record;
  currentStatus;
  caseListforRefresh;
  tabCols = tabCols;
  @api recordId;
  firstName;
  error;
  subscription = {};
  CHANNEL_NAME = "/event/Feedback_Rating_Event__e";

  @wire(getOpenCasesWithId, { storeId: "$recordId" }) caseList;

  refreshList = () => {
    this.caseListforRefresh = this.caseList;
    //Update list of Store tickets
    refreshApex(this.caseListforRefresh);
  };

  connectedCallback() {
    subscribe(this.CHANNEL_NAME, -1, this.refreshList).then((result) => {
      this.subscription = result;
    });
    onError((error) => {
      console.log("Server Error in Callback " + error);
    });
  }
  renderedCallback() {
    const toastMsg = new ShowToastEvent({
      title: "New Case",
      message: "Cases have been updated!",
      variant: "success"
    });
    this.dispatchEvent(toastMsg);
  }
}
