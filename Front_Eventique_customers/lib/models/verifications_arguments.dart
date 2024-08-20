//taghreed
class VerificationArguments {
  final String email;
  final String type; // 'signup', 'forgotPassword', 'resetEmail'

  VerificationArguments({
    required this.email,
    required this.type,
  });
}
