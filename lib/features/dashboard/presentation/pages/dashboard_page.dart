import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikmart/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quikmart/features/auth/presentation/bloc/auth_event.dart';
import 'package:quikmart/features/auth/presentation/pages/login_page.dart';
import 'package:quikmart/features/dashboard/presentation/widgets/custom_appbar.dart';
import 'package:quikmart/features/dashboard/presentation/widgets/error_state.dart';
import 'package:quikmart/features/dashboard/presentation/widgets/floating_cart_button.dart';
import 'package:quikmart/features/dashboard/presentation/widgets/product_card.dart';
import 'package:quikmart/features/dashboard/presentation/widgets/promo_banner.dart';
import 'package:quikmart/features/cart/presentation/pages/cart_page.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardBloc>()..add(FetchDashboardDataEvent()),

      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoading || state is DashboardInitial) {
                  return CustomScrollView(
                    slivers: [
                      QuickMartAppBar(
                        title: 'QuikMart',
                        iconPath: 'assets/images/app_icon.png',
                        onLogoutTap: () {
                          _showClearCartDialog(context);
                        },
                        onCartTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CartPage()),
                          );
                        },
                      ),
                      _buildShimmerCategoryList(),
                      _buildShimmerProductGrid(),
                      const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
                    ],
                  );
                } else if (state is DashboardError) {
                  return ErrorState(message: state.message);
                } else if (state is DashboardLoaded) {
                  return CustomScrollView(
                    slivers: [
                      QuickMartAppBar(
                        title: 'QuikMart',
                        iconPath: 'assets/images/app_icon.png',
                        onLogoutTap: () {
                          _showClearCartDialog(context);
                        },
                        onCartTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CartPage()),
                          );
                        },
                      ),
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: PromoBanner(),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 70,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            itemCount: state.categories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Chip(
                                  label: Text(
                                    state.categories[index].name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  backgroundColor: AppColors.primary,
                                  side: BorderSide.none,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.65,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final product = state.products[index];
                            return ProductCard(product: product);
                          }, childCount: state.products.length),
                        ),
                      ),
                      const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
            FloatingCartButton()
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildShimmerCategoryList() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 70,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  SliverPadding _buildShimmerProductGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        }, childCount: 4),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to Logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false, // Clears the navigation stack
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
