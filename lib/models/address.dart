class Address{
  int number;
  String typeStreet;
  String nameStreet;
  int code;
  String city;
  double long;
  double lat;
  Address(this.number,this.typeStreet,this.nameStreet,this.code,this.city,this.long,this.lat);

  @override
  String toString() {
    return "$number $typeStreet $nameStreet $code $city";
  }
}