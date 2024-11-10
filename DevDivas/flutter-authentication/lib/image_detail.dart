import 'package:flutter/material.dart';

class ImageDetailsPage extends StatelessWidget {
  final Map<String, dynamic>? responseData;
  final List<Map<String, dynamic>>? responseDataList;

  const ImageDetailsPage({super.key, this.responseData, this.responseDataList});

  @override
  Widget build(BuildContext context) {
    final dataToShow = responseDataList ?? [responseData!];

    return Scaffold(
      backgroundColor: const Color(0xFFDFFFD6), // Light green background
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'DIY Wiz',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[700], // Dark green AppBar
        elevation: 4,
      ),
      body: ListView.builder(
        itemCount: dataToShow.length,
        itemBuilder: (context, index) {
          final data = dataToShow[index];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    data['image_url'] ?? 'https://example.com/placeholder-image.jpg',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Title
                Text(
                  data['title'] ?? 'Generated Image Title',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Title in green
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Description
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data['description'] ?? 'No description available.',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Expansion Tile for details
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ExpansionTile(
                    leading: Icon(
                      Icons.expand_more,
                      color: Colors.green[700],
                    ),
                    title: const Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    children: [
                      // Materials Section
                      if (data['materials'] != null && data['materials'] is List)
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Materials:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 5),
                              ...data['materials'].map<Widget>((material) {
                                return Text(
                                  '- ${material['item'] ?? 'Unknown item'}',
                                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      // Steps Section
                      if (data['steps'] != null && data['steps'] is List)
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Steps:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 5),
                              ...data['steps'].map<Widget>((step) {
                                return Text(
                                  'Step ${step['step_number']}: ${step['instruction']}',
                                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



