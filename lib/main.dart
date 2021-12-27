import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_cubit/service/crud_cubit.dart';
import 'package:flutter_bloc_cubit/service/login_cubit.dart';
import 'package:flutter_bloc_cubit/service/main_cubit.dart';
import 'package:flutter_bloc_cubit/view/add_page.dart';
import 'package:flutter_bloc_cubit/view/home_page.dart';
import 'package:flutter_bloc_cubit/view/login_page.dart';
import 'package:flutter_bloc_cubit/view/transactions_page.dart';
import 'package:flutter_bloc_cubit/widgets/bottom_nav_bar.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CubitMain()),
        BlocProvider(create: (context) => AccountViewCubit()),
        BlocProvider(create: (context) => AddColorCheckCubit()),
        BlocProvider(create: (context) => CRUDCubit()),
        BlocProvider(create: (context) => GoogleSignInCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<CRUDCubit>().sumData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blueGrey.shade900,
      bottomNavigationBar: BottomNavBar(),
      body: SingleChildScrollView(
        child: BlocBuilder<CubitMain, int>(
          builder: (context, pageIndex) {
            return (pageIndex == 0)
                ? HomePage()
                : (pageIndex == 1)
                    ? AddPage()
                    : (pageIndex == 2)
                        ? TransactionsPage()
                        : HomePage();
          },
        ),
      ),
    );
  }
}
