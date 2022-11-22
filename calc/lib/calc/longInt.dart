import 'dart:math';

class LongDouble {
  static const int divDigits = 1000;
  static const int sqrtDigits = 100;
  int sign = 0;
  List<int> digits = [];
  int exponent = 0;

  LongDouble.nul(){
    sign = 1; // ноль будем считать положительным числом
    List<int> d = [];
    d.add(0);
    digits = d; // создаём вектор из 1 нулевой цифры
    exponent = 1;
  }

  // конструктор из строки
  LongDouble(String value) {
    int index;
    // если первый символ строки - минус, значит число отрицательное
    if (value[0] == '-') {
      sign = -1; // знак отрицательного числа -1
      index = 1; // начинать идти нужно будет с первого символа
    } else {
      sign = 1; // иначе число положительное
      index = 0; // и идти нужно будет с нулевого символа
    }
    exponent = value.length -
        index; // предполагаем, что всё число будет целым, а значит и экспонента будет равна длине строки
    // идём по всей строке
    while (index < value.length) {
      if (value[index] == '.') {
        exponent = sign == 1 ? index : index -
            1;
      } else {
        digits.add(int.parse(
            value[index]));
      } // иначе вставляем в вектор очередную цифру

      index++; // переходим к новому символу
    }
  }

  LongDouble.copyOb(LongDouble x){
    sign = x.sign;
    digits = List<int>.from(x.digits);;
    exponent = x.exponent;
  }

  bool isR(LongDouble x, LongDouble y)
  {
    if (y.sign != x.sign) {
      return false; // если знаки разные, то положительное число больше
    }
    if (y.exponent != x.exponent) {
      return false; // если экспоненты разные, то больше число с большей экспонентой с учётом знака
    }
// копируем вектор
    List d1 = List<int>.from(y.digits);
    List d2 = List<int>.from(x.digits);
    int size = max(d1.length, d2.length); // определяем максимальный размер векторов

// выравниваем размеры векторов, добавляя в концы нули
    while (d1.length != size) {
      d1.add(0);
    }

    while (d2.length != size) {
      d2.add(0);
    }

// проходим по всем цифрам числа
    for (int i = 0; i < size; i++) {
      if (d1[i] != d2[i]) {
        return false; // если в каком-то разряде цифры разные, то больше число с большей цифрой с учётом знака
      }
    }
    return true; // иначе числа равны, а значит не больше
  }

  void removeZeroes() {
    int n = max(1, exponent); // определяем, до какого момента нужно будет идти для удаления нулей справа
    // пока справа нули
    while (digits.length > n && digits[digits.length - 1] == 0) {
      digits.removeLast();
    } // удаляем их
    //print(digits);
    // пока число цифр больше одной и вектор начинается с нуля
    while (digits.length > 1 && digits[0] == 0) {
      digits.removeAt(0); // удаляем нули из начала вектора
      exponent--; // и уменьшаем экспоненту
    }
    //print(digits);
    // если справа всё ещё остались нули
    while (digits.length > 1 && digits[digits.length - 1] == 0) {
      digits.removeLast();
    } // то удалим их

    // если в результате осталась всего одна нулевая цифра, то превратим её в честный ноль
    if (digits.length == 1 && digits[0] == 0) {
      exponent = 1;
      sign = 1;
    }
  }

  LongDouble operator -()
  {
    LongDouble res = LongDouble('0'); // создаём число
    res.sign = -sign; // меняем знак на противоположный
    res.exponent = exponent; // копируем экспоненту
    res.digits = digits; // копируем цифры

    return res; // возвращаем результат
  }

// проверка, что число больше другого
  bool operator>(x)  {
    if (sign != x.sign) {
      return sign > x.sign; // если знаки разные, то положительное число больше
    }
    if (exponent != x.exponent) {
      return (exponent > x.exponent) ^ (sign == -1); // если экспоненты разные, то больше число с большей экспонентой с учётом знака
    }
// копируем вектор
    List d1 = List<int>.from(digits);
    List d2 = List<int>.from(x.digits);
    int size = max(d1.length, d2.length); // определяем максимальный размер векторов

// выравниваем размеры векторов, добавляя в концы нули
    while (d1.length != size) {
      d1.add(0);
    }

    while (d2.length != size) {
      d2.add(0);
    }

// проходим по всем цифрам числа
    for (int i = 0; i < size; i++) {
      if (d1[i] != d2[i]) {
        return (d1[i] > d2[i]) ^ (sign == -1); // если в каком-то разряде цифры разные, то больше число с большей цифрой с учётом знака
      }
    }
    return false; // иначе числа равны, а значит не больше
  }

  LongDouble operator +(LongDouble x)  {
    if (sign == x.sign) { // если знаки одинаковые
      int exp1 = exponent; // запоминаем экспоненту первого
      int exp2 = x.exponent; // и второго чисел
      int exp = max(exp1, exp2); // находим максимальную экспоненту. К ней будем приводить оба числа

// создаём вектора из векторов цифр наших чисел
      List d1 = new List<int>.from(digits);
      List d2 = new List<int>.from(x.digits);

// выравниваем экспоненты
      while (exp1 != exp) {
        d1.insert(0, 0); // добавляя нули в начало первого
        exp1++;
      }

    while (exp2 != exp) {
      d2.insert(0, 0); // и в начало второго векторов
      exp2++;
    }

    int size = max(d1.length, d2.length); // определяем максимальный размер векторов

// выравниваем размеры векторов, добавляя нули в конец каждого из них
    while (d1.length != size) {
      d1.add(0);
    }
    while (d2.length != size) {
      d2.add(0);
    }

  int len = size+1;

  LongDouble res = LongDouble("0"); // создаём новое число

  res.sign = sign; // знак результата совпадает со знаком чисел
  List<int> u = [];
  for(int i=0; i<len; i++){
    u.add(0);
  }
  res.digits = u;
  res.exponent = 3;

// заполняем каждую ячейку вектора суммой двух соответствующих цифр
  for (int i = 0; i < size; i++) {
    res.digits[i + 1] = d1[i] + d2[i];
  }
// проверяем переполнения
  for (int i = len-1; i > 0; i--) {
    res.digits[i - 1] += (res.digits[i] ~/ 10); // прибавляем к более старшему разряду десятки текущего
    res.digits[i] %= 10;
    // оставляем у текущего разряда только единицы
  }
  res.exponent = exp + 1; // восстанавливаем экспоненту
  res.removeZeroes(); // убираем нули

  return res; // возвращаем число
  }

  if (sign == -1) {
    return x -
        (-(this)); // если первое число отрицательное, то из второго вычитаем первое с обратным знаком
  }
  return this - (-x); // иначе из первого вычитаем второе с обратным знаком
}

LongDouble operator -(LongDouble x) {
   if (sign == 1 && x.sign == 1) { // если боа числа положительны
     if (isR(this, x)==true) {
       return LongDouble("0");
     }
     bool cmp = this > x; // получаем флаг того, больше ли первое число
      int exp1 = cmp ? exponent : x.exponent; // сохраняем экспоненту большего числа
      int exp2 = cmp ? x.exponent : exponent; // сохраняем экспоненту меньшего числа
      int exp = max(exp1, exp2); // определяем максимальную экспоненту, чтобы к ней привести числа
      List d1 = new List<int>.from(cmp ? digits : x.digits);
      List d2 = new List<int>.from(cmp ? x.digits : digits);
      //List d1 = (cmp ? digits : x.digits); // запоминаем вектор цифр большего числа
      //List d2 = (cmp ? x.digits : digits); // запоминаем вектор цифр меньшего числа

// выравниваем экспоненты как при сложении (добавляя нули вначале числа)
      while (exp1 != exp) {
        d1.insert(0, 0);
        exp1++;
      }

      while (exp2 != exp) {
        d2.insert(0, 0);
        exp2++;
      }

      int size = max(d1.length, d2.length); // определяем максимальный размер

// добавляем нули в конец векторов цифр
      while (d1.length != size) {
        d1.add(0);
      }
      while (d2.length != size) {
        d2.add(0);
      }
      int len = 1 + size;

     LongDouble res = LongDouble("0"); // создаём число для результата

      res.sign = cmp ? 1 : -1; // знак будет 1, если первое больше второго, и -1, если первое меньше второго
     List<int> ll = [];
     for(int i =0; i<len; i++)
       {
         ll.add(0);
       }
      res.digits = ll; // создаём вектор из len нулей

      for (int i = 0; i < size; i++) {
        res.digits[i + 1] = d1[i] - d2[i]; // вычитаем соответствующие разряды
      }
// обрабатываем переполнения
      for (int i = len - 1; i > 0; i--) {
        if (res.digits[i] < 0) { // если текущий разряд стал меньше нуля
          res.digits[i] += 10; // занимаем у предыдущего, прибавляя 10 к текущему
          res.digits[i - 1]--; // уменьшаем на 1 предыдущий разряд
      }
  }

      res.exponent = exp + 1; // восстанавливаем экспоненту
      res.removeZeroes(); // удаляем лишнии нули
      return res; // возвращаем результат
 }

  if (sign == -1 && x.sign == -1) {
    return (-x) -
        (-(this)); // если оба числа отрицательны, то из второго с обратным знаком вычитаем первое с обратным знаком
  }


  return this + (-x); // если знаки разные, прибавляем к первому отрицательное второе
}

LongDouble operator*(LongDouble x) {
  int len = digits.length + x.digits.length; // максимальная длина нового числа не больше суммы длин перемножаемых чисел
  LongDouble res = LongDouble("0"); // создадим объект для результата

  res.sign = sign * x.sign; // перемножаем знаки
  List<int> k = [];
  for(int i=0; i<len; i++) {
    k.add(0);
  }

  res.digits = k; // создаём вектор из нулей
  res.exponent = exponent + x.exponent; // складываем экспоненты

  // умножаем числа в столбик
  for (int i = 0; i < digits.length; i++) {
    for (int j = 0; j < x.digits.length; j++) {
      res.digits[i + j + 1] += digits[i] * x.digits[j]; // прибавляем результат произведения цифр из i-го и j-го разрядов
    }
  }
  // в результате такого перемножения в ячейках могли получиться двузначные числа, поэтому нужно выполнить переносы
  for (int i = len - 1; i > 0; i--) {
    res.digits[i - 1] += (res.digits[i] ~/ 10); // добавляем к более старшему разряду десятки текущего разряда
    res.digits[i] %= 10; // оставляем только единицы у текущего разряда
  }
  res.removeZeroes(); // удаляем нули, как в конструкторе из строки, если таковые имеются

  return res; // возвращаем результат умножения двух чисел
}

bool operator<(LongDouble x) {
  return !(this > x || (isR(this, x)));
  }

  bool isZero() {

  return digits.length == 1 && digits[0] == 0;
  }


  bool operator>=(LongDouble x){
  return this > x || (isR(this, x));
  }

LongDouble inverse() {
  if (isZero()) {
    throw ("LongDouble LongDouble::inverse() - division by zero!"); // делить на ноль нельзя, поэтому бросим исключение
  }

  LongDouble x = LongDouble.copyOb(this); // скопируем число,
  x.sign = 1; // сделав его положительным


  LongDouble d = LongDouble("1"); // создадим то, что будем делить на x
  //d.exponent = 1;
  LongDouble res = LongDouble.nul(); // создадит объект для результата
  res.sign = sign; // знак результата совпадёт со знаком числа
  res.exponent = 1; // начнём с единичной экспоненты
  List<int> cc = [];
  res.digits = cc; // создадим пустой вектор для цифр обратного элемента

  LongDouble s = LongDouble("1");
// пока число меньше 1
  while (x < s) {
    x.exponent++; // будем увеличивать его экспоненту (умножать на 10 фактически)
    res.exponent++; // и заодно экспоненту результата
  }

// дальше сдлеаем число d большим x, также умножая его на 10, чтобы получить число 100...0
  while (d < x) {
    d.exponent++;
  }

  res.exponent -= d.exponent - 1; // подсчитаем реальное количество цифр в целой части
  int numbers = 0; // количество уже вычисленных цифр дробной части
  int totalNumbers = divDigits +
      max(0, res.exponent); // количество цифр с учётом целой части
  //h.exponent = d.exponent;
  //d.exponent = 3;
  do {
    int div = 0; // будущая цифра
    // считаем, сколько раз нужно вычесть x из d

    while ((d > x)||(isR(d, x))) {
      div++;
      d =d-x;
    }

    d.exponent++;
    //print(div);
    d.removeZeroes();
    res.digits.add(div); // записываем сформированную цифру
    numbers++; // увеличиваем число вычисленных цифр
    //h.exponent = d.exponent;
  } while (!d.isZero() && numbers < totalNumbers); // считаем до тех пор, пока не дойдём до нулевого остатка или пока не превысим точность
  return res; // возвращаем результат
}

  bool operator<=(LongDouble x)  {
  return this < x || isR(this, x);
  }

  LongDouble operator/(LongDouble x) {
    int count=0;
    for(int i=0; i<x.digits.length; i++)
      {
        if(x.digits[i] == 0)
          {
            count++;
          }
      }
    if (isR(LongDouble("1"), x))
      {
        return this;
      }

    if (isR(LongDouble("10"), x))
      {
        return this * LongDouble("0.1");
      }
    if (count == x.digits.length)
      {
        return this;
      }
    int c=0;
    if(x.digits.last == 1&&x.digits[x.digits.length-2] != 1) {
      //if(x.digits.length==1)
        //{
        if (x.isInteger() == true) {
          print(333);
          return this;
        }
        for (int i = 0; i < x.digits.length - 1; i++) {
          if (x.digits[i] == 0) {
            c++;
          }
        }
        if (c == x.digits.length - 1) {
          List d1 = List.from(x.digits);
          d1[0] = d1[d1.length - 1];
          d1[d1.length - 1] = 0;
          String l = d1.join("");
          LongDouble s = LongDouble(l);
          //LongDouble k = LongDouble(s.digits[0].toString());
          //s.digits[0] = 1;
          //LongDouble res = this / k;
          LongDouble res = this * s;
          return res;

      }
    }


    LongDouble res = this * x.inverse();
    int i = res.digits.length - 1 - max(0, exponent);
    int n = max(0, res.exponent);
    // если в указанном месте девятка, то ищем место, в котором девятки закончатся
    if (i > n && res.digits[i] == 9) {
      while (i > n && res.digits[i] == 9) {
        i--;
      }

      // если дошли до целой части
      if (res.digits[i] == 9) {
        for( int i = res.digits.length-1; i>=n; i--) {
          res.digits.removeLast();
        } // то удаляем всю вещественную часть
        res = res + LongDouble(res.sign.toString()); // и прибавляем 1 (или -1 к отрицательному)
      }
      else {
        for( int i = res.digits.length-1; i>=i+1; i--) {
          res.digits.removeLast();
        } // иначе обрезаем с найденного места
        res.digits[i]++; // и увеличиваем на 1 текущий разряд
      }
    }

    return res;
  }

  List<String> priint(LongDouble value) {
    List<String> p = [];
  if (value.sign == -1) {
    p.add('-');
  } // если число отрицательное, то сначала выведем знак минус

  // если экспонента положительна, то у числа ненулевая целая часть
  if (value.exponent > 0) {
  int i = 0;
  int e = value.exponent;

  // выводим первые exponent цифр (или все цифры, если экспонента больше) числа чтобы вывести целую часть
  while(i < value.digits.length && i < e) {
    p.add(value.digits[i++].toString());
  }
  // если экспонента больше цифр числа, то выводим нули, чтобы дойти до экспоненты
  while (i < e) {
    p.add("0");
  i++;
  }

  // если цифры ещё остались
  if (i < value.digits.length) {
    p.add(".");

  // и выводим оставшиеся цифры как дробную часть
  while(i < value.digits.length) {
    p.add(value.digits[i++].toString());
  }
  }
  }
  else { // иначе эспонента отрицательна или нулевая
    p.add("0.");

  // выводим |exponent| нулей (если экспонента нулевая, то не будет ни одного нуля)
  for (int i = 0; i < -value.exponent; i++) {
    p.add("0");
  }
  // выводим все цифры числа
  for (int i = 0; i < value.digits.length; i++) {
    p.add(value.digits[i].toString());
  }
  }

  return p; // возвращаем поток вывода
  }

  LongDouble abs()  {
  LongDouble res = this;
  res.sign = 1;

  return res;
}

bool isInteger() {
if (exponent < 0) {
  return false;
}

return digits.length <= exponent;
}

  bool isOdd()  {
  if (!isInteger()) {
    return false;
  }

  if (digits.length ==  exponent)
  return digits[digits.length - 1] % 2 == 1;

  return false;
  }


/*LongDouble sqrt()  {
  if (sign == -1)
  throw ("LongDouble LongDouble::sqrt() - number is negative");

  if (isZero()) {
    return LongDouble("0");
  }

  LongDouble x0;
  LongDouble p = LongDouble("0.5");
  LongDouble xk = LongDouble("0.5");
  LongDouble eps = LongDouble.nul();
  List<int> ss = [];
  ss[0]=1;
  eps.digits = ss;
  eps.exponent = 1 - sqrtDigits;

  do {
  x0 = xk;
  xk = p * (x0 + this / x0);
  } while ((x0 - xk).abs() > eps);
  int s=0;
  if (0> xk.exponent)
    {
      s=0;
    }
  else
    {
      s = xk.exponent;
    }
  int  dd = xk.digits[0]+s + sqrtDigits;
  xk.digits.removeRange(dd, xk.digits[xk.digits.length]);
  xk.removeZeroes();

  return xk;
  }

  LongDouble pow(LongDouble n)  {
  if (!n.isInteger())
  throw ("LongDouble LongDouble::power(const LongDouble& n) - n is not integer!");

  LongDouble res = LongDouble("1");
  LongDouble a = n.sign == 1 ? this : inverse();
  LongDouble power = n.abs();

  while (power > 0) {
  if (power.isOdd())
  res *= a;

  a *= a;
  power /= 2;

  if (!power.isInteger())
  power.digits.erase(power.digits.end() - 1);
  }

  return res;
  }*/

}
