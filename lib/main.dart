import 'package:myapp/restaurant_list.dart';

void main() async {
  try {
    print(await fetchRestaurantByKeyword("홍대"));
  } catch (e) {
    print(e);
  }

  try {
    print("평점 순으로 정렬된 맛집 리스트:");
    print(await sortRestaurantsByRating());
  } catch (e) {
    print(e);
  }
}

Future<List<String>> fetchRestaurantByKeyword(String query,
    {int retry = 0}) async {
  // 전체 레스토랑 리스트를 받아오는 작업
  List<Restaurant> restaurants = await makeRestaurants();

  // query(name) 인자를 활용해서 레스토랑을 검색
  List<String> result = [];

  for (var restaurant in restaurants) {
    if (restaurant.name.contains(query)) {
      result.add(restaurant.name);
    }
  }

  // 만약 매칭되는 식당들이 없으면 에러 발생 및 재시도
  if (result.isEmpty) {
    retry++;
    if (retry <= 3) {
      print("검색 결과가 없습니다! 3초 뒤 재시도합니다. (재시도 횟수: $retry)");
      await Future.delayed(Duration(seconds: 3)); // 3초 대기
      return await fetchRestaurantByKeyword(query, retry: retry); // 재시도
    } else {
      throw Exception("매칭되는 식당이 없습니다. 최대 재시도 횟수(3회)를 초과했습니다.");
    }
  }

  return result;
}

Future<List<Map<String, dynamic>>> sortRestaurantsByRating() async {
  List<Restaurant> restaurants = await makeRestaurants();
  restaurants.sort((a, b) => (b.rating ?? 0.0).compareTo(a.rating ?? 0.0));
   return restaurants.map((restaurant) => {
    'name': restaurant.name,
    'rating': restaurant.rating ?? 0.0
  }).toList();
}
