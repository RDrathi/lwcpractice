({
  handleInit: function (component) {
    var action = component.get("c.getContacts");
    action.setCallback(this, function (response) {
      component.set("v.contacts", response.getReturnValue());
    });
    $A.enqueueAction(action);
  },
  searchKeyChange: function (cmp, event) {
    var searchkeyVar = event.getParam("searchkey");
    var actionReplay = cmp.get("c.getContactsByName");
    actionReplay.setParams({
      searchKey: searchkeyVar
    });
    actionReplay.setCallback(this, function (response) {
      cmp.set("v.contacts", response.getReturnValue());
    });
    $A.enqueueAction(actionReplay);
  }
});
