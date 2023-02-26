//login authexception

class UserNotFoundAuthException implements Exception{}

class WrongPasswordAuthException implements Exception{}

//register authexception

class WeakPasswordAuthException implements Exception{}

class EmailAlreadyInUseAuthException implements Exception{}

class InvalidEmailAuthException implements Exception{}

//generic AuthException

class GenericAuthException implements Exception{}

class UserNotLoggedInAuthException implements Exception{}