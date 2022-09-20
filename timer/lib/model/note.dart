final String workOutNotes = 'workOuts';

class WorkOutFields {
  static final List<String> values = [
    /// Add all fields
    id, name, color, workoutTime, warmUpTime,coolDownTime, rep, resPer
  ];

  static final String id = 'id';
  static final String name = 'name';
  static final String color = 'color';
  static final String workoutTime = 'workoutTime';
  static final String warmUpTime = 'warmUpTime';
  static final String coolDownTime = 'coolDownTime';
  static final String rep = 'rep';
  static final String resPer = 'resPer';

}


class WorkOut {
  final int? id;
  final String name;
  final String color;
  final int? workoutTime;
  final int? warmUpTime;
  final int? coolDownTime;
  final int? rep;
  final int? resPer;

  const WorkOut({
    this.id,
    required this.name,
    required this.color,
    this.workoutTime,
    this.warmUpTime,
    this.coolDownTime,
    this.rep,
    this.resPer
  });

  static WorkOut fromJson(Map<String, dynamic> res)=>WorkOut(
      id : res["id"] ,
      name: res["name"],
      color: res["color"],
      workoutTime: res["workoutTime"],
      warmUpTime: res["warmUpTime"],
      coolDownTime: res["coolDownTime"],
      rep: res["rep"],
      resPer: res["resPer"]
  );

  Map<String, Object?> toJson() {
    return {'id':id,'name': name, 'color': color,'workoutTime':workoutTime,'warmUpTime':warmUpTime,'coolDownTime':coolDownTime,'rep':rep,'resPer':resPer};
  }

}

