import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://bhtxloxmasrfkkpdogws.supabase.co',
    anonKey: 'sb_publishable_vZq5JZey7osrke1XenhSXw_Ehx5qB_1',
  );
  runApp(const ElbayaaApp());
}

const gold = Color(0xFFE8B33D);
const gold2 = Color(0xFFFFD66B);
const bg = Color(0xFF070707);
const card = Color(0xFF151515);

class Product {
  final dynamic id;
  final String name, price, oldPrice, image, category;
  final double rating;
  Product(this.id, this.name, this.price, this.oldPrice, this.image, this.category, this.rating);
  double get priceValue => double.tryParse(price.replaceAll(',', '.')) ?? 0;
  factory Product.fromMap(Map<String, dynamic> m) => Product(
    m['id'], (m['name'] ?? 'منتج').toString(), (m['price'] ?? '0').toString(),
    (m['old_price'] ?? m['oldPrice'] ?? '').toString(), (m['image'] ?? m['image_url'] ?? '').toString(),
    (m['category'] ?? '').toString(), double.tryParse((m['rating'] ?? 0).toString()) ?? 0,
  );
}

final fallbackProducts = <Product>[
  Product(1, 'سماعة بلوتوث لاسلكية', '199', '249', '🎧', 'سماعات', 4.8),
  Product(2, 'كابل تايب سي لايتنينج', '99', '149', '🔌', 'كابلات', 4.9),
  Product(3, 'كفر حماية ماج سيف', '89', '129', '📱', 'كفرات وجرابات', 4.7),
  Product(4, 'شاحن سريع 20W', '149', '199', '🔋', 'شواحن', 4.8),
];

class ProductRepository {
  static Future<List<Product>> getProducts() async {
    try {
      final rows = await Supabase.instance.client.from('products').select().order('id', ascending: false);
      final result = (rows as List).map((r) => Product.fromMap(Map<String, dynamic>.from(r))).toList();
      return result.isEmpty ? fallbackProducts : result;
    } catch (_) { return fallbackProducts; }
  }
}

class CartController extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  List<CartItem> get items => _items.values.toList();
  int get count => _items.values.fold(0, (s, x) => s + x.quantity);
  double get total => _items.values.fold(0, (s, x) => s + x.product.priceValue * x.quantity);
  void add(Product p) {
    final key = p.id?.toString() ?? p.name;
    if (_items.containsKey(key)) _items[key]!.quantity++;
    else _items[key] = CartItem(p);
    notifyListeners();
  }
  void decrease(Product p) {
    final key = p.id?.toString() ?? p.name;
    final item = _items[key]; if (item == null) return;
    if (item.quantity > 1) item.quantity--; else _items.remove(key);
    notifyListeners();
  }
  void remove(Product p) { _items.remove(p.id?.toString() ?? p.name); notifyListeners(); }
  void clear() { _items.clear(); notifyListeners(); }
}
class CartItem { final Product product; int quantity = 1; CartItem(this.product); }
final cart = CartController();

class ElbayaaApp extends StatelessWidget {
  const ElbayaaApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false, title: 'ELBAYAA Store',
    theme: ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: bg, colorScheme: const ColorScheme.dark(primary: gold, secondary: gold2), fontFamily: 'Arial',
    ), home: const Shell(),
  );
}

class Shell extends StatefulWidget { final int initialIndex; const Shell({super.key, this.initialIndex = 0}); @override State<Shell> createState()=>_ShellState(); }
class _ShellState extends State<Shell> {
  late int index = widget.initialIndex;
  final pages = const [HomePage(), CategoriesPage(), CartPage(), ProfilePage()];
  @override void initState(){super.initState(); cart.addListener(_changed);}
  @override void dispose(){cart.removeListener(_changed);super.dispose();}
  void _changed()=>setState((){});
  @override Widget build(BuildContext context)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(
    body: pages[index], bottomNavigationBar: NavigationBar(backgroundColor:const Color(0xFF0D0D0D),indicatorColor:gold.withOpacity(.16),selectedIndex:index,onDestinationSelected:(i)=>setState(()=>index=i),
    destinations:[
      const NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'الرئيسية'),
      const NavigationDestination(icon:Icon(Icons.grid_view_outlined),selectedIcon:Icon(Icons.grid_view),label:'الأقسام'),
      NavigationDestination(icon:Badge(count:cart.count,child:const Icon(Icons.shopping_cart_outlined)),selectedIcon:Badge(count:cart.count,child:const Icon(Icons.shopping_cart)),label:'السلة'),
      const NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'حسابي'),
    ]),
  ));
}

class Badge extends StatelessWidget { final int count; final Widget child; const Badge({required this.count,required this.child,super.key}); @override Widget build(BuildContext c)=>Stack(clipBehavior:Clip.none,children:[child,if(count>0)Positioned(right:-9,top:-9,child:Container(padding:const EdgeInsets.all(4),decoration:const BoxDecoration(color:gold,shape:BoxShape.circle),child:Text('$count',style:const TextStyle(color:Colors.black,fontSize:9,fontWeight:FontWeight.bold))))]); }

class Header extends StatelessWidget { const Header({super.key}); @override Widget build(BuildContext context)=>Row(children:[Image.asset('assets/images/logo.png',width:62,height:62),const Spacer(),IconButton(onPressed:(){},icon:const Icon(Icons.notifications_none,color:gold)),IconButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const CartPage())),icon:Badge(count:cart.count,child:const Icon(Icons.shopping_cart_outlined,color:gold)))]); }

class HomePage extends StatefulWidget { const HomePage({super.key}); @override State<HomePage> createState()=>_HomePageState(); }
class _HomePageState extends State<HomePage> {
  late Future<List<Product>> future; String search='';
  @override void initState(){super.initState();future=ProductRepository.getProducts();}
  @override Widget build(BuildContext context)=>SafeArea(child:ListView(padding:const EdgeInsets.fromLTRB(16,8,16,20),children:[
    const Header(), TextField(onChanged:(v)=>setState(()=>search=v.trim()),decoration:InputDecoration(hintText:'ابحث عن منتج...',prefixIcon:const Icon(Icons.search),filled:true,fillColor:card,border:OutlineInputBorder(borderRadius:BorderRadius.circular(18),borderSide:BorderSide.none))),
    const SizedBox(height:16), Container(height:190,padding:const EdgeInsets.all(20),decoration:BoxDecoration(borderRadius:BorderRadius.circular(24),gradient:const LinearGradient(colors:[Color(0xFF141414),Color(0xFF2A210E)]),border:Border.all(color:gold.withOpacity(.45))),child:Row(children:[Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.center,children:[const Text('أقوى العروض على'),const Text('إكسسوارات الهواتف',style:TextStyle(fontSize:23,fontWeight:FontWeight.bold)),const SizedBox(height:8),const Text('خصم يصل إلى 40%',style:TextStyle(color:gold,fontSize:27,fontWeight:FontWeight.w900)),const SizedBox(height:12),_GoldButton(text:'تسوق الآن',onTap:()=>setState((){}))])),const Text('📱\n🎧\n🔌',textAlign:TextAlign.center,style:TextStyle(fontSize:45))])),
    const SizedBox(height:22),const SectionTitle('الأقسام'),SizedBox(height:92,child:ListView(scrollDirection:Axis.horizontal,children:['كفرات وجرابات','سماعات','شواحن','كابلات','حوامل'].map((x)=>_CategoryChip(x)).toList())),const SectionTitle('منتجات مميزة'),
    FutureBuilder<List<Product>>(future:future,builder:(context,s){if(s.connectionState==ConnectionState.waiting)return const Padding(padding:EdgeInsets.all(30),child:Center(child:CircularProgressIndicator(color:gold))); final all=s.data??fallbackProducts;final items=search.isEmpty?all:all.where((p)=>p.name.contains(search)||p.category.contains(search)).toList();if(items.isEmpty)return const Padding(padding:EdgeInsets.all(30),child:Center(child:Text('لا توجد منتجات مطابقة')));return GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:items.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,childAspectRatio:.68,crossAxisSpacing:12,mainAxisSpacing:12),itemBuilder:(_,i)=>ProductCard(product:items[i]));}),
    const SizedBox(height:20),Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:card,borderRadius:BorderRadius.circular(18)),child:const Row(mainAxisAlignment:MainAxisAlignment.spaceAround,children:[Benefit(Icons.verified_outlined,'منتجات أصلية'),Benefit(Icons.local_shipping_outlined,'شحن سريع'),Benefit(Icons.support_agent,'دعم 24/7')]))
  ]));
}
class SectionTitle extends StatelessWidget{final String text;const SectionTitle(this.text,{super.key});@override Widget build(BuildContext c)=>Padding(padding:const EdgeInsets.only(bottom:12,top:8),child:Text(text,style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)));}
class Benefit extends StatelessWidget{final IconData icon;final String text;const Benefit(this.icon,this.text,{super.key});@override Widget build(BuildContext c)=>Column(children:[Icon(icon,color:gold),const SizedBox(height:5),Text(text,style:const TextStyle(fontSize:11))]);}
class _CategoryChip extends StatelessWidget{final String text;const _CategoryChip(this.text);@override Widget build(BuildContext c)=>Container(width:105,margin:const EdgeInsets.only(left:10),decoration:BoxDecoration(color:card,borderRadius:BorderRadius.circular(18),border:Border.all(color:gold.withOpacity(.25))),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.phone_android,color:gold),const SizedBox(height:5),Text(text,textAlign:TextAlign.center,style:const TextStyle(fontSize:11))]);}
class _GoldButton extends StatelessWidget{final String text;final VoidCallback onTap;const _GoldButton({required this.text,required this.onTap});@override Widget build(BuildContext c)=>InkWell(onTap:onTap,child:Container(padding:const EdgeInsets.symmetric(horizontal:18,vertical:10),decoration:BoxDecoration(color:gold,borderRadius:BorderRadius.circular(12)),child:Text(text,style:const TextStyle(color:Colors.black,fontWeight:FontWeight.bold))));}

class ProductCard extends StatelessWidget{final Product product;const ProductCard({required this.product,super.key});@override Widget build(BuildContext context)=>InkWell(onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>ProductPage(product:product))),child:Container(padding:const EdgeInsets.all(10),decoration:BoxDecoration(color:card,borderRadius:BorderRadius.circular(18),border:Border.all(color:Colors.white10)),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[Expanded(child:ProductImage(product.image)),Text(product.name,maxLines:2,overflow:TextOverflow.ellipsis,style:const TextStyle(fontWeight:FontWeight.bold)),Text('★ ${product.rating}',style:const TextStyle(color:gold)),const SizedBox(height:4),Row(children:[Text('${product.price} ج.م',style:const TextStyle(color:gold,fontSize:18,fontWeight:FontWeight.bold)),const Spacer(),IconButton(padding:EdgeInsets.zero,onPressed:(){cart.add(product);ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('تمت إضافة المنتج إلى السلة')));},icon:const Icon(Icons.add_shopping_cart,color:gold,size:20))]) ]));}
class ProductImage extends StatelessWidget{final String value;const ProductImage(this.value,{super.key});@override Widget build(BuildContext c){final uri=Uri.tryParse(value);final isUrl=uri!=null&&(uri.scheme=='http'||uri.scheme=='https');return Center(child:isUrl?ClipRRect(borderRadius:BorderRadius.circular(14),child:Image.network(value,fit:BoxFit.contain,loadingBuilder:(c,child,p)=>p==null?child:const Center(child:CircularProgressIndicator(color:gold)),errorBuilder:(_,__,___)=>const Text('📦',style:TextStyle(fontSize:60))):Text(value.isEmpty?'📦':value,style:const TextStyle(fontSize:60)));}}

class ProductPage extends StatelessWidget{final Product product;const ProductPage({required this.product,super.key});@override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('تفاصيل المنتج'),backgroundColor:bg),body:ListView(padding:const EdgeInsets.all(16),children:[Container(height:300,decoration:BoxDecoration(color:card,borderRadius:BorderRadius.circular(24),border:Border.all(color:gold.withOpacity(.3))),child:ProductImage(product.image)),const SizedBox(height:18),Text(product.name,style:const TextStyle(fontSize:28,fontWeight:FontWeight.bold)),Text('★ ${product.rating}   تقييم العملاء',style:const TextStyle(color:gold)),const SizedBox(height:8),Text('${product.price} ج.م',style:const TextStyle(color:gold,fontSize:32,fontWeight:FontWeight.w900)),if(product.oldPrice.isNotEmpty)Text('${product.oldPrice} ج.م',style:const TextStyle(decoration:TextDecoration.lineThrough,color:Colors.grey)),const SizedBox(height:20),const Text('منتج مميز لإكسسوارات الهواتف، تصميم عملي وجودة مناسبة للاستخدام اليومي.',style:TextStyle(fontSize:16,height:1.5)),const SizedBox(height:25),SizedBox(height:56,child:FilledButton.icon(style:FilledButton.styleFrom(backgroundColor:gold,foregroundColor:Colors.black),onPressed:(){cart.add(product);ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('تمت إضافة المنتج إلى السلة')));},icon:const Icon(Icons.shopping_cart),label:const Text('أضف إلى السلة',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold))))]));}

class CategoriesPage extends StatelessWidget{const CategoriesPage({super.key});@override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('الأقسام')),body:GridView.count(padding:const EdgeInsets.all(16),crossAxisCount:2,crossAxisSpacing:12,mainAxisSpacing:12,children:['كفرات وجرابات','سماعات','شواحن','كابلات','حوامل','حماية الشاشة'].map((x)=>Container(decoration:BoxDecoration(color:card,borderRadius:BorderRadius.circular(20)),child:Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.phone_android,color:gold,size:40),const SizedBox(height:10),Text(x)]))).toList()));}

class CartPage extends StatefulWidget{const CartPage({super.key});@override State<CartPage> createState()=>_CartPageState();}
class _CartPageState extends State<CartPage>{@override void initState(){super.initState();cart.addListener(_update);}@override void dispose(){cart.removeListener(_update);super.dispose();}void _update()=>setState((){});@override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:Text('سلة المشتريات (${cart.count})')),body:cart.items.isEmpty?Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.shopping_cart_outlined,color:gold,size:70),const SizedBox(height:12),const Text('السلة فارغة',style:TextStyle(fontSize:20)),const SizedBox(height:18),FilledButton(onPressed:()=>Navigator.pop(c),child:const Text('ابدأ التسوق'))]):ListView(padding:const EdgeInsets.all(16),children:[...cart.items.map((item)=>Container(margin:const EdgeInsets.only(bottom:12),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:card,borderRadius:BorderRadius.circular(18)),child:Row(children:[SizedBox(width:62,height:62,child:ProductImage(item.product.image)),const SizedBox(width:10),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(item.product.name,maxLines:2,overflow:TextOverflow.ellipsis),Text('${item.product.price} ج.م',style:const TextStyle(color:gold,fontWeight:FontWeight.bold)),Row(children:[IconButton(onPressed:()=>cart.decrease(item.product),icon:const Icon(Icons.remove_circle_outline)),Text('${item.quantity}',style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold)),IconButton(onPressed:()=>cart.add(item.product),icon:const Icon(Icons.add_circle_outline))])])),IconButton(onPressed:()=>cart.remove(item.product),icon:const Icon(Icons.delete_outline,color:Colors.redAccent))])),const SizedBox(height:4),Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:card,borderRadius:BorderRadius.circular(18)),child:Column(children:[Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[const Text('الإجمالي'),Text('${cart.total.toStringAsFixed(0)} ج.م',style:const TextStyle(color:gold,fontSize:22,fontWeight:FontWeight.bold))]),const SizedBox(height:16),SizedBox(width:double.infinity,height:52,child:FilledButton(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>CheckoutPage(total:cart.total))),child:const Text('إتمام الطلب',style:TextStyle(fontSize:17,fontWeight:FontWeight.bold))))]))]));}

class CheckoutPage extends StatefulWidget{final double total;const CheckoutPage({required this.total,super.key});@override State<CheckoutPage> createState()=>_CheckoutPageState();}
class _CheckoutPageState extends State<CheckoutPage>{final name=TextEditingController(),phone=TextEditingController(),address=TextEditingController();String payment='الدفع عند الاستلام';bool saving=false;@override void dispose(){name.dispose();phone.dispose();address.dispose();super.dispose();}Future<void> submit()async{if(name.text.trim().isEmpty||phone.text.trim().isEmpty||address.text.trim().isEmpty){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('من فضلك أكمل بيانات الطلب')));return;}setState(()=>saving=true);try{await Supabase.instance.client.from('orders').insert({'customer_name':name.text.trim(),'phone':phone.text.trim(),'address':address.text.trim(),'payment_method':payment,'total':widget.total,'items':cart.items.map((x)=>{'product_id':x.product.id,'name':x.product.name,'price':x.product.priceValue,'quantity':x.quantity}).toList()});}catch(_){/* UI remains usable if orders table is not created yet. */}if(!mounted)return;cart.clear();setState(()=>saving=false);showDialog(context:context,barrierDismissible:false,builder:(_)=>AlertDialog(title:const Text('تم استلام طلبك ✅'),content:const Text('شكرًا لك. سيتم التواصل معك لتأكيد الطلب.'),actions:[TextButton(onPressed:(){Navigator.pop(context);Navigator.pop(context);Navigator.pop(context);},child:const Text('حسنًا'))]));}
@override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('إتمام الطلب')),body:ListView(padding:const EdgeInsets.all(16),children:[const SectionTitle('بيانات العميل'),TextField(controller:name,decoration:const InputDecoration(labelText:'الاسم الكامل')),const SizedBox(height:12),TextField(controller:phone,keyboardType:TextInputType.phone,decoration:const InputDecoration(labelText:'رقم الهاتف')),const SizedBox(height:12),TextField(controller:address,maxLines:3,decoration:const InputDecoration(labelText:'العنوان بالتفصيل')),const SizedBox(height:22),const SectionTitle('طريقة الدفع'),...['الدفع عند الاستلام','تحويل/دفع إلكتروني'].map((x)=>RadioListTile<String>(value:x,groupValue:payment,onChanged:(v)=>setState(()=>payment=v!),title:Text(x))),const SizedBox(height:12),Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:card,borderRadius:BorderRadius.circular(18)),child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[const Text('الإجمالي'),Text('${widget.total.toStringAsFixed(0)} ج.م',style:const TextStyle(color:gold,fontSize:24,fontWeight:FontWeight.bold))])),const SizedBox(height:18),SizedBox(height:54,child:FilledButton(onPressed:saving?null:submit,child:saving?const CircularProgressIndicator():const Text('تأكيد الطلب',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold))))]));}

class ProfilePage extends StatelessWidget{
  const ProfilePage({super.key});
  @override Widget build(BuildContext c)=>Scaffold(
    appBar:AppBar(title:const Text('حسابي')),
    body:ListView(padding:const EdgeInsets.all(16),children:[
      Card(color:card,child:ListTile(leading:const Icon(Icons.dashboard_outlined,color:gold),title:const Text('لوحة التحكم'),subtitle:const Text('إدارة المنتجات والطلبات'),trailing:const Icon(Icons.chevron_left,color:gold),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const AdminLoginPage())))),
      ...['طلباتي','العناوين','المفضلة','الإشعارات','الإعدادات'].map((x)=>Card(color:card,child:ListTile(title:Text(x),trailing:const Icon(Icons.chevron_left,color:gold)))),
    ]));
}

class AdminLoginPage extends StatefulWidget{const AdminLoginPage({super.key});@override State<AdminLoginPage> createState()=>_AdminLoginPageState();}
class _AdminLoginPageState extends State<AdminLoginPage>{
  final email=TextEditingController(); final password=TextEditingController(); bool loading=false;
  @override void dispose(){email.dispose();password.dispose();super.dispose();}
  Future<void> login() async {
    if(email.text.trim().isEmpty||password.text.isEmpty){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('أدخل البريد وكلمة المرور')));return;}
    setState(()=>loading=true);
    try{
      await Supabase.instance.client.auth.signInWithPassword(email:email.text.trim(),password:password.text);
      final ok=await Supabase.instance.client.rpc('is_admin');
      if(ok!=true){await Supabase.instance.client.auth.signOut();throw Exception('هذا الحساب ليس مديرًا');}
      if(!mounted)return; Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const AdminDashboardPage()));
    }catch(e){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('تعذر تسجيل الدخول: ${e.toString().replaceFirst('Exception: ','')}')));}
    if(mounted)setState(()=>loading=false);
  }
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('دخول لوحة التحكم')),body:ListView(padding:const EdgeInsets.all(20),children:[const Icon(Icons.admin_panel_settings,color:gold,size:72),const SizedBox(height:20),TextField(controller:email,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(labelText:'البريد الإلكتروني')),const SizedBox(height:14),TextField(controller:password,obscureText:true,decoration:const InputDecoration(labelText:'كلمة المرور')),const SizedBox(height:24),SizedBox(height:54,child:FilledButton(onPressed:loading?null:login,child:loading?const CircularProgressIndicator():const Text('دخول',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold))))]));
}

class AdminDashboardPage extends StatefulWidget{const AdminDashboardPage({super.key});@override State<AdminDashboardPage> createState()=>_AdminDashboardPageState();}
class _AdminDashboardPageState extends State<AdminDashboardPage>{
  List<Map<String,dynamic>> products=[]; List<Map<String,dynamic>> orders=[]; bool loading=true;
  @override void initState(){super.initState();load();}
  Future<void> load() async {setState(()=>loading=true);try{final p=await Supabase.instance.client.from('products').select().order('id',ascending:false);final o=await Supabase.instance.client.from('orders').select().order('id',ascending:false);products=(p as List).map((x)=>Map<String,dynamic>.from(x)).toList();orders=(o as List).map((x)=>Map<String,dynamic>.from(x)).toList();}catch(e){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('خطأ في تحميل البيانات: $e')));}if(mounted)setState(()=>loading=false);}
  Future<void> addProduct() async {final n=TextEditingController(),pr=TextEditingController(),cat=TextEditingController(),img=TextEditingController();final ok=await showDialog<bool>(context:context,builder:(_)=>AlertDialog(title:const Text('إضافة منتج'),content:SingleChildScrollView(child:Column(children:[TextField(controller:n,decoration:const InputDecoration(labelText:'اسم المنتج')),TextField(controller:pr,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'السعر')),TextField(controller:cat,decoration:const InputDecoration(labelText:'القسم')),TextField(controller:img,decoration:const InputDecoration(labelText:'رابط الصورة أو Emoji'))])),actions:[TextButton(onPressed:()=>Navigator.pop(context,false),child:const Text('إلغاء')),FilledButton(onPressed:()=>Navigator.pop(context,true),child:const Text('حفظ'))]));if(ok!=true)return;try{await Supabase.instance.client.from('products').insert({'name':n.text.trim(),'price':double.tryParse(pr.text.trim())??0,'category':cat.text.trim(),'image':img.text.trim(),'active':true});await load();}catch(e){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('فشل الحفظ: $e')));}}
  Future<void> updateStatus(Map<String,dynamic> order) async {const statuses=['جديد','قيد التجهيز','تم الشحن','تم التسليم','ملغي'];final current=(order['status']??'جديد').toString();final value=await showDialog<String>(context:context,builder:(_)=>SimpleDialog(title:const Text('حالة الطلب'),children:statuses.map((x)=>SimpleDialogOption(onPressed:()=>Navigator.pop(context,x),child:Text(x,style:TextStyle(color:x==current?gold:null)))).toList()));if(value==null)return;await Supabase.instance.client.from('orders').update({'status':value}).eq('id',order['id']);await load();}
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('لوحة التحكم'),actions:[IconButton(onPressed:load,icon:const Icon(Icons.refresh)),IconButton(onPressed:()async{await Supabase.instance.client.auth.signOut();if(mounted)Navigator.pop(c);},icon:const Icon(Icons.logout))]),floatingActionButton:FloatingActionButton(backgroundColor:gold,foregroundColor:Colors.black,onPressed:addProduct,child:const Icon(Icons.add)),body:loading?const Center(child:CircularProgressIndicator(color:gold)):RefreshIndicator(onRefresh:load,child:ListView(padding:const EdgeInsets.all(16),children:[Text('المنتجات (${products.length})',style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)),const SizedBox(height:10),...products.map((p)=>Card(color:card,child:ListTile(leading:SizedBox(width:50,height:50,child:ProductImage((p['image']??'').toString())),title:Text((p['name']??'').toString()),subtitle:Text('${p['price']??0} ج.م • ${p['stock']??0} قطعة'),trailing:PopupMenuButton<String>(onSelected:(v)async{if(v=='toggle'){await Supabase.instance.client.from('products').update({'active':!((p['active']??true)==true)}).eq('id',p['id']);await load();}else if(v=='delete'){await Supabase.instance.client.from('products').delete().eq('id',p['id']);await load();}},itemBuilder:(_)=>[PopupMenuItem(value:'toggle',child:Text((p['active']??true)==true?'إخفاء المنتج':'إظهار المنتج')),const PopupMenuItem(value:'delete',child:Text('حذف المنتج'))]))))),const SizedBox(height:24),Text('الطلبات (${orders.length})',style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)),const SizedBox(height:10),...orders.map((o)=>Card(color:card,child:ListTile(onTap:()=>updateStatus(o),title:Text('${o['customer_name']??'عميل'} • ${o['total']??0} ج.م'),subtitle:Text('${o['phone']??''}\n${o['address']??''}\n${o['status']??'جديد'}'),isThreeLine:true,trailing:const Icon(Icons.edit,color:gold))))])));
}

