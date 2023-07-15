({
  searchKeyChange: function (component, event, helper) {
    var myEvent = $A.get("e.c:searchKeyEvent");
    myEvent.setParams({ searchkey: event.target.value });
    myEvent.fire();
  }
});