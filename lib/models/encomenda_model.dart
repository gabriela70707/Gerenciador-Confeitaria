import 'package:cloud_firestore/cloud_firestore.dart';

class EncomendaModel {
  String? id;
  String produto;
  String cliente;
  String telefone;
  String dataRetirada;
  String horaRetirada;
  String? observacoes;
  double valor;
  String status; // 'pendente', 'concluido'
  DateTime createdAt;

  EncomendaModel({
    this.id,
    required this.produto,
    required this.cliente,
    required this.telefone,
    required this.dataRetirada,
    required this.horaRetirada,
    this.observacoes,
    required this.valor,
    this.status = 'pendente',
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'produto': produto,
      'cliente': cliente,
      'telefone': telefone,
      'dataRetirada': dataRetirada,
      'horaRetirada': horaRetirada,
      'observacoes': observacoes,
      'valor': valor,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory EncomendaModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return EncomendaModel(
      id: doc.id,
      produto: data['produto'] ?? '',
      cliente: data['cliente'] ?? '',
      telefone: data['telefone'] ?? '',
      dataRetirada: data['dataRetirada'] ?? '',
      horaRetirada: data['horaRetirada'] ?? '',
      observacoes: data['observacoes'],
      valor: (data['valor'] ?? 0).toDouble(),
      status: data['status'] ?? 'pendente',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}