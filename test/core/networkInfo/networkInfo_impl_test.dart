import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/core/networkInfo/network_info.dart';

import 'networkInfo_impl_test.mocks.dart';



@GenerateMocks([InternetConnectionChecker])

void main(){
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(
      internetConnectionChecker: mockInternetConnectionChecker
  );
  });
    test('Should return true when there is internet connection', () async {
      when(mockInternetConnectionChecker.hasConnection).thenAnswer((_) async  => true);

      final result = await networkInfo.isConnected;

      expect(result, true);
      verify(mockInternetConnectionChecker.hasConnection);
    });
    test('Should return false when there is no internet connection', () async {
      when(mockInternetConnectionChecker.hasConnection).thenAnswer((_) async  => false);

      final result = await networkInfo.isConnected;

      expect(result, false);
      verify(mockInternetConnectionChecker.hasConnection);
    });
}