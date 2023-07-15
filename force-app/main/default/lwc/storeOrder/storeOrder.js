import { LightningElement, api } from "lwc";

export default class StoreOrder extends LightningElement {
  //Store supply order to display
  @api orderItem;

  //Whether the component has unsaved changes
  isModified = false;

  //Current changed order Value
  form = {};

  //handles changes to the record value
  handleFormChange(event) {
    this.isModified = true;
    const field = event.target.dataset.fieldName;
    let value = parseInt(event.detail.value.trim(), 10);
    if (!Number.isInteger(value)) {
      value = 0;
    }
    this.form[field] = value;
  }

  //Fire custom event to the parent component notifying that the record has changed
  saveOrderItem() {
    const eventVar = new CustomEvent("orderitemchange", {
      detail: Object.assign({}, { Id: this.orderItem.Id }, this.form)
    });
    this.dispatchEvent(eventVar);
    this.isModified = false;
  }
  cancelChanges() {
    this.isModified = false;
  }
}
