class UserForm {
  String fullName;
  String email;
  String password;
  String phone;
  bool gender;
  String address;
  String address2;
  String city;
  String state;
  String country;
  String postcode;

  UserForm({
    this.fullName, 
    this.email,
    this.password,
    this.phone,
    this.gender = true,
    this.address,
    this.address2,
    this.city,
    this.state,
    this.country,
    this.postcode
  }
  );

  Map<String,dynamic> toJson() => {
      "email": email,
      "fullName": fullName,
      "phone": phone,
      "gender": gender,
      "address": address,
      "address2": address2.trim(),
      "city": city,
      "state": state,
      "country": country,
      "postcode": postcode
  };
}