import 'package:aicycle_buyme_plus/aicycle_buyme_plus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AiCycle SDK Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F2738)),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  // General Config
  final _apiTokenController = TextEditingController(text: '');
  final _documentIdController = TextEditingController(text: '');
  final _documentNameController = TextEditingController(text: 'Test Claim');
  AiCycleEnvironment _environment = AiCycleEnvironment.stage;
  AiCycleOrg _organization = AiCycleOrg.partner;
  bool _loggingEnabled = true;
  bool _showResultScreen = true;

  // Car Information
  final _carCompanyIdController = TextEditingController(text: 'kia-07');
  final _carModelIdController = TextEditingController(text: 'kia.morning');
  final _mYearController = TextEditingController(text: '2022');
  final _vSpecController = TextEditingController(text: 'luxury');
  final _lPlateController = TextEditingController(text: '30E 96544');
  final _vTypeController = TextEditingController(text: 'sedan');
  final _colorController = TextEditingController(text: '#A2A8A1');

  // Validation Config
  bool _sameCarValidation = false;
  bool _missingPartValidation = false;

  // Display Config - selected angles
  final Map<AicycleCarAngle, bool> _selectedAngles = {
    for (var angle in AicycleCarAngle.values) angle: true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AiCycle SDK Settings'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('General Configuration'),
            _textField('API Token', _apiTokenController, isRequired: true),
            _textField('Document ID', _documentIdController, isRequired: true),
            _textField('Document Name', _documentNameController),
            _dropdown<AiCycleEnvironment>(
              'Environment',
              _environment,
              AiCycleEnvironment.values,
              (val) => setState(() => _environment = val!),
            ),
            _dropdown<AiCycleOrg>(
              'Organization',
              _organization,
              AiCycleOrg.values,
              (val) => setState(() => _organization = val!),
              isRequired: true,
            ),
            _switchTile(
              'Enable Logging',
              _loggingEnabled,
              (val) => setState(() => _loggingEnabled = val),
            ),
            _switchTile(
              'Show Result Screen',
              _showResultScreen,
              (val) => setState(() => _showResultScreen = val),
            ),

            const Divider(height: 32),
            _sectionTitle('Car Information'),
            _textField('Car Company ID', _carCompanyIdController),
            _textField('Car Model ID', _carModelIdController),
            _textField('Manufacturing Year', _mYearController, isNumber: true),
            _textField('Vehicle Spec', _vSpecController),
            _textField('License Plate', _lPlateController),
            _textField('Vehicle Type', _vTypeController),
            _textField('Color (Hex, e.g., #FFFFFF)', _colorController),

            const Divider(height: 32),
            _sectionTitle('Validation Configuration'),
            _switchTile(
              'Same Car Validation',
              _sameCarValidation,
              (val) => setState(() => _sameCarValidation = val),
            ),
            _switchTile(
              'Missing Part Validation',
              _missingPartValidation,
              (val) => setState(() => _missingPartValidation = val),
            ),

            const Divider(height: 32),
            _sectionTitle('Display Configuration - Car Angles'),
            Wrap(
              spacing: 8,
              children: AicycleCarAngle.values.map((angle) {
                return FilterChip(
                  label: Text(_getAngleName(angle)),
                  selected: _selectedAngles[angle] ?? false,
                  onSelected: (selected) {
                    setState(() {
                      _selectedAngles[angle] = selected;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _startSdk,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF1F2738),
                foregroundColor: Colors.white,
              ),
              child: const Text('START AI INSPECTION'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          label: isRequired ? _richLabel(label) : Text(label),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _dropdown<T>(
    String label,
    T value,
    List<T> items,
    ValueChanged<T?> onChanged, {
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        decoration: InputDecoration(
          label: isRequired ? _richLabel(label) : Text(label),
          border: const OutlineInputBorder(),
        ),
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(item.toString().split('.').last),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _richLabel(String label) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(color: Colors.black54, fontSize: 16),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _switchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }

  String _getAngleName(AicycleCarAngle angle) {
    switch (angle) {
      case AicycleCarAngle.front:
        return 'Trước';
      case AicycleCarAngle.frontLeft:
        return 'Trước trái';
      case AicycleCarAngle.frontRight:
        return 'Trước phải';
      case AicycleCarAngle.rear:
        return 'Sau';
      case AicycleCarAngle.rearLeft:
        return 'Sau trái';
      case AicycleCarAngle.rearRight:
        return 'Sau phải';
      case AicycleCarAngle.left:
        return 'Sườn trái';
      case AicycleCarAngle.right:
        return 'Sườn phải';
      case AicycleCarAngle.regStamp:
        return 'Tem đăng kiểm';
      case AicycleCarAngle.vinNumber:
        return 'Số khung';
      case AicycleCarAngle.taplo:
        return 'Taplo';
      case AicycleCarAngle.regCert:
        return 'Đăng kiểm';
      case AicycleCarAngle.exterior:
        return 'Ngoại thất';
    }
  }

  void _startSdk() {
    if (_apiTokenController.text.isEmpty ||
        _documentIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final Map<AicycleCarAngle, String> carAnglesWithDisplayName = {};
    _selectedAngles.forEach((angle, isSelected) {
      if (isSelected) {
        carAnglesWithDisplayName[angle] = _getAngleName(angle);
      }
    });

    final config = AiCycleConfig(
      generalConfig: GeneralConfig(
        apiToken: _apiTokenController.text,
        documentId: _documentIdController.text,
        documentName: _documentNameController.text,
        environment: _environment,
        organization: _organization,
        loggingEnabled: _loggingEnabled,
        showResultScreen: _showResultScreen,
      ),
      carInformation: CarInformation(
        carCompanyId: _carCompanyIdController.text,
        carModelId: _carModelIdController.text,
        manufacturingYear: int.tryParse(_mYearController.text),
        vehicleSpec: _vSpecController.text,
        licensePlate: _lPlateController.text,
        vehicleType: _vTypeController.text,
        color: _colorController.text,
      ),
      validationConfig: ValidationConfig(
        sameCarValidation: _sameCarValidation,
        missingPartValidation: _missingPartValidation,
      ),
      displayConfig: DisplayConfig(
        carAnglesWithDisplayName: carAnglesWithDisplayName,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AiCycleBuyMe(
          aiCycleConfig: config,
          onComplete: (data) {
            Navigator.popUntil(context, (route) => route.isFirst);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Inspection completed')),
            );
          },
          onError: (error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('SDK Error: $error')));
          },
        ),
      ),
    );
  }
}
