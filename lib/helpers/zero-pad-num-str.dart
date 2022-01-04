String zeroPadNumStr(int input) {
  return input < 10 ? "0$input" : input.toString();
}
