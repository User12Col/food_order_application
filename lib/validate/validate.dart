class Validate{
  static bool isMatchPassword(String password, String cfpassword){
    if(password == cfpassword){
      return true;
    }
    return false;
  }

  static bool isEmpty(String input){
    if(input.isEmpty){
      return true;
    }
    return false;
  }
}