({
  handleClick: function (component, event) {
    var target;
    if (event.getSource) {
      //this part will run if compnent event is fired
      target = event.getSource();
      component.set("v.write", target.get("v.label"));
    } else {
      //this part will be fired if DOM event is fired
      target = event.target.value;
      component.set("v.write", target);
    }
    var attributeVal = component.get("v.write");
    console.log("Current Text is " + attributeVal);
  }
});
