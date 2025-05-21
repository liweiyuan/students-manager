import 'package:student_manager/data/mock_data.dart';
import 'package:test/test.dart';

void main() {
  test('mock_student_size', () {
    expect(students.length, 3);
  });
}
