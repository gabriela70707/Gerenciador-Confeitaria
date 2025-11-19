import 'package:flutter/material.dart';

class Telahomeadmin extends StatefulWidget {
  const Telahomeadmin({super.key});

  @override
  State<Telahomeadmin> createState() => _TelahomeadminState();
}

class _TelahomeadminState extends State<Telahomeadmin> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Column(
                            children: [
                              Text(
                                "Gestão",
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                "Painel administrativo",
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.exit_to_app),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
