class Exercise {
  final int? id;
  final String name;
  final String muscleGroup;
  final String? imagePath;
  final bool isCustom;

  Exercise({
    this.id,
    required this.name,
    required this.muscleGroup,
    this.imagePath,
    this.isCustom = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'muscle_group': muscleGroup,
      'image_path': imagePath,
      'is_custom': isCustom ? 1 : 0,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as int?,
      name: map['name'] as String,
      muscleGroup: map['muscle_group'] as String,
      imagePath: map['image_path'] as String?,
      isCustom: map['is_custom'] == 1,
    );
  }

  Exercise copyWith({
    int? id,
    String? name,
    String? muscleGroup,
    String? imagePath,
    bool? isCustom,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      imagePath: imagePath ?? this.imagePath,
      isCustom: isCustom ?? this.isCustom,
    );
  }
} 