import 'dart:convert';

class Charge {
  const Charge({
    required this.object,
    required this.id,
    required this.amount,
    required this.net,
    required this.fee,
    required this.feeVat,
    required this.currency,
    this.description,
    required this.source,
    required this.createAt,
    required this.expiresAt,
    this.returnUri,
  });
  final String object;
  final String id;
  final int amount;
  final int net;
  final int fee;
  final int feeVat;
  final String currency;
  final String? description;
  final Source source;
  final String createAt;
  final String expiresAt;
  final String? returnUri;

  Charge copyWith({
    String? object,
    String? id,
    int? amount,
    int? net,
    int? fee,
    int? feeVat,
    String? currency,
    String? description,
    Source? source,
    String? createAt,
    String? expiresAt,
    String? returnUri,
  }) {
    return Charge(
      object: object ?? this.object,
      id: id ?? this.id,
      amount: amount ?? this.amount,
      net: net ?? this.net,
      fee: fee ?? this.fee,
      feeVat: feeVat ?? this.feeVat,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      source: source ?? this.source,
      createAt: createAt ?? this.createAt,
      expiresAt: expiresAt ?? this.expiresAt,
      returnUri: returnUri ?? this.returnUri,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'object': object,
      'id': id,
      'amount': amount,
      'net': net,
      'fee': fee,
      'feeVat': feeVat,
      'currency': currency,
      'description': description,
      'source': source.toMap(),
      'createAt': createAt,
      'expiresAt': expiresAt,
      'returnUri': returnUri,
    };
  }

  factory Charge.fromMap(Map<String, dynamic> map) {
    return Charge(
      object: map['object'] as String,
      id: map['id'] as String,
      amount: map['amount'] as int,
      net: map['net'] as int,
      fee: map['fee'] as int,
      feeVat: map['feeVat'] as int,
      currency: map['currency'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      source: Source.fromMap(map['source'] as Map<String, dynamic>),
      createAt: map['createAt'] as String,
      expiresAt: map['expiresAt'] as String,
      returnUri: map['returnUri'] != null ? map['returnUri'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Charge.fromJson(String source) =>
      Charge.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Charge(object: $object, id: $id, amount: $amount, net: $net, fee: $fee, feeVat: $feeVat, currency: $currency, description: $description, source: $source, createAt: $createAt, expiresAt: $expiresAt, returnUri: $returnUri)';
  }

  @override
  bool operator ==(covariant Charge other) {
    if (identical(this, other)) return true;

    return other.object == object &&
        other.id == id &&
        other.amount == amount &&
        other.net == net &&
        other.fee == fee &&
        other.feeVat == feeVat &&
        other.currency == currency &&
        other.description == description &&
        other.source == source &&
        other.createAt == createAt &&
        other.expiresAt == expiresAt &&
        other.returnUri == returnUri;
  }

  @override
  int get hashCode {
    return object.hashCode ^
        id.hashCode ^
        amount.hashCode ^
        net.hashCode ^
        fee.hashCode ^
        feeVat.hashCode ^
        currency.hashCode ^
        description.hashCode ^
        source.hashCode ^
        createAt.hashCode ^
        expiresAt.hashCode ^
        returnUri.hashCode;
  }
}

class Source {
  const Source({
    required this.object,
    required this.id,
    required this.amount,
    required this.currency,
    this.name,
    this.mobileNumber,
    this.phoneNumber,
    required this.scannableCode,
  });
  final String object;
  final String id;
  final int amount;
  final String currency;
  final String? name;
  final String? mobileNumber;
  final String? phoneNumber;
  final ScannableCode scannableCode;

  Source copyWith({
    String? object,
    String? id,
    int? amount,
    String? currency,
    String? name,
    String? mobileNumber,
    String? phoneNumber,
    ScannableCode? scannableCode,
  }) {
    return Source(
      object: object ?? this.object,
      id: id ?? this.id,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      scannableCode: scannableCode ?? this.scannableCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'object': object,
      'id': id,
      'amount': amount,
      'currency': currency,
      'name': name,
      'mobileNumber': mobileNumber,
      'phoneNumber': phoneNumber,
      'scannableCode': scannableCode.toMap(),
    };
  }

  factory Source.fromMap(Map<String, dynamic> map) {
    return Source(
      object: map['object'] as String,
      id: map['id'] as String,
      amount: map['amount'] as int,
      currency: map['currency'] as String,
      name: map['name'] != null ? map['name'] as String : null,
      mobileNumber:
          map['mobileNumber'] != null ? map['mobileNumber'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      scannableCode:
          ScannableCode.fromMap(map['scannableCode'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Source.fromJson(String source) =>
      Source.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Source(object: $object, id: $id, amount: $amount, currency: $currency, name: $name, mobileNumber: $mobileNumber, phoneNumber: $phoneNumber, scannableCode: $scannableCode)';
  }

  @override
  bool operator ==(covariant Source other) {
    if (identical(this, other)) return true;

    return other.object == object &&
        other.id == id &&
        other.amount == amount &&
        other.currency == currency &&
        other.name == name &&
        other.mobileNumber == mobileNumber &&
        other.phoneNumber == phoneNumber &&
        other.scannableCode == scannableCode;
  }

  @override
  int get hashCode {
    return object.hashCode ^
        id.hashCode ^
        amount.hashCode ^
        currency.hashCode ^
        name.hashCode ^
        mobileNumber.hashCode ^
        phoneNumber.hashCode ^
        scannableCode.hashCode;
  }
}

class ScannableCode {
  const ScannableCode({
    required this.object,
    required this.type,
    required this.image,
  });
  final String object;
  final String type;
  final QRImage image;

  ScannableCode copyWith({
    String? object,
    String? type,
    QRImage? image,
  }) {
    return ScannableCode(
      object: object ?? this.object,
      type: type ?? this.type,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'object': object,
      'type': type,
      'image': image.toMap(),
    };
  }

  factory ScannableCode.fromMap(Map<String, dynamic> map) {
    return ScannableCode(
      object: map['object'] as String,
      type: map['type'] as String,
      image: QRImage.fromMap(map['image'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScannableCode.fromJson(String source) =>
      ScannableCode.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ScannableCode(object: $object, type: $type, image: $image)';

  @override
  bool operator ==(covariant ScannableCode other) {
    if (identical(this, other)) return true;

    return other.object == object && other.type == type && other.image == image;
  }

  @override
  int get hashCode => object.hashCode ^ type.hashCode ^ image.hashCode;
}

class QRImage {
  const QRImage({
    required this.object,
    required this.id,
    required this.filename,
    required this.location,
    required this.kind,
    required this.downLoadUri,
    required this.createAt,
  });
  final String object;
  final String id;
  final String filename;
  final String location;
  final String kind;
  final String downLoadUri;
  final String createAt;

  QRImage copyWith({
    String? object,
    String? id,
    String? filename,
    String? location,
    String? kind,
    String? downLoadUri,
    String? createAt,
  }) {
    return QRImage(
      object: object ?? this.object,
      id: id ?? this.id,
      filename: filename ?? this.filename,
      location: location ?? this.location,
      kind: kind ?? this.kind,
      downLoadUri: downLoadUri ?? this.downLoadUri,
      createAt: createAt ?? this.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'object': object,
      'id': id,
      'filename': filename,
      'location': location,
      'kind': kind,
      'downLoadUri': downLoadUri,
      'createAt': createAt,
    };
  }

  factory QRImage.fromMap(Map<String, dynamic> map) {
    return QRImage(
      object: map['object'] as String,
      id: map['id'] as String,
      filename: map['filename'] as String,
      location: map['location'] as String,
      kind: map['kind'] as String,
      downLoadUri: map['downLoadUri'] as String,
      createAt: map['createAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory QRImage.fromJson(String source) =>
      QRImage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QRImage(object: $object, id: $id, filename: $filename, location: $location, kind: $kind, downLoadUri: $downLoadUri, createAt: $createAt)';
  }

  @override
  bool operator ==(covariant QRImage other) {
    if (identical(this, other)) return true;

    return other.object == object &&
        other.id == id &&
        other.filename == filename &&
        other.location == location &&
        other.kind == kind &&
        other.downLoadUri == downLoadUri &&
        other.createAt == createAt;
  }

  @override
  int get hashCode {
    return object.hashCode ^
        id.hashCode ^
        filename.hashCode ^
        location.hashCode ^
        kind.hashCode ^
        downLoadUri.hashCode ^
        createAt.hashCode;
  }
}
