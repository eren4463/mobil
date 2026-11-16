import 'package:flutter/material.dart';

void main() {
  runApp(const GamerStoreApp());
}

// GERÇEK SEPET HAFIZAMIZ
List<Product> globalCart = [];

class GamerStoreApp extends StatelessWidget {
  const GamerStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gamer Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      home: const DiscoverPage(),
    );
  }
}

class Product {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Product({required this.name, required this.description, required this.price, required this.imageUrl});
}

// 1. ARAMA YAPABİLMEK İÇİN SAYFAYI STATEFUL YAPTIK
class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  String searchQuery = ''; // Arama kutusuna yazılan metni tutacak

  final List<Product> allProducts = [
    Product(name: 'Razer Huntsman V2', description: 'Işık hızında tepkime veren optik mekanik oyuncu klavyesi.', price: 199.99, imageUrl: 'https://images.unsplash.com/photo-1595225476474-87563907a212?w=500&q=80'),
    Product(name: 'HyperX Cloud II', description: '7.1 Surround ses deneyimi sunan efsanevi oyuncu kulaklığı.', price: 99.99, imageUrl: 'https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?w=500&q=80'),
    Product(name: 'Asus ROG Monitör', description: '240Hz 1ms yenileme hızıyla rakipsiz akıcılık sağlayan monitör.', price: 499.99, imageUrl: 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?w=500&q=80'),
    Product(name: 'Oculus Quest 2', description: 'Kablosuz VR sanal gerçeklik gözlüğü.', price: 299.99, imageUrl: 'https://images.unsplash.com/photo-1622979135225-d2ba269cf1ac?w=500&q=80'),
    Product(name: 'Nvidia RTX 4090', description: '4K çözünürlükte maksimum FPS değerleri sunan yeni nesil devasa ekran kartı.', price: 1599.99, imageUrl: 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?w=500&q=80'),
    Product(name: 'Secretlab Titan Evo', description: 'Uzun oyun seansları için ergonomik oyuncu koltuğu.', price: 449.99, imageUrl: 'https://images.unsplash.com/photo-1598550476439-6847785fcea6?w=500&q=80'),
    Product(name: 'Blue Yeti Mikrofon', description: 'Profesyonel yayıncı stüdyo mikrofonu.', price: 129.99, imageUrl: 'https://images.unsplash.com/photo-1585565804112-f201f68c48b4?w=500&q=80'),
  ];

  @override
  Widget build(BuildContext context) {
    // 2. YAZILAN KELİMEYE GÖRE LİSTEYİ FİLTRELEME
    final filteredProducts = allProducts.where((product) {
      return product.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gamer Store 🎮'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage())),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                // 3. KLAVYEDEN HER HARF GİRİLDİĞİNDE TETİKLENEN KOD
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  hintText: 'Ekipman ara... (Örn: Asus, Razer)',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (searchQuery.isEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=1000&q=80',
                  width: double.infinity, height: 140, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(height: 140, color: Colors.grey[900], child: const Center(child: Icon(Icons.sports_esports, color: Colors.grey, size: 50))),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Trend Ekipmanlar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 12),
            ] else ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text('"${filteredProducts.length}" sonuç bulundu', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
              )
            ],
            Expanded(
              child: filteredProducts.isEmpty
                  ? const Center(child: Text('Aradığınız ürün bulunamadı. 😢', style: TextStyle(color: Colors.white54, fontSize: 16)))
                  : GridView.builder(
                      itemCount: filteredProducts.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.72, crossAxisSpacing: 16, mainAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) {
                        return ProductCard(product: filteredProducts[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(product: product))),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imageUrl, fit: BoxFit.cover, width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[800], child: const Center(child: Icon(Icons.videogame_asset, color: Colors.grey, size: 50))),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage())),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity, height: 300,
            child: Image.network(
              product.imageUrl, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[900], child: const Center(child: Icon(Icons.videogame_asset, color: Colors.grey, size: 100))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))),
                    Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Ürün Açıklaması', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70)),
                const SizedBox(height: 8),
                Text(product.description, style: const TextStyle(fontSize: 16, color: Colors.white54, height: 1.5)),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                onPressed: () {
                  globalCart.add(product);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} sepete eklendi! 🛒'), backgroundColor: Colors.green));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Sepete Ekle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    for (var item in globalCart) {
      totalPrice += item.price;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Sepetim')),
      body: globalCart.isEmpty
          ? const Center(child: Text('Sepetiniz şu an boş. 🛒\nHadi birkaç ekipman alalım!', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 18)))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: globalCart.length,
                    itemBuilder: (context, index) {
                      final item = globalCart[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey)),
                          ),
                          title: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          subtitle: Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.greenAccent)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () {
                              setState(() { globalCart.removeAt(index); });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.grey[900], borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Toplam:', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('\$${totalPrice.toStringAsFixed(2)}', style: const TextStyle(color: Colors.greenAccent, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}