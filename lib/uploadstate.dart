import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class UploadState extends StatefulWidget {
  @override
  _UploadStateState createState() => _UploadStateState();
}

class _UploadStateState extends State<UploadState> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  Position? _location;
  String _address = 'Fetching address...';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  /// Fetch the current location
  Future<void> _getCurrentLocation() async {
    try {
      // Check permissions and request location access
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      // Fetch current location if permission is granted
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _location = position;
        });

        // Optionally, fetch address using the coordinates
        _getAddressFromCoordinates(position.latitude, position.longitude);
      } else {
        setState(() {
          _address = "Location permission denied";
        });
      }
    } catch (e) {
      setState(() {
        _address = "Failed to get location: $e";
      });
    }
  }

  /// Fetch address from latitude and longitude
  Future<void> _getAddressFromCoordinates(double latitude, double longitude) async {
    // Use a reverse geocoding service or package like 'geocoding' to get address.
    // For now, we'll just display latitude and longitude as the "address."
    setState(() {
      _address = "Latitude: $latitude, Longitude: $longitude";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Title:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Enter title'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Description:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(hintText: 'Enter description'),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              const Text(
                'Date:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(hintText: 'Enter date (e.g., YYYY-MM-DD)'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Location Information:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_location != null)
                Text(
                  'Latitude: ${_location!.latitude}, Longitude: ${_location!.longitude}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              else
                const CircularProgressIndicator(), // Show loader while fetching location
              const SizedBox(height: 8),
              const Text(
                'Address:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                _address,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle form submission logic here
                    print('Title: ${_titleController.text}');
                    print('Description: ${_descriptionController.text}');
                    print('Date: ${_dateController.text}');
                    if (_location != null) {
                      print('Latitude: ${_location!.latitude}');
                      print('Longitude: ${_location!.longitude}');
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
