import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:video_player/video_player.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _allMedicines = [];
  List<dynamic> _pharmacies = [];
  List<dynamic> _suggestions = [];
  dynamic _selectedMedicine;
  bool _isLoading = false;
  String _loadingText = "Checking stock...";
  double _progress = 0.0;

  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _loadMedicines();
    _loadPharmacies();
    _loadAndInitializeVideo();
  }

  Future<void> _loadAndInitializeVideo() async {
    _videoController = VideoPlayerController.asset('assets/videos/loadervideo.mp4');
    await _videoController.initialize();
    _videoController.setLooping(true);
    setState(() {});
  }

  Future<void> _loadMedicines() async {
    try {
      final String response = await rootBundle.loadString('lib/data/medicines.json');
      final data = await json.decode(response);
      setState(() => _allMedicines = data);
    } catch (e) {
      debugPrint("Error loading JSON: $e");
    }
  }

  Future<void> _loadPharmacies() async {
    try {
      final String response = await rootBundle.loadString('lib/data/pharmacies.json');
      final data = await json.decode(response);
      setState(() => _pharmacies = data);
    } catch (e) {
      debugPrint("Error loading pharmacies: $e");
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _suggestions = query.length >= 2
          ? _allMedicines.where((m) => m['name'].toString().toLowerCase().contains(query.toLowerCase())).take(5).toList()
          : [];
    });
  }

  void _performFullSearch(dynamic medicine) async {
    setState(() {
      _searchController.text = medicine['name'];
      _suggestions = [];
      _isLoading = true;
      _loadingText = "Searching nearby pharmacies...";
      _progress = 0.0;
    });

    _videoController.setLooping(true);
    await _videoController.play();

    for (int i = 1; i <= 13; i++) {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
            _progress = i / 13;
            if (i == 3) _loadingText = "Calculating fastest route...";
            if (i == 7) _loadingText = "Checking stock in pharmacies...";
            if (i == 10) _loadingText = "Finalizing results...";
        });
    }

    setState(() {
      _selectedMedicine = medicine;
      _isLoading = false;
    });
    _videoController.pause();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isShowingResults = !_isLoading && _selectedMedicine != null;

    return Scaffold(
      appBar: !_isLoading ? AppBar(title: const Text('CareCart Finder')) : null,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (!isShowingResults && !_isLoading) ...[
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Search for Dolo, Pan, Augmentin...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  if (_suggestions.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: _suggestions.map((m) => ListTile(
                          title: Text(m['name']),
                          onTap: () => _performFullSearch(m),
                        )).toList(),
                      ),
                    ),
                ],
                if (isShowingResults)
                  Expanded(
                    child: ListView(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_selectedMedicine['name'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                Text(_selectedMedicine['details'], style: TextStyle(color: Colors.grey[700])),
                                const Divider(),
                                ..._pharmacies.map((pharmacy) {
                                  return ListTile(
                                    leading: const Icon(Icons.local_pharmacy, color: Colors.blueAccent),
                                    title: Text(pharmacy['name']),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Address: ${pharmacy['location']}'),
                                        Text('Distance: ${pharmacy['distance']} | Time: ${pharmacy['time']}'),
                                      ],
                                    ),
                                  );
                                }).toList()
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedMedicine = null;
                              _searchController.clear();
                            });
                          },
                          child: const Text('Back to Search'),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black, // Full-screen black background
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: _videoController.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: VideoPlayer(_videoController),
                            )
                          : const CircularProgressIndicator(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(_loadingText, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(value: _progress, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
