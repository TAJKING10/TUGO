import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:emailjs/emailjs.dart';


class VerificationStorage {

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> storeVerificationCode(String verificationCode) async {
    await _secureStorage.write(key: 'verificationCode', value: verificationCode);
  }

  Future<String> _getVerificationCode() async {
    return await _secureStorage.read(key: 'verificationCode')??'';
  }

  Future<void> deleteVerificationCode() async {
    await _secureStorage.delete(key: 'verificationCode');
  }

  Future<bool> compareVerificationCode(String providedCode) async {
    String storedCode = await _getVerificationCode();
    return storedCode == providedCode;
  }

}
class RandomNumberGenerator {

  String generateCode() {
    final random = Random.secure();
    final codeDigits = List<int>.generate(6, (_) => random.nextInt(9));
    return codeDigits.join();
  }
}
class EmailSending {
  final RandomNumberGenerator _randomNumberGenerator=new RandomNumberGenerator();
  final VerificationStorage _secureStorageManager = VerificationStorage();



  Future<void> sendVerificationEmail(email) async {
    String code= _randomNumberGenerator.generateCode();
    await _secureStorageManager.storeVerificationCode(code);


    Map<String, dynamic> templateParams = {
      'email': email,
      'code':code
    };
    try {
      await EmailJS.send(
        'service_qsifgzg',
        'template_ok2w7xa',
        templateParams,
        const Options(
          publicKey: 'LBjfA84KWdv7w58Jw',
          privateKey: 'CRo6kdh7hMOoSAHkkYTAB',
        ),
      );
      print('SUCCESS!');
    } catch (error) {
      print(error.toString());
    }
  }




  Future<void> sendResetPasswordEmail(email) async {
    String code= _randomNumberGenerator.generateCode();
    await _secureStorageManager.storeVerificationCode(code);


    Map<String, dynamic> templateParams = {
      'email': email,
      'code':code
    };
    try {
      await EmailJS.send(
        'service_qsifgzg',
        'template_t0olbpi',
        templateParams,
        const Options(
          publicKey: 'LBjfA84KWdv7w58Jw',
          privateKey: 'CRo6kdh7hMOoSAHkkYTAB',
        ),
      );
      print('SUCCESS!');
    } catch (error) {
      print(error.toString());
    }
  }

}
