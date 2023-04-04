import 'package:equatable/equatable.dart';
import '../utility/base/base_firebase.dart';

class NumberModel extends Equatable
    with IdModel, BaseFirebaseModel<NumberModel> {
  NumberModel({
    this.number,
  });

  final String? number;

  NumberModel copyWith({
    String? number,
  }) {
    return NumberModel(
      number: number ?? this.number,
    );
  }

  @override
  // TODO: implement id
  String? id = '';

  Map<String, dynamic> toJson() {
    return {
      'number': number,
    };
  }

  @override
  NumberModel fromJson(Map<String, dynamic> json) {
    return NumberModel(
      number: json['number'] as String?,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [number];
}
