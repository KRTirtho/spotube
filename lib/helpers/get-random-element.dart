import 'dart:math';

final Random _random = Random();
T getRandomElement<T>(List<T> list) {
  return list[_random.nextInt(list.length)];
}
