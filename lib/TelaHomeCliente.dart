import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/encomenda_model.dart';
import 'models/produto_model.dart';
import 'services/firebase_service.dart';

class TelaHomeCliente extends StatefulWidget {
  const TelaHomeCliente({super.key});

  @override
  State<TelaHomeCliente> createState() => _TelaHomeClienteState();
}

class _TelaHomeClienteState extends State<TelaHomeCliente> {
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
                  colors: [
                    Color.fromARGB(255, 194, 17, 146),
                    Color.fromARGB(255, 235, 144, 238)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Delicias em Camadas",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Olá, Cliente!",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.exit_to_app, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Barra de busca
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Buscar produtos...",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey[400]),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Seção de produtos
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Nossos Produtos",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _firebaseService.buscarProdutos(),
                    builder: (context, snapshot) {
                      int count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 239, 36, 202),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "$count itens",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Grid de produtos com StreamBuilder
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firebaseService.buscarProdutos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar produtos'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('Nenhum produto disponível'),
                    );
                  }

                  final produtos = snapshot.data!.docs.map((doc) {
                    return ProdutoModel.fromFirestore(doc);
                  }).toList();

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: produtos.length,
                    itemBuilder: (context, index) {
                      return _buildProdutoCard(produtos[index]);
                    },
                  );
                },
              ),
            ),

            // Botão de fazer encomenda
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 194, 17, 146),
                        Color.fromARGB(255, 235, 144, 238)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 239, 36, 202).withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _mostrarFormularioEncomenda(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Fazer Encomenda",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProdutoCard(ProdutoModel produto) {
    return GestureDetector(
      onTap: () {
        _mostrarFormularioEncomenda(context, produtoSelecionado: produto);
      },
      child: Container(
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
            // Imagem placeholder
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFCE4EC),
                    Color(0xFFFFF3E0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.cake,
                  size: 48,
                  color: Color(0xFFE91E63).withOpacity(0.3),
                ),
              ),
            ),
            // Informações do produto
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.grey[300], size: 18),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    produto.nome,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    produto.descricao,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Color(0xFFFF9800), size: 16),
                      SizedBox(width: 4),
                      Text(
                        "${produto.avaliacao}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "R\$ ${produto.preco.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE91E63),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 239, 36, 202),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Pedir",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarFormularioEncomenda(BuildContext context, {ProdutoModel? produtoSelecionado}) {
    String? produtoId = produtoSelecionado?.id;
    String? produtoNome = produtoSelecionado?.nome;
    double? produtoPreco = produtoSelecionado?.preco;
    
    TextEditingController nomeController = TextEditingController();
    TextEditingController telefoneController = TextEditingController();
    TextEditingController dataController = TextEditingController();
    TextEditingController horaController = TextEditingController();
    TextEditingController observacoesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
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
                          colors: [Color(0xFFE91E63), Color(0xFFFF9800)],
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
                            "Nova Encomenda",
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
                            // Nome do Cliente
                            Text(
                              "Seu Nome",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE91E63),
                              ),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: nomeController,
                              decoration: InputDecoration(
                                hintText: "Digite seu nome completo",
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Color(0xFFE91E63),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xFFE91E63),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            
                            // Telefone
                            Text(
                              "Telefone",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE91E63),
                              ),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: telefoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: "(00) 00000-0000",
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Color(0xFFE91E63),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xFFE91E63),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            
                            // Produto
                            Text(
                              "Produto",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE91E63),
                              ),
                            ),
                            SizedBox(height: 8),
                            StreamBuilder<QuerySnapshot>(
                              stream: _firebaseService.buscarProdutos(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                }
                                
                                final produtos = snapshot.data!.docs.map((doc) {
                                  return ProdutoModel.fromFirestore(doc);
                                }).toList();

                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Text("Selecione o produto"),
                                      value: produtoNome,
                                      items: produtos.map((produto) {
                                        return DropdownMenuItem<String>(
                                          value: produto.nome,
                                          child: Text("${produto.nome} - R\$ ${produto.preco.toStringAsFixed(2)}"),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setModalState(() {
                                          produtoNome = newValue;
                                          final produtoSel = produtos.firstWhere(
                                            (p) => p.nome == newValue,
                                          );
                                          produtoId = produtoSel.id;
                                          produtoPreco = produtoSel.preco;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 20),
                            
                            // Data
                            Text(
                              "Data da Retirada",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE91E63),
                              ),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: dataController,
                              decoration: InputDecoration(
                                hintText: "dd/mm/aaaa",
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFFE91E63),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xFFE91E63),
                                  ),
                                ),
                              ),
                              onTap: () async {
                                FocusScope.of(context).requestFocus(FocusNode());
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030),
                                );
                                if (picked != null) {
                                  dataController.text =
                                      "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                                }
                              },
                            ),
                            SizedBox(height: 20),
                            
                            // Hora
                            Text(
                              "Horário da Retirada",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE91E63),
                              ),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: horaController,
                              decoration: InputDecoration(
                                hintText: "--:--",
                                prefixIcon: Icon(
                                  Icons.access_time,
                                  color: Color(0xFFE91E63),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xFFE91E63),
                                  ),
                                ),
                              ),
                              onTap: () async {
                                FocusScope.of(context).requestFocus(FocusNode());
                                TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  horaController.text =
                                      "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                                }
                              },
                            ),
                            SizedBox(height: 20),
                            
                            // Observações
                            Text(
                              "Observações",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE91E63),
                              ),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: observacoesController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: "Ex: decoração especial, mensagem personalizada...",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(bottom: 60),
                                  child: Icon(
                                    Icons.note,
                                    color: Color(0xFFE91E63),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xFFE91E63),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Botão confirmar
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFE91E63), Color(0xFFFF9800)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              // Validações
                              if (nomeController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Por favor, digite seu nome"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              
                              if (telefoneController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Por favor, digite seu telefone"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              if (produtoNome == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Por favor, selecione um produto"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              if (dataController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Por favor, selecione a data"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              if (horaController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Por favor, selecione o horário"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              // Criar encomenda
                              try {
                                EncomendaModel novaEncomenda = EncomendaModel(
                                  produto: produtoNome!,
                                  cliente: nomeController.text,
                                  telefone: telefoneController.text,
                                  dataRetirada: dataController.text,
                                  horaRetirada: horaController.text,
                                  observacoes: observacoesController.text.isNotEmpty 
                                      ? observacoesController.text 
                                      : null,
                                  valor: produtoPreco ?? 0,
                                  status: 'pendente',
                                );

                                await _firebaseService.criarEncomenda(novaEncomenda.toMap());

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Encomenda realizada com sucesso!"),
                                    backgroundColor: Color(0xFF4CAF50),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Erro ao criar encomenda: $e"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Confirmar Encomenda",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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
}