import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class FoodUploadScreen extends StatefulWidget {
  const FoodUploadScreen({super.key});

  @override
  State<FoodUploadScreen> createState() => _FoodUploadScreenState();
}

class _FoodUploadScreenState extends State<FoodUploadScreen> {
  bool _isScanning = false;
  bool _isScanMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Food'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mode Toggle
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isScanMode = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _isScanMode ? AppTheme.primaryGreen : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'AI Scan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _isScanMode ? Colors.white : AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isScanMode = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: !_isScanMode ? AppTheme.primaryGreen : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Manual Input',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: !_isScanMode ? Colors.white : AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (_isScanMode) ...[
              // Camera Section
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primaryGreen, width: 2),
                  ),
                  child: _isScanning
                      ? _buildScanningAnimation()
                      : _buildCameraPlaceholder(),
                ),
              ),
            ] else ...[
              // Manual Input Form
              Expanded(child: _buildManualInputForm()),
            ],

            const SizedBox(height: 24),

            // Action Buttons
            if (_isScanMode && !_isScanning)
              ElevatedButton(
                onPressed: _startScanning,
                child: const Text('Start Scanning'),
              )
            else if (_isScanMode && _isScanning)
              ElevatedButton(
                onPressed: _stopScanning,
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.warningRed),
                child: const Text('Stop Scanning'),
              )
            else
              ElevatedButton(
                onPressed: () {},
                child: const Text('Upload Food Details'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.camera_alt,
          size: 80,
          color: AppTheme.primaryGreen.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 16),
        Text(
          'Point camera at your food',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'AI will automatically detect food type and details',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildScanningAnimation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
        ),
        const SizedBox(height: 24),
        Text(
          'Detecting food type...',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.primaryGreen,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please hold steady',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildManualInputForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Food Name
          TextField(
            decoration: const InputDecoration(
              labelText: 'Food Name',
              hintText: 'e.g., Chicken Breast',
            ),
          ),
          const SizedBox(height: 16),

          // Category Dropdown
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Category',
            ),
            items: ['Meat', 'Vegetables', 'Fruits', 'Dairy', 'Grains', 'Prepared Food']
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: (value) {},
          ),
          const SizedBox(height: 16),

          // Halal Toggle
          Row(
            children: [
              Text(
                'Halal:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(width: 16),
              Switch(
                value: true,
                onChanged: (value) {},
                activeTrackColor: AppTheme.primaryGreen,
                activeThumbColor: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Expiry Date
          TextField(
            decoration: const InputDecoration(
              labelText: 'Expiry Date',
              hintText: 'Select date',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () async {
              await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
            },
          ),
          const SizedBox(height: 16),

          // Approximate Value
          TextField(
            decoration: const InputDecoration(
              labelText: 'Approximate Value (RM)',
              hintText: 'e.g., 15.00',
              prefixText: 'RM ',
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  void _startScanning() {
    setState(() {
      _isScanning = true;
    });

    // Simulate scanning process
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
        _showDetectionResult();
      }
    });
  }

  void _stopScanning() {
    setState(() {
      _isScanning = false;
    });
  }

  void _showDetectionResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Food Detected!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detected: Chicken Breast'),
            const Text('Category: Meat'),
            const Text('Expires in: 3 days'),
            const Text('Estimated value: RM 12.00'),
            const SizedBox(height: 16),
            const Text('Would you like to edit these details?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Edit Details'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to action choice screen
            },
            child: const Text('Looks Good'),
          ),
        ],
      ),
    );
  }
}