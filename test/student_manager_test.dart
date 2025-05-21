import 'package:student_manager/student_data.dart';
import 'package:test/test.dart';

void main() {
  test('mock_student_size', () {
    expect(students.length, 3);
  });
}
