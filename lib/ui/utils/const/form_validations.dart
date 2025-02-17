
String? validateText(String? value) {
  if (value == null || value.trim().length < 3) {
    return '';
  } else {
    return null;
  }
}

String? validateGstNumber(String? value) {
  if (value == null || value.trim().length < 15) {
    return '';
  } else {
    return null;
  }
}

String? validateLoginPassword(String? value) {
  if (value == null || value.trim().length < 8) {
    return '';
  } else {
    return null;
  }
}

String? validatePassword(String? value) {
  Pattern pattern =
      r'^(?=.{8,20}$)(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).*$';
  RegExp regex = RegExp(pattern.toString());
  if (value == null || !regex.hasMatch(value)) {
    return '';
  } else {
    return null;
  }
}

String? validateMobile(String? value) {
// Indian Mobile number are of 10 digit only
  if (value == null || value.trim().length < 10) {
    return 'Mobile Number must be of 10 digit';
  } else {
    return null;
  }
}

String? validateEmail(String? value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern.toString());
  if (value == null || !regex.hasMatch(value)) {
    return '';
  } else {
    return null;
  }
}
