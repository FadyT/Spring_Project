import 'dart:io';

void main() {
  // Prompt user to enter an integer number
  print('Enter an integer number:');
  int? number = int.tryParse(stdin.readLineSync()!);

  // Check if the number is valid
  if (number == null) {
    print('Invalid input. Please enter a valid integer.');
    return;
  }

  // Check if the number is positive or negative
  if (number > 0) {
    print('$number is positive.');
  } else if (number < 0) {
    print('$number is negative.');
  } else {
    print('$number is neither positive nor negative.');
  }

  // Check if the number is even or odd
  if (number % 2 == 0) {
    print('$number is even.');
  } else {
    print('$number is odd.');
  }
}
