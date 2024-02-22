import 'package:aicycle_buyme_lib/aicycle.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AICycle.initial();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController externalClaimIdController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    externalClaimIdController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: externalClaimIdController,
                  decoration: InputDecoration(
                    hintText: 'Enter your externalClaimId',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (externalClaimIdController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter your externalClaimId"),
                        ),
                      );
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => AiCycleBuyMe(
                          onViewResultCallBack: (imagesResult) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("return result"),
                              ),
                            );
                          },
                          argument: AiCycleBuyMeArgument(
                            externalClaimId: externalClaimIdController.text,
                            apiToken: '',
                            locale: const Locale('en', 'US'),
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "GO",
                    style: TextStyle(fontSize: 14, color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // body: FolderDetailPage(),
      // body: SafeArea(
      //   child: AiCycleBuyMe(
      //     onViewResultCallBack: (imagesResult) {
      //       print(imagesResult);
      //     },
      //     argument: AiCycleBuyMeArgument(
      //       externalClaimId: '101',
      //       apiToken: '7adbbf78-a400-4953-9dbc-35abd1699dc3',
      //     ),
      //   ),
      // ),
    );
  }
}
