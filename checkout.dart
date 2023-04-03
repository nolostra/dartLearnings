import 'dart:io';

class Product {
  const Product({required this.id, required this.name, required this.price});
  final int id;
  final String name;
  final double price;
  // String get displayName => '$name: \$$price';
  String get displayName => '($intial)${name.substring(1)}: \$$price';
  String get intial => name.substring(0, 1);
}

class Item {
  const Item({required this.product, this.quantity = 1});
  final Product product;
  final int quantity;

  double get price => quantity * product.price;
  @override
  String toString() => '$quantity x ${product.name}: \$$price ';
}

class Cart {
  final Map<int, Item> _items = {};
  void addProduct(Product product) {
    final item = _items[product.id];
    if (item == null) {
      _items[product.id] = Item(product: product, quantity: 1);
    } else {
      _items[product.id] = Item(product: product, quantity: item.quantity + 1);
    }
  }

  bool get isEmpty => _items.isEmpty;

  double total() => _items.values
      .map((item) => item.price)
      .reduce((value, element) => value + element);
  @override
  String toString() {
    if (_items.isEmpty) {
      return 'cart is empty';
    }
    final itemzedList = _items.values.map((item) => item.toString()).join('\n');
    return '------\n $itemzedList\n Total: \$${total()}\n------';
  }
}

const allProducts = [
  Product(id: 1, name: 'apples', price: 1.6),
  Product(id: 2, name: 'banana', price: .70),
  Product(id: 3, name: 'courgettes', price: 1.0),
  Product(id: 4, name: 'grapes', price: 2.0),
  Product(id: 5, name: 'mushrooms', price: 0.8),
  Product(id: 6, name: 'potatoes', price: 1.5),
];

void main() {
  final cart = Cart();
  while (true) {
    stdout.write(
        "what do u want to do ? (v)iew items , (a)dd aitems , (c)heckout");
    final line = stdin.readLineSync();
    if (line == 'a') {
      final product = chooseProduct();
      if (product != null) {
        cart.addProduct(product);
        print(cart);
      }
    } else if (line == 'v') {
      print(cart);
    } else if (line == 'c') {
      if (checkout(cart)) {
        break;
      }
    }
  }
}

Product? chooseProduct() {
  final productList =
      allProducts.map((product) => product.displayName).join('\n');
  stdout.write("Available Products : \n $productList");
  final line = stdin.readLineSync();
  for (var product in allProducts) {
    if (product.intial == line) {
      return product;
    }
  }
  print('Not Found');
  return null;
}

bool checkout(Cart cart) {
  if (cart.isEmpty) {
    print('Cart is empty');
    return false;
  }
  final total = cart.total();
  print('Total: \$$total');
  stdout.write('Payment in cash');
  final line = stdin.readLineSync();
  if (line == null || line.isEmpty) {
    return false;
  }
  final paid = double.tryParse(line);
  if (paid == null) {
    return false;
  }
  if (paid >= total) {
    final change = paid - total;
    print('Change: \$${change.toStringAsFixed(2)}');
    return true;
  } else {
    print('not enough cash');
    return false;
  }
}
