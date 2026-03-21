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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AiCycle SDK Test'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AiCycleBuyMe(
                    aiCycleConfig: AiCycleConfig(
                      generalConfig: GeneralConfig(
                        apiToken:
                            '61a688:b97cd78259f945de8672bba778cdf67ff8ce214b59104fe588ab78dffe438ec2',
                        documentId: '999',
                        environment: AiCycleEnvironment.stage,
                        organization: AiCycleOrg.partner,
                      ),
                      carInformation: CarInformation(
                        carCompanyId: 'TOYOTA',
                        carModelId: 'VIOS',
                        licensePlate: '51H80828',
                        color: '#FFFFFF',
                      ),
                    ),
                    onError: (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Init Error: $error')),
                      );
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Start New Claim Flow'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
