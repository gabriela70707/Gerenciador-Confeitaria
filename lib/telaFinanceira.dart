import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'models/transacao_model.dart';
import 'services/firebase_service.dart';

class TelaFinanceira extends StatefulWidget {
  const TelaFinanceira({super.key});

  @override
  State<TelaFinanceira> createState() => _TelaFinanceiraState();
}

class _TelaFinanceiraState extends State<TelaFinanceira> {
  String selectedTab = "Vendas";
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
                  colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
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
                              "Gestão Financeira",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Controle completo de finanças",
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
                ],
              ),
            ),

            // Card de lucro do mês
            StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.buscarTransacoes(),
              builder: (context, snapshot) {
                double vendas = 0.0;
                double gastos = 0.0;

                if (snapshot.hasData) {
                  final transacoes = snapshot.data!.docs
                      .map((doc) => TransacaoModel.fromFirestore(doc))
                      .toList();

                  // Filtrar transações do mês atual
                  final agora = DateTime.now();
                  final transacoesMes = transacoes.where((t) {
                    return t.data.month == agora.month && t.data.year == agora.year;
                  }).toList();

                  vendas = transacoesMes
                      .where((t) => t.tipo == 'venda')
                      .fold(0.0, (sum, t) => sum + t.valor);

                  gastos = transacoesMes
                      .where((t) => t.tipo == 'gasto')
                      .fold(0.0, (sum, t) => sum + t.valor);
                }

                double lucro = vendas - gastos;

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF4CAF50).withOpacity(0.3),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lucro do Mês",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "R\$ ${lucro.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.trending_up,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Cards de vendas e gastos
            StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.buscarTransacoes(),
              builder: (context, snapshot) {
                double vendas = 0.0;
                double gastos = 0.0;

                if (snapshot.hasData) {
                  final transacoes = snapshot.data!.docs
                      .map((doc) => TransacaoModel.fromFirestore(doc))
                      .toList();

                  final agora = DateTime.now();
                  final transacoesMes = transacoes.where((t) {
                    return t.data.month == agora.month && t.data.year == agora.year;
                  }).toList();

                  vendas = transacoesMes
                      .where((t) => t.tipo == 'venda')
                      .fold(0.0, (sum, t) => sum + t.valor);

                  gastos = transacoesMes
                      .where((t) => t.tipo == 'gasto')
                      .fold(0.0, (sum, t) => sum + t.valor);
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
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
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    color: Color(0xFF4CAF50),
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Vendas",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                "R\$ ${vendas.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Container(
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
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.trending_down,
                                    color: Color(0xFFEF5350),
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Gastos",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                "R\$ ${gastos.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Tabs
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(child: _buildTabButton("Vendas")),
                  SizedBox(width: 8),
                  Expanded(child: _buildTabButton("Gastos")),
                ],
              ),
            ),

            // Lista de transações
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedTab == "Vendas" ? "Últimas Vendas" : "Últimos Gastos",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _mostrarFormularioTransacao(context),
                          icon: Icon(Icons.add, size: 18),
                          label: Text(selectedTab == "Vendas" ? "Nova Venda" : "Novo Gasto"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firebaseService.buscarTransacoesPorTipo(
                        selectedTab == "Vendas" ? "venda" : "gasto",
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Erro ao carregar transações'));
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.receipt_long,
                                    size: 80, color: Colors.grey[400]),
                                SizedBox(height: 16),
                                Text(
                                  'Nenhuma transação encontrada',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final transacoes = snapshot.data!.docs
                            .map((doc) => TransacaoModel.fromFirestore(doc))
                            .toList();

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: transacoes.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                _buildTransacaoCard(transacoes[index]),
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
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title) {
    bool isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF4CAF50) : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransacaoCard(TransacaoModel transacao) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    bool isVenda = transacao.tipo == 'venda';

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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transacao.descricao,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  dateFormat.format(transacao.data),
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isVenda ? Color(0xFF4CAF50) : Color(0xFFEF5350),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${isVenda ? '+' : '-'} R\$ ${transacao.valor.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _confirmarDelecao(transacao.id!),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _mostrarFormularioTransacao(BuildContext context) {
    final descricaoController = TextEditingController();
    final valorController = TextEditingController();
    String tipoSelecionado = selectedTab == "Vendas" ? "venda" : "gasto";
    DateTime dataSelecionada = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            "Nova Transação",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Formulário
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Tipo"),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: tipoSelecionado,
                                  items: [
                                    DropdownMenuItem(value: "venda", child: Text("Venda")),
                                    DropdownMenuItem(value: "gasto", child: Text("Gasto")),
                                  ],
                                  onChanged: (String? newValue) {
                                    setModalState(() {
                                      tipoSelecionado = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            _buildLabel("Descrição"),
                            TextField(
                              controller: descricaoController,
                              decoration: _buildInputDecoration(
                                  "Ex: Bolo de Chocolate / Compra de farinha"),
                            ),
                            SizedBox(height: 20),
                            _buildLabel("Valor (R\$)"),
                            TextField(
                              controller: valorController,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              decoration: _buildInputDecoration("0.00"),
                            ),
                            SizedBox(height: 20),
                            _buildLabel("Data"),
                            GestureDetector(
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: dataSelecionada,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setModalState(() {
                                    dataSelecionada = picked;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today, color: Color(0xFF4CAF50)),
                                    SizedBox(width: 12),
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(dataSelecionada),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Botão criar
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (descricaoController.text.isEmpty) {
                              _mostrarSnackBar(context, "Digite a descrição", Colors.red);
                              return;
                            }

                            try {
                              TransacaoModel novaTransacao = TransacaoModel(
                                tipo: tipoSelecionado,
                                descricao: descricaoController.text,
                                valor: double.tryParse(valorController.text) ?? 0,
                                data: dataSelecionada,
                              );

                              await _firebaseService.criarTransacao(novaTransacao.toMap());

                              Navigator.pop(context);
                              _mostrarSnackBar(context, "Transação criada com sucesso!",
                                  Color(0xFF4CAF50));
                            } catch (e) {
                              _mostrarSnackBar(context, "Erro: $e", Colors.red);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4CAF50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Criar Transação",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmarDelecao(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar Exclusão"),
        content: Text("Deseja realmente excluir esta transação?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _firebaseService.deletarTransacao(id);
                Navigator.pop(context);
                _mostrarSnackBar(context, "Transação excluída!", Color(0xFF4CAF50));
              } catch (e) {
                _mostrarSnackBar(context, "Erro: $e", Colors.red);
              }
            },
            child: Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4CAF50),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFF4CAF50)),
      ),
    );
  }

  void _mostrarSnackBar(BuildContext context, String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: cor),
    );
  }
}