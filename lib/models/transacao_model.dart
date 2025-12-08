import 'package:cloud_firestore/cloud_firestore.dart';

class TransacaoModel {
  String? id;
  String tipo; // 'venda' ou 'gasto'
  String descricao;
  double valor;
  DateTime data;
  DateTime createdAt;

  TransacaoModel({
    this.id,
    required this.tipo,
    required this.descricao,
    required this.valor,
    required this.data,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo,
      'descricao': descricao,
      'valor': valor,
      'data': Timestamp.fromDate(data),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory TransacaoModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TransacaoModel(
      id: doc.id,
      tipo: data['tipo'] ?? 'venda',
      descricao: data['descricao'] ?? '',
      valor: (data['valor'] ?? 0).toDouble(),
      data: (data['data'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}