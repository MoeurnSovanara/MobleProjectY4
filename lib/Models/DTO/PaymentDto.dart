class Paymentdto {
  final int paymentId;
  final int userId;
  final String clientId;
  final String secretKey;
  final String currencyCode;

  Paymentdto({
    required this.paymentId,
    required this.userId,
    required this.clientId,
    required this.secretKey,
    required this.currencyCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'userId': userId,
      'clientId': clientId,
      'secretKey': secretKey,
      'currencyCode': currencyCode,
    };
  }

  factory Paymentdto.fromJson(Map<String, dynamic> json) {
    return Paymentdto(
      paymentId: json['paymentId'] ?? 0,
      userId: json['userId'] ?? 0,
      clientId: json['clientId'] ?? "",
      secretKey: json['secretKey'] ?? "",
      currencyCode: json['currencyCode'] ?? "",
    );
  }
}
