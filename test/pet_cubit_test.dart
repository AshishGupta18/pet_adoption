import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:pet_adoption/presentation/blocs/pet_cubit/pet_cubit.dart';
import 'package:pet_adoption/data/datasources/mock_pet_data.dart';
import 'package:pet_adoption/data/repositories/pet_repository_impl.dart';

void main() {
  group('PetCubit', () {
    late PetCubit petCubit;
    late MockPetDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockPetDataSource();
      petCubit = PetCubit(PetRepositoryImpl(dataSource: mockDataSource));
    });

    tearDown(() {
      petCubit.close();
    });

    test('initial state is PetInitial', () {
      expect(petCubit.state, isA<PetInitial>());
    });

    blocTest<PetCubit, PetState>(
      'emits [PetLoading, PetLoaded] when pets are loaded successfully',
      build: () => petCubit,
      act: (cubit) => cubit.loadPets(),
      expect: () => [isA<PetLoading>(), isA<PetLoaded>()],
      verify: (cubit) {
        final state = cubit.state as PetLoaded;
        expect(state.pets, isNotEmpty);
      },
    );
  });
}
