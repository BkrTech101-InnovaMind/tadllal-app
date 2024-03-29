import 'package:tedllal/config/config.dart';
import 'package:tedllal/config/global.dart';
import 'package:tedllal/services/dio_helper.dart';

initApiConfig() async {
  if (Config().baseUrl != null) {
    await DioHelper.init(Config().baseUrl!);
    await DioHelper.initCookies();
  } else {
    Config.set("baseUrl", appApiUri);
    await DioHelper.init(Config().baseUrl!);
    await DioHelper.initCookies();
  }
}

Future<void> setBaseUrl(url) async {
  bool isSSL = true;
  if (!url.startsWith('http://') && isSSL == false) {
    url = "http://$url";
  } else if (!url.startsWith('http://') &&
      !url.startsWith('https://') &&
      isSSL == true) {
    url = "https://$url";
  }
  await Config.set('baseUrl', url);
  await DioHelper.init(url);
}

String getAbsoluteUrl(String url) {
  return Uri.encodeFull("${Config().baseUrl}$url");
}
