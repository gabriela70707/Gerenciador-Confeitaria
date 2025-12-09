import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'models/fiado_model.dart';
import 'services/firebase_service.dart';

class TelaFiado extends StatefulWidget {
  const TelaFiado({super.key});

  @override
  State<TelaFiado> createState() => _TelaFiadoState();
}

class _TelaFiadoState extends State<TelaFiado> {
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
                  colors: [Color(0xFFAB47BC), Color(0xFFE91E63)],
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
                              "Controle de Fiado",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            StreamBuilder<QuerySnapshot>(
                              stream: _firebaseService.buscarFiados(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text(
                                    "Total pendente: R\$ 0.00",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  );
                                }

                                double total = snapshot.data!.docs
                                    .map((doc) => FiadoModel.fromFirestore(doc))
                                    .fold(0.0, (sum, fiado) => sum + fiado.valorTotal);

                                return Text(
                                  "Total pendente: R\$ ${total.toStringAsFixed(2)}",
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
                ],
              ),
            ),

            // Total a receber
            StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.buscarFiados(),
              builder: (context, snapshot) {
                double total = 0.0;
                if (snapshot.hasData) {
                  total = snapshot.data!.docs
                      .map((doc) => FiadoModel.fromFirestore(doc))
                      .fold(0.0, (sum, fiado) => sum + fiado.valorTotal);
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total a Receber",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "R\$ ${total.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFFAB47BC).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.attach_money,
                            color: Color(0xFFAB47BC),
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Seção clientes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Clientes com Fiado",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _mostrarFormularioFiado(context),
                    icon: Icon(Icons.add, size: 18),
                    label: Text("Novo"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFAB47BC),
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

            // Lista de clientes
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firebaseService.buscarFiados(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar fiados'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline,
                              size: 80, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            'Nenhum cliente com fiado',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final fiados = snapshot.data!.docs
                      .map((doc) => FiadoModel.fromFirestore(doc))
                      .toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: fiados.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          _buildClienteCard(fiados[index]),
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

  Widget _buildClienteCard(FiadoModel fiado) {
    final dateFormat = DateFormat('dd/MM/yyyy');

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
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFAB47BC).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: Color(0xFFAB47BC),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fiado.nomeCliente,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Última: ${dateFormat.format(fiado.ultimaCompra)}",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFAB47BC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "R\$ ${fiado.valorTotal.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _mostrarHistorico(fiado),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFFAB47BC),
                    side: BorderSide(color: Color(0xFFAB47BC)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Ver Histórico"),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _mostrarDialogoPagamento(fiado),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Registrar Pagamento"),
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _confirmarDelecao(fiado.id!),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _mostrarFormularioFiado(BuildContext context) {
    final nomeController = TextEditingController();
    final produtoController = TextEditingController();
    final valorController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
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
                      colors: [Color(0xFFAB47BC), Color(0xFFE91E63)],
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
                        "Novo Cliente Fiado",
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
                        _buildLabel("Nome do Cliente"),
                        TextField(
                          controller: nomeController,
                          decoration: _buildInputDecoration("Digite o nome completo"),
                        ),
                        SizedBox(height: 20),
                        _buildLabel("Produto"),
                        TextField(
                          controller: produtoController,
                          decoration: _buildInputDecoration("Ex: Bolo de Chocolate"),
                        ),
                        SizedBox(height: 20),
                        _buildLabel("Valor"),
                        TextField(
                          controller: valorController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: _buildInputDecoration("0.00"),
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
                        if (nomeController.text.isEmpty) {
                          _mostrarSnackBar(context, "Digite o nome do cliente", Colors.red);
                          return;
                        }

                        try {
                          FiadoModel novoFiado = FiadoModel(
                            nomeCliente: nomeController.text,
                            valorTotal: double.tryParse(valorController.text) ?? 0,
                            ultimaCompra: DateTime.now(),
                            itens: produtoController.text.isNotEmpty
                                ? [
                                    ItemFiado(
                                      produto: produtoController.text,
                                      valor: double.tryParse(valorController.text) ?? 0,
                                      data: DateTime.now(),
                                    )
                                  ]
                                : [],
                          );

                          await _firebaseService.criarFiado(novoFiado.toMap());

                          Navigator.pop(context);
                          _mostrarSnackBar(
                              context, "Cliente cadastrado com sucesso!", Color(0xFF4CAF50));
                        } catch (e) {
                          _mostrarSnackBar(context, "Erro: $e", Colors.red);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFAB47BC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Criar Cliente",
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
  }

  void _mostrarDialogoPagamento(FiadoModel fiado) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Registrar Pagamento"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Cliente: ${fiado.nomeCliente}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Valor devido: R\$ ${fiado.valorTotal.toStringAsFixed(2)}"),
            SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: "Valor pago (R\$)",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              double valorPago = double.tryParse(controller.text) ?? 0;
              if (valorPago > 0) {
                try {
                  await _firebaseService.registrarPagamento(fiado.id!, valorPago);
                  Navigator.pop(context);
                  _mostrarSnackBar(context, "Pagamento registrado!", Color(0xFF4CAF50));
                } catch (e) {
                  _mostrarSnackBar(context, "Erro: $e", Colors.red);
                }
              }
            },
            child: Text("Confirmar"),
          ),
        ],
      ),
    );
  }

  void _mostrarHistorico(FiadoModel fiado) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Histórico - ${fiado.nomeCliente}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Total devido: R\$ ${fiado.valorTotal.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFAB47BC),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: fiado.itens.isEmpty
                  ? Center(child: Text("Nenhuma compra registrada"))
                  : ListView.builder(
                      itemCount: fiado.itens.length,
                      itemBuilder: (context, index) {
                        final item = fiado.itens[index];
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.shopping_bag,
                                color: Color(0xFFAB47BC)),
                            title: Text(item.produto),
                            subtitle: Text(dateFormat.format(item.data)),
                            trailing: Text(
                              "R\$ ${item.valor.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmarDelecao(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar Exclusão"),
        content: Text("Deseja realmente excluir este cliente?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _firebaseService.deletarFiado(id);
                Navigator.pop(context);
                _mostrarSnackBar(context, "Cliente excluído!", Color(0xFF4CAF50));
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
          color: Color(0xFFAB47BC),
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
        borderSide: BorderSide(color: Color(0xFFAB47BC)),
      ),
    );
  }

  void _mostrarSnackBar(BuildContext context, String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: cor),
    );
  }
}