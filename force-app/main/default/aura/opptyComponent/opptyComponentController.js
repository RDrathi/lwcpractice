({
  getOpptys: function (component) {
    var action = component.get("c.getOpps");
    debugger;
    action.setCallback(this, function (response) {
      var state = response.getState();
      debugger;
      if (state === "SUCCESS") {
        component.set("v.opptys", response.getReturnValue());
      }
    });
    $A.enqueueAction(action);
  }
});
