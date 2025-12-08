import 'package:cloud_firestore/cloud_firestore.dart';

/// Classe utilitária para inicializar o banco de dados
/// com dados de exemplo na primeira execução do app
class InitDatabase {
  
  /// Método estático que popula o banco com dados iniciais
  /// É chamado apenas UMA VEZ quando o app inicia
  static Future<void> popularDadosIniciais() async {
    // Referência ao Firestore (banco de dados)
    final firestore = FirebaseFirestore.instance;
    
    // ==================== VERIFICAÇÃO ====================
    // Primeiro, verifica se já existem produtos no banco
    // Isso evita duplicar dados toda vez que o app abre
    final produtos = await firestore.collection('produtos').get();
    
    if (produtos.docs.isNotEmpty) {
      // Se já tem produtos, NÃO faz nada
      print('✅ Banco já contém dados. Pulando inicialização.');
      return; // Sai da função
    }
    
    print('🔄 Populando banco de dados com dados iniciais...');
    
    // ==================== PRODUTOS ====================
    // Se chegou aqui, o banco está vazio. Vamos popular!
    
    // Produto 1: Bolo de Chocolate
    await firestore.collection('produtos').add({
      'nome': 'Bolo de Chocolate',
      'descricao': 'Massa úmida com cobertura cremosa',
      'preco': 45.00,
      'avaliacao': 4.8,
      'createdAt': Timestamp.now(), // Data/hora atual
    });
    
    // Produto 2: Brigadeiro Gourmet
    await firestore.collection('produtos').add({
      'nome': 'Brigadeiro Gourmet',
      'descricao': 'Receita especial da casa',
      'preco': 2.50,
      'avaliacao': 5.0,
      'createdAt': Timestamp.now(),
    });
    
    // Produto 3: Torta de Morango
    await firestore.collection('produtos').add({
      'nome': 'Torta de Morango',
      'descricao': 'Morangos frescos e chantilly',
      'preco': 55.00,
      'avaliacao': 4.9,
      'createdAt': Timestamp.now(),
    });
    
    // Produto 4: Cupcake Decorado
    await firestore.collection('produtos').add({
      'nome': 'Cupcake Decorado',
      'descricao': 'Vários sabores disponíveis',
      'preco': 8.00,
      'avaliacao': 4.7,
      'createdAt': Timestamp.now(),
    });
    
    // ==================== INSUMOS ====================
    // Adiciona alguns insumos de exemplo
    
    await firestore.collection('insumos').add({
      'nome': 'Farinha de Trigo',
      'quantidadeAtual': 2.5,
      'quantidadeMinima': 5.0,
      'quantidadeMaxima': 20.0,
      'unidade': 'kg',
      'createdAt': Timestamp.now(),
    });
    
    await firestore.collection('insumos').add({
      'nome': 'Açúcar',
      'quantidadeAtual': 3.0,
      'quantidadeMinima': 3.0,
      'quantidadeMaxima': 15.0,
      'unidade': 'kg',
      'createdAt': Timestamp.now(),
    });
    
    await firestore.collection('insumos').add({
      'nome': 'Chocolate em Pó',
      'quantidadeAtual': 4.0,
      'quantidadeMinima': 2.0,
      'quantidadeMaxima': 10.0,
      'unidade': 'kg',
      'createdAt': Timestamp.now(),
    });
    
    await firestore.collection('insumos').add({
      'nome': 'Embalagens',
      'quantidadeAtual': 12.0,
      'quantidadeMinima': 20.0,
      'quantidadeMaxima': 100.0,
      'unidade': 'un',
      'createdAt': Timestamp.now(),
    });
    
    // ==================== FIADOS (Exemplo) ====================
    // Adiciona alguns clientes com fiado
    
    await firestore.collection('fiados').add({
      'nomeCliente': 'Carla Mendes',
      'valorTotal': 120.00,
      'ultimaCompra': Timestamp.now(),
      'itens': [
        {
          'produto': 'Bolo de Chocolate',
          'valor': 45.00,
          'data': Timestamp.now(),
        },
        {
          'produto': 'Torta de Morango',
          'valor': 55.00,
          'data': Timestamp.now(),
        },
      ],
      'createdAt': Timestamp.now(),
    });
    
    await firestore.collection('fiados').add({
      'nomeCliente': 'Roberto Silva',
      'valorTotal': 85.00,
      'ultimaCompra': Timestamp.now(),
      'itens': [
        {
          'produto': 'Cupcakes',
          'valor': 85.00,
          'data': Timestamp.now(),
        },
      ],
      'createdAt': Timestamp.now(),
    });
    
    // ==================== TRANSAÇÕES (Exemplo) ====================
    // Adiciona algumas transações financeiras de exemplo
    
    // Vendas
    await firestore.collection('transacoes').add({
      'tipo': 'venda',
      'descricao': 'Bolo de Chocolate',
      'valor': 45.00,
      'data': Timestamp.now(),
      'createdAt': Timestamp.now(),
    });
    
    await firestore.collection('transacoes').add({
      'tipo': 'venda',
      'descricao': 'Torta de Morango',
      'valor': 55.00,
      'data': Timestamp.now(),
      'createdAt': Timestamp.now(),
    });
    
    // Gastos
    await firestore.collection('transacoes').add({
      'tipo': 'gasto',
      'descricao': 'Compra de farinha',
      'valor': 35.00,
      'data': Timestamp.now(),
      'createdAt': Timestamp.now(),
    });
    
    await firestore.collection('transacoes').add({
      'tipo': 'gasto',
      'descricao': 'Embalagens',
      'valor': 22.00,
      'data': Timestamp.now(),
      'createdAt': Timestamp.now(),
    });
    
    // Mensagem de sucesso
    print('Banco de dados populado com sucesso!');
    print('4 produtos adicionados');
    print('4 insumos adicionados');
    print('2 clientes com fiado adicionados');
    print('4 transações adicionadas');
  }
}