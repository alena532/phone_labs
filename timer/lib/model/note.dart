final String workOutNotes = 'workOuts';

class WorkOutFields {
  static final List<String> values = [
    /// Add all fields
    id, name, color, workoutTime, restTime,warmUpTime,coolDownTime, rep, startDelay
  ];

  static final String id = 'id';
  static final String name = 'name';
  static final String color = 'color';
  static final String workoutTime = 'workoutTime';
  static final String restTime = 'restTime';
  static final String warmUpTime = 'warmUpTime';
  static final String coolDownTime = 'coolDownTime';
  static final String rep = 'rep';
  static final String startDelay = 'startDelay';

}


class WorkOut {
  late final int? id;
   String name;
   String color;
   int? workoutTime ;
  int? restTime ;
   int? warmUpTime ;
   int? coolDownTime ;
   int? rep ;
   int? startDelay ;


   WorkOut({
    this.id,
    required this.name,
    required this.color,
    this.workoutTime = 5,
     this.restTime = 5,
    this.warmUpTime = 5,
    this.coolDownTime = 5,
    this.rep = 1,
    this.startDelay = 5,
  });

  static WorkOut fromJson(Map<String, dynamic> res) => WorkOut(
      id : res["id"] ,
      name: res["name"],
      color: res["color"],
      workoutTime: res["workoutTime"],
      restTime: res["restTime"],
      warmUpTime: res["warmUpTime"],
      coolDownTime: res["coolDownTime"],
      rep: res["rep"],
      startDelay: res["startDelay"]
  );

  Map<String, Object?> toJson() {
    return {'id':id,'name': name, 'color': color,'workoutTime':workoutTime,'restTime':restTime, 'warmUpTime':warmUpTime,'coolDownTime':coolDownTime,'rep':rep,'startDelay':startDelay};
  }

}

