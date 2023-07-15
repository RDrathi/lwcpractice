({
  locationChangeHandler: function (component, event, helper) {
    var token = event.getParam("token");
    if (token.indexOf("contact/") === 0) {
      var contactIdVar = token.substr(token.indexOf("/") + 1);
      var action = component.get("c.getContactsById");
      action.setParams({
        contactId: contactIdVar
      });
    }
    action.setCallback(this, function (response) {
      component.set("v.conRecord", response.getReturnValue());
    });
    $A.enqueueAction(action);
  }
});