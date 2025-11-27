/// Servicio de Autenticación
abstract class AuthService {
  /// Inicia sesión con email y contraseña
  Future<void> login(String email, String password);

  /// Registra un nuevo usuario
  Future<void> register(String email, String password, String username);

  /// Cierra sesión
  Future<void> logout();

  /// Obtiene el usuario actual
  Future<String?> getCurrentUserId();

  /// Verifica si el usuario está autenticado
  Future<bool> isAuthenticated();
}
