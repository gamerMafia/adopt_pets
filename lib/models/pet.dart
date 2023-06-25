class Pet {
  final String name;
  final String age;
  final double price;
  final String image;
  bool isAdopted;

  Pet({required this.name, required this.age, required this.price, required this.image, this.isAdopted = false});
}
