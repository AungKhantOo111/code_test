import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class ProductsTable extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get name => text()();
  IntColumn get priceMmk => integer()();
  BoolColumn get isNew => boolean().withDefault(const Constant(false))();
  IntColumn get discountPercent => integer().nullable()();
  TextColumn get imageUrl => text()();
  TextColumn get description => text()();
  TextColumn get section => text()(); // 'seasonal_specials', 'popular', 'order_again'

  @override
  Set<Column> get primaryKey => {id};
}

class BannersTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get subtitle => text()();
  TextColumn get actionUrl => text()();
  TextColumn get imageUrl => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class ShopsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get address => text()();
  TextColumn get imageUrl => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class MemberProfilesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get photoUrl => text()();
  TextColumn get tier => text()();
  IntColumn get points => integer()();
  TextColumn get nextTier => text()();
  IntColumn get pointsToNextTier => integer()();
  IntColumn get totalPoints => integer()();
  IntColumn get unreadNotifications => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class ChallengesTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get current => integer()();
  IntColumn get target => integer()();
  IntColumn get rewardPoints => integer()();
  TextColumn get type => text()(); // 'donut' or 'coffee'
  TextColumn get imageUrl => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  ProductsTable,
  BannersTable,
  ShopsTable,
  MemberProfilesTable,
  ChallengesTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'jdonuts_db'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(challengesTable);
          }
        },
      );
}
