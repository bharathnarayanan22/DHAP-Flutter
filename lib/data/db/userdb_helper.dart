import 'package:cbl/cbl.dart';
import 'package:dhap_flutter_project/data/db/CouchbaseCore_helper.dart';
import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:flutter/cupertino.dart';

class Userdb_helper {
  final _core = CouchbaseCoreHelper();

  Future<void> saveUser(User user) async {
    final db = await _core.database;

    final doc = MutableDocument.withId(
      user.email,
      {
        'type': 'user',
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'mobile': user.mobile,
        'addressLine': user.addressLine,
        'city': user.city,
        'country': user.country,
        'pincode': user.pincode,
        'role': user.role,
        'taskIds': user.taskIds,
        'resourceIds': user.resourceIds,
      },
    );

    await db!.saveDocument(doc);
    debugPrint("User saved in Couchbase: ${user.email}");
  }

  Future<List<User>> getAllUsers() async {
    final db = await _core.database;
    final dbName = 'dhap';
   // if (db == null) await init();

    final query = await QueryBuilder.createAsync()
        .select(SelectResult.all())
        .from(DataSource.database(db))
        .where(Expression.property('type').equalTo(Expression.string('user')));

    final result = await query.execute();

    final List<User> users = [];

    await for (final row in result.asStream()) {
      final data = row.dictionary(dbName);

      if (data != null) {
        users.add(User(
          name: data.string('name') ?? '',
          email: data.string('email') ?? '',
          password: data.string('password') ?? '',
          mobile: data.string('mobile') ?? '',
          addressLine: data.string('addressLine') ?? '',
          city: data.string('city') ?? '',
          country: data.string('country') ?? '',
          pincode: data.string('pincode') ?? '',
          role: data.string('role') ?? '',
          taskIds: List<int>.from(data.array('taskIds')?.toList() ?? []),
          resourceIds: List<int>.from(data.array('resourceIds')?.toList() ?? []),
        ));
      }
    }

    return users;
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await _core.database;
    //if (_db == null) await init();
    final doc = await db!.document(email);
    if (doc == null) return null;

    return User(
      name: doc.string('name') ?? '',
      email: doc.string('email') ?? '',
      password: doc.string('password') ?? '',
      mobile: doc.string('mobile') ?? '',
      addressLine: doc.string('addressLine') ?? '',
      city: doc.string('city') ?? '',
      country: doc.string('country') ?? '',
      pincode: doc.string('pincode') ?? '',
      role: doc.string('role') ?? '',
      taskIds: List<int>.from(doc.array('taskIds')?.toList() ?? []),
      resourceIds: List<int>.from(doc.array('resourceIds')?.toList() ?? []),
    );
  }

  Future<void> deleteUser(String email) async {
    final db = await _core.database;
    //if (_db == null) await init();
    final doc = await db!.document(email);
    if (doc != null) {
      await db!.deleteDocument(doc);
      debugPrint("🗑️ User deleted: $email");
    }
  }

  Future<void> updateUserRole(String email, String newRole) async {
    final db = await _core.database;
    final doc = await db.document(email);
    if (doc == null) {
      debugPrint("User not found: $email");
      return;
    }

    final mutableDoc = doc.toMutable();
    mutableDoc.setString(key: 'role', newRole);
    await db.saveDocument(mutableDoc);

    debugPrint("User role updated to: $newRole for $email");
  }


  Future<void> acceptTask(int taskId, String userEmail) async {
    final db = await _core.database;

    final userDoc = await db.document(userEmail);
    if (userDoc == null) {
      debugPrint("User not found: $userEmail");
      return;
    }

    final mutableUser = userDoc.toMutable();
    final existingTaskIds =
    List<int>.from(mutableUser.array('taskIds')?.toList() ?? []);

    if (!existingTaskIds.contains(taskId) && !mutableUser.boolean('inTask')) {
      existingTaskIds.add(taskId);
      mutableUser.setBoolean(key: 'inTask', true);
      final mutableArray = MutableArray();
      for (var id in existingTaskIds) {
        mutableArray.addInteger(id);
      }

      mutableUser.setArray(key: 'taskIds', mutableArray);
      await db.saveDocument(mutableUser);
      debugPrint("Task $taskId added to user $userEmail");

      final taskDoc = await db.document(taskId.toString());
      if (taskDoc == null) {
        debugPrint("Task not found for id: $taskId");
        return;
      }

      final mutableTask = taskDoc.toMutable();

      final currentVolunteers = mutableTask.integer('volunteersAccepted');
      mutableTask.setInteger(key: 'volunteersAccepted', currentVolunteers + 1);
      if(mutableTask.string('Status') == 'Pending'){
        mutableTask.setString(key: 'Status', 'In Progress');
      }

      await db.saveDocument(mutableTask);
      debugPrint("Task $taskId volunteersAccepted incremented to ${currentVolunteers + 1}");
    } else {
      debugPrint("Task already accepted by user: $taskId");
    }

  }
}