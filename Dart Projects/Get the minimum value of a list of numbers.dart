void main() {
  // Add the list of integer numbers 
  List<int> numbers = [34, 7, 23, 32, 5, 62];

  // Make a function that finds the minimum value of this list.
  int getMinValue(List<int> numbers) {
    int minValue = numbers[0]; 
    for (int i = 1; i < numbers.length; i++) {
      if (numbers[i] < minValue) {
        minValue = numbers[i];
      }
    }
    return minValue;
  }

  // use the function to get min number
  int minValue = getMinValue(numbers);

  // Print the result
  print('The minimum value in the list is: $minValue');
}
