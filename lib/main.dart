import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:varsity_app/bloc/portfolio_bloc/portfolio_bloc.dart';
import 'package:varsity_app/views/splash.dart';

import 'api/local_repo.dart';
import 'api/local_service.dart';
import 'bloc/cards_bloc/card_bloc.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _AppState();
}

class _AppState extends State<MyApp> {
  final LocalRepository _localRepository = LocalRepository(service: LocalService());

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          BlocProvider<CardsBloc>(
              create: (context) => CardsBloc(repository: _localRepository,)
                // ..add(GetAllCardsItems())
          ),
          BlocProvider<PortfolioBloc>(
              create: (context) => PortfolioBloc(repository: _localRepository,)
                ..add(GetName())
          )
          ],
        child: Sizer(builder: (context, orientation, deviceType) {
      return  Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Paper Trades',
        theme: ThemeData(
          fontFamily: 'ProximaNova',
          brightness: Brightness.dark,
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          primaryColor: Color(0xFF1E1E2C),
          useMaterial3: true,
        ),
        home: SplashScreen()
        // RootScreen(tab: 1),
      );
    });
      }));
  }
}


