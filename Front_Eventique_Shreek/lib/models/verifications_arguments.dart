//taghreed
class VerificationArguments {
  final String email;
  final String type; // 'forgotPassword', 'resetEmail'

  VerificationArguments({
    required this.email,
    required this.type,
  });
}
