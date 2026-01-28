import 'package:test/test.dart';
import 'package:tie_fp/tie_fp.dart';

class TestModel {
  const TestModel({required this.name, required this.age});

  factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
        name: json['name'] as String,
        age: json['age'] as int,
      );

  final String name;
  final int age;
}

void main() {
  group('Extensions result', () {
    int value(int v) => v;
    int valueError() => throw Exception();
    Future<int> futureValue() => Future.value(1);
    Future<int> futureError() async => throw Exception();

    test('Function return error', () {
      // final a = Result.t;
      final r = Result.wrapFunction(() => valueError());
      expect(r, isA<Result>());
      expect(r.isError(), true);
      expect(r.getError(), isException);
      expect(() => r.getValue(), throwsA(isA<Failure>()));
    });
    test('Function return value', () {
      // final a = Result.t;
      final r = Result.wrapFunction(() => value(1));
      expect(r, TypeMatcher<Result<int>>());
      expect(r.isError(), false);
      expect(() => r.getError(), throwsA(isA<Failure>()));
      expect(r.getValue(), 1);
    });
    test('Future return value', () async {
      // final a = Result.t;
      final r = await futureValue().toResult();
      expect(r, TypeMatcher<Result<int>>());
      expect(r.isError(), false);
      expect(() => r.getError(), throwsA(isA<Failure>()));
      expect(r.getValue(), 1);
    });
    test('Future throws error', () async {
      final r = await futureError().toResult();

      expect(r, isA<Result>());
      expect(r.isError(), true);
      expect(r.getError(), isException);

      expect(() => r.getValue(), throwsA(isA<Failure>()));
    });
    test('Future throws error', () async {
      final r = await futureError().toResult();

      expect(r, isA<Result>());
      expect(r.getError(), isException);
      expect(() => r.getValue(), throwsA(isA<Failure>()));
    });
  });

  group('ResultFromJson extension', () {
    test('JSON parsing returns Success with valid data', () {
      final json = {'name': 'John', 'age': 25};

      final r = TestModel.fromJson.toResult(json);

      expect(r, isA<Result<TestModel>>());
      expect(r.isError(), false);
      expect(r.getValue().name, 'John');
      expect(r.getValue().age, 25);
    });

    test('JSON parsing returns Failure with missing required field', () {
      final json = <String, dynamic>{'name': 'John'};

      final r = TestModel.fromJson.toResult(json);

      expect(r, isA<Result<TestModel>>());
      expect(r.isError(), true);
      expect(r.getError(), isA<TypeError>());
      expect(() => r.getValue(), throwsA(isA<Failure>()));
    });

    test('JSON parsing returns Failure with wrong type', () {
      final json = <String, dynamic>{'name': 'John', 'age': 'not an int'};

      final r = TestModel.fromJson.toResult(json);

      expect(r, isA<Result<TestModel>>());
      expect(r.isError(), true);
      expect(r.getError(), isA<TypeError>());
      expect(() => r.getValue(), throwsA(isA<Failure>()));
    });

    test('JSON parsing returns Failure with null json values', () {
      final json = <String, dynamic>{'name': null, 'age': 25};

      final r = TestModel.fromJson.toResult(json);

      expect(r, isA<Result<TestModel>>());
      expect(r.isError(), true);
      expect(() => r.getValue(), throwsA(isA<Failure>()));
    });
  });
}
