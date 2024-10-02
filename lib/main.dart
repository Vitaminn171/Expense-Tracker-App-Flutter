import 'package:expenseapp/providers/expense_provider.dart';
import 'package:expenseapp/providers/revenues_provider.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:expenseapp/viewmodels/expense_viewmodel.dart';
import 'package:expenseapp/views/add_expense.dart';
import 'package:expenseapp/views/expense.dart';
import 'package:expenseapp/views/expenseDetail.dart';
import 'package:expenseapp/views/home.dart';
import 'package:expenseapp/views/login.dart';
import 'package:expenseapp/views/otp.dart';
import 'package:expenseapp/views/register.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_otp/email_otp.dart';

import 'models/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterLocalization localization = FlutterLocalization.instance;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  EmailOTP.config(
    appName: 'MyApp',
    otpType: OTPType.numeric,
    expiry: 300000,
    emailTheme: EmailTheme.v6,
  );
  final prefs = await SharedPreferences.getInstance();

  String initRoute = '/Home';

  if(prefs.getString('this_email') == null || prefs.getString('this_username') == null){
    initRoute = '/Login';
  }
  runApp(
      MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => RevenueProvider()),
        ChangeNotifierProvider(create: (context) => HomeViewModel(context.read<UserProvider>(),context.read<ExpenseProvider>(),context.read<RevenueProvider>())),
        ChangeNotifierProvider(create: (context) => ExpenseListViewModel(context.read<UserProvider>(),context.read<ExpenseProvider>())),
        ChangeNotifierProvider(create: (context) => ExpenseDetailViewModel(context.read<UserProvider>(),context.read<ExpenseProvider>())),
        ChangeNotifierProvider(create: (context) => AddExpenseViewModel(context.read<UserProvider>(),context.read<ExpenseProvider>())),
      ],
      child: Directionality(
          textDirection: TextDirection
              .ltr, // Or TextDirection.rtl for right-to-left languages
          child: MaterialApp(
            theme: ThemeData(
              bottomSheetTheme: BottomSheetThemeData(
                dragHandleColor: alternate2Color, // --> This will change the color of the drag handle
              ),
            ),
            initialRoute: initRoute,
            routes: {
              '/Login': (context) => const LoginWidget(),
              '/Register': (context) => const RegisterWidget(),
              '/Otp': (context) => const RegisterOTPWidget(),
              '/Home': (_) => const HomeWidget(),
              // '/HomeExtend': (context) => const LoginWidget(),
              // '/AddRevenue': (context) => const LoginWidget(),
              '/AddExpense': (context) => const AddExpenseWidget(),
              // '/AddSaving': (context) => const LoginWidget(),
              // '/RevenueList': (context) => const LoginWidget(),
              '/ExpenseList': (context) => const ExpenseListWidget(),
              // '/SavingList': (context) => const LoginWidget(),
              // '/RevenueDetail': (context) => const LoginWidget(),
              '/ExpenseDetail': (context) => const ExpenseDetailWidget(),
              // '/SavingDetail': (context) => const LoginWidget(),
              // '/ChangeProfile': (context) => const LoginWidget(),
              // '/ChangeColor': (context) => const LoginWidget(),
            },
            supportedLocales: [
              Locale('en'), // English
              Locale('vi'),
            ],
            localizationsDelegates: localization.localizationsDelegates,
          ))));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String name = '';

  @override
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   final prefs = await SharedPreferences.getInstance();
    //   await prefs.clear();
    // });

    super.initState();
  }

  Future<void> test() async {
    // final ref = FirebaseDatabase.instance.ref();

    final databaseRef = FirebaseDatabase.instance.ref();
    final id = await getStoredUserId();
    print(id);
    if (id != null) {
      //final id = getStoredUserId.toString();
      setState(() {
        name = id.toString();
      });
      // final snapshot = await databaseRef.child('user/$id').get();
      // if (snapshot.exists) {
      //   setState(() {
      //     name = snapshot.value.toString();
      //   });
      //   print(snapshot.value);
      // } else {
      //   print('No data available.');
      // }
    } else {
      final newRef = databaseRef.child('user').push();

      newRef.set({
        'name': 'hehe',
      });

// Get the unique key
      final uniqueId = newRef.key;
      print("Unique Key: " + uniqueId.toString());

// Use the unique ID to create expense data
      final expenseRef = databaseRef.child('expenses/$uniqueId');
      expenseRef.set({
        'amount': 100,
        'category': 'Food',
        'date': DateTime.now().toIso8601String(),
      });
      storeUserId(uniqueId!);
      setState(() {
        name = uniqueId.toString();
      });
    }
  }

  Future<void> storeUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<String?> getStoredUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? null;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController otpController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              name,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextFormField(controller: emailController),
            ElevatedButton(
              onPressed: () async {
                if (await EmailOTP.sendOTP(email: emailController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("OTP has been sent")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("OTP failed sent")));
                }
              },
              child: const Text('Send OTP'),
            ),
            TextFormField(controller: otpController),
            ElevatedButton(
              onPressed: () => EmailOTP.verifyOTP(otp: otpController.text),
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: test,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), //
    );
  }
}
