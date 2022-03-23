

class WhetherData{
  double temp;
  double feels_like;
  double temp_min;
  double temp_max;

  WhetherData(
      {required this.temp,
      required this.feels_like,
      required this.temp_min,
      required this.temp_max,
      });

  factory WhetherData.fromJson(Map<String, dynamic> json)=> WhetherData(temp: double.parse(json["temp"].toString()), feels_like: json["feels_like"], temp_min: json["temp_min"], temp_max: json["temp_max"]);
}