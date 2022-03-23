

class GeometryModel{
  double lon;
  double lat;

  GeometryModel(this.lon, this.lat);

  factory GeometryModel.fromJson(Map<String, dynamic> json)=>GeometryModel(json["lat"], json["lon"]);
}