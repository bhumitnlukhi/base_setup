import 'package:dio/dio.dart';


class DioClient {

  final Dio _dio;
  DioClient(this._dio);


  // /*
  // * ----Get Method
  // * */
  // Future<dynamic> getData(String endpoint) async {
  //
  //   String clientId= await HiveProvider.get(LocalConst.clientID);
  //   String token= await HiveProvider.get(LocalConst.tokenData);
  //   String aggId= await HiveProvider.get(LocalConst.aggId);
  //   String udf1= await HiveProvider.get(LocalConst.udf1);
  //   String lang= await HiveProvider.get(LocalConst.language);
  //
  //   try {
  //     _dio.options.headers = {
  //       // "clientId": "637208",
  //       "clientId": clientId,
  //       "token": token,
  //       "aggId": aggId,
  //       "udf1": udf1,
  //       "lang": lang,
  //     };
  //     Response response = await _dio.get(endpoint);
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //
  //
  // /*
  // * ----Post Method
  // * */
  // Future<dynamic> postData(String endpoint,String data) async {
  //   try {
  //     /*Options opt = Options(
  //         headers: {
  //           "bcagentid": "1",
  //           "tokendata": "12345"
  //         }
  //     );*/
  //
  //     // String tokenData= await HiveProvider.get(LocalConst.tokenData);
  //     String clientId= await HiveProvider.get(LocalConst.clientID);
  //     String token= await HiveProvider.get(LocalConst.tokenData);
  //     String aggId= await HiveProvider.get(LocalConst.aggId);
  //     String udf1= await HiveProvider.get(LocalConst.udf1);
  //     String lang= await HiveProvider.get(LocalConst.language);
  //
  //     /*Options opt = Options(
  //         headers: {
  //           "clientId": "674268"
  //         });*/
  //        _dio.options.headers = {
  //          // "clientId": "637208",
  //          "clientId": clientId,
  //          "token": token,
  //          "aggId": aggId,
  //          "udf1": udf1,
  //          "lang": lang,
  //          // "Content-Type" : "application/json"
  //        };
  //     Response response = await _dio.post(endpoint,data: data);
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //
  // /*
  // * ----Post without Header
  // * */
  // Future<dynamic> postDataVerifySession(String endpoint,String data) async {
  //   try {
  //     Response response = await _dio.post(endpoint,data: data);
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }



}
