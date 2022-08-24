import 'package:flutter/material.dart';
import 'package:internet_connection_check/services/connectivity_service.dart';
import 'package:provider/provider.dart';

import 'app/locator.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize locator
  setupLocator();

  // Initialize connectivity Service
  locator.get<ConnectivityService>().initialise();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<ConnectivityStatus>(
          create: (_) => locator
              .get<ConnectivityService>()
              .connectivityStatusController
              .stream,
          initialData: ConnectivityStatus.connected,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Internet Checker',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityStatus>(
      builder: (context, connectivityStatus, _) {
        return Scaffold(
          backgroundColor: connectivityStatus == ConnectivityStatus.disconnected
              ?  Colors.red
              :  Colors.green,
          appBar: AppBar(
            title: const Text('Internet Checker', ),
            centerTitle: true,
          ),
          body: Center(
            child: connectivityStatus == ConnectivityStatus.disconnected
                ? const Text('No internet Connection',style: TextStyle(color: Colors.white, fontSize: 20),)
                : const Text('Connected',style: TextStyle(color: Colors.white, fontSize: 20),),
          ),
        );
      },
    );
  }
}
