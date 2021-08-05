
enum MovementUnit {
  reps, cal, meter, km, yard, foot, mile
}

extension MovementUniToDisplayName on MovementUnit {
  String toDisplayName() {
    switch (this) {
      case MovementUnit.reps:
        return "Reps";
      case MovementUnit.cal:
        return "Cals";
      case MovementUnit.meter:
        return "m";
      case MovementUnit.km:
        return "km";
      case MovementUnit.yard:
        return "yd";
      case MovementUnit.foot:
        return "ft";
      case MovementUnit.mile:
        return "mi";
    }
  }
}

enum MovementCategory {
  strength, cardio
}

extension MovementCategoryToDisplayName on MovementCategory {
  String toDisplayName() {
    switch (this) {
      case MovementCategory.strength:
        return "strength";
      case MovementCategory.cardio:
        return "cardio";
    }
  }
}

class UiMovement {
  UiMovement({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.description,
  });

  int? id;
  int? userId;
  String name;
  MovementCategory category;
  String? description;
}

class Movement {
  Movement({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.description,
  });

  int id;
  int? userId;
  String name;
  MovementCategory category;
  String? description;

  UiMovement toUiMovement() {
    return UiMovement(
      id: id,
      userId: userId,
      name: name,
      category: category,
      description: description,
    );
  }
}