import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  Widget build(BuildContext context) {
    //use media query to design responsive UI.
    final size = MediaQuery.of(context).size;

    return Scaffold(
      //give a title to the page using appBar
      appBar: AppBar(
        title: Text('appTitle'.tr()), // Localized app title
      ),
      body: Center(
        child: ListView(
          children: [
            //place at the start of the page text says ""our products"" below it a pageView that shows images of the products
             Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text( 'ourProducts'.tr() , style: TextStyle(fontSize: 24)),
            ),
            // vertical list for products
            SizedBox(
              height: size.height /4,
              child: PageView(
                children: List.generate(
                  2,
                      (index) => Image.asset('assets/product0$index.jpeg', fit: BoxFit.cover),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: Text('', style: TextStyle(fontSize: 24)),
            ),
            //place gridView that display 2 cards in the single row of the gridView these cards shows
            SizedBox(
               height: size.height/5, // Adjust the height based on your design
               child: GridView.builder(
                 scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 1, // Two items per column
                   mainAxisSpacing: 10, // Space between columns
                   crossAxisSpacing: 10, // Space between rows
                   childAspectRatio: 1, // Aspect ratio for the grid items
                 ),
                 itemCount: 2, // Total number of items
                 itemBuilder: (context, index) {
                   //text , image and add to cart icon (make sure when the icon is tapped to display
                   // snackbar that says item added to the cart)
                   return Card(
                     elevation: 0,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Image.asset(
                           'assets/product0$index.jpeg',
                           height: 80,
                           fit: BoxFit.cover,
                         ),
                         const SizedBox(height: 8),
                         Text('productName'.tr()),
                         IconButton(
                           icon: const Icon(Icons.add_shopping_cart),
                           onPressed: () {
                             ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(content: Text('Item added to the cart')),
                             );
                           },
                         ),
                       ],
                     ),
                   );
                 },
               ),
             ),
            //below the gridView add a text says ""hot offers""
             Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('hotOffers'.tr(), style: TextStyle(fontSize: 24)),
            ),
            // using ListView builder build a list of 5 items with images
            // and text inside it use expanded widget for both images and text.
            SizedBox(
              height: 200, // Constrain the height of the ListView
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // Horizontal scrolling
                itemCount: 5, // Number of items in the list
                itemBuilder: (context, index) {
                  return Container(
                    width: 200, // Width of each item
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Image.asset(
                            'assets/product0$index.jpeg', // Replace with your image paths
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${'item'.tr()} ${index + 1}', // Replace with dynamic content
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
