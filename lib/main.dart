import 'package:flutter/material.dart';
import 'cart_page.dart';

// Projede kullanılacak ürünlerin veri modelini tanımlayan sınıf (Model Class)
class Product {
  final String title;
  final String subtitle;
  final String price;
  final Color bgColor;
  final String imagePath;
  final bool isDarkBg;

  Product({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.bgColor,
    required this.imagePath,
    required this.isDarkBg,
  });
}

// Sepete eklenen ürünleri tutan global liste (State simülasyonu için)
List<Product> cartItems = [];

void main() {
  runApp(const MyApp());
}

// Uygulamanın kök widget'ı
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Katalog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DiscoverPage(),
    );
  }
}

// Ana keşfet (katalog) sayfası
class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  // Katalogda sergilenecek ürünlerin listesi
  final List<Product> products = [
    Product(title: "AirPods Pro (2nd)", subtitle: "Adaptive Audio.", price: "\$249", bgColor: Colors.grey[800]!, imagePath: "images/airpods_pro.png", isDarkBg: true),
    Product(title: "AirPods Max", subtitle: "Sound focused.", price: "\$549", bgColor: Colors.blue[100]!, imagePath: "images/airpods_max.png", isDarkBg: false),
    Product(title: "iPhone 15 Pro", subtitle: "Titanium. So strong.", price: "\$999", bgColor: Colors.grey[900]!, imagePath: "images/iPhone.png", isDarkBg: true),
    Product(title: "MacBook Pro 14\"", subtitle: "Pro to the max.", price: "\$1599", bgColor: Colors.grey[200]!, imagePath: "images/macbook.png", isDarkBg: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Discover",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
        ),
        actions: [
          // Sepet ikonu ve bildirim sayısı (Badge) mantığı
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 28),
                onPressed: () {
                  // Sepet sayfasına geçiş işlemi
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  ).then((_) {
                    // Sepet sayfasından dönüldüğünde sayacı güncellemek için ekranı yeniler
                    setState(() {});
                  });
                },
              ),
              // Sepette ürün varsa mavi badge içinde sayıyı gösterir
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                    child: Text(
                      '${cartItems.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text('Find your perfect device.', style: TextStyle(fontSize: 16, color: Colors.black54)),
            ),
            // Arama çubuğu tasarımı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search products',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
            ),
            // Kampanya/Hediye kartı tasarımı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(15)),
                child: const Row(
                  children: [
                    Icon(Icons.card_giftcard, color: Colors.blue, size: 40),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("GIFT STORE", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18)),
                        Text("Special offers for you", style: TextStyle(color: Colors.blue, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            // Ürünlerin GridView ile iki kolon halinde listelenmesi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.70,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 20,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(products[index]);
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Ürün kartlarını oluşturan yardımcı metod
  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        // Kartın üzerine tıklandığında detay sayfasına veri aktararak geçiş yapar
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        ).then((_) {
          // Geri dönüldüğünde sepet sayacının güncel kalmasını sağlar
          setState(() {});
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: product.bgColor, borderRadius: BorderRadius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  product.imagePath,
                  fit: BoxFit.contain, // Resmin kutuya orantılı sığmasını sağlar
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(product.subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(product.price, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

// Ürün Detay Sayfası. Yalnızca veri gösterdiği için Stateless widget olarak tanımlandı.
class ProductDetailPage extends StatelessWidget {
  final Product product;

  // Constructor üzerinden seçili ürün verisi alınır
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: product.bgColor,
        elevation: 0,
        // isDarkBg durumuna göre ikon rengini belirler
        iconTheme: IconThemeData(color: product.isDarkBg ? Colors.white : Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView( // İçeriğin kaydırılabilir olması için eklendi
        child: Column(
          children: [
            // Ürün resminin bulunduğu geniş alan
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: product.bgColor,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Image.asset(product.imagePath, fit: BoxFit.contain),
              ),
            ),
            // Ürün açıklaması ve fiyat bilgileri
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(product.subtitle, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 15),
                  
                  const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text(
                    "This is a premium product designed with cutting-edge technology. It offers exceptional performance, beautiful design, and seamless integration into your daily life.",
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 25),

                  // Ürünün teknik özelliklerinin (Specifications) gösterildiği bölüm
                  const Text("Specifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSpecItem("SIZE", "3.3 inches"),
                      _buildSpecItem("AUDIO", "360-degree"),
                      _buildSpecItem("COLORS", "5 colors"),
                    ],
                  ),

                  const SizedBox(height: 40), 

                  // Fiyat ve Sepete Ekle Butonu Row yapısı
                  Row(
                    children: [
                      Text(product.price, style: const TextStyle(fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      SizedBox(
                        height: 55,
                        width: 160,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: () {
                            // Ürünü global listeye ekler ve ana sayfaya geri döner
                            cartItems.add(product);
                            Navigator.pop(context);
                          },
                          child: const Text("Add to Cart", style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Özellik kutucuklarını oluşturan yardımcı metod
  Widget _buildSpecItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}