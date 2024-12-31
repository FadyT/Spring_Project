
class Book {
  // Books Class has attributes (id, title, borrowed) 
  int id;
  String title;
  bool borrowed;

  // Class constructor for book class
  Book(this.id, this.title, this.borrowed);

  // displayInfo method.
  void displayInfo() {
    print('Book ID: $id, Title: $title, Borrowed: $borrowed');
  }
}

class User {
  // User Class has attributes (id, name) 
  int id;
  String name;

  // Constructor for the User class
  User(this.id, this.name);

  // displayInfo method.
  void displayInfo() {
    print('User ID: $id, Name: $name');
  }
}

class Library {
  // Library Class has attributes (list of books , list of users) 
  List<Book> books = [];
  List<User> users = [];

  //  Library methods to (addBook , return book , borrowBook ,displayInfo).
  void addBook(Book book) {
    books.add(book);
    print('Book added: ${book.title}');
  }

  // Method to return a book to the library
  void returnBook(int bookId, int userId) {
    Book? book = _findBookById(bookId);
    if (book != null && book.borrowed) {
      book.borrowed = false;
      print('Book returned: ${book.title} by User ID: $userId');
    } else {
      print('Book not available for return.');
    }
  }

  // Method to borrow a book from the library
  void borrowBook(int bookId, int userId) {
    Book? book = _findBookById(bookId);
    if (book != null && !book.borrowed) {
      book.borrowed = true;
      print('Book borrowed: ${book.title} by User ID: $userId');
    } else {
      print('Book not available for borrowing.');
    }
  }


  // Display library information method
  void displayInfo() {
    print('Library Books:');
    for (var book in books) {
      book.displayInfo();
    }

    print('\nLibrary Users:');
    for (var user in users) {
      user.displayInfo();
    }
  }

  // method to find a book by its ID
  Book? _findBookById(int bookId) {
    for (var book in books) {
      if (book.id == bookId) {
        return book;
      }
    }
    return null;
  }
}

void main() {
  // Create instances of the Library class
  Library library = Library();

  // Create and add books to the library
  Book book1 = Book(1, '1984', false);
  Book book2 = Book(2, 'To Kill a Mockingbird', false);
  library.addBook(book1);
  library.addBook(book2);

  // Create and add users to the library
  User user1 = User(1, 'Alice');
  User user2 = User(2, 'Bob');
  library.users.add(user1);
  library.users.add(user2);

  // Perform borrowing and returning operations
  library.borrowBook(1, 1);
  library.returnBook(1, 1);
  library.borrowBook(2, 2);
  library.borrowBook(1, 2); // Book already borrowed

  // Display final state of the library
  library.displayInfo();
}
