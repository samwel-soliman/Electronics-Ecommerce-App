import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}


class ThemeNotifier with ChangeNotifier {
  bool _isDark = false;

  ThemeNotifier() {
    _isDark = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
  }

  bool get isDark => _isDark;

  set isDark(bool value) {
    _isDark = value;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
debugShowCheckedModeBanner: false,
          title: 'E-Commerce App',
          theme: themeNotifier.isDark
              ? ThemeData.dark().copyWith(
                  iconTheme: IconThemeData(color: Colors.white))
              : ThemeData.light().copyWith(
                  iconTheme: IconThemeData(color: Colors.black)),
          home: ECommerceApp(),
        );
      },
    );
  }
}

class ECommerceApp extends StatefulWidget {
  @override
  _ECommerceAppState createState() => _ECommerceAppState();
}

class _ECommerceAppState extends State<ECommerceApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ShoppingCartScreen(),
    DeliverablesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Commerce App'),
        actions: [
          IconButton(
            icon: Icon(Provider.of<ThemeNotifier>(context).isDark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              Provider.of<ThemeNotifier>(context, listen: false).isDark =
                  !Provider.of<ThemeNotifier>(context, listen: false).isDark;
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping), label: 'Deliverables'),
        ],
      ),
    );
  }
}


// Shopping cart logic
class ShoppingCart {
  static final List<Map<String, dynamic>> _cartItems = [];
  static final List<Map<String, dynamic>> _deliverables = [];

  static void addToCart(Map<String, dynamic> product) {
    _cartItems.add(product);
  }

  static void removeFromCart(Map<String, dynamic> product) {
    _cartItems.remove(product);
  }

  static void clearCart() {
    _cartItems.clear();
  }

  static List<Map<String, dynamic>> get cartItems => _cartItems;
  static List<Map<String, dynamic>> get deliverables => _deliverables;

  static double get totalPrice =>
      _cartItems.fold(0, (sum, item) => sum + item['price']);

  static void moveToDeliverables() {
    _deliverables.addAll(_cartItems);
    _cartItems.clear();
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
        backgroundColor: Color(0xFF4567B7), // Primary color
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 37, 57, 104), // Primary color
              Color.fromARGB(255, 105, 112, 79), // Secondary color
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 300,
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
            ),
            Expanded(child: ProductList(searchQuery: _searchQuery)),
          ],
        ),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final String searchQuery;

  ProductList({Key? key, required this.searchQuery}) : super(key: key);

  final List<Map<String, dynamic>> products = [
  {
    'name': 'Smartphone',
    'image': 'assets/smartphone.png',
    'description': 'Latest model with high performance and long-lasting battery.',
    'rating': 4.5,
    'price': 699.99,
  },
  {
    'name': 'Laptop',
    'image': 'assets/laptop.png',
    'description': 'Powerful laptop for professionals and gamers.',
    'rating': 4.8,
    'price': 999.99,
  },
  {
    'name': 'Wireless Earbuds',
    'image': 'assets/earbuds.png',
    'description': 'Compact and high-quality sound with noise cancellation.',
    'rating': 4.2,
    'price': 49.99,
  },
  {
    'name': 'Smart Watch',
    'image': 'assets/smartwatch.png',
    'description': 'Track your fitness and notifications on the go.',
    'rating': 4.7,
    'price': 199.99,
  },
  {
    'name': 'Gaming Mouse',
    'image': 'assets/mouse.png',
    'description': 'Ergonomic design with customizable buttons and RGB lighting.',
    'rating': 4.6,
    'price': 59.99,
  },
  {
    'name': 'Bluetooth Speaker',
    'image': 'assets/speaker.png',
    'description': 'Portable speaker with powerful bass and long battery life.',
    'rating': 4.4,
    'price': 89.99,
  },
  {
    'name': '4K TV',
    'image': 'assets/tv.png',
    'description': 'Ultra HD Smart TV with vibrant colors and built-in apps.',
    'rating': 4.9,
    'price': 1299.99,
  },
  {
    'name': 'Electric Kettle',
    'image': 'assets/kettle.png',
    'description': 'Fast boiling with a sleek design and auto shut-off feature.',
    'rating': 4.3,
    'price': 29.99,
  },
  {
    'name': 'Fitness Tracker',
    'image': 'assets/tracker.png',
    'description': 'Track your steps, calories, and sleep with this lightweight band.',
    'rating': 4.1,
    'price': 79.99,
  },
  {
    'name': 'Camera',
    'image': 'assets/camera.png',
    'description': 'Capture high-quality photos and videos with ease.',
    'rating': 4.8,
    'price': 499.99,
  },  
  {
    'name': 'Tablet',
    'image': 'assets/tablet.png',
    'description': 'A high-resolution tablet suitable for work and entertainment.',
    'rating': 4.5,
    'price': 329.99,
  },
  {
    'name': 'Headphones',
    'image': 'assets/headphones.png',
    'description': 'Over-ear headphones with noise isolation and rich sound.',
    'rating': 4.7,
    'price': 129.99,
  },
  {
    'name': 'Gaming Laptop',
    'image': 'assets/gaming_laptop.png',
    'description': 'A powerful gaming laptop with high refresh rate display.',
    'rating': 4.8,
    'price': 1299.99,
  },
  {
    'name': '4K Monitor',
    'image': 'assets/4k_monitor.png',
    'description': 'Ultra HD monitor with vibrant colors and thin bezels.',
    'rating': 4.7,
    'price': 399.99,
  },
  {
    'name': 'Mechanical Keyboard',
    'image': 'assets/mechanical_keyboard.png',
    'description': 'RGB mechanical keyboard with customizable keys.',
    'rating': 4.6,
    'price': 99.99,
  },
  {
    'name': 'Wireless Charger',
    'image': 'assets/wireless_charger.png',
    'description': 'Fast wireless charger compatible with most smartphones.',
    'rating': 4.4,
    'price': 29.99,
  },
  {
    'name': 'Smart Glasses',
    'image': 'assets/smart_glasses.png',
    'description': 'Wearable smart glasses with AR capabilities.',
    'rating': 4.2,
    'price': 499.99,
  },
  
  {
    'name': 'VR Headset',
    'image': 'assets/vr_headset.png',
    'description': 'Immersive virtual reality headset for gaming and entertainment.',
    'rating': 4.7,
    'price': 299.99,
  },
  {
    'name': 'Smart Thermostat',
    'image': 'assets/smart_thermostat.png',
    'description': 'Energy-efficient thermostat with remote control capabilities.',
    'rating': 4.6,
    'price': 199.99,
  },
  {
    'name': 'Smart Speaker',
    'image': 'assets/smart_speaker.png',
    'description': 'Voice-activated speaker with high-quality sound.',
    'rating': 4.5,
    'price': 99.99,
  },
  {
    'name': 'WiFi Range Extender',
    'image': 'assets/wifi_extender.png',
    'description': 'Boosts WiFi signal strength in large homes.',
    'rating': 4.5,
    'price': 49.99,
  },
 
  {
    'name': 'Graphic Tablet',
    'image': 'assets/graphic_tablet.png',
    'description': 'Drawing tablet with pressure-sensitive stylus.',
    'rating': 4.7,
    'price': 129.99,
  },
  {
    'name': 'Home Security Camera',
    'image': 'assets/security_camera.png',
    'description': 'WiFi camera with night vision and motion alerts.',
    'rating': 4.6,
    'price': 89.99,
  },
  {
    'name': 'LED Monitor Light',
    'image': 'assets/monitor_light.png',
    'description': 'Adjustable monitor light to reduce eye strain.',
    'rating': 4.4,
    'price': 39.99,
  },
  {
    'name': 'Smart Ceiling Fan',
    'image': 'assets/smart_ceiling_fan.png',
    'description': 'WiFi-enabled ceiling fan with voice control.',
    'rating': 4.7,
    'price': 229.99,
  },
  {
    'name': 'Digital Alarm Clock',
    'image': 'assets/digital_clock.png',
    'description': 'Alarm clock with USB charging and night light.',
    'rating': 4.5,
    'price': 29.99,
  },
  {
    'name': 'Portable Hard Drive',
    'image': 'assets/portable_hard_drive.png',
    'description': '2TB external hard drive for secure data storage.',
    'rating': 4.6,
    'price': 89.99,
  },
];

  @override
  Widget build(BuildContext context) {
    int crossAxisCount;
    if (MediaQuery.of(context).size.width > 1200) {
      crossAxisCount = 5;
    } else if (MediaQuery.of(context).size.width > 700) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    final filteredProducts = products
        .where((product) => product['name'].toLowerCase().contains(searchQuery))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDescriptionScreen(product: product),
                ),
              );
            },
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Color(0xFF6495ED), // Accent color
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      product['image'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      product['name'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    product['description'],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    '\$${product['price'].toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Rating: ${product['rating']}', style: TextStyle(color: Colors.amber)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductDescriptionScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductDescriptionScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: Color(0xFF4567B7), // Primary color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                product['image'],
                width: double.infinity,  // Full width of the container
                height: 250,              // Set a fixed height
                fit: BoxFit.contain,      // Ensure the whole image fits without cropping
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              product['name'],
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(product['description'], style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 16.0),
            Text('Rating: ${product['rating']}', style: TextStyle(color: Colors.amber)),
            SizedBox(height: 16.0),
            Text(
              'Price: \$${product['price'].toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20.0, color: Color(0xFF6495ED)),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                ShoppingCart.addToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added to cart!')),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF4567B7)), // Primary color
              ),
              child: Text('Add to Cart', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// Remaining classes like ShoppingCartScreen, CheckoutScreen, DeliverablesScreen, and OrderConfirmationScreen remain unchanged.


class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cartItems = ShoppingCart.cartItems;


    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          : Container(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Card(
                          child: ListTile(
                            leading: Image.asset(item['image']),
                            title: Text(item['name']),
                            subtitle: Text('\$${item['price']}'),
                            trailing: IconButton(
                              icon: Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  ShoppingCart.removeFromCart(item);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Removed from cart!')),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Total: \$${ShoppingCart.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (cartItems.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CheckoutScreen()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Your cart is empty, add some items first!')),
                              );
                            }
                          },
                          child: Text('Checkout'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
class   CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'Contact Number', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your contact number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    ShoppingCart.moveToDeliverables();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderConfirmationScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill out all fields')),
                    );
                  }
                },
                child: Text('Confirm Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeliverablesScreen extends StatelessWidget {
  const DeliverablesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deliverables = ShoppingCart.deliverables;
    const totalTime = '2-3 hours'; // Hardcoded delivery time for simplicity

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deliverables'),
        centerTitle: true,
      ),
      body: deliverables.isEmpty
          ? Center(
              child: Text(
                'There is No Deliverables',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Order:',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Column(
                    children: deliverables.map((item) {
                      return Card(
                        child: ListTile(
                          leading: Image.asset(item['image']),
                          title: Text(item['name']),
                          subtitle: Text('\$${item['price']}'),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Estimated Delivery Time: $totalTime',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
    );
  }
}


class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 16.0),
            Text(
              'Your order has been placed successfully!',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            Text('On the way. Your order will arrive in 2-3 hours.'),
            SizedBox(height: 16.0),
            ElevatedButton(
  onPressed: () {
    // Replace with direct navigation to Home screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => ECommerceApp()), // Replace ECommerceApp() with your home screen widget
      (route) => false, // This condition removes all previous routes
    );
  },
  child: Text('Back to Home'),
)

          ],
        ),
      ),
    );
  }
}
class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
@override
Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 9, 7, 29),
    body: SingleChildScrollView(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 400,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -40,
                    height: 400,
                    width: width,
                    child: FadeInUp(duration: Duration(seconds: 1), child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill
                        )
                      ),
                    )),
                  ),
                  Positioned(
                    height: 400,
                    width: width+20,
                    child: FadeInUp(duration: Duration(milliseconds: 1000), child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/background-2.png'),
                          fit: BoxFit.fill
                        )
                      ),
                    )),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(duration: Duration(milliseconds: 1500), child: Text("Login", style: TextStyle(color: Color.fromRGBO(49, 39, 79, 1), fontWeight: FontWeight.bold, fontSize: 30),)),
                  SizedBox(height: 30,),
                  FadeInUp(duration: Duration(milliseconds: 1700), child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(color: Color.fromRGBO(196, 135, 198, .3)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(196, 135, 198, .3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        )
                      ]
                    ),
                child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(
                              color: Color.fromRGBO(196, 135, 198, .3)
                            ))
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Username",
                              hintStyle: TextStyle(color: Colors.grey.shade700)
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey.shade700)
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
                  SizedBox(height: 20,),
                  FadeInUp(duration: Duration(milliseconds: 1700), child: Center(child: TextButton(onPressed: () {}, child: Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(196, 135, 198, 1)),)))),
                  SizedBox(height: 30,),
                  FadeInUp(duration: Duration(milliseconds: 1900), child: MaterialButton(
                    onPressed: () {},
                    color: Color.fromRGBO(49, 39, 79, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    height: 50,
                    child: Center(
                      child: Text("Login", style: TextStyle(color: Colors.white),),
                    ),
                  )),
                  SizedBox(height: 30,),
                  FadeInUp(duration: Duration(milliseconds: 2000), child: Center(child: TextButton(onPressed: () {}, child: Text("Create Account", style: TextStyle(color: Color.fromRGBO(49, 39, 79, .6)),)))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}