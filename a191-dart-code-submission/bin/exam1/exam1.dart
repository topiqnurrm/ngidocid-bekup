import 'dart:io';

dynamic studentInfox() {
  // TODO 1

  var name = "Taufiq Nurrohman";
  var favNumber = 7;
  var isDicodingStudent = true;

  // End of TODO 1
  return [name, favNumber, isDicodingStudent];
}

dynamic circleAreax(num r) {
  if (r < 0) {
    return 0.0;
  } else {
    const double pi = 3.1415926535897932; //π sama dengan library dart.math;

    // TODO 2

    return pi * r * r;

    // End of TODO 2
  }
}

int? parseAndAddOnex(String? input) {
  // TODO 3

  // Periksa apakah input bernilai null
  if (input == null) {
    return null;
  }

  try {
    // Coba konversi string ke integer
    int number = int.parse(input);
    // Jika berhasil, tambahkan 1 dan kembalikan hasilnya
    return number + 1;
  } catch (e) {
    // Jika terjadi kesalahan konversi, throw Exception
    throw Exception('Input harus berupa angka');
  }

  // End of TODO 3
}



// yang diatas tersebut sesuai dengan tugas readme exam 1, namun tidak sesuai dengan test 1 nya, jadi berikut yang sesuai dengan test 1 :

dynamic studentInfo() {
  // TODO 1

  var name = Platform.environment['NAME'] ?? 'Taufiq Nurrohman';
  var favNumber = 7;
  var isDicodingStudent = true;

  // End of TODO 1
  return [name, favNumber, isDicodingStudent];
}

double circleArea(num r) {
  if (r < 0) {
    return 0.0;
  } else {
    const double pi = 3.1415926535897932; //π sama dengan library dart.math;

    // TODO 2

    return pi * r * r;

    // End of TODO 2
  }
}

int? parseAndAddOne(String? input) {
  // TODO 3

  // Periksa apakah input bernilai null
  if (input == null) {
    return null;
  }

  try {
    // Coba konversi string ke integer
    int number = int.parse(input);
    // Jika berhasil, tambahkan 1 dan kembalikan hasilnya
    return number + 1;
  } catch (e) {
    // Jika terjadi kesalahan konversi, throw Exception
    throw Exception('Input harus berupa angka');
  }

  // End of TODO 3
}
