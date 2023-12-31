import { LightningElement, api } from "lwc";

//import fields for record Form
import FIRST_NAME_FIELD from "@salesforce/schema/Lead.FirstName";
import LAST_NAME_FIELD from "@salesforce/schema/Lead.LastName";
import EMAIL_FIELD from "@salesforce/schema/Lead.Email";
import COMPANY_FIELD from "@salesforce/schema/Lead.Company";
import LEAD_SOURCE_FIELD from "@salesforce/schema/Lead.LeadSource";
import RATING_FIELD from "@salesforce/schema/Lead.Rating";

export default class CreateLead extends LightningElement {
  @api recordId;
  @api objectApiName = "Lead";
  fields = [
    FIRST_NAME_FIELD,
    LAST_NAME_FIELD,
    EMAIL_FIELD,
    COMPANY_FIELD,
    LEAD_SOURCE_FIELD,
    RATING_FIELD
  ];
}