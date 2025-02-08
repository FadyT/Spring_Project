import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Counter Cubit
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterCubit(),
      child: MaterialApp(
        theme: ThemeData.light(),
        home: CounterScreen(),
      ),
    );
  }
}

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cubit Counter")),
      body: BlocConsumer<CounterCubit, int>(
        listener: (context, count) {
          if (count == 10 || count == -10) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Counter reached $count!")),
            );
          }
          if (count < 0) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Warning"),
                content: Text("Counter is negative!"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("OK"),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, count) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Counter: $count", style: TextStyle(fontSize: 24)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: () => context.read<CounterCubit>().increment(),
                      child: Icon(Icons.add),
                    ),
                    SizedBox(width: 20),
                    FloatingActionButton(
                      onPressed: () => context.read<CounterCubit>().decrement(),
                      child: Icon(Icons.remove),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
