import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/insumo_model.dart';
import 'services/firebase_service.dart';

class TelaEstoque extends StatefulWidget {
  const TelaEstoque({super.key});

  @override
  State<TelaEstoque> createState() => _TelaEstoqueState();
}

class _TelaEstoqueState extends State<TelaEstoque> {
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
                  colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
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
                              "Estoque de Insumos",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            StreamBuilder<QuerySnapshot>(
                              stream: _firebaseService.buscarInsumos(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return SizedBox();
                                
                                int alertas = snapshot.data!.docs.where((doc) {
                                  var insumo = InsumoModel.fromFirestore(doc);
                                  return insumo.isEstoqueBaixo;
                                }).length;

                                return Text(
                                  "$alertas alertas de estoque baixo",
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

            // Alerta de estoque baixo
            StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.buscarInsumos(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return SizedBox();

                var insumosBaixos = snapshot.data!.docs
                    .map((doc) => InsumoModel.fromFirestore(doc))
                    .where((insumo) => insumo.isEstoqueBaixo)
                    .toList();

                if (insumosBaixos.isEmpty) return SizedBox();

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFFFB74D), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Color(0xFFEF6C00),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Atenção: Estoque Baixo",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEF6C00),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        ...insumosBaixos.map((insumo) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                "• ${insumo.nome}: ${insumo.quantidadeAtual.toStringAsFixed(1)} ${insumo.unidade}",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[800]),
                              ),
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Seção todos os insumos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Todos os Insumos",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _mostrarFormularioInsumo(context),
                    icon: Icon(Icons.add, size: 18),
                    label: Text("Novo Insumo"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF42A5F5),
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

            // Lista de insumos
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firebaseService.buscarInsumos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar insumos'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2,
                              size: 80, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            'Nenhum insumo cadastrado',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final insumos = snapshot.data!.docs
                      .map((doc) => InsumoModel.fromFirestore(doc))
                      .toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: insumos.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          _buildInsumoCard(insumos[index]),
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

  Widget _buildInsumoCard(InsumoModel insumo) {
    double percentual =
        (insumo.quantidadeAtual / insumo.quantidadeMaxima) * 100;
    Color statusColor =
        insumo.isEstoqueBaixo ? Color(0xFFFF9800) : Color(0xFF42A5F5);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            insumo.isEstoqueBaixo ? Border.all(color: Color(0xFFFF9800), width: 2) : null,
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
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.inventory_2, color: statusColor, size: 24),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insumo.nome,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Mínimo: ${insumo.quantidadeMinima.toStringAsFixed(1)} ${insumo.unidade}",
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
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
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${insumo.quantidadeAtual.toStringAsFixed(1)} ${insumo.unidade}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Barra de progresso
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: insumo.quantidadeAtual / insumo.quantidadeMaxima,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 8,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "0",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                "${insumo.quantidadeMaxima.toStringAsFixed(0)} ${insumo.unidade}",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _mostrarDialogoUsar(insumo),
                  icon: Icon(Icons.remove, size: 18),
                  label: Text("Usar"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: statusColor,
                    side: BorderSide(color: statusColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _mostrarDialogoAdicionar(insumo),
                  icon: Icon(Icons.add, size: 18),
                  label: Text("Adicionar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _confirmarDelecaoInsumo(insumo.id!),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _mostrarFormularioInsumo(BuildContext context, {InsumoModel? insumo}) {
    final nomeController = TextEditingController(text: insumo?.nome);
    final qtdAtualController = TextEditingController(
        text: insumo?.quantidadeAtual.toString() ?? '0');
    final qtdMinimaController = TextEditingController(
        text: insumo?.quantidadeMinima.toString() ?? '0');
    final qtdMaximaController = TextEditingController(
        text: insumo?.quantidadeMaxima.toString() ?? '0');
    String unidadeSelecionada = insumo?.unidade ?? 'kg';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
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
                          colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
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
                            insumo == null ? "Novo Insumo" : "Editar Insumo",
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
                            _buildLabel("Nome do Insumo"),
                            TextField(
                              controller: nomeController,
                              decoration: _buildInputDecoration("Ex: Farinha de Trigo"),
                            ),
                            SizedBox(height: 20),
                            _buildLabel("Quantidade Atual"),
                            TextField(
                              controller: qtdAtualController,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              decoration: _buildInputDecoration("0.0"),
                            ),
                            SizedBox(height: 20),
                            _buildLabel("Quantidade Mínima"),
                            TextField(
                              controller: qtdMinimaController,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              decoration: _buildInputDecoration("0.0"),
                            ),
                            SizedBox(height: 20),
                            _buildLabel("Quantidade Máxima"),
                            TextField(
                              controller: qtdMaximaController,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              decoration: _buildInputDecoration("0.0"),
                            ),
                            SizedBox(height: 20),
                            _buildLabel("Unidade de Medida"),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: unidadeSelecionada,
                                  items: ['kg', 'g', 'l', 'ml', 'un']
                                      .map((unidade) => DropdownMenuItem(
                                            value: unidade,
                                            child: Text(unidade),
                                          ))
                                      .toList(),
                                  onChanged: (String? newValue) {
                                    setModalState(() {
                                      unidadeSelecionada = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Botão salvar
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (nomeController.text.isEmpty) {
                              _mostrarSnackBar(context, "Digite o nome do insumo", Colors.red);
                              return;
                            }

                            try {
                              InsumoModel novoInsumo = InsumoModel(
                                id: insumo?.id,
                                nome: nomeController.text,
                                quantidadeAtual: double.tryParse(qtdAtualController.text) ?? 0,
                                quantidadeMinima: double.tryParse(qtdMinimaController.text) ?? 0,
                                quantidadeMaxima: double.tryParse(qtdMaximaController.text) ?? 0,
                                unidade: unidadeSelecionada,
                              );

                              if (insumo == null) {
                                await _firebaseService.criarInsumo(novoInsumo.toMap());
                              } else {
                                await _firebaseService.atualizarQuantidadeInsumo(
                                  insumo.id!,
                                  novoInsumo.quantidadeAtual,
                                );
                              }

                              Navigator.pop(context);
                              _mostrarSnackBar(
                                context,
                                insumo == null
                                    ? "Insumo criado com sucesso!"
                                    : "Insumo atualizado!",
                                Color(0xFF4CAF50),
                              );
                            } catch (e) {
                              _mostrarSnackBar(context, "Erro: $e", Colors.red);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF42A5F5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            insumo == null ? "Criar Insumo" : "Atualizar Insumo",
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

  void _mostrarDialogoUsar(InsumoModel insumo) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Usar ${insumo.nome}"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: "Quantidade a usar (${insumo.unidade})",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              double quantidade = double.tryParse(controller.text) ?? 0;
              if (quantidade > 0) {
                try {
                  await _firebaseService.usarQuantidadeInsumo(insumo.id!, quantidade);
                  Navigator.pop(context);
                  _mostrarSnackBar(context, "Quantidade usada com sucesso!", Color(0xFF4CAF50));
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

  void _mostrarDialogoAdicionar(InsumoModel insumo) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Adicionar ${insumo.nome}"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: "Quantidade a adicionar (${insumo.unidade})",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              double quantidade = double.tryParse(controller.text) ?? 0;
              if (quantidade > 0) {
                try {
                  await _firebaseService.adicionarQuantidadeInsumo(insumo.id!, quantidade);
                  Navigator.pop(context);
                  _mostrarSnackBar(context, "Quantidade adicionada com sucesso!", Color(0xFF4CAF50));
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

  void _confirmarDelecaoInsumo(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar Exclusão"),
        content: Text("Deseja realmente excluir este insumo?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _firebaseService.deletarInsumo(id);
                Navigator.pop(context);
                _mostrarSnackBar(context, "Insumo excluído!", Color(0xFF4CAF50));
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
          color: Color(0xFF42A5F5),
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
        borderSide: BorderSide(color: Color(0xFF42A5F5)),
      ),
    );
  }

  void _mostrarSnackBar(BuildContext context, String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: cor),
    );
  }
}