import 'package:cloud_firestore/cloud_firestore.dart';

class InsumoModel {
  String? id;
  String nome;
  double quantidadeAtual;
  double quantidadeMinima;
  double quantidadeMaxima;
  String unidade; // 'kg', 'un', 'l'
  DateTime createdAt;

  InsumoModel({
    this.id,
    required this.nome,
    required this.quantidadeAtual,
    required this.quantidadeMinima,
    required this.quantidadeMaxima,
    this.unidade = 'kg',
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  bool get isEstoqueBaixo => quantidadeAtual <= quantidadeMinima;

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'quantidadeAtual': quantidadeAtual,
      'quantidadeMinima': quantidadeMinima,
      'quantidadeMaxima': quantidadeMaxima,
      'unidade': unidade,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory InsumoModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return InsumoModel(
      id: doc.id,
      nome: data['nome'] ?? '',
      quantidadeAtual: (data['quantidadeAtual'] ?? 0).toDouble(),
      quantidadeMinima: (data['quantidadeMinima'] ?? 0).toDouble(),
      quantidadeMaxima: (data['quantidadeMaxima'] ?? 0).toDouble(),
      unidade: data['unidade'] ?? 'kg',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}