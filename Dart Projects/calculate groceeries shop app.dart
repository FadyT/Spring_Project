void main() {
  const double taxRate = 0.10;

//Let each grocery item as a map with key name and price
  List<Map<String, dynamic>> groceryItems = [
    {'name': 'Apple', 'price': 2.5},
    {'name': 'Milk', 'price': 1.5},
    {'name': 'Bread', 'price': 3.0},
    {'name': 'Eggs', 'price': 2.0}
  ];

  double totalPrice = 0.0;
//Use the loop to calculate the total price, then add it to the tax rate.

  for (var item in groceryItems) {
    totalPrice += item['price'];
  }
//Add taxes constant doesn't change throughout the program (it'll be 10%)
  double totalPriceWithTax = totalPrice + (totalPrice * taxRate);

  // Print the results
  print('Total price without tax: \$${totalPrice.toStringAsFixed(2)}');
  print('Total price with tax: \$${totalPriceWithTax.toStringAsFixed(2)}');
}
