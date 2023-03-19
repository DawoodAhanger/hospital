import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:sqflite/sqflite.dart";
import "package:path_provider/path_provider.dart";

import "package:path/path.dart";

import "crud_execption.dart";





class MessageService {
  Database? _db;
  Future<DatabaseMessage> updateMessage(
      {required DatabaseMessage message, required String text}) async {
        final db = _getDatabaseOrThrow();
        await getmessage(id: message.id);
        final updatescount = await db.update(messagetable, {textColumn:text,isSyncedWithCloudColumn:0});
        if(updatescount==0){
          throw CouldNotUpdateMessage();
          }
          else{
            return await getmessage(id: message.id);
          }
      }
  
  
  
  
  Future<Iterable<DatabaseMessage>> getAllMessage() async {
    final db = _getDatabaseOrThrow();
    final message = await db.query(messagetable);
    return message.map((messageRow) => DatabaseMessage.fromRow(messageRow));
  }

  Future<DatabaseMessage> getmessage({required int id}) async {
    final db = _getDatabaseOrThrow();
    final message = await db.query(
      messagetable,
      limit: 1,
      where: 'id=?',
      whereArgs: [id],
    );
    if (message.isEmpty) {
      throw CouldNotFindmessage();
    } else {
      return DatabaseMessage.fromRow(message.first);
    }
  }

  Future<int> deleteallmessage() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(messagetable);
  }

  Future<void> deletemessage({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletecount = await db.delete(
      messagetable,
      where: 'id = ?',
      whereArgs: [idcolumn],
    );
    if (deletecount == 0) {
      throw CouldNotDeleteMessage();
    }
  }

  Future<DatabaseMessage> createMessage({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    const text = '';
    //create notes
    final messageId = await db.insert(messagetable, {
      useridcolumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });
    final message = DatabaseMessage(
      id: messageId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );
    return message;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      usertable,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (result.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(result.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      usertable,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (result.isNotEmpty) {
      throw UserAlredyExist();
    }
    final userId = await db.insert(
      usertable,
      {emailcolumn: email.toLowerCase()},
    );
    return DatabaseUser(
      id: userId,
      email: email,
    );
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletecount = await db.delete(
      usertable,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletecount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpenExecption();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpenExecption();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenExecption();
    }
    try {
      final docspath = await getApplicationDocumentsDirectory();
      final dbPath = join(docspath.path, dbname);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);

      await db.execute(createmessagetable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idcolumn] as int,
        email = map[emailcolumn] as String;

  @override
  String toString() => 'Person,ID =$id,email=$email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseMessage {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseMessage({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });
  DatabaseMessage.fromRow(Map<String, Object?> map)
      : id = map[idcolumn] as int,
        userId = map[useridcolumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud = map[isSyncedWithCloudColumn] as bool;

  @override
  String toString() =>
      'Message,ID=$id,userId=$userId,isSyncedWithCloud=$isSyncedWithCloud';
}

const dbname = 'message.db';
const usertable = 'user';
const messagetable = 'message';
const idcolumn = "id";
const emailcolumn = "email";
const useridcolumn = "user_id";
const textColumn = "text";
const isSyncedWithCloudColumn = "is_synced_with_cloud";
const createmessagetable = '''CREATE TABLE IF NOT EXISTS "Messages" (
	"ID"	INTEGER NOT NULL,
	"User_ID"	INTEGER NOT NULL,
	"Text"	TEXT,
	"is_synced_with_server"	INTEGER NOT NULL DEFAULT 0,
	FOREIGN KEY("User_ID") REFERENCES "user"("ID"),
	PRIMARY KEY("ID" AUTOINCREMENT)
);

''';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
	"ID"	INTEGER,
	"Email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("ID" AUTOINCREMENT)
);
    ''';
