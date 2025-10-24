import 'package:cbl/cbl.dart';
import 'package:dhap_flutter_project/data/db/CouchbaseCore_helper.dart';
import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:flutter/cupertino.dart';

class Userdb_helper {
  final _core = CouchbaseCoreHelper();

  Future<void> saveUser(User user) async {
    final db = await _core.database;
    final collection = await db.defaultCollection;

    final doc = MutableDocument.withId(user.email, {
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
      'inTask': user.inTask,
      'isCoordinator': user.isCoordinator,
      'isSubmitted': user.isSubmitted,
    });

    await collection.saveDocument(doc);
    debugPrint("User saved in Couchbase: ${user.email}");
  }

  Future<List<User>> getAllUsers() async {
    final db = await _core.database;
    final collection = await db.defaultCollection;

    //final dbName = 'dhap';

    final query = await QueryBuilder.createAsync()
        .select(SelectResult.all())
        .from(DataSource.collection(collection))
        .where(Expression.property('type').equalTo(Expression.string('user')));

    final result = await query.execute();

    final List<User> users = [];

    await for (final row in result.asStream()) {
      final data = row.dictionary(collection.name);

      if (data != null) {
        users.add(
          User(
            id: data.string('id'),
            name: data.string('name') ?? '',
            email: data.string('email') ?? '',
            password: data.string('password') ?? '',
            mobile: data.string('mobile') ?? '',
            addressLine: data.string('addressLine') ?? '',
            city: data.string('city') ?? '',
            country: data.string('country') ?? '',
            pincode: data.string('pincode') ?? '',
            role: data.string('role') ?? '',
            inTask: data.boolean('inTask'),
            isCoordinator: data.boolean('isCoordinator'),
            isSubmitted: data.boolean('isSubmitted'),
            taskIds: List<String>.from(data.array('taskIds')?.toList() ?? []),
            resourceIds: List<String>.from(
              data.array('resourceIds')?.toList() ?? [],
            ),
          ),
        );
      }
    }

    return users;
  }

  Stream<List<User>> watchAllUsers() async* {
    final db = await _core.database;
    final collection = await db.defaultCollection;

    final query = QueryBuilder.createAsync()
        .select(SelectResult.all())
        .from(DataSource.collection(collection))
        .where(Expression.property('type').equalTo(Expression.string('user')));

    final listener = query.changes();

    await for (final change in listener.asBroadcastStream()) {
      final results = await change.results?.allResults();
      final List<User> users = [];

      if (results != null) {
        for (final row in results) {
          final data = row.dictionary(collection.name);

          if (data != null) {
            users.add(
              User(
                id: data.string('id'),
                name: data.string('name') ?? '',
                email: data.string('email') ?? '',
                password: data.string('password') ?? '',
                mobile: data.string('mobile') ?? '',
                addressLine: data.string('addressLine') ?? '',
                city: data.string('city') ?? '',
                country: data.string('country') ?? '',
                pincode: data.string('pincode') ?? '',
                role: data.string('role') ?? '',
                inTask: data.boolean('inTask'),
                isCoordinator: data.boolean('isCoordinator'),
                isSubmitted: data.boolean('isSubmitted'),
                taskIds: List<String>.from(data.array('taskIds')?.toList() ?? []),
                resourceIds: List<String>.from(
                  data.array('resourceIds')?.toList() ?? [],
                ),
              ),
            );
          }
        }
      }

      // 👇 Yield each time query results change
      yield users;
    }
  }


  Future<User?> getUserByEmail(String email) async {
    final db = await _core.database;
    final collection = await db.defaultCollection;

    //if (_db == null) await init();
    final doc = await collection.document(email);
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
      inTask: doc.boolean('inTask'),
      isCoordinator: doc.boolean('isCoordinator'),
      isSubmitted: doc.boolean('isSubmitted'),
      taskIds: List<String>.from(doc.array('taskIds')?.toList() ?? []),
      resourceIds: List<String>.from(doc.array('resourceIds')?.toList() ?? []),
    );
  }

  Future<void> deleteUser(String email) async {
    final db = await _core.database;
    final collection = await db.defaultCollection;

    //if (_db == null) await init();
    final doc = await collection.document(email);
    if (doc != null) {
      await collection.deleteDocument(doc);
      debugPrint("User deleted: $email");
    }
  }

  Future<void> updateUserRole(String email, String newRole) async {
    final db = await _core.database;
    final collection = await db.defaultCollection;

    final doc = await collection.document(email);
    if (doc == null) {
      debugPrint("User not found: $email");
      return;
    }

    final mutableDoc = doc.toMutable();
    mutableDoc.setString(key: 'role', newRole);
    await collection.saveDocument(mutableDoc);

    debugPrint("User role updated to: $newRole for $email");
  }

  Future<void> acceptTask(String taskId, String userEmail) async {
    final db = await _core.database;
    final collection = await db.defaultCollection;

    final userDoc = await collection.document(userEmail);
    if (userDoc == null) {
      debugPrint("User not found: $userEmail");
      return;
    }

    debugPrint("userDoc: $userDoc");

    final mutableUser = userDoc.toMutable();
    final existingTaskIds = List<String>.from(
      mutableUser.array('taskIds')?.toList() ?? [],
    );

    if (!existingTaskIds.contains(taskId) && !mutableUser.boolean('inTask')) {
      existingTaskIds.add(taskId);
      mutableUser.setBoolean(key: 'inTask', true);
      final mutableArray = MutableArray();
      for (var id in existingTaskIds) {
        mutableArray.addString(id);
      }

      mutableUser.setArray(key: 'taskIds', mutableArray);
      await collection.saveDocument(mutableUser);
      debugPrint("Task $taskId added to user $userEmail");

      final taskDoc = await collection.document(taskId);
      if (taskDoc == null) {
        debugPrint("Task not found for id: $taskId");
        return;
      }

      debugPrint("taskDoc: $taskDoc");

      final mutableTask = taskDoc.toMutable();

      final currentVolunteers = mutableTask.integer('volunteersAccepted');
      mutableTask.setInteger(key: 'volunteersAccepted', currentVolunteers + 1);
      if (mutableTask.string('Status') == 'Pending') {
        mutableTask.setString(key: 'Status', 'In Progress');
      }

      await collection.saveDocument(mutableTask);
      debugPrint(
        "Task $taskId volunteersAccepted incremented to ${currentVolunteers + 1}",
      );
    } else {
      debugPrint("Task already accepted by user: $taskId");
    }
  }

  Future<void> addResource(String resourceId, String userEmail) async {
    final db = await _core.database;
    final collection = await db.defaultCollection;

    final userDoc = await collection.document(userEmail);
    if (userDoc == null) {
      debugPrint("User not found: $userEmail");
      return;
    }

    debugPrint("userDoc: $userDoc");

    final mutableUser = userDoc.toMutable();
    final existingResourceIds = List<String>.from(
      mutableUser.array('resourceIds')?.toList() ?? [],
    );

    if (!existingResourceIds.contains(resourceId)) {
      existingResourceIds.add(resourceId);
      final mutableArray = MutableArray();
      for (var id in existingResourceIds) {
        mutableArray.addString(id);
      }

      mutableUser.setArray(key: 'resourceIds', mutableArray);
      await collection.saveDocument(mutableUser);
      debugPrint("Task $resourceId added to user $userEmail");
    } else {
      debugPrint("Task already accepted by user: $resourceId");
    }
  }

  Future<void> updateUserSubmissionStatus(String email, bool isSubmitted) async {
    final db = await _core.database;
    final collection = await db.defaultCollection;

    final userDoc = await collection.document(email);
    if (userDoc == null) {
      debugPrint("User not found: $email");
      return;
    }

    final mutableUser = userDoc.toMutable();
    mutableUser.setBoolean(key: 'isSubmitted', isSubmitted);

    await collection.saveDocument(mutableUser);
    debugPrint("User $email submission status updated to: $isSubmitted");
  }


}
