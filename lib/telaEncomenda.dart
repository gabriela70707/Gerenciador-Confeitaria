import 'package:flutter/material.dart';

class TelaEncomendas extends StatefulWidget {
  const TelaEncomendas({super.key});

  @override
  State<TelaEncomendas> createState() => _TelaEncomendasState();
}

class _TelaEncomendasState extends State<TelaEncomendas> {
  String selectedTab = "Pendentes";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE91E63), Color(0xFFFF9800)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Agenda de Encomendas",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "4 pedidos pendentes",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Tabs
                  Row(
                    children: [
                      _buildTab("Todas"),
                      SizedBox(width: 8),
                      _buildTab("Pendentes"),
                      SizedBox(width: 8),
                      _buildTab("Concluídas"),
                    ],
                  ),
                ],
              ),
            ),

            // Lista de encomendas
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildEncomendaCard(
                    "Bolo de Chocolate",
                    "Maria Silva",
                    "(11) 98765-4321",
                    "17/11/2025",
                    "14:00",
                    "R\$ 45.00",
                  ),
                  SizedBox(height: 12),
                  _buildEncomendaCard(
                    "Torta de Morango",
                    "João Santos",
                    "(11) 91234-5678",
                    "17/11/2025",
                    "16:00",
                    "R\$ 55.00",
                  ),
                  SizedBox(height: 12),
                  _buildEncomendaCard(
                    "Cupcakes (24un)",
                    "Ana Costa",
                    "(11) 99876-5432",
                    "18/11/2025",
                    "10:00",
                    "R\$ 192.00",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title) {
    bool isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Color(0xFFE91E63) : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildEncomendaCard(
    String produto,
    String cliente,
    String telefone,
    String data,
    String hora,
    String valor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  produto,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFFF9800),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.schedule, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      "Pendente",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.person_outline, size: 18, color: Color(0xFFE91E63)),
              SizedBox(width: 8),
              Text(
                cliente,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.phone_outlined, size: 18, color: Color(0xFFE91E63)),
              SizedBox(width: 8),
              Text(
                telefone,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFFFF0F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Color(0xFFE91E63)),
                SizedBox(width: 8),
                Text(
                  data,
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
                SizedBox(width: 20),
                Icon(Icons.access_time, size: 16, color: Color(0xFFE91E63)),
                SizedBox(width: 8),
                Text(
                  hora,
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Valor: $valor",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: Text(
                  "Marcar como Concluído",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
