import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'TelaHomeAdmin.dart';
import 'TelaHomeCliente.dart';
import 'utils/init_database.dart';

void main() async {
  // Garante que o Flutter esteja inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🚀 Iniciando app...');
  
  try {
    // PASSO 1: Inicializa o Firebase com as opções da plataforma
    print('🔄 Inicializando Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase inicializado com sucesso');
    
  } catch (e, stackTrace) {
    print('❌ ERRO ao inicializar Firebase: $e');
    print('Stack: $stackTrace');
  }
  
  print('🎨 Iniciando interface...');
  // PASSO 2: Inicia o app imediatamente
  runApp(const MyApp());
  print('✅ App iniciado');
  
  // PASSO 3: Popular dados em background
  InitDatabase.popularDadosIniciais().catchError((e) {
    print('❌ Erro ao popular dados: $e');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController user = TextEditingController();
  TextEditingController password = TextEditingController();

  String correctUser = 'admin';
  String correctPassword = 'admin';

  String correctCliente = 'cliente';
  String correctPasswordCliente = 'cliente';
  String mensage = "";

  void login() {
    if (user.text == correctUser && password.text == correctPassword) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TelaHomeAdmin()),
      );
    } else if (user.text == correctCliente &&
        password.text == correctPasswordCliente) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TelaHomeCliente()),
      );
    } else {
      setState(() {
        mensage = "Credenciais incorretas. Tente novamente";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Image.asset(
                'assets/images/logo.png',
                width: MediaQuery.of(context).size.width * 0.4,
              ),
              SizedBox(height: 40),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 163, 163, 163)
                          .withOpacity(0.3),
                      spreadRadius: 0.2,
                      blurRadius: 20,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Seja Bem-Vindo!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: user,
                      maxLength: 30,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 116, 2, 78),
                          ),
                        ),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.account_circle,
                              color: Colors.pinkAccent,
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Digite seu usuário",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      maxLength: 30,
                      obscureText: true,
                      controller: password,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 230, 71, 195),
                          ),
                        ),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.password, color: Colors.pinkAccent),
                            SizedBox(width: 15),
                            Text(
                              "Digite a Senha",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 194, 17, 146),
                              Color.fromARGB(255, 235, 144, 238),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Entrar",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text("$mensage", style: TextStyle(color: Colors.redAccent)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}