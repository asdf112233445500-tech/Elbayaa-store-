from pathlib import Path

p = Path("lib/main.dart")
s = p.read_text()

marker = "const productColors = <String, Color>{"

insert = r'''
class Category {
  final dynamic id;
  final String name;
  final String imageUrl;
  final String icon;
  final int sortOrder;
  final bool active;

  const Category({
    this.id,
    required this.name,
    this.imageUrl = '',
    this.icon = '',
    this.sortOrder = 0,
    this.active = true,
  });

  factory Category.fromMap(Map<String, dynamic> m) {
    return Category(
      id: m['id'],
      name: '${m['name'] ?? ''}',
      imageUrl: '${m['image_url'] ?? ''}',
      icon: '${m['icon'] ?? ''}',
      sortOrder: int.tryParse('${m['sort_order'] ?? 0}') ?? 0,
      active: m['active'] == true,
    );
  }
}

class CategoryRepository {
  static Future<List<Category>> getCategories({
    bool includeInactive = false,
  }) async {
    try {
      var query = supabase.from('categories').select();

      if (!includeInactive) {
        query = query.eq('active', true);
      }

      final data = await query.order('sort_order', ascending: true);

      final list = (data as List)
          .map((e) => Category.fromMap(Map<String, dynamic>.from(e)))
          .where((e) => e.name.trim().isNotEmpty)
          .toList();

      if (list.isNotEmpty) return list;
    } catch (e) {
      debugPrint('CATEGORIES ERROR: $e');
    }

    return productCategories
        .asMap()
        .entries
        .map(
          (e) => Category(
            id: e.key + 1,
            name: e.value,
            sortOrder: e.key + 1,
          ),
        )
        .toList();
  }
}

'''

if marker not in s:
    raise SystemExit("MARKER_NOT_FOUND")

if "class Category {" in s:
    raise SystemExit("CATEGORY_ALREADY_EXISTS")

s = s.replace(marker, insert + marker, 1)
p.write_text(s)
print("Category model/repository added successfully.")
