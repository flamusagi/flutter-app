import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/content_list/newslist.dart';

void main() {
  group('NewsItem Tests', () {
    test('toMap should return a map with the correct values', () {
      final newsItem = NewsItem(
        id: '1',
        ctime: '2023-11-07',
        title: 'Test Title',
        description: 'Test Description',
        source: 'Test Source',
        picUrl: 'https://example.com/image.jpg',
        url: 'https://example.com/news',
      );

      final map = newsItem.toMap();

      expect(map, {
        'id': '1',
        'ctime': '2023-11-07',
        'title': 'Test Title',
        'description': 'Test Description',
        'source': 'Test Source',
        'picUrl': 'https://example.com/image.jpg',
        'url': 'https://example.com/news',
      });
    });

    test('fromMap should create a NewsItem instance from a map', () {
      final map = {
        'id': '2',
        'ctime': '2023-11-08',
        'title': 'Another Title',
        'description': 'Another Description',
        'source': 'Another Source',
        'picUrl': 'https://example.com/another.jpg',
        'url': 'https://example.com/another-news',
      };

      final newsItem = NewsItem.fromMap(map);

      expect(newsItem.id, '2');
      expect(newsItem.ctime, '2023-11-08');
      expect(newsItem.title, 'Another Title');
      expect(newsItem.description, 'Another Description');
      expect(newsItem.source, 'Another Source');
      expect(newsItem.picUrl, 'https://example.com/another.jpg');
      expect(newsItem.url, 'https://example.com/another-news');
    });

    test('fromJson should create a NewsItem instance from a JSON map', () {
      final json = {
        'id': '3',
        'ctime': '2023-11-09',
        'title': 'JSON Title',
        'description': 'JSON Description',
        'source': 'JSON Source',
        'picUrl': 'https://example.com/json.jpg',
        'url': 'https://example.com/json-news',
      };

      final newsItem = NewsItem.fromJson(json);

      expect(newsItem.id, '3');
      expect(newsItem.ctime, '2023-11-09');
      expect(newsItem.title, 'JSON Title');
      expect(newsItem.description, 'JSON Description');
      expect(newsItem.source, 'JSON Source');
      expect(newsItem.picUrl, 'https://example.com/json.jpg');
      expect(newsItem.url, 'https://example.com/json-news');
    });
  });
}
