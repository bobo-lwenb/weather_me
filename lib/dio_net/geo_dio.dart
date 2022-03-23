import 'package:dio/dio.dart';
import 'package:weather_me/dio_net/base_dio.dart';
import 'package:weather_me/router/area_list/model/lookup_area.dart';

late var _baseUrl = 'https://geoapi.qweather.com/v2';

GeoDio geoDio = GeoDio(baseUrl: _baseUrl);

class GeoDio extends BaseDio {
  GeoDio({required String baseUrl}) : super(baseUrl: baseUrl);

  Future<List<LookupArea>> lookupLocation({
    required String adcode,
    String keyWord = 'location',
    CancelToken? cancelToken,
  }) async {
    var params = {
      'location': adcode,
      'number': 10,
    };
    List<dynamic> result = await get(
      path: '/city/lookup',
      queryParams: params,
      keyWord: keyWord,
      cancelToken: cancelToken,
    );
    List<LookupArea> list = List.empty(growable: true);
    for (var item in result) {
      LookupArea lookupCity = LookupArea.fromJson(item);
      list.add(lookupCity);
    }
    return list;
  }
}
