import 'package:data_bloc_app/bloc/data_bloc.dart';
import 'package:data_bloc_app/bloc/data_state.dart';
import 'package:data_bloc_app/repo/data_repo.dart';
import 'package:data_bloc_app/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //repository provider over bloc provider
      home: RepositoryProvider(
        create: (context) => DataRepository(),
        child: const Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    // repository provider -> bloc provider -> bloc listener (snackbar)
    // ->bloc builder(show 3 states)
    //1) loading(circle loader)
    //2) error
    //at end home screen will be builded
    return BlocProvider(
      //to initialise data bloc we need to give it the repo reference
      create: (context) => DataBloc(
        dataRepository: RepositoryProvider.of<DataRepository>(context),
      ),
      child: Scaffold(
        key: scaffoldKey,
        body: BlocListener<DataBloc, DataState>(
          listener: (context, state) {
            //if data added successfully show snackbar
            if (state is DataAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Data Added"),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          },
          child: BlocBuilder<DataBloc, DataState>(
            builder: (context, state) {
              //if data being added show loading
              if (state is DataAdding) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
                //if error show error
              } else if (state is ErrorState) {
                return const Center(
                  child: Text("Error"),
                );
              }
              //at the end home screen will be builded
              return const HomeScreen();
            },
          ),
        ),
      ),
    );
  }
}
