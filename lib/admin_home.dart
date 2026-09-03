import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  final VoidCallback onProducts;
  final VoidCallback onCategories;
  final VoidCallback onOrders;

  const AdminHomePage({
    super.key,
    required this.onProducts,
    required this.onCategories,
    required this.onOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'لوحة الإدارة',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF171717),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مرحباً بك في لوحة الإدارة',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'اختر القسم الذي تريد إدارته',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.25,
              children: [
                _AdminMenuCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'المنتجات',
                  subtitle: 'إضافة وتعديل المنتجات',
                  onTap: onProducts,
                ),
                _AdminMenuCard(
                  icon: Icons.category_outlined,
                  title: 'الأقسام',
                  subtitle: 'إدارة أقسام المتجر',
                  onTap: onCategories,
                ),
                _AdminMenuCard(
                  icon: Icons.shopping_bag_outlined,
                  title: 'الطلبات',
                  subtitle: 'متابعة وإدارة الطلبات',
                  onTap: onOrders,
                ),
                _AdminMenuCard(
                  icon: Icons.storefront_outlined,
                  title: 'إعدادات المتجر',
                  subtitle: 'الدفع ومعلومات المتجر',
                  onTap: () {},
                ),
                _AdminMenuCard(
                  icon: Icons.palette_outlined,
                  title: 'تخصيص التطبيق',
                  subtitle: 'الشكل والخطوط والألوان',
                  onTap: () {},
                ),
                _AdminMenuCard(
                  icon: Icons.bar_chart_rounded,
                  title: 'الإحصائيات',
                  subtitle: 'تقارير وأرقام المتجر',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminMenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC84A).withOpacity(.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: Color(0xFFFFC84A),
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
