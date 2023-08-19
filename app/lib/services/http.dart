import 'package:tadllal/config/config.dart';
import 'package:tadllal/services/dio_helper.dart';

initApiConfig() async {
  if (Config().baseUrl != null) {
    await DioHelper.init(Config().baseUrl!);
    await DioHelper.initCookies();
  }
}

Future<void> setBaseUrl(url) async {
  /* if (!url.startsWith('https://')) {
    url = "https://$url";
  }*/
  if (!url.startsWith('http://')) {
    url = "http://$url";
  } else if (!url.startsWith('http://') && !url.startsWith('https://')) {
    url = "https://$url";
  }
  await Config.set('baseUrl', url);
  await DioHelper.init(url);
}

String getAbsoluteUrl(String url) {
  return Uri.encodeFull("${Config().baseUrl}$url");
}
