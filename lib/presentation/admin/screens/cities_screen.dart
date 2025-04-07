import 'package:flutter/material.dart';
import 'package:citi_guide_app/core/services/city_service.dart';
import 'package:citi_guide_app/models/city.dart';
import 'package:citi_guide_app/presentation/admin/screens/attractions.dart';
import 'package:citi_guide_app/presentation/admin/screens/confirmation_dialog.dart';
import 'package:citi_guide_app/presentation/admin/widgets/add_edit_city_dialog.dart';
import 'package:citi_guide_app/presentation/admin/widgets/admin_drawer.dart'; // Make sure to import
import 'package:citi_guide_app/widgets/city_card.dart';

class CitiesScreen extends StatefulWidget {
  const CitiesScreen({super.key});

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  final CityService _cityService = CityService();
  List<City> _cities = [];
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Add this key

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    setState(() => _isLoading = true);
    try {
      _cities = await _cityService.getCities();
    } catch (e) {
      _showSnackbar('Failed to load cities: ${e.toString()}', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the key to Scaffold
      drawer: const AdminDrawer(), // Add the drawer here
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCityDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Manage Cities'),
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer(); // Open drawer when menu is pressed
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, '/home'),
        ),
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: _loadCities,
        ),
      ],
    );
  }

  // ... rest of your existing code remains the same ...
  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_cities.isEmpty) return _buildEmptyState();
    return _buildCityList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_city, size: 48, color: Color.fromARGB(255, 79, 2, 98)),
          const SizedBox(height: 16),
          const Text('No cities found'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _showAddCityDialog,
            child: const Text('Add First City'),
          ),
        ],
      ),
    );
  }

  Widget _buildCityList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _cities.length,
      itemBuilder: (context, index) => CityCard(
        city: _cities[index],
        onTap: () => _navigateToAttractions(_cities[index]),
        onEdit: () => _showEditCityDialog(_cities[index]),
        onDelete: () => _confirmDelete(_cities[index]),
      ),
    );
  }

  void _navigateToAttractions(City city) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttractionsScreen(cityId: city.id),
      ),
    );
  }

  void _showAddCityDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEditCityDialog(
        onSave: (city, imageBytes) async {
          try {
            await _cityService.addCity(city, imageBytes);
            if (mounted) {
              _showSnackbar('City added successfully', const Color.fromARGB(255, 7, 174, 93));
              _loadCities();
            }
          } catch (e) {
            _showSnackbar('Failed to add city: ${e.toString()}', const Color.fromARGB(255, 220, 37, 24));
          }
        },
      ),
    );
  }

  void _showEditCityDialog(City city) {
    showDialog(
      context: context,
      builder: (context) => AddEditCityDialog(
        city: city,
        onSave: (updatedCity, newImageBytes) async {
          try {
            await _cityService.updateCity(updatedCity, newImageBytes: newImageBytes);
            if (mounted) {
              _showSnackbar('City updated successfully', const Color.fromARGB(255, 17, 162, 99));
              _loadCities();
            }
          } catch (e) {
            _showSnackbar('Failed to update city: ${e.toString()}', const Color.fromARGB(255, 191, 32, 20));
          }
        },
      ),
    );
  }

  void _confirmDelete(City city) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Delete City',
        message: 'Are you sure you want to delete "${city.name}"?',
        onConfirm: () async {
          try {
            await _cityService.deleteCity(city.id);
            if (mounted) {
              _showSnackbar('City deleted successfully', Colors.green);
              _loadCities();
            }
          } catch (e) {
            _showSnackbar('Failed to delete city: ${e.toString()}', Colors.red);
          }
        },
      ),
    );
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }
}