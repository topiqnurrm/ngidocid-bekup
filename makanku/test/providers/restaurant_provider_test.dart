import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:makanku/data/models/restaurant.dart';
import 'package:makanku/data/restaurant_repository.dart';
import 'package:makanku/providers/restaurant_provider.dart';

// ✅ Langkah penting: beri tahu mockito untuk generate mock
@GenerateMocks([RestaurantRepository])
import 'restaurant_provider_test.mocks.dart';

void main() {
  late RestaurantProvider provider;
  late MockRestaurantRepository mockRepository;

  setUp(() {
    mockRepository = MockRestaurantRepository();
    provider = RestaurantProvider(repo: mockRepository);
  });

  group('RestaurantProvider Test', () {
    test('State awal provider harus didefinisikan dengan benar', () {
      expect(provider.state, equals(LoadingState.idle));
      expect(provider.restaurants, isEmpty);
      expect(provider.message, equals(''));
    });

    test('Harus mengembalikan daftar restoran ketika pengambilan data API berhasil', () async {
      // Arrange
      final dummyRestaurants = [
        Restaurant.fromJson({
          "id": "1",
          "name": "Sate Pak Man",
          "description": "Sate legendaris di kota Malang.",
          "city": "Malang",
          "address": "Jl. Merdeka No. 10",
          "pictureId": "1",
          "rating": 4.7,
          "menus": {
            "foods": [{"name": "Sate Ayam"}],
            "drinks": [{"name": "Es Teh Manis"}]
          },
          "customerReviews": []
        }),
        Restaurant.fromJson({
          "id": "2",
          "name": "Bakso Bu Tini",
          "description": "Bakso terenak dengan kuah kaldu gurih.",
          "city": "Surabaya",
          "address": "Jl. Pahlawan No. 23",
          "pictureId": "2",
          "rating": 4.5,
          "menus": {
            "foods": [{"name": "Bakso Urat"}],
            "drinks": [{"name": "Jeruk Hangat"}]
          },
          "customerReviews": []
        }),
      ];

      when(mockRepository.getRestaurants())
          .thenAnswer((_) async => dummyRestaurants);

      // Act
      await provider.loadRestaurants();

      // Assert
      expect(provider.state, equals(LoadingState.idle));
      expect(provider.restaurants, isNotEmpty);
      expect(provider.restaurants.length, equals(2));
      verify(mockRepository.getRestaurants()).called(1);
    });

    test('Harus mengembalikan kesalahan ketika pengambilan data API gagal', () async {
      // Arrange
      when(mockRepository.getRestaurants())
          .thenThrow(Exception('Network error'));

      // Act
      await provider.loadRestaurants();

      // Assert
      expect(provider.state, equals(LoadingState.error));
      expect(provider.message, contains('Oops'));
      verify(mockRepository.getRestaurants()).called(1);
    });
  });
}
