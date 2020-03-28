import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart' show required;
import 'package:my_flutter_app_2/models/play_list.dart';

class YouTubeAPI {
  final String apiKey;

  YouTubeAPI({@required this.apiKey}) : assert(apiKey != null);

  String _getUrl(Map<String, String> queryParameters) {
    final uri = Uri(
        scheme: 'https',
        host: 'www.googleapis.com',
        path: '/youtube/v3/playlists',
        queryParameters: queryParameters);

    return uri.toString();
  }

  Future<List<PlayList>> getPlayLists(String channelId) async {
    try {
      final url = _getUrl({
        "channelId": channelId,
        "part": "snippet,contentDetails",
        "maxResults": "7",
        "key": this.apiKey
      });
      print(url);
      final response = await http.get(url);
      print(response.body);
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final List<PlayList> items = (parsed['items'] as List)
            .map<PlayList>((item) => PlayList.fromJson(item))
            .toList();
        return items;
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }
}
