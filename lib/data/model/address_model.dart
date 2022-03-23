

class AddressModel{
  String street;
  String city;
  String state;
  String zip;

  AddressModel(this.street, this.city, this.state, this.zip);

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(json["street"], json["city"], json["state"], json["zip"]);
}