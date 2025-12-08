import 'package:cloud_firestore/cloud_firestore.dart';

class FiadoModel {
  String? id;
  String nomeCliente;
  double valorTotal;
  DateTime ultimaCompra;
  List<ItemFiado> itens;
  DateTime createdAt;

  FiadoModel({
    this.id,
    required this.nomeCliente,
    required this.valorTotal,
    required this.ultimaCompra,
    this.itens = const [],
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'nomeCliente': nomeCliente,
      'valorTotal': valorTotal,
      'ultimaCompra': Timestamp.fromDate(ultimaCompra),
      'itens': itens.map((item) => item.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory FiadoModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FiadoModel(
      id: doc.id,
      nomeCliente: data['nomeCliente'] ?? '',
      valorTotal: (data['valorTotal'] ?? 0).toDouble(),
      ultimaCompra: (data['ultimaCompra'] as Timestamp).toDate(),
      itens: (data['itens'] as List<dynamic>?)
              ?.map((item) => ItemFiado.fromMap(item))
              .toList() ??
          [],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}

class ItemFiado {
  String produto;
  double valor;
  DateTime data;

  ItemFiado({
    required this.produto,
    required this.valor,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'produto': produto,
      'valor': valor,
      'data': Timestamp.fromDate(data),
    };
  }

  factory ItemFiado.fromMap(Map<String, dynamic> map) {
    return ItemFiado(
      produto: map['produto'] ?? '',
      valor: (map['valor'] ?? 0).toDouble(),
      data: (map['data'] as Timestamp).toDate(),
    );
  }
}