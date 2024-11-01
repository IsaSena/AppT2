import 'package:postgres/postgres.dart';

class DatabaseConnection {
  final PostgreSQLConnection connection;

  DatabaseConnection()
      : connection = PostgreSQLConnection(
    'localhost',
    5432,       // Porta padrão do PostgreSQL
    'postgres', // Nome do banco de dados
    username: 'postgres', // Usuário do banco
    password: '123',   // Senha do banco
  );

  Future<void> openConnection() async {
    try {
      await connection.open();
      print('Conexão com o banco de dados estabelecida.');
    } catch (e) {
      print('Erro ao conectar ao banco de dados: $e');
    }
  }

  Future<void> closeConnection() async {
    await connection.close();
    print('Conexão com o banco de dados encerrada.');
  }
}
