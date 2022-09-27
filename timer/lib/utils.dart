
int GetMinuts(int seconds){
  double a =seconds / 60;
  return a.floor() ;
}
int GetSeconds(int? seconds){
  return seconds! % 60;
}

Duration convertToDuration(int sec)
{
  final seconds = GetSeconds(sec);
  final minutes = GetMinuts(sec);
  return Duration(minutes: minutes,seconds: seconds);

}
int convertFromDuration (Duration time){
  return time.inSeconds;
}
String formatTime(int? sec) {
  String minutes = (GetMinuts(sec!)).toString().padLeft(2, '0');
  String seconds = (GetSeconds(sec)).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

String formatTimeForDuration(Duration time){
  String minutes = (time.inMinutes).toString().padLeft(2, '0');
  String seconds = (time.inSeconds%60).toString().padLeft(2, '0');
  return '$minutes:$seconds';

}
