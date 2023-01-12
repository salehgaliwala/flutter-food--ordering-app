class Foo {
  // Creating a field/instance variable
  String _fooName = ""; //Keeping it private always

  // Using the getter
  String get getName {
//We can do something else here, like saving the variable somewhere and then returning it to the caller function
    return _fooName; // private variable return for use in outside class
  }

  // Using the setter method
  set foo_name(String name) {
    // We can do something else, like update another variable based on fooName
    this._fooName = name; //private variable being assigned new value
  }
}
