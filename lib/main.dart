
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://bhtxloxmasrfkkpdogws.supabase.co';
const supabasePublishableKey =
    'sb_publishable_vZq5JZey7osrke1XenhSXw_Ehx5qB_1';

const gold = Color(0xFFFFC84A);
const goldDark = Color(0xFFD99618);
const bg = Color(0xFF060606);
const surface = Color(0xFF101010);
const card = Color(0xFF171717);
const card2 = Color(0xFF202020);
const muted = Color(0xFF9E9E9E);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabasePublishableKey,
    );
    runApp(const ElbayaaApp());
  } catch (e, stackTrace) {
    debugPrint('SUPABASE INITIALIZATION ERROR: $e');
    debugPrint('$stackTrace');
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _theme(),
        home: StartupErrorPage(error: e),
      ),
    );
  }
}

SupabaseClient get supabase => Supabase.instance.client;

class AppSettingsRepository {
  static const defaultDiscountMessage = 'خصم يصل إلى 40%';
  static const defaultWalletNumber = 'رقم المحفظة غير مضاف';
  static const defaultInstapayPhone = 'رقم الهاتف غير مضاف';

  static Future<Map<String, String>> load() async {
    try {
      final rows = await supabase.from('app_settings').select('key,value');
      final result = <String, String>{};
      for (final row in rows as List) {
        final map = Map<String, dynamic>.from(row);
        result['${map['key']}'] = '${map['value'] ?? ''}';
      }
      return result;
    } catch (_) {
      return {};
    }
  }

  static Future<void> save(Map<String, String> values) async {
    await supabase.from('app_settings').upsert(
      values.entries
          .map((e) => {'key': e.key, 'value': e.value})
          .toList(),
      onConflict: 'key',
    );
  }
}

ThemeData _theme() {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: bg,
    colorScheme: const ColorScheme.dark(
      primary: gold,
      secondary: gold,
      surface: surface,
      onPrimary: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: bg,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: card,
      labelStyle: const TextStyle(color: muted),
      hintStyle: const TextStyle(color: muted),
      prefixIconColor: gold,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withOpacity(.06)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: gold, width: 1.2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: gold,
        foregroundColor: Colors.black,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF0C0C0C),
      indicatorColor: gold.withOpacity(.18),
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
      iconTheme: MaterialStateProperty.all(
        const IconThemeData(color: Colors.white),
      ),
    ),
    cardTheme: CardThemeData(
      color: card,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}

class ElbayaaApp extends StatelessWidget {
  const ElbayaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ELBAYAA Store',
      theme: _theme(),
      home: const HomePage(),
    );
  }
}

class StartupErrorPage extends StatelessWidget {
  final Object error;
  const StartupErrorPage({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ElbayaaLogo(size: 92),
              const SizedBox(height: 24),
              const Text(
                'تعذر تشغيل الاتصال بالخدمة',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                getSupabaseError(error),
                style: const TextStyle(color: muted, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ============================================================
   LOGO
============================================================ */

class ElbayaaLogo extends StatelessWidget {
  final double size;
  const ElbayaaLogo({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    final mark = size * .54;
    return SizedBox(
      width: size * 1.75,
      height: size,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: mark,
            height: mark,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [gold, goldDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(size * .18),
              boxShadow: [
                BoxShadow(
                  color: gold.withOpacity(.25),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_rounded,
                  size: mark * .48,
                  color: Colors.black,
                ),
                Text(
                  'B',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: mark * .52,
                    fontWeight: FontWeight.w900,
                    height: .8,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: size * .10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ELBAYAA',
                style: TextStyle(
                  color: gold,
                  fontSize: size * .25,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                  height: 1,
                ),
              ),
              Text(
                'MOBILE ACCESSORIES',
                style: TextStyle(
                  color: Colors.white.withOpacity(.75),
                  fontSize: size * .105,
                  fontWeight: FontWeight.w600,
                  letterSpacing: .8,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   PRODUCT
============================================================ */

class Product {
  final dynamic id;
  final String name;
  final String price;
  final String oldPrice;
  final String image;
  final String category;
  final double rating;

  Product({
    this.id,
    required this.name,
    required this.price,
    this.oldPrice = '',
    this.image = '',
    this.category = '',
    this.rating = 0,
  });

  double get priceValue =>
      double.tryParse(price.replaceAll(',', '.')) ?? 0;

  factory Product.fromMap(Map<String, dynamic> m) {
    return Product(
      id: m['id'],
      name: '${m['name'] ?? 'منتج'}',
      price: '${m['price'] ?? 0}',
      oldPrice: '${m['old_price'] ?? ''}',
      image: '${m['image'] ?? m['image_url'] ?? ''}',
      category: '${m['category'] ?? ''}',
      rating: double.tryParse('${m['rating'] ?? 0}') ?? 0,
    );
  }
}

final fallbackProducts = <Product>[
  Product(
    id: 1,
    name: 'سماعة بلوتوث لاسلكية',
    price: '199',
    oldPrice: '249',
    image: '🎧',
    category: 'سماعات',
    rating: 4.8,
  ),
  Product(
    id: 2,
    name: 'كابل تايب سي لايتنينج',
    price: '99',
    oldPrice: '149',
    image: '🔌',
    category: 'كابلات',
    rating: 4.9,
  ),
  Product(
    id: 3,
    name: 'كفر حماية ماج سيف',
    price: '89',
    oldPrice: '129',
    image: '📱',
    category: 'كفرات',
    rating: 4.7,
  ),
  Product(
    id: 4,
    name: 'شاحن سريع 20W',
    price: '149',
    oldPrice: '199',
    image: '🔋',
    category: 'شواحن',
    rating: 4.8,
  ),
];

class ProductRepository {
  static Future<List<Product>> getProducts() async {
    try {
      final data = await supabase
          .from('products')
          .select()
          .eq('active', true)
          .order('id', ascending: false);

      final list = (data as List)
          .map((e) => Product.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      return list.isEmpty ? fallbackProducts : list;
    } catch (e) {
      debugPrint('PRODUCTS ERROR: $e');
      return fallbackProducts;
    }
  }
}

/* ============================================================
   CART
============================================================ */

class CartItem {
  final Product product;
  int quantity;
  CartItem(this.product, {this.quantity = 1});
}

class CartController extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  int get count =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get total => _items.values.fold(
        0,
        (sum, item) => sum + item.product.priceValue * item.quantity,
      );

  void add(Product product) {
    final key = '${product.id ?? product.name}';
    if (_items.containsKey(key)) {
      _items[key]!.quantity++;
    } else {
      _items[key] = CartItem(product);
    }
    notifyListeners();
  }

  void decrease(Product product) {
    final key = '${product.id ?? product.name}';
    final item = _items[key];
    if (item == null) return;
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(key);
    }
    notifyListeners();
  }

  void remove(Product product) {
    _items.remove('${product.id ?? product.name}');
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

final cart = CartController();

/* ============================================================
   COMMON UI
============================================================ */

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
}

class CartIcon extends StatelessWidget {
  const CartIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: cart,
      builder: (_, __) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.shopping_bag_outlined, color: gold),
            if (cart.count > 0)
              Positioned(
                top: -7,
                right: -8,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 19),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: const BoxDecoration(
                    color: gold,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${cart.count}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const SectionTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 28,
          decoration: BoxDecoration(
            color: gold,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 78,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? gold.withOpacity(.16) : card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? gold : Colors.white.withOpacity(.06),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected ? gold : Colors.white70,
              size: 23,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: selected ? gold : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   HOME
============================================================ */

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> products;
  String search = '';
  String category = 'الكل';
  String discountMessage = AppSettingsRepository.defaultDiscountMessage;

  @override
  void initState() {
    super.initState();
    products = ProductRepository.getProducts();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await AppSettingsRepository.load();
    if (!mounted) return;
    setState(() {
      discountMessage = settings['discount_message']?.trim().isNotEmpty == true
          ? settings['discount_message']!.trim()
          : AppSettingsRepository.defaultDiscountMessage;
    });
  }

  void refreshProducts() {
    setState(() {
      products = ProductRepository.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            color: gold,
            backgroundColor: card,
            onRefresh: () async => refreshProducts(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 25),
              children: [
                Row(
                  children: [
                    const Expanded(child: ElbayaaLogo(size: 54)),
                    IconButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())),
                      icon: const Icon(Icons.person_outline),
                      color: Colors.white,
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage())),
                      icon: const CartIcon(),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'أهلاً بك في ELBAYAA 👋',
                  style: TextStyle(
                    color: muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'كل إكسسواراتك في مكان واحد',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) => setState(
                    () => search = value.trim(),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'ابحث عن سماعة، شاحن، كابل...',
                    prefixIcon: Icon(Icons.search_rounded),
                    suffixIcon: Icon(Icons.tune_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                _HeroBanner(
                  discountMessage: discountMessage,
                  onTap: () {
                    setState(() => category = 'الكل');
                  },
                ),
                const SizedBox(height: 22),
                const SectionTitle(
                  title: 'تسوق حسب القسم',
                  subtitle: 'اختار القسم المناسب لك',
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 92,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryChip(
                        label: 'الكل',
                        icon: Icons.apps_rounded,
                        selected: category == 'الكل',
                        onTap: () => setState(() => category = 'الكل'),
                      ),
                      const SizedBox(width: 9),
                      CategoryChip(
                        label: 'سماعات',
                        icon: Icons.headphones_rounded,
                        selected: category == 'سماعات',
                        onTap: () => setState(() => category = 'سماعات'),
                      ),
                      const SizedBox(width: 9),
                      CategoryChip(
                        label: 'شواحن',
                        icon: Icons.bolt_rounded,
                        selected: category == 'شواحن',
                        onTap: () => setState(() => category = 'شواحن'),
                      ),
                      const SizedBox(width: 9),
                      CategoryChip(
                        label: 'كابلات',
                        icon: Icons.cable_rounded,
                        selected: category == 'كابلات',
                        onTap: () => setState(() => category = 'كابلات'),
                      ),
                      const SizedBox(width: 9),
                      CategoryChip(
                        label: 'كفرات',
                        icon: Icons.phone_android_rounded,
                        selected: category == 'كفرات',
                        onTap: () => setState(() => category = 'كفرات'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const SectionTitle(
                  title: 'منتجات مميزة 🔥',
                  subtitle: 'أفضل الاختيارات بأسعار مميزة',
                ),
                const SizedBox(height: 12),
                FutureBuilder<List<Product>>(
                  future: products,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(50),
                        child: Center(
                          child: CircularProgressIndicator(color: gold),
                        ),
                      );
                    }

                    final all = snapshot.data ?? fallbackProducts;
                    final list = all.where((product) {
                      final matchesSearch = search.isEmpty ||
                          product.name.contains(search) ||
                          product.category.contains(search);
                      final matchesCategory = category == 'الكل' ||
                          product.category.contains(category);
                      return matchesSearch && matchesCategory;
                    }).toList();

                    if (list.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(child: Text('لا توجد منتجات مطابقة')),
                      );
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth >= 700 ? 4 : 2;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            childAspectRatio: .62,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (_, index) =>
                              ProductCard(product: list[index]),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: 0,
          onDestinationSelected: (index) {
            if (index == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
            } else if (index == 2) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: gold),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: CartIcon(),
              selectedIcon: CartIcon(),
              label: 'السلة',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person_rounded, color: gold),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  final VoidCallback onTap;
  final String discountMessage;
  const _HeroBanner({required this.onTap, required this.discountMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF27200F), Color(0xFF0D0D0D)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        border: Border.all(color: gold.withOpacity(.55)),
        boxShadow: [
          BoxShadow(
            color: gold.withOpacity(.08),
            blurRadius: 25,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: -30,
            top: -45,
            child: Icon(
              Icons.shopping_bag_rounded,
              size: 190,
              color: gold.withOpacity(.07),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'عروض ELBAYAA',
                style: TextStyle(
                  color: gold,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                discountMessage,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'جودة • سرعة • ثقة',
                style: TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: onTap,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(120, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                  ),
                  child: const Text('تسوق الآن'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   PRODUCT CARD / IMAGE
============================================================ */

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductPage(product: product),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D0D0D),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: ProductImage(product.image),
                  ),
                  if (product.oldPrice.isNotEmpty)
                    Positioned(
                      top: 7,
                      right: 7,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'خصم',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 9),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: gold, size: 15),
                const SizedBox(width: 3),
                Text(
                  product.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                Text(
                  '${product.price} ج.م',
                  style: const TextStyle(
                    color: gold,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 38,
              child: FilledButton(
                onPressed: () {
                  cart.add(product);
                  showMessage(context, 'تمت إضافة المنتج للسلة');
                },
                style: FilledButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_shopping_cart_rounded, size: 17),
                    SizedBox(width: 5),
                    Text('أضف للسلة', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  final String value;
  const ProductImage(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(value);
    final isUrl = uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https');

    if (isUrl) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          value,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const _ImageFallback(),
        ),
      );
    }

    return Center(
      child: Text(
        value.isEmpty ? '📦' : value,
        style: const TextStyle(fontSize: 55),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.inventory_2_outlined,
        color: gold,
        size: 55,
      ),
    );
  }
}

/* ============================================================
   PRODUCT PAGE
============================================================ */

class ProductPage extends StatelessWidget {
  final Product product;
  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const ElbayaaLogo(size: 42),
          actions: [
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              ),
              icon: const CartIcon(),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              height: 330,
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(28),
              ),
              child: ProductImage(product.image),
            ),
            const SizedBox(height: 20),
            Text(
              product.category.isEmpty ? 'إكسسوارات' : product.category,
              style: const TextStyle(color: gold, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: gold),
                const SizedBox(width: 4),
                Text('${product.rating} تقييم'),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Text(
                  '${product.price} ج.م',
                  style: const TextStyle(
                    color: gold,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (product.oldPrice.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  Text(
                    '${product.oldPrice} ج.م',
                    style: const TextStyle(
                      color: muted,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_rounded, color: gold),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'منتج مناسب للاستخدام اليومي مع تجربة شراء سهلة وسريعة.',
                      style: TextStyle(color: Colors.white70, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: FilledButton.icon(
                onPressed: () {
                  cart.add(product);
                  showMessage(context, 'تمت إضافة المنتج للسلة');
                },
                icon: const Icon(Icons.shopping_bag_rounded),
                label: const Text(
                  'أضف إلى السلة',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   CART
============================================================ */

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    cart.addListener(_update);
  }

  @override
  void dispose() {
    cart.removeListener(_update);
    super.dispose();
  }

  void _update() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('السلة (${cart.count})'),
        ),
        body: cart.items.isEmpty
            ? const _EmptyState(
                icon: Icons.shopping_bag_outlined,
                title: 'السلة فارغة',
                subtitle: 'أضف منتجاتك المفضلة وستظهر هنا.',
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...cart.items.map((item) => _CartTile(item: item)),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _PriceRow(
                          label: 'عدد المنتجات',
                          value: '${cart.count}',
                        ),
                        const SizedBox(height: 10),
                        _PriceRow(
                          label: 'الإجمالي',
                          value:
                              '${cart.total.toStringAsFixed(0)} ج.م',
                          highlight: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 55,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutPage(total: cart.total),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('إتمام الطلب'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  final CartItem item;
  const _CartTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: ProductImage(item.product.image),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 5),
                Text(
                  '${item.product.price} ج.م',
                  style: const TextStyle(
                    color: gold,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => cart.decrease(item.product),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                '${item.quantity}',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              IconButton(
                onPressed: () => cart.add(item.product),
                icon: const Icon(Icons.add_circle_outline, color: gold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _PriceRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: highlight ? Colors.white : muted,
            fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: highlight ? gold : Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: highlight ? 21 : 15,
          ),
        ),
      ],
    );
  }
}

/* ============================================================
   CHECKOUT
============================================================ */

class _PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? gold : Colors.white.withOpacity(.06),
            width: selected ? 1.2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? gold : Colors.white70),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(color: muted, fontSize: 12)),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? gold : muted,
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  final double total;
  const CheckoutPage({super.key, required this.total});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  bool loading = false;
  String paymentMethod = 'الدفع عند الاستلام';
  String walletNumber = AppSettingsRepository.defaultWalletNumber;
  String instapayPhone = AppSettingsRepository.defaultInstapayPhone;

  @override
  void initState() {
    super.initState();
    _loadPaymentSettings();
  }

  Future<void> _loadPaymentSettings() async {
    final settings = await AppSettingsRepository.load();
    if (!mounted) return;
    setState(() {
      walletNumber = settings['wallet_number']?.trim().isNotEmpty == true
          ? settings['wallet_number']!.trim()
          : AppSettingsRepository.defaultWalletNumber;
      instapayPhone = settings['instapay_phone']?.trim().isNotEmpty == true
          ? settings['instapay_phone']!.trim()
          : AppSettingsRepository.defaultInstapayPhone;
    });
  }

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    address.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (name.text.trim().isEmpty ||
        phone.text.trim().isEmpty ||
        address.text.trim().isEmpty) {
      showMessage(context, 'أكمل بيانات الطلب أولاً');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => loading = true);

    try {
      await supabase.from('orders').insert({
        'customer_name': name.text.trim(),
        'phone': phone.text.trim(),
        'address': address.text.trim(),
        'payment_method': paymentMethod,
        'total': widget.total,
        'status': 'جديد',
        'items': cart.items
            .map(
              (item) => {
                'product_id': item.product.id,
                'name': item.product.name,
                'price': item.product.priceValue,
                'quantity': item.quantity,
              },
            )
            .toList(),
      });

      cart.clear();

      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('تم استلام طلبك ✅'),
          content: const Text(
            'شكراً لطلبك من ELBAYAA.\nسيتم التواصل معك لتأكيد الطلب.',
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('العودة للمتجر'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        showMessage(
          context,
          'حدث خطأ أثناء إرسال الطلب:\n${getSupabaseError(e)}',
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Text('إتمام الطلب'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _CheckoutStepBar(),
            const SizedBox(height: 20),
            const Text(
              'بيانات التوصيل',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: name,
              decoration: const InputDecoration(
                labelText: 'الاسم الكامل',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: address,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'العنوان بالتفصيل',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'طريقة الدفع',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            _PaymentOption(
              title: 'الدفع عند الاستلام',
              subtitle: 'ادفع عند استلام طلبك',
              icon: Icons.payments_outlined,
              selected: paymentMethod == 'الدفع عند الاستلام',
              onTap: () => setState(() => paymentMethod = 'الدفع عند الاستلام'),
            ),
            const SizedBox(height: 8),
            _PaymentOption(
              title: 'المحفظة البنكية',
              subtitle: walletNumber,
              icon: Icons.account_balance_wallet_outlined,
              selected: paymentMethod == 'المحفظة البنكية',
              onTap: () => setState(() => paymentMethod = 'المحفظة البنكية'),
            ),
            const SizedBox(height: 8),
            _PaymentOption(
              title: 'InstaPay',
              subtitle: instapayPhone,
              icon: Icons.phone_android_outlined,
              selected: paymentMethod == 'InstaPay',
              onTap: () => setState(() => paymentMethod = 'InstaPay'),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long_outlined, color: gold),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'الطريقة المختارة\n$paymentMethod',
                      style: const TextStyle(height: 1.5),
                    ),
                  ),
                  Text(
                    '${widget.total.toStringAsFixed(0)} ج.م',
                    style: const TextStyle(
                      color: gold,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 56,
              child: FilledButton.icon(
                onPressed: loading ? null : submit,
                icon: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.black,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  loading ? 'جاري إرسال الطلب...' : 'تأكيد الطلب',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutStepBar extends StatelessWidget {
  const _CheckoutStepBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Step(number: '1', label: 'بيانات', active: true),
        Expanded(child: Container(height: 1, color: gold)),
        _Step(number: '2', label: 'العنوان', active: true),
        Expanded(child: Container(height: 1, color: gold)),
        _Step(number: '3', label: 'تأكيد', active: false),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  final String number;
  final String label;
  final bool active;
  const _Step({
    required this.number,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: active ? gold : card2,
          child: Text(
            number,
            style: TextStyle(
              color: active ? Colors.black : Colors.white70,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: muted)),
      ],
    );
  }
}

/* ============================================================
   PROFILE / ADMIN LOGIN
============================================================ */

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('حسابي'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: gold.withOpacity(.18)),
              ),
              child: Column(
                children: [
                  const ElbayaaLogo(size: 72),
                  const SizedBox(height: 15),
                  const Text(
                    'مرحباً بك في ELBAYAA',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'إكسسوارات موبايل بجودة وسعر مناسب',
                    style: TextStyle(color: muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _ProfileTile(
              icon: Icons.admin_panel_settings_outlined,
              title: 'لوحة التحكم',
              subtitle: 'إدارة المنتجات والطلبات',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminLoginPage(),
                ),
              ),
            ),
            _ProfileTile(
              icon: Icons.support_agent_outlined,
              title: 'خدمة العملاء',
              subtitle: 'يسعدنا مساعدتك',
              onTap: () => showMessage(
                context,
                'تواصل معنا من خلال رقم خدمة العملاء المضاف في مشروعك.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: gold.withOpacity(.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: gold),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: muted, fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_left, color: gold),
        onTap: onTap,
      ),
    );
  }
}

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final email = TextEditingController(text: 'emadelbaya388@gmail.com');
  final password = TextEditingController();
  bool loading = false;
  bool obscure = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (email.text.trim().isEmpty || password.text.isEmpty) {
      showMessage(context, 'أدخل البريد وكلمة المرور');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => loading = true);

    try {
      final response = await supabase.auth.signInWithPassword(
        email: email.text.trim(),
        password: password.text,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('لم يتم إنشاء جلسة تسجيل الدخول.');
      }

      final admin = await supabase
          .from('admins')
          .select('user_id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (admin == null) {
        await supabase.auth.signOut();
        throw Exception(
          'تم تسجيل الدخول، لكن الحساب غير موجود في جدول admins.',
        );
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminDashboardPage(),
        ),
      );
    } on AuthException catch (e) {
      if (mounted) {
        showMessage(context, 'خطأ تسجيل الدخول:\n${e.message}');
      }
    } on PostgrestException catch (e) {
      if (mounted) {
        showMessage(
          context,
          'تم الدخول لكن تعذر التحقق من صلاحيات الأدمن:\n'
          '${e.message}\nCode: ${e.code}',
        );
      }
    } catch (e) {
      if (mounted) {
        showMessage(context, getSupabaseError(e));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('دخول لوحة التحكم')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: gold.withOpacity(.18)),
                    ),
                    child: Column(
                      children: [
                        const ElbayaaLogo(size: 88),
                        const SizedBox(height: 22),
                        const Text(
                          'مرحباً بمدير ELBAYAA',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'سجل الدخول لإدارة المنتجات والطلبات',
                          style: TextStyle(color: muted),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 22),
                        TextField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'البريد الإلكتروني',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: password,
                          obscureText: obscure,
                          onSubmitted: (_) {
                            if (!loading) login();
                          },
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => obscure = !obscure),
                              icon: Icon(
                                obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 55,
                          child: FilledButton.icon(
                            onPressed: loading ? null : login,
                            icon: loading
                                ? const SizedBox(
                                    width: 21,
                                    height: 21,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: Colors.black,
                                    ),
                                  )
                                : const Icon(Icons.login_rounded),
                            label: Text(
                              loading ? 'جاري الدخول...' : 'دخول',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ============================================================
   ADMIN DASHBOARD
============================================================ */

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() =>
      _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> orders = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    if (mounted) setState(() => loading = true);

    try {
      final p = await supabase
          .from('products')
          .select()
          .order('id', ascending: false);

      final o = await supabase
          .from('orders')
          .select()
          .order('id', ascending: false);

      products = (p as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      orders = (o as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (e) {
      if (mounted) showMessage(context, 'خطأ في تحميل البيانات:\n${getSupabaseError(e)}');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> addProduct() async {
    await _productDialog();
  }

  Future<void> _productDialog({
    Map<String, dynamic>? existing,
  }) async {
    final name = TextEditingController(
      text: '${existing?['name'] ?? ''}',
    );
    final price = TextEditingController(
      text: '${existing?['price'] ?? ''}',
    );
    final oldPrice = TextEditingController(
      text: '${existing?['old_price'] ?? ''}',
    );
    final category = TextEditingController(
      text: '${existing?['category'] ?? ''}',
    );
    final image = TextEditingController(
      text: '${existing?['image'] ?? ''}',
    );

    bool active = existing?['active'] != false;

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            title: Text(existing == null ? 'إضافة منتج' : 'تعديل المنتج'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: name,
                    decoration: const InputDecoration(labelText: 'اسم المنتج'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: price,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(labelText: 'السعر'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: oldPrice,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'السعر القديم - اختياري',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: category,
                    decoration: const InputDecoration(labelText: 'القسم'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: image,
                    decoration: const InputDecoration(
                      labelText: 'رابط الصورة أو Emoji',
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    value: active,
                    onChanged: (value) =>
                        setDialogState(() => active = value),
                    activeColor: gold,
                    title: const Text('إظهار المنتج'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('إلغاء'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('حفظ'),
              ),
            ],
          );
        },
      ),
    );

    if (result != true) {
      name.dispose();
      price.dispose();
      oldPrice.dispose();
      category.dispose();
      image.dispose();
      return;
    }

    if (name.text.trim().isEmpty || price.text.trim().isEmpty) {
      showMessage(context, 'اكتب اسم المنتج والسعر');
      name.dispose();
      price.dispose();
      oldPrice.dispose();
      category.dispose();
      image.dispose();
      return;
    }

    try {
      final payload = {
        'name': name.text.trim(),
        'price': double.tryParse(
              price.text.trim().replaceAll(',', '.'),
            ) ??
            0,
        'old_price': oldPrice.text.trim(),
        'category': category.text.trim(),
        'image': image.text.trim(),
        'active': active,
      };

      if (existing == null) {
        await supabase.from('products').insert(payload);
      } else {
        await supabase
            .from('products')
            .update(payload)
            .eq('id', existing['id']);
      }

      await load();
      if (mounted) showMessage(context, 'تم حفظ المنتج بنجاح');
    } catch (e) {
      if (mounted) {
        showMessage(context, 'فشل حفظ المنتج:\n${getSupabaseError(e)}');
      }
    } finally {
      name.dispose();
      price.dispose();
      oldPrice.dispose();
      category.dispose();
      image.dispose();
    }
  }

  Future<void> deleteProduct(Map<String, dynamic> product) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف المنتج'),
        content: Text(
          'هل تريد حذف "${product['name'] ?? 'المنتج'}"؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      await supabase
          .from('products')
          .delete()
          .eq('id', product['id']);
      await load();
      if (mounted) showMessage(context, 'تم حذف المنتج');
    } catch (e) {
      if (mounted) showMessage(context, 'فشل الحذف:\n${getSupabaseError(e)}');
    }
  }

  Future<void> toggleProduct(Map<String, dynamic> product) async {
    try {
      await supabase
          .from('products')
          .update({'active': product['active'] != true})
          .eq('id', product['id']);
      await load();
    } catch (e) {
      if (mounted) {
        showMessage(context, 'فشل تغيير الحالة:\n${getSupabaseError(e)}');
      }
    }
  }

  Future<void> openSettings() async {
    final settings = await AppSettingsRepository.load();
    final discount = TextEditingController(
      text: settings['discount_message'] ?? AppSettingsRepository.defaultDiscountMessage,
    );
    final wallet = TextEditingController(
      text: settings['wallet_number'] ?? '',
    );
    final instapay = TextEditingController(
      text: settings['instapay_phone'] ?? '',
    );

    final save = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('إعدادات المتجر'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: discount,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'رسالة الخصومات في الواجهة'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: wallet,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'رقم المحفظة البنكية'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: instapay,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'رقم هاتف InstaPay'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('حفظ')),
        ],
      ),
    );

    if (save == true) {
      try {
        await AppSettingsRepository.save({
          'discount_message': discount.text.trim(),
          'wallet_number': wallet.text.trim(),
          'instapay_phone': instapay.text.trim(),
        });
        if (mounted) showMessage(context, 'تم حفظ إعدادات المتجر');
      } catch (e) {
        if (mounted) showMessage(context, 'فشل حفظ الإعدادات:\n${getSupabaseError(e)}');
      }
    }

    discount.dispose();
    wallet.dispose();
    instapay.dispose();
  }

  Future<void> deleteCancelledOrders() async {
    final cancelled = orders.where((o) => '${o['status'] ?? ''}' == 'ملغي').length;
    if (cancelled == 0) {
      showMessage(context, 'لا توجد طلبات ملغية للمسح');
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('مسح الطلبات الملغية'),
        content: Text('سيتم حذف $cancelled طلبات ملغية نهائياً. هل تريد المتابعة؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('مسح نهائياً')),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await supabase.from('orders').delete().eq('status', 'ملغي');
      await load();
      if (mounted) showMessage(context, 'تم مسح الطلبات الملغية');
    } catch (e) {
      if (mounted) showMessage(context, 'فشل مسح الطلبات:\n${getSupabaseError(e)}');
    }
  }

  Future<void> changeOrderStatus(Map<String, dynamic> order) async {
    const statuses = [
      'جديد',
      'قيد التجهيز',
      'تم الشحن',
      'تم التسليم',
      'ملغي',
    ];

    final status = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: surface,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'تغيير حالة الطلب',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            ...statuses.map(
              (status) => ListTile(
                leading: const Icon(Icons.circle, color: gold, size: 12),
                title: Text(status),
                onTap: () => Navigator.pop(context, status),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (status == null) return;

    try {
      await supabase
          .from('orders')
          .update({'status': status})
          .eq('id', order['id']);
      await load();
    } catch (e) {
      if (mounted) {
        showMessage(context, 'فشل تحديث الطلب:\n${getSupabaseError(e)}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeCount =
        products.where((p) => p['active'] == true).length;
    final newOrders =
        orders.where((o) => '${o['status'] ?? 'جديد'}' == 'جديد').length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Text(
            'لوحة التحكم',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          actions: [
            IconButton(
              onPressed: openSettings,
              tooltip: 'إعدادات المتجر',
              icon: const Icon(Icons.settings_outlined),
            ),
            IconButton(
              onPressed: loading ? null : load,
              icon: const Icon(Icons.refresh_rounded),
            ),
            IconButton(
              onPressed: () async {
                await supabase.auth.signOut();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomePage(),
                    ),
                    (_) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: gold,
          foregroundColor: Colors.black,
          onPressed: addProduct,
          icon: const Icon(Icons.add),
          label: const Text(
            'منتج جديد',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator(color: gold))
            : RefreshIndicator(
                color: gold,
                onRefresh: load,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: [
                    const ElbayaaLogo(size: 62),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'المنتجات',
                            value: '${products.length}',
                            icon: Icons.inventory_2_outlined,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatCard(
                            title: 'المتاحة',
                            value: '$activeCount',
                            icon: Icons.visibility_outlined,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatCard(
                            title: 'طلبات جديدة',
                            value: '$newOrders',
                            icon: Icons.shopping_bag_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const SectionTitle(title: 'إدارة المنتجات'),
                    const SizedBox(height: 10),
                    if (products.isEmpty)
                      const _EmptyCard(text: 'لا توجد منتجات حالياً')
                    else
                      ...products.map(
                        (product) => _AdminProductCard(
                          product: product,
                          onEdit: () => _productDialog(existing: product),
                          onDelete: () => deleteProduct(product),
                          onToggle: () => toggleProduct(product),
                        ),
                      ),
                    const SizedBox(height: 24),
                    const SectionTitle(title: 'إدارة الطلبات'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: openSettings,
                            icon: const Icon(Icons.tune_rounded),
                            label: const Text('إعدادات المتجر'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: deleteCancelledOrders,
                            icon: const Icon(Icons.delete_sweep_outlined),
                            label: const Text('مسح الملغية'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (orders.isEmpty)
                      const _EmptyCard(text: 'لا توجد طلبات حالياً')
                    else
                      ...orders.map(
                        (order) => _AdminOrderCard(
                          order: order,
                          onTap: () => changeOrderStatus(order),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: gold.withOpacity(.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: gold, size: 20),
          const SizedBox(height: 9),
          Text(
            value,
            style: const TextStyle(
              color: gold,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: muted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _AdminProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const _AdminProductCard({
    required this.product,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final active = product['active'] == true;
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFF0C0C0C),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ProductImage('${product['image'] ?? ''}'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${product['name'] ?? 'منتج'}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(
                  '${product['price'] ?? 0} ج.م • '
                  '${active ? 'ظاهر' : 'مخفي'}',
                  style: TextStyle(
                    color: active ? gold : muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'toggle') onToggle();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('تعديل'),
              ),
              PopupMenuItem(
                value: 'toggle',
                child: Text(active ? 'إخفاء' : 'إظهار'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('حذف'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdminOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onTap;

  const _AdminOrderCard({
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = '${order['status'] ?? 'جديد'}';
    final isNew = status == 'جديد';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isNew ? gold.withOpacity(.30) : Colors.white.withOpacity(.05),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${order['customer_name'] ?? 'عميل'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  '${order['total'] ?? 0} ج.م',
                  style: const TextStyle(
                    color: gold,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Text(
              '${order['phone'] ?? ''}',
              style: const TextStyle(color: muted),
            ),
            const SizedBox(height: 3),
            Text(
              '${order['address'] ?? ''}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: muted),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isNew
                        ? gold.withOpacity(.14)
                        : Colors.white.withOpacity(.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: isNew ? gold : Colors.white70,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.edit_outlined,
                  color: gold,
                  size: 19,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   EMPTY / ERRORS
============================================================ */

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: gold, size: 70),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              subtitle,
              style: const TextStyle(color: muted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String text;
  const _EmptyCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: const TextStyle(color: muted),
      ),
    );
  }
}

String getSupabaseError(Object error) {
  final text = error.toString();

  debugPrint('SUPABASE ERROR: $text');

  if (text.contains('Failed host lookup')) {
    return 'تعذر الوصول إلى خادم ELBAYAA حالياً.\n'
        'المشكلة في اتصال الشبكة أو DNS، وليست كلمة المرور.';
  }

  if (text.contains('SocketException')) {
    return 'تعذر الاتصال بخادم Supabase.';
  }

  if (text.contains('Invalid login credentials')) {
    return 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
  }

  if (text.contains('Email not confirmed')) {
    return 'البريد الإلكتروني غير مؤكد في Supabase.';
  }

  if (text.contains('No API key')) {
    return 'مفتاح Supabase غير موجود أو غير صحيح.';
  }

  if (text.contains('AuthException')) {
    return text.replaceFirst('AuthException: ', '');
  }

  if (text.contains('PostgrestException')) {
    return text;
  }

  return text.replaceFirst('Exception: ', '');
}
