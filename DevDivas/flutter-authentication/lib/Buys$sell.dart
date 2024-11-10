import 'package:flutter/material.dart';

class RevenuePage extends StatefulWidget {
  @override
  _RevenuePageState createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<WasteItem> wasteItems = [
    WasteItem(
      title: 'Plastic Bottles',
      description: '10 kg of clean plastic bottles',
      price: 5.00,
      image: 'assets/images/bottle.jpg',
    ),
    WasteItem(
      title: 'Cardboard Boxes',
      description: '5 kg of flattened cardboard',
      price: 3.00,
      image: 'assets/images/cardboard.jpg',
    ),
  ];

  final List<DIYProduct> diyProducts = [
    DIYProduct(
      title: 'Bottle Planter',
      description: 'Beautiful vertical garden using plastic bottles',
      price: 25.00,
      materials: ['Plastic bottles', 'Soil', 'Seeds'],
      image: 'assets/images/img1.jpg',
    ),
    DIYProduct(
      title: 'Cardboard Organizer',
      description: 'Desk organizer made from recycled cardboard',
      price: 15.00,
      materials: ['Cardboard', 'Glue', 'Paint'],
      image: 'assets/images/img2.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFFFD6), // Matches UploadImagePage
      appBar: AppBar(
        title: Text('Revenue Center', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green[700], // Matches UploadImagePage app bar color
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          tabs: [
            Tab(text: 'Sell Waste',),
            Tab(text: 'Buy DIY Products'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWasteSellSection(),
          _buildDIYProductsSection(),
        ],
      ),
    );
  }

  Widget _buildWasteSellSection() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: wasteItems.length,
      itemBuilder: (context, index) {
        return _buildWasteItemCard(wasteItems[index]);
      },
    );
  }

  Widget _buildWasteItemCard(WasteItem item) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            leading: Image.asset(
              item.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text(item.title),
            subtitle: Text(item.description),
            trailing: Text('\$${item.price.toStringAsFixed(2)}'),
          ),
          ButtonBar(
            children: [
              TextButton(
                onPressed: () => _showContactCompaniesDialog(),
                child: Text('Contact Companies' , style: TextStyle(color: Colors.black),),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800], // Matches button color in UploadImagePage
                ),
                onPressed: () => _showListItemDialog(),
                child: Text('List Item' , style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDIYProductsSection() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: diyProducts.length,
      itemBuilder: (context, index) {
        return _buildDIYProductCard(diyProducts[index]);
      },
    );
  }

  Widget _buildDIYProductCard(DIYProduct product) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.asset(
              product.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.green),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _showPurchaseDialog(product),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800], // Matches button color in UploadImagePage
                    minimumSize: Size(double.infinity, 36),
                  ),
                  child: Text('Buy Now' , style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showContactCompaniesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Companies'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.business),
              title: Text('EcoRecycle Corp'),
              subtitle: Text('Specializes in plastic recycling'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('Green Future Ltd'),
              subtitle: Text('Buys all types of recyclables'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showListItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('List Your Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Quantity (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Price per kg',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('List Now'),
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(DIYProduct product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase ${product.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Price: \$${product.price.toStringAsFixed(2)}'),
            SizedBox(height: 16),
            Text('Materials included:'),
            ...product.materials.map((material) => Text('• $material')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Confirm Purchase'),
          ),
        ],
      ),
    );
  }
}

class WasteItem {
  final String title;
  final String description;
  final double price;
  final String image;

  WasteItem({
    required this.title,
    required this.description,
    required this.price,
    required this.image,
  });
}

class DIYProduct {
  final String title;
  final String description;
  final double price;
  final List<String> materials;
  final String image;

  DIYProduct({
    required this.title,
    required this.description,
    required this.price,
    required this.materials,
    required this.image,
  });
}
