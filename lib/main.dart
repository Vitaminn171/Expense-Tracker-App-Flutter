import 'package:expenseapp/providers/expense_provider.dart';
import 'package:expenseapp/providers/revenues_provider.dart';
import 'package:expenseapp/providers/user_provider.dart';
import 'package:expenseapp/viewmodels/revenueDetail_viewmodel.dart';
import 'package:expenseapp/viewmodels/revenue_viewmodel.dart';
import 'package:expenseapp/viewmodels/setting_viewmodel.dart';
import 'package:expenseapp/views/add_expense.dart';
import 'package:expenseapp/views/add_revenue.dart';
import 'package:expenseapp/views/edit_profile.dart';
import 'package:expenseapp/views/expense.dart';
import 'package:expenseapp/views/expenseDetail.dart';
import 'package:expenseapp/views/home.dart';
import 'package:expenseapp/views/login.dart';
import 'package:expenseapp/views/otp.dart';
import 'package:expenseapp/views/register.dart';
import 'package:expenseapp/views/revenue.dart';
import 'package:expenseapp/views/revenueDetail.dart';
import 'package:expenseapp/views/setting.dart';
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
    appName: 'Ứng dụng chi tiêu',
    otpType: OTPType.numeric,
    expiry: 300000,
    emailTheme: EmailTheme.v6,
  );
  final prefs = await SharedPreferences.getInstance();

  String initRoute = '/Home';
  Widget home = HomeWidget();

  if(prefs.getString('this_email') == null || prefs.getString('this_username') == null){
    initRoute = '/Login';
    home = LoginWidget();
  }
  //TODO: check internet connection for entire app
  //https://pub.dev/packages/internet_connection_checker_plus

  final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);


  runApp(
      MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => RevenueProvider()),

        ChangeNotifierProvider(create: (context) => HomeViewModel(context.read<UserProvider>(),context.read<ExpenseProvider>(),context.read<RevenueProvider>())),
        ChangeNotifierProvider(create: (context) => SettingViewModel(context.read<UserProvider>())),
        ChangeNotifierProvider(create: (context) => EditProfileViewModel(context.read<UserProvider>())),

        ChangeNotifierProvider(create: (context) => ExpenseListViewModel(context.read<UserProvider>(),context.read<ExpenseProvider>())),
        ChangeNotifierProvider(create: (context) => ExpenseDetailViewModel(context.read<UserProvider>(),context.read<ExpenseProvider>())),
        ChangeNotifierProvider(create: (context) => AddExpenseViewModel(context.read<UserProvider>(),context.read<ExpenseProvider>())),

        ChangeNotifierProvider(create: (context) => RevenueListViewModel(context.read<UserProvider>(),context.read<RevenueProvider>())),
        ChangeNotifierProvider(create: (context) => RevenueDetailViewModel(context.read<UserProvider>(),context.read<RevenueProvider>())),
        ChangeNotifierProvider(create: (context) => AddRevenueViewModel(context.read<UserProvider>(),context.read<RevenueProvider>())),
      ],
      child: Directionality(
          textDirection: TextDirection
              .ltr, // Or TextDirection.rtl for right-to-left languages
          child: MaterialApp(
            theme: ThemeData(
              bottomSheetTheme: const BottomSheetThemeData(
                dragHandleColor: alternate2Color, // --> This will change the color of the drag handle
              ),
            ),
            //initialRoute: initRoute,
            home: home,
            // onGenerateRoute: (RouteSettings settings) {
            //   print('========================> Current route: ${settings.name}');
            //   switch (settings.name) {
            //     case '/Login':
            //       return PageRouteBuilder(
            //         pageBuilder: (context, animation, secondaryAnimation) => const LoginWidget(),
            //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
            //           final offsetAnimation = animation.drive(tween);
            //           return SlideTransition(
            //             position: offsetAnimation,
            //             child: child,
            //           );
            //         },
            //       );
            //     case '/Register':
            //       return PageRouteBuilder(
            //         pageBuilder: (context, animation, secondaryAnimation) => const RegisterWidget(),
            //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
            //           final offsetAnimation = animation.drive(tween);
            //           return SlideTransition(
            //             position: offsetAnimation,
            //             child: child,
            //           );
            //         },
            //       );
            //     case '/Otp':
            //       return PageRouteBuilder(
            //         pageBuilder: (context, animation, secondaryAnimation) => const RegisterOTPWidget(),
            //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
            //           final offsetAnimation = animation.drive(tween);
            //           return SlideTransition(
            //             position: offsetAnimation,
            //             child: child,
            //           );
            //         },
            //       );
            //     case '/Home':
            //       return PageRouteBuilder(
            //         pageBuilder: (context, animation, secondaryAnimation) => const HomeWidget(),
            //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
            //           final offsetAnimation = animation.drive(tween);
            //           return SlideTransition(
            //             position: offsetAnimation,
            //             child: child,
            //           );
            //         },
            //       );
            //     case '/AddRevenue':
            //       return PageRouteBuilder(
            //         pageBuilder: (context, animation, secondaryAnimation) => const AddRevenueWidget(),
            //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
            //           final offsetAnimation = animation.drive(tween);
            //           return SlideTransition(
            //             position: offsetAnimation,
            //             child: child,
            //           );
            //         },
            //       );
            //     case '/AddExpense':
            //       return PageRouteBuilder(
            //         pageBuilder: (context, animation, secondaryAnimation) => const AddExpenseWidget(),
            //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
            //           final offsetAnimation = animation.drive(tween);
            //           return SlideTransition(
            //             position: offsetAnimation,
            //             child: child,
            //           );
            //         },
            //       );
            //     case '/RevenueList':
            //       return PageRouteBuilder(
            //         pageBuilder: (context, animation, secondaryAnimation) => const RevenueListWidget(),
            //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
            //           final offsetAnimation = animation.drive(tween);
            //           return SlideTransition(
            //             position: offsetAnimation,
            //             child: child,
            //           );
            //         },
            //       );
            //     case '/ExpenseList':
            //       return PageRouteBuilder(
            //         pageBuilder: (context, animation, secondaryAnimation) => const ExpenseListWidget(),
            //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
            //           final offsetAnimation = animation.drive(tween);
            //           return SlideTransition(
            //             position: offsetAnimation,
            //             child: child,
            //           );
            //         },
            //       );
            //     case '/RevenueDetail':
            //       return PageRouteBuilder(
            //         pageBuilder: (context, animation, secondaryAnimation) => const RevenueDetailWidget(),
            //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
            //           final offsetAnimation = animation.drive(tween);
            //           return SlideTransition(
            //             position: offsetAnimation,
            //             child: child,
            //           );
            //         },
            //       );
            //     case '/ExpenseDetail':
            //       return PageRouteBuilder(
            //         pageBuilder: (context, animation, secondaryAnimation) => const ExpenseDetailWidget(),
            //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
            //           final offsetAnimation = animation.drive(tween);
            //           return SlideTransition(
            //             position: offsetAnimation,
            //             child: child,
            //           );
            //         },
            //       );
            //     case '/Setting':
            //       return PageRouteBuilder(
            //         pageBuilder: (context, animation, secondaryAnimation) => const SettingWidget(),
            //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
            //           final offsetAnimation = animation.drive(tween);
            //           return SlideTransition(
            //             position: offsetAnimation,
            //             child: child,
            //           );
            //         },
            //       );
            //     default:
            //       throw Exception('Invalid route: ${settings.name}');
            //   }
            // },

            routes: {
              '/Login': (_) => const LoginWidget(),
              '/Register': (_) => const RegisterWidget(),
              '/Otp': (_) => const RegisterOTPWidget(),
              '/Home': (_) => const HomeWidget(),
              //'/HomePage': (_) => HomePageWidget(),
              // '/HomeExtend': (context) => const LoginWidget(),
              '/AddRevenue': (_) => const AddRevenueWidget(),
              '/AddExpense': (_) => const AddExpenseWidget(),
              // '/AddSaving': (context) => const LoginWidget(),
              '/RevenueList': (_) => const RevenueListWidget(),
              '/ExpenseList': (_) => const ExpenseListWidget(),
              // '/ExpenseList': (_) =>
              // MaterialPageRoute(
              //   builder: (context) => ExpenseListWidget(),
              //   pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
              //     opacity: animation,
              //     child: ExpenseListWidget(),
              //   ),
              // ),
              // '/SavingList': (context) => const LoginWidget(),
              '/RevenueDetail': (_) => const RevenueDetailWidget(),
              '/ExpenseDetail': (_) => const ExpenseDetailWidget(),
              // '/SavingDetail': (context) => const LoginWidget(),
              '/Setting': (_) => const SettingWidget(),
              '/EditProfile': (_) => const EditProfileWidget(),
              // '/ChangeColor': (context) => const LoginWidget(),
            },
            supportedLocales: const [
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
