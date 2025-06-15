import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pet_adoption/presentation/blocs/pet_cubit/pet_cubit.dart';
import 'package:pet_adoption/data/repositories/petfinder_repository_impl.dart';
import 'package:pet_adoption/data/services/petfinder_service.dart';
import 'package:pet_adoption/domain/entities/pet_entity.dart';

@GenerateMocks([PetfinderService])
import 'pet_cubit_test.mocks.dart';

void main() {
  group('PetCubit', () {
    late PetCubit petCubit;
    late MockPetfinderService mockService;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      mockService = MockPetfinderService();
      petCubit = PetCubit(PetfinderRepositoryImpl(mockService), prefs);
    });

    tearDown(() {
      petCubit.close();
    });

    test('initial state is PetInitial', () {
      expect(petCubit.state, isA<PetInitial>());
    });

    blocTest<PetCubit, PetState>(
      'emits [PetLoading, PetLoaded] when pets are loaded successfully',
      build: () {
        when(mockService.getPets()).thenAnswer(
          (_) async => [
            PetEntity(
              id: '1',
              name: 'Test Pet',
              age: 2,
              price: 100.0,
              imageUrl: 'https://example.com/image.jpg',
            ),
          ],
        );
        return petCubit;
      },
      act: (cubit) => cubit.loadPets(),
      expect: () => [isA<PetLoading>(), isA<PetLoaded>()],
      verify: (cubit) {
        final state = cubit.state as PetLoaded;
        expect(state.pets, isNotEmpty);
        expect(state.pets.first.name, equals('Test Pet'));
      },
    );

    blocTest<PetCubit, PetState>(
      'emits [PetLoading, PetError] when loading pets fails',
      build: () {
        when(mockService.getPets()).thenThrow(Exception('Failed to load pets'));
        return petCubit;
      },
      act: (cubit) => cubit.loadPets(),
      expect: () => [isA<PetLoading>(), isA<PetError>()],
      verify: (cubit) {
        final state = cubit.state as PetError;
        expect(state.message, isNotEmpty);
      },
    );
  });
}
