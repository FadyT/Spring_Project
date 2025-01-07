# storeapp

Simple store app

## shopping_page

- App use media query to design responsive UI.
- it has a title using appBar
- At the start of the page text says ""our products"" below it a pageView that shows images of the products
- then there is a gridView that display 2 cards in the single row of the gridView these cards shows text , image and add to cart icon (make sure when the icon is tapped to display snackbar that says item added to the cart)
- below the gridView there is a text says ""hot offers"" and using ListView builder build a list of 5 items with images 
and text inside it use expanded widget for both images and text.
- the page is scrollable horizontally."

<img width="1728" alt="Screenshot 2025-01-04 at 4 15 03 AM" src="https://github.com/user-attachments/assets/6ffd6272-5e2c-45ae-83a4-3f6b3271bfa2" />


## sign_up_page
- in the page we have 4 textformfields one for username , email , pass and pass confirmation
- we used a TextEditingController for each of them 
- user name is checking that first letter is upper case
- email check if it contains @
- password check if both are matching and has more than 6 letter 
- we have 3 methods check and submit to navigate to next page if all data are valid 
- show snack bar to show snack bar contain the error if data is not valid
- and show dialog to show successful signup if all data is valid
  <img width="1728" alt="image" src="https://github.com/user-attachments/assets/6ab345c3-8ea2-4757-b32d-d63ae2c37e04" />


## fade animation
- added navigateWithFade function to fade the transition between pages and updated the dialog on press to fade instead of changing the page without effect
