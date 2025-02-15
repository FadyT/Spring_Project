class User {
  final String firstName;
  final String lastName;
  final int? age;
  final String? phone;

  User._builder(UserBuilder builder)
      : firstName = builder.firstName,
        lastName = builder.lastName,
        age = builder.age,
        phone = builder.phone;

  @override
  String toString() {
    return 'User(firstName: $firstName, lastName: $lastName, age: $age, phone: $phone)';
  }
}

class UserBuilder {
  final String firstName;
  final String lastName;
  int? age;
  String? phone;

  UserBuilder({required this.firstName, required this.lastName});

  UserBuilder setAge(int age) {
    this.age = age;
    return this;
  }

  UserBuilder setPhone(String phone) {
    this.phone = phone;
    return this;
  }

  User build() {
    return User._builder(this);
  }
}

void main() {
  User user = UserBuilder(firstName: "John", lastName: "Doe")
      .setAge(25)
      .setPhone("123-456-7890")
      .build();

  print(user);
}
