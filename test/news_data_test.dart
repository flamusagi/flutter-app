import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/content_list/newslist.dart';


void main(){
  group('NewsItemHelper Tests', () {
    test('loadJsonData should fetch and parse news data', () async {

      final newsItemHelper = NewsItemHelper();
      final newsItems = await newsItemHelper.loadJsonData(NewsItem.currentPage);

      expect(newsItems.isNotEmpty, isTrue);
      expect(newsItems, isNotEmpty);
      expect(newsItems, isA<List<NewsItem>>());


// Add more assertions to validate the fetched data
    });
  });
}
