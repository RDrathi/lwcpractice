({
  addNumbers: function (component) {
    var addValues = component.get("v.num1") + component.get("v.num2");
    component.set("v.sum", addValues);
  }
});
