import 'dart:convert';
import 'package:dialog/dialog.dart';
import 'dart:html';
import 'package:http/http.dart' as http;

void main() {
  querySelector('#searchCity').onClick.listen((event) async {
    event.preventDefault();
    var myDialog = await prompt('Which city wants weather information?');

    if (myDialog.toString().length > 0) {
      loadData([myDialog.toString()]);
    } else {
      alert('No cities entered');
    }
  });
}

Future getWeather(String city) {
  String url =
      'https://api.hgbrasil.com/weather?format=json-cors&key=2911d0d9&city_name=$city';
  return http.get(url);
}

void loadData(List cities) {
  var empty = querySelector('#empty');

  if (empty != null) {
    empty.remove();
  }

  cities.forEach((city) {
    insertData(getWeather(city));
  });
}

void insertData(Future data) async {
  var insertData = await data;
  var body = json.decode(insertData.body);

  if (body['results']['forecast'].length > 0) {
    String html = '<div class="row">';
    html += formatedHtml(body['results']['city_name']);
    html += formatedHtml(body['results']['temp']);
    html += formatedHtml(body['results']['description']);
    html += formatedHtml(body['results']['wind_speedy']);
    html += formatedHtml(body['results']['sunrise']);
    html += formatedHtml(body['results']['sunset']);
    html += '</div>';

    querySelector('.table').innerHtml += html;
  }
}

String formatedHtml(var data) {
  return '<div class="cell">$data</div>';
}
