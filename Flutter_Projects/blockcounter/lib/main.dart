import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class CounterEvent {}
class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}

abstract class ThemeEvent {}
class ToggleTheme extends ThemeEvent {}

// Bloc for Counter
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
    on<Decrement>((event, emit) => emit(state - 1));
  }
}

// Bloc for Theme
class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  ThemeBloc()
      : super(ThemeData.light()) {
    on<ToggleTheme>((event, emit) {
      emit(state == ThemeData.light() ? ThemeData.dark() : ThemeData.light());
    });
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CounterBloc()),
        BlocProvider(create: (context) => ThemeBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeData>(
        builder: (context, theme) {
          return MaterialApp(
            theme: theme,
            home: CounterScreen(),
          );
        },
      ),
    );
  }
}

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bloc Counter & Theme")),
      body: BlocConsumer<CounterBloc, int>(
        listener: (context, count) {
          if (count == 5) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Counter reached 5!")),
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
                      onPressed: () => context.read<CounterBloc>().add(Increment()),
                      child: Icon(Icons.add),
                    ),
                    SizedBox(width: 20),
                    FloatingActionButton(
                      onPressed: () => context.read<CounterBloc>().add(Decrement()),
                      child: Icon(Icons.remove),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => context.read<ThemeBloc>().add(ToggleTheme()),
                  child: Text("Toggle Theme"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
