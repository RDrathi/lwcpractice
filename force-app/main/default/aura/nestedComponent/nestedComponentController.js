({
  getInput: function (component, event) {
    var firstName = component.find("firstName").get("v.value");
    var lastName = component.find("lastName").get("v.value");
    var outputName = component.find("nameOutput");
    outputName.set("v.value", firstName + " " + lastName);
  }
});
