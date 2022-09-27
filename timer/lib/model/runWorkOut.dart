import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:timer/model/note.dart';
import 'package:timer/model/settings.dart';



//var player = AudioPlayer();


enum WorkoutState { initial, starting, exercising, resting, warmingUp, coolingDown, finished }

class WorkOutDTO{
  final Duration startDelay;
  final Duration workoutTime;
  final Duration restTime;
  final Duration warmUpTime;
  final Duration coolDownTime;
  final int rep;

  const WorkOutDTO({

    required this.startDelay,
    required this.workoutTime,
    required this.restTime,
    required this.warmUpTime,
    required this.coolDownTime,
    required this.rep,
  });

}
class BeginWorkout{
  AudioCache player  = AudioCache();
  static const String alarmSoundPath = "sound/oof.mp3";
  Settings _settings;
  WorkOutDTO _config;
  Function _onStateChange;

  WorkoutState currentStep = WorkoutState.initial;

  Timer? _timer;

  late Duration _timeLeft;

  int rep = 0;

  int times=1;

  BeginWorkout(this._settings, this._config, this._onStateChange);

   Future _playSound() async {
     await player.play(alarmSoundPath);
  }


  start() {
    if (currentStep == WorkoutState.initial) {
      currentStep = WorkoutState.starting;
      if (_config.startDelay.inSeconds == 0) {
        _nextStep();
      } else {
        _timeLeft = _config.startDelay;
      }
    }
    _timer = Timer.periodic(Duration(seconds: 1), _tick);
    _onStateChange();
  }

  dispose() {
    _timer?.cancel();
  }

  pause() {
    _timer?.cancel();
    _onStateChange();
  }

  _tick(Timer timer)async {

    if (_timeLeft.inSeconds == 1) {
      _nextStep();
    } else {
      _timeLeft -= Duration(seconds: 1);
      if (_timeLeft.inSeconds<4  && currentStep != WorkoutState.starting) {
        await _playSound();
      }
    }
    _onStateChange();


  }

  _nextStep() {
     if(currentStep == WorkoutState.starting){
      _startExercise();
    } else if (currentStep == WorkoutState.exercising) {
        _startRest();
    } else if (currentStep == WorkoutState.resting) {
      _startWarmUp();
    } else if (currentStep == WorkoutState.warmingUp) {
      _startCoolingDown();
    } else if (currentStep == WorkoutState.coolingDown) {
       if(_config.rep ==rep+1){
         _finish();
       }
       else{
         rep++;
         go();
       }
     }
  }


  _prevStep() {
    if(currentStep == WorkoutState.starting){
      if(rep > 0){
        --rep;
        currentStep == WorkoutState.coolingDown;
        _startWarmUp();
      } else{
        go();
      }

    } else if (currentStep == WorkoutState.exercising) {

      go();
    } else if (currentStep == WorkoutState.resting) {

      _startExercise();

    } else if (currentStep == WorkoutState.warmingUp) {

      _startRest();

    } else if (currentStep == WorkoutState.coolingDown) {

      _startWarmUp();
    }
  }

  goToNext(){
    if(isActive)
    {
      _timeLeft = Duration(seconds: 1);
    }
    else{
      _timeLeft = Duration(seconds: 0);
    }

    _nextStep();
    _onStateChange();

  }

  goToPrev(){


      _prevStep();
      _onStateChange();

  }

  go(){
    currentStep = WorkoutState.starting;
      if (_config.startDelay.inSeconds == 0) {
        _nextStep();
        return;
      }
        _timeLeft = _config.startDelay;
  }

  _startExercise() {
    currentStep = WorkoutState.exercising;
    if (_config.workoutTime.inSeconds == 0) {
      _nextStep();
      return;
    }
    _timeLeft = _config.workoutTime;

  }

  _startRest() {
    currentStep = WorkoutState.resting;
    if (_config.restTime.inSeconds == 0) {
      _nextStep();
      return;
    }
    _timeLeft = _config.restTime;

  }

  _startWarmUp() {
    currentStep = WorkoutState.warmingUp;
    if (_config.warmUpTime.inSeconds == 0) {
      _nextStep();
      return;
    }
    _timeLeft = _config.warmUpTime;

  }
  _startCoolingDown() {
    currentStep = WorkoutState.coolingDown;
    if (_config.coolDownTime.inSeconds == 0) {
      _nextStep();
      return;
    }
    _timeLeft = _config.coolDownTime;

  }

  _finish() {
    _timer?.cancel();
    currentStep = WorkoutState.finished;
    _timeLeft = Duration(seconds: 0);
    _playSound();

   _onStateChange();

  }


  get config => _config;


  get _rep => rep;

  get step => currentStep;
  get player1 => player;

  get timeLeft => _timeLeft;


  get isActive => _timer != null && _timer!.isActive;
  get next=>goToNext();
  get previous=>goToPrev();


}