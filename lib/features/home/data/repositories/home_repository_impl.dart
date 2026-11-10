import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../../../core/errors/result.dart';
import '../../../../core/storage/app_database.dart';
import '../../domain/models/home_models.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final AppDatabase _db;

  HomeRepositoryImpl({required AppDatabase db}) : _db = db;

  @override
  Future<void> seedInitialDataIfEmpty() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/seed/initial_data.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);

      await _db.batch((batch) {
        // 1. Member Profile
        if (data['member'] != null) {
          final m = data['member'] as Map<String, dynamic>;
          batch.insert(
            _db.memberProfilesTable,
            MemberProfilesTableCompanion.insert(
              id: m['id'] as String,
              name: m['name'] as String,
              photoUrl: m['photoUrl'] as String,
              tier: m['tier'] as String,
              points: m['points'] as int,
              nextTier: m['nextTier'] as String,
              pointsToNextTier: m['pointsToNextTier'] as int,
              totalPoints: m['totalPoints'] as int,
              unreadNotifications:
                  Value(m['unreadNotifications'] as int? ?? 0),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }

        // 2. Banners
        if (data['banners'] != null) {
          final banners = data['banners'] as List;
          for (final b in banners) {
            batch.insert(
              _db.bannersTable,
              BannersTableCompanion.insert(
                id: b['id'] as String,
                title: b['title'] as String,
                subtitle: b['subtitle'] as String,
                actionUrl: b['actionUrl'] as String,
                imageUrl: b['imageUrl'] as String,
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        }

        // 3. Products: Seasonal Specials
        void insertProducts(List list, String section) {
          for (final p in list) {
            batch.insert(
              _db.productsTable,
              ProductsTableCompanion.insert(
                id: p['id'] as String,
                code: p['code'] as String,
                name: p['name'] as String,
                priceMmk: p['priceMmk'] as int,
                isNew: Value(p['isNew'] as bool? ?? false),
                discountPercent: Value(p['discountPercent'] as int?),
                imageUrl: p['imageUrl'] as String,
                description: p['description'] as String,
                section: section,
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        }

        if (data['seasonal_specials'] != null) {
          insertProducts(data['seasonal_specials'] as List, 'seasonal_specials');
        }
        if (data['popular'] != null) {
          insertProducts(data['popular'] as List, 'popular');
        }
        if (data['order_again'] != null) {
          insertProducts(data['order_again'] as List, 'order_again');
        }

        // 4. Shops
        if (data['shops'] != null) {
          final shops = data['shops'] as List;
          for (final s in shops) {
            batch.insert(
              _db.shopsTable,
              ShopsTableCompanion.insert(
                id: s['id'] as String,
                name: s['name'] as String,
                address: s['address'] as String,
                imageUrl: s['imageUrl'] as String,
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        }

        // 5. Challenges (Task 3)
        if (data['challenges'] != null) {
          final challenges = data['challenges'] as List;
          for (final c in challenges) {
            batch.insert(
              _db.challengesTable,
              ChallengesTableCompanion.insert(
                id: c['id'] as String,
                title: c['title'] as String,
                current: c['current'] as int,
                target: c['target'] as int,
                rewardPoints: c['rewardPoints'] as int,
                type: c['type'] as String,
                imageUrl: c['imageUrl'] as String,
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        }
      });
    } catch (e) {
      // Failed to read seed asset or parse JSON
    }
  }

  @override
  Future<Result<HomeData, Failure>> getHomeData() async {
    try {
      await seedInitialDataIfEmpty();

      final members = await _db.select(_db.memberProfilesTable).get();
      final banners = await _db.select(_db.bannersTable).get();
      final products = await _db.select(_db.productsTable).get();
      final shops = await _db.select(_db.shopsTable).get();

      if (members.isEmpty) {
        return const Error(StorageFailure('Member profile not found in local cache'));
      }

      final member = _mapMember(members.first);
      final mappedBanners = banners.map(_mapBanner).toList();
      final mappedShops = shops.map(_mapShop).toList();

      final seasonal = products
          .where((p) => p.section == 'seasonal_specials')
          .map(_mapProduct)
          .toList();
      final popular = products
          .where((p) => p.section == 'popular')
          .map(_mapProduct)
          .toList();
      final orderAgain = products
          .where((p) => p.section == 'order_again')
          .map(_mapProduct)
          .toList();

      return Success(HomeData(
        member: member,
        banners: mappedBanners,
        seasonalSpecials: seasonal,
        popular: popular,
        orderAgain: orderAgain,
        shops: mappedShops,
      ));
    } catch (e) {
      return Error(StorageFailure('Failed to load local data: $e'));
    }
  }

  @override
  Stream<HomeData> watchHomeData() {
    return _db.select(_db.memberProfilesTable).watch().asyncMap((_) async {
      final res = await getHomeData();
      return res.dataOrNull!;
    });
  }

  @override
  Future<Result<ProductItem, Failure>> getProductById(String id) async {
    try {
      await seedInitialDataIfEmpty();
      final query = _db.select(_db.productsTable)..where((tbl) => tbl.id.equals(id));
      final product = await query.getSingleOrNull();

      if (product == null) {
        return const Error(StorageFailure('Product not found in local cache'));
      }
      return Success(_mapProduct(product));
    } catch (e) {
      return Error(StorageFailure('Failed to fetch product: $e'));
    }
  }

  @override
  Future<Result<void, Failure>> refreshData() async {
    await seedInitialDataIfEmpty();
    await Future.delayed(const Duration(milliseconds: 300));
    return const Success(null);
  }

  MemberProfile _mapMember(MemberProfilesTableData m) => MemberProfile(
        id: m.id,
        name: m.name,
        photoUrl: m.photoUrl,
        tier: m.tier,
        points: m.points,
        nextTier: m.nextTier,
        pointsToNextTier: m.pointsToNextTier,
        totalPoints: m.totalPoints,
        unreadNotifications: m.unreadNotifications,
      );

  BannerItem _mapBanner(BannersTableData b) => BannerItem(
        id: b.id,
        title: b.title,
        subtitle: b.subtitle,
        actionUrl: b.actionUrl,
        imageUrl: b.imageUrl,
      );

  ShopItem _mapShop(ShopsTableData s) => ShopItem(
        id: s.id,
        name: s.name,
        address: s.address,
        imageUrl: s.imageUrl,
      );

  ProductItem _mapProduct(ProductsTableData p) => ProductItem(
        id: p.id,
        code: p.code,
        name: p.name,
        priceMmk: p.priceMmk,
        isNew: p.isNew,
        discountPercent: p.discountPercent,
        imageUrl: p.imageUrl,
        description: p.description,
        section: p.section,
      );
}
