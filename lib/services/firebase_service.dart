import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== ENCOMENDAS ====================
  
  // CREATE - Criar encomenda
  Future<String> criarEncomenda(Map<String, dynamic> dados) async {
    try {
      DocumentReference doc = await _firestore.collection('encomendas').add(dados);
      return doc.id;
    } catch (e) {
      throw Exception('Erro ao criar encomenda: $e');
    }
  }

  // READ - Buscar todas as encomendas
  Stream<QuerySnapshot> buscarEncomendas() {
    return _firestore
        .collection('encomendas')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // READ - Buscar encomendas por status
  Stream<QuerySnapshot> buscarEncomendarPorStatus(String status) {
    return _firestore
        .collection('encomendas')
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // UPDATE - Atualizar encomenda
  Future<void> atualizarEncomenda(String id, Map<String, dynamic> dados) async {
    try {
      await _firestore.collection('encomendas').doc(id).update(dados);
    } catch (e) {
      throw Exception('Erro ao atualizar encomenda: $e');
    }
  }

  // UPDATE - Marcar encomenda como concluída
  Future<void> concluirEncomenda(String id) async {
    try {
      await _firestore.collection('encomendas').doc(id).update({
        'status': 'concluido',
      });
    } catch (e) {
      throw Exception('Erro ao concluir encomenda: $e');
    }
  }

  // DELETE - Deletar encomenda
  Future<void> deletarEncomenda(String id) async {
    try {
      await _firestore.collection('encomendas').doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao deletar encomenda: $e');
    }
  }

  // ==================== INSUMOS ====================

  // CREATE - Criar insumo
  Future<String> criarInsumo(Map<String, dynamic> dados) async {
    try {
      DocumentReference doc = await _firestore.collection('insumos').add(dados);
      return doc.id;
    } catch (e) {
      throw Exception('Erro ao criar insumo: $e');
    }
  }

  // READ - Buscar todos os insumos
  Stream<QuerySnapshot> buscarInsumos() {
    return _firestore
        .collection('insumos')
        .orderBy('nome')
        .snapshots();
  }

  // UPDATE - Atualizar quantidade do insumo
  Future<void> atualizarQuantidadeInsumo(String id, double novaQuantidade) async {
    try {
      await _firestore.collection('insumos').doc(id).update({
        'quantidadeAtual': novaQuantidade,
      });
    } catch (e) {
      throw Exception('Erro ao atualizar insumo: $e');
    }
  }

  // UPDATE - Adicionar quantidade
  Future<void> adicionarQuantidadeInsumo(String id, double quantidade) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('insumos').doc(id).get();
      double atual = (doc['quantidadeAtual'] ?? 0).toDouble();
      await atualizarQuantidadeInsumo(id, atual + quantidade);
    } catch (e) {
      throw Exception('Erro ao adicionar quantidade: $e');
    }
  }

  // UPDATE - Usar quantidade
  Future<void> usarQuantidadeInsumo(String id, double quantidade) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('insumos').doc(id).get();
      double atual = (doc['quantidadeAtual'] ?? 0).toDouble();
      double nova = atual - quantidade;
      if (nova < 0) nova = 0;
      await atualizarQuantidadeInsumo(id, nova);
    } catch (e) {
      throw Exception('Erro ao usar quantidade: $e');
    }
  }

  // DELETE - Deletar insumo
  Future<void> deletarInsumo(String id) async {
    try {
      await _firestore.collection('insumos').doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao deletar insumo: $e');
    }
  }

  // ==================== FIADO ====================

  // CREATE - Criar registro de fiado
  Future<String> criarFiado(Map<String, dynamic> dados) async {
    try {
      DocumentReference doc = await _firestore.collection('fiados').add(dados);
      return doc.id;
    } catch (e) {
      throw Exception('Erro ao criar fiado: $e');
    }
  }

  // READ - Buscar todos os fiados
  Stream<QuerySnapshot> buscarFiados() {
    return _firestore
        .collection('fiados')
        .orderBy('ultimaCompra', descending: true)
        .snapshots();
  }

  // UPDATE - Registrar pagamento
  Future<void> registrarPagamento(String id, double valorPago) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('fiados').doc(id).get();
      double valorAtual = (doc['valorTotal'] ?? 0).toDouble();
      double novoValor = valorAtual - valorPago;
      if (novoValor < 0) novoValor = 0;
      
      await _firestore.collection('fiados').doc(id).update({
        'valorTotal': novoValor,
      });
    } catch (e) {
      throw Exception('Erro ao registrar pagamento: $e');
    }
  }

  // UPDATE - Adicionar compra ao fiado
  Future<void> adicionarCompraFiado(String id, Map<String, dynamic> item) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('fiados').doc(id).get();
      double valorAtual = (doc['valorTotal'] ?? 0).toDouble();
      List<dynamic> itens = doc['itens'] ?? [];
      
      itens.add(item);
      
      await _firestore.collection('fiados').doc(id).update({
        'valorTotal': valorAtual + item['valor'],
        'itens': itens,
        'ultimaCompra': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Erro ao adicionar compra: $e');
    }
  }

  // DELETE - Deletar fiado
  Future<void> deletarFiado(String id) async {
    try {
      await _firestore.collection('fiados').doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao deletar fiado: $e');
    }
  }

  // ==================== TRANSAÇÕES ====================

  // CREATE - Criar transação
  Future<String> criarTransacao(Map<String, dynamic> dados) async {
    try {
      DocumentReference doc = await _firestore.collection('transacoes').add(dados);
      return doc.id;
    } catch (e) {
      throw Exception('Erro ao criar transação: $e');
    }
  }

  // READ - Buscar todas as transações
  Stream<QuerySnapshot> buscarTransacoes() {
    return _firestore
        .collection('transacoes')
        .orderBy('data', descending: true)
        .snapshots();
  }

  // READ - Buscar transações por tipo
  Stream<QuerySnapshot> buscarTransacoesPorTipo(String tipo) {
    return _firestore
        .collection('transacoes')
        .where('tipo', isEqualTo: tipo)
        .orderBy('data', descending: true)
        .snapshots();
  }

  // DELETE - Deletar transação
  Future<void> deletarTransacao(String id) async {
    try {
      await _firestore.collection('transacoes').doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao deletar transação: $e');
    }
  }

  // ==================== PRODUTOS ====================

  // CREATE - Criar produto
  Future<String> criarProduto(Map<String, dynamic> dados) async {
    try {
      DocumentReference doc = await _firestore.collection('produtos').add(dados);
      return doc.id;
    } catch (e) {
      throw Exception('Erro ao criar produto: $e');
    }
  }

  // READ - Buscar todos os produtos
  Stream<QuerySnapshot> buscarProdutos() {
    return _firestore
        .collection('produtos')
        .orderBy('nome')
        .snapshots();
  }

  // UPDATE - Atualizar produto
  Future<void> atualizarProduto(String id, Map<String, dynamic> dados) async {
    try {
      await _firestore.collection('produtos').doc(id).update(dados);
    } catch (e) {
      throw Exception('Erro ao atualizar produto: $e');
    }
  }

  // DELETE - Deletar produto
  Future<void> deletarProduto(String id) async {
    try {
      await _firestore.collection('produtos').doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao deletar produto: $e');
    }
  }
}