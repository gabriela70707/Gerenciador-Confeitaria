import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/encomenda_model.dart';
import 'services/firebase_service.dart';

class TelaEncomendas extends StatefulWidget {
  const TelaEncomendas({super.key});

  @override
  State<TelaEncomendas> createState() => _TelaEncomendasState();
}

class _TelaEncomendasState extends State<TelaEncomendas> {
  String selectedTab = "Pendentes";
  final FirebaseService _firebaseService = FirebaseService();

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
                            StreamBuilder<QuerySnapshot>(
                              stream: _firebaseService.buscarEncomendarPorStatus('pendente'),
                              builder: (context, snapshot) {
                                int count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                                return Text(
                                  "$count pedidos pendentes",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                );
                              },
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

            // Lista de encomendas com StreamBuilder
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getStreamPorTab(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Erro ao carregar encomendas: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            'Nenhuma encomenda encontrada',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final encomendas = snapshot.data!.docs.map((doc) {
                    return EncomendaModel.fromFirestore(doc);
                  }).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: encomendas.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          _buildEncomendaCard(encomendas[index]),
                          SizedBox(height: 12),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getStreamPorTab() {
    if (selectedTab == "Pendentes") {
      return _firebaseService.buscarEncomendarPorStatus('pendente');
    } else if (selectedTab == "Concluídas") {
      return _firebaseService.buscarEncomendarPorStatus('concluido');
    } else {
      return _firebaseService.buscarEncomendas();
    }
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

  Widget _buildEncomendaCard(EncomendaModel encomenda) {
    bool isConcluida = encomenda.status == 'concluido';
    
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
                  encomenda.produto,
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
                  color: isConcluida ? Color(0xFF4CAF50) : Color(0xFFFF9800),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isConcluida ? Icons.check_circle : Icons.schedule,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      isConcluida ? "Concluída" : "Pendente",
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
                encomenda.cliente,
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
                encomenda.telefone,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
          if (encomenda.observacoes != null && encomenda.observacoes!.isNotEmpty) ...[
            SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.note_outlined, size: 18, color: Color(0xFFE91E63)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    encomenda.observacoes!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ],
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
                  encomenda.dataRetirada,
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
                SizedBox(width: 20),
                Icon(Icons.access_time, size: 16, color: Color(0xFFE91E63)),
                SizedBox(width: 8),
                Text(
                  encomenda.horaRetirada,
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
                "Valor: R\$ ${encomenda.valor.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Row(
                children: [
                  if (!isConcluida)
                    ElevatedButton(
                      onPressed: () async {
                        await _concluirEncomenda(encomenda.id!);
                      },
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
                        "Concluir",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      _confirmarDelecao(encomenda.id!);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _concluirEncomenda(String id) async {
    try {
      await _firebaseService.concluirEncomenda(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Encomenda concluída com sucesso!"),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao concluir encomenda: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmarDelecao(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar Exclusão"),
        content: Text("Deseja realmente excluir esta encomenda?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deletarEncomenda(id);
            },
            child: Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deletarEncomenda(String id) async {
    try {
      await _firebaseService.deletarEncomenda(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Encomenda excluída com sucesso!"),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao excluir encomenda: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}