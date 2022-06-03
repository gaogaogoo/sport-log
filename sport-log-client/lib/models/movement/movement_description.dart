import 'package:json_annotation/json_annotation.dart';
import 'package:sport_log/database/db_interfaces.dart';
import 'package:sport_log/models/entity_interfaces.dart';
import 'package:sport_log/models/movement/movement.dart';

part 'movement_description.g.dart';

@JsonSerializable()
class MovementDescription extends CompoundEntity {
  MovementDescription({
    required this.movement,
    required this.hasReference,
  });

  MovementDescription.defaultValue()
      : movement = Movement.defaultValue(),
        hasReference = false;

  factory MovementDescription.fromJson(Map<String, dynamic> json) =>
      _$MovementDescriptionFromJson(json);

  Movement movement;
  bool hasReference;

  @override
  Map<String, dynamic> toJson() => _$MovementDescriptionToJson(this);

  @override
  MovementDescription clone() => MovementDescription(
        movement: movement.clone(),
        hasReference: hasReference,
      );

  @override
  bool isValidBeforeSanitazion() {
    return validate(
      movement.isValidBeforeSanitazion(),
      'MovementDescription: movement is not valid',
    );
  }

  @override
  bool isValid() {
    return isValidBeforeSanitazion() &&
        validate(
          movement.isValid(),
          'MovementDescription: movement is not valid',
        );
  }

  @override
  void sanitize() {
    movement.sanitize();
  }

  @override
  bool operator ==(other) =>
      other is MovementDescription &&
      other.hasReference == hasReference &&
      other.movement == movement;

  @override
  int get hashCode => Object.hash(hasReference, movement);

  static bool areTheSame(MovementDescription m1, MovementDescription m2) =>
      m1.movement.id == m2.movement.id;
}
