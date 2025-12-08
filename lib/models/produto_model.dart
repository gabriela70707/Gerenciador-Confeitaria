import 'package:cloud_firestore/cloud_firestore.dart';

class ProdutoModel {
  String? id;
  String nome;
  String descricao;
  double preco;
  double avaliacao;
  DateTime createdAt;

  ProdutoModel({
    this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.avaliacao,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  // Converter para Map (para salvar no Firebase)
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'avaliacao': avaliacao,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Criar objeto a partir do Firebase
  factory ProdutoModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProdutoModel(
      id: doc.id,
      nome: data['nome'] ?? '',
      descricao: data['descricao'] ?? '',
      preco: (data['preco'] ?? 0).toDouble(),
      avaliacao: (data['avaliacao'] ?? 0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}