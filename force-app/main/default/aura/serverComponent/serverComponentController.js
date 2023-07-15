({
  clientEcho: function (component) {
    var action = component.get("c.serverEcho");
    action.setParams({ firstName: component.get("v.firstName") });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        alert("From Server: " + response.getReturnValue());
      } else if (state === "ERROR") {
        var errors = response.getError();
        console.log("Errors:- " + errors);
      } else if (state === "INCOMPLETE") {
        alert("Incomplete response from Server");
      }
    });
    $A.enqueueAction(action);
  }
});
