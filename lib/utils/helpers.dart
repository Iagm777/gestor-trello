/// Funciones auxiliares de la aplicación
class Helpers {
  /// Valida un email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Valida una contraseña
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Valida un username
  static bool isValidUsername(String username) {
    return username.length >= 3 && username.length <= 20;
  }

  /// Formatea una fecha
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Formatea una fecha con hora
  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Obtiene el tiempo relativo
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'hace unos segundos';
    } else if (difference.inMinutes < 60) {
      return 'hace ${difference.inMinutes} minuto(s)';
    } else if (difference.inHours < 24) {
      return 'hace ${difference.inHours} hora(s)';
    } else if (difference.inDays < 30) {
      return 'hace ${difference.inDays} día(s)';
    } else {
      return formatDate(dateTime);
    }
  }

  /// Trunca un texto a una longitud máxima
  static String truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }
}
