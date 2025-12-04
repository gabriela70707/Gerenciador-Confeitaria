import 'package:flutter/material.dart';
import 'TelaHomeAdmin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // chama a pagina de login
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // variveis que observa o que o usuario escreve
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
              SizedBox(height: 120),
              Image.asset(
                'assets/images/logo.png',
                width: MediaQuery.of(context).size.width * 0.4,
              ),

              SizedBox(height: 40),

              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    255,
                    255,
                    255,
                  ), // cor de fundo
                  borderRadius: BorderRadius.circular(20), // borda arredondada
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        163,
                        163,
                        163,
                      ).withOpacity(0.3), // cor da sombra
                      spreadRadius: 0.2, // quanto a sombra se espalha
                      blurRadius: 20, // intensidade do desfoque
                      offset: Offset(4, 4), // posição da sombra (x, y)
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
                      //input
                      controller: user,
                      maxLength:
                          30, // numero maximo de caracteres que o campo aceita
                      //controller: user, // qual variavel que armazena o valor digitado
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ), //arredondar a borda
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 116, 2, 78),
                          ),
                        ),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.password, color: Colors.pinkAccent),
                            SizedBox(width: 8),
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
                      //input
                      maxLength:
                          30, // numero maximo de caracteres que o campo aceita
                      //controller: user, // qual variavel que armazena o valor digitado
                      obscureText: true,
                      controller: password,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ), //arredondar a borda
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 155, 4, 122),
                          ),
                        ),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.account_circle,
                              color: Colors.pinkAccent,
                            ),
                            SizedBox(width: 8),
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
                              const Color.fromARGB(255, 109, 163, 235),
                              const Color.fromARGB(255, 245, 133, 207),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // arredonda borda
                        ),
                        child: ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.transparent, // fundo transparente
                            shadowColor:
                                Colors.transparent, // remove sombra padrão
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ), // acompanha o container
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
                    SizedBox(
                      height: 30,
                    ), // Distancia entre o botao e a mensagem de erro
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
