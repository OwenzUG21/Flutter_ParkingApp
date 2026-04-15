import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lottie/lottie.dart';
import '../services/booking_service.dart';
import '../database/app_database.dart';
import '../themes/colors.dart';
import '../services/auth_service.dart';
import '../services/theme_service.dart';
import '../services/weather_service.dart';
import '../services/favorites_service.dart';
import '../services/preferences_service.dart';
import '../services/print_service.dart';
import '../widgets/notification_badge.dart';
import 'profile_screen.dart';
import 'community_screen.dart';
import 'settings_screen.dart';
import 'weather_screen.dart';

void main() {
  runApp(const DashboardApp());
}

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkFlex Dashboard',
      theme: ThemeData(primarySwatch: Colors.indigo, fontFamily: 'Roboto'),
      debugShowCheckedModeBanner: false,
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final int? initialTab;

  const DashboardScreen({super.key, this.initialTab});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int selectedNavIndex = 0;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();
  bool _showSearchBar = true;
  double _lastScrollOffset = 0;
  bool _showFavoritesOnly = false;
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

  final List<ParkingLot> _parkingLots = [
    ParkingLot(
      name: 'Acacia Mall Parking',
      location: 'Kololo, Kampala',
      totalSlots: 40,
      availableSlots: 18,
      pricePerHour: 1500,
      imagePath: 'assets/images/bd.jpg',
      rating: 4.5,
    ),
    ParkingLot(
      name: 'Garden City Parking',
      location: 'Kira Rd, Kampala',
      totalSlots: 36,
      availableSlots: 12,
      pricePerHour: 2000,
      imagePath: 'assets/images/Kampala-ciuty.jpg',
      rating: 4.8,
    ),
    ParkingLot(
      name: 'Kampala Road Parking',
      location: 'Central Division',
      totalSlots: 32,
      availableSlots: 9,
      pricePerHour: 1500,
      imagePath: 'assets/images/ka1.jpg',
      rating: 4.2,
    ),
    ParkingLot(
      name: 'Boazi Parking',
      location: '8 Nakasero Ln, Kampala, Uganda',
      totalSlots: 78,
      availableSlots: 45,
      pricePerHour: 3500,
      imagePath: 'assets/images/Jinja-Town.jpg',
      rating: 4.5,
    ),
    ParkingLot(
      name: 'CB Parking Lot',
      location: 'Nkrumah Rd, Kampala, Uganda',
      totalSlots: 68,
      availableSlots: 35,
      pricePerHour: 2800,
      imagePath: 'assets/images/Jinja.jpg',
      rating: 4.2,
    ),
    ParkingLot(
      name: 'Nana Parking Lot B',
      location: 'Sir Apollo Kaggwa Rd, Kampala',
      totalSlots: 84,
      availableSlots: 28,
      pricePerHour: 2200,
      imagePath: 'assets/images/own.webp',
      rating: 4.0,
    ),
    ParkingLot(
      name: 'DUNIA HOUSE PARKING',
      location: 'Nasser Rd, Kampala, Uganda',
      totalSlots: 65,
      availableSlots: 55,
      pricePerHour: 1200,
      imagePath: 'assets/images/bd.jpg',
      rating: 4.5,
    ),
    ParkingLot(
      name: 'Client Parking',
      location: 'Client Parking',
      totalSlots: 55,
      availableSlots: 32,
      pricePerHour: 2500,
      imagePath: 'assets/images/ka1.jpg',
      rating: 4.3,
    ),
  ];

  Timer? _timer;
  final Random _random = Random();
  final WeatherService _weatherService = WeatherService();
  WeatherData? _currentWeather;

  @override
  void initState() {
    super.initState();
    _initializeFavorites();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab ?? 0,
    );

    // Add listener to refresh when tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });

    // Add scroll listener to hide/show search bar
    _scrollController.addListener(_onScroll);

    // Add focus listener to search field
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      setState(() {
        for (final lot in _parkingLots) {
          final delta = _random.nextInt(5) - 2;
          final next =
              (lot.availableSlots + delta).clamp(0, lot.totalSlots).toInt();
          lot.availableSlots = next;
        }
      });
    });

    // Fetch weather data
    _fetchWeather();
  }

  Future<void> _initializeFavorites() async {
    await FavoritesService().initialize();
    if (mounted) setState(() {});
  }

  void _onScroll() {
    final currentOffset = _scrollController.offset;
    final delta = currentOffset - _lastScrollOffset;

    // Only trigger if scrolled more than 10 pixels
    if (delta.abs() > 10) {
      if (delta > 0 && _showSearchBar) {
        // Scrolling down - hide search bar and unfocus search field
        setState(() {
          _showSearchBar = false;
        });
        _searchFocusNode.unfocus();
      } else if (delta < 0 && !_showSearchBar) {
        // Scrolling up - show search bar
        setState(() {
          _showSearchBar = true;
        });
      }
      _lastScrollOffset = currentOffset;
    }

    // Always show search bar when at the top
    if (currentOffset <= 0 && !_showSearchBar) {
      setState(() {
        _showSearchBar = true;
      });
    }
  }

  Future<void> _fetchWeather() async {
    final weather = await _weatherService.getWeather('Kampala');
    if (mounted) {
      setState(() {
        _currentWeather = weather;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  List<ParkingLot> get _filteredParkingLots {
    var filtered = _parkingLots;

    // Apply favorites filter
    if (_showFavoritesOnly) {
      filtered = filtered.where((lot) => lot.isFavorite).toList();
    }

    // Apply search filter
    if (_searchQuery.isEmpty) {
      return filtered;
    }
    return filtered.where((lot) {
      return lot.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          lot.location.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: selectedNavIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && selectedNavIndex != 0) {
          setState(() {
            selectedNavIndex = 0;
          });
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        drawer: _buildDrawer(context),
        body: SafeArea(child: _getSelectedScreen()),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
              child: GNav(
                rippleColor: Colors.grey.withValues(alpha: 0.1),
                hoverColor: Colors.grey.withValues(alpha: 0.05),
                gap: 6,
                activeColor: Colors.white,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: AppColors.redButton,
                color: Colors.grey.shade600,
                textSize: 12,
                tabs: const [
                  GButton(icon: Icons.home_rounded, text: 'Home'),
                  GButton(icon: Icons.groups_rounded, text: 'Community'),
                  GButton(icon: Icons.person_rounded, text: 'Profile'),
                  GButton(icon: Icons.settings_rounded, text: 'Settings'),
                ],
                selectedIndex: selectedNavIndex,
                onTabChange: (index) {
                  setState(() {
                    selectedNavIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getSelectedScreen() {
    switch (selectedNavIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return const CommunityScreen();
      case 2:
        return const ProfileScreen();
      case 3:
        return const SettingsScreen();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      backgroundColor: theme.brightness == Brightness.dark
          ? theme.colorScheme.surface
          : AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: theme.brightness == Brightness.dark
                        ? Container(
                            width: 80,
                            height: 80,
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Lottie.asset(
                              'assets/animations/parking_logo.json',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              repeat: true,
                            ),
                          )
                        : Image.asset(
                            'assets/launcher_icon/pk.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "ParkFlexApp",
                    style: TextStyle(
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF1A1F36),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Smart Parking Solutions",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(
                    icon: Icons.home_rounded,
                    title: 'Home',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => selectedNavIndex = 0);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.local_parking_rounded,
                    title: 'Parking',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        selectedNavIndex = 0;
                        _tabController.animateTo(0);
                      });
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.history_rounded,
                    title: 'Reserves',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        selectedNavIndex = 0;
                        _tabController.animateTo(1);
                      });
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.payment_rounded,
                    title: 'Payment',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        selectedNavIndex = 0;
                        _tabController.animateTo(2);
                      });
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => selectedNavIndex = 3);
                    },
                  ),
                  const SizedBox(height: 8),
                  Divider(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: 8),
                  // Dark Mode Toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.dark_mode,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white.withValues(alpha: 0.9)
                              : const Color(0xFF1A1F36),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Dark Mode',
                            style: TextStyle(
                              color: theme.brightness == Brightness.dark
                                  ? Colors.white.withValues(alpha: 0.95)
                                  : const Color(0xFF1A1F36),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        Switch(
                          value: ThemeService().isDarkMode,
                          onChanged: (value) {
                            ThemeService().toggleTheme();
                          },
                          activeThumbColor: Colors.white,
                          activeTrackColor: const Color(0xFF00A884),
                          inactiveThumbColor: Colors.white70,
                          inactiveTrackColor: Colors.white24,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: 16),
                  _buildDrawerItem(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    onTap: () async {
                      Navigator.pop(context);
                      // Sign out from Firebase
                      await AuthService().signOut();
                      // Navigation handled by AuthWrapper
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color: isDark
            ? Colors.white.withValues(alpha: 0.9)
            : const Color(0xFF1A1F36),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDark
              ? Colors.white.withValues(alpha: 0.95)
              : const Color(0xFF1A1F36),
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
      onTap: onTap,
      hoverColor: isDark
          ? Colors.white.withValues(alpha: 0.1)
          : const Color(0xFF00A884).withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildDashboardContent() {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Professional App Bar
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu, color: theme.colorScheme.primary),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'ParkFlex',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              NotificationBadge(
                onTap: () {
                  Navigator.pushNamed(context, '/notifications').then((_) {
                    // Refresh badge count when returning from notifications screen
                    setState(() {});
                  });
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),

        // Tab Bar
        Container(
          color: theme.colorScheme.surface,
          child: TabBar(
            controller: _tabController,
            indicatorColor: theme.colorScheme.primary,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.brightness == Brightness.dark
                ? Colors.grey.shade400
                : Colors.grey,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(text: 'Parking'),
              Tab(text: 'Reserve'),
              Tab(text: 'Payment'),
            ],
          ),
        ),

        Expanded(
          child: Container(
            color: theme.scaffoldBackgroundColor,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFindParkingTab(),
                _buildReservationsTab(),
                _buildPaymentTab(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFindParkingTab() {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Column(
          children: [
            // Search Bar and Current Location (only in Parking tab) - Animated
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _showSearchBar ? null : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showSearchBar ? 1.0 : 0.0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: theme.scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current Location with Weather on Right
                      Row(
                        children: [
                          // Left side - Location info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: theme.brightness == Brightness.dark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Current Location',
                                      style: TextStyle(
                                        color:
                                            theme.brightness == Brightness.dark
                                                ? Colors.grey.shade400
                                                : Colors.grey.shade600,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Kampala, Uganda',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Right side - Weather info
                          if (_currentWeather != null)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WeatherScreen(currentCity: 'Kampala'),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _currentWeather!.weatherIcon,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${_currentWeather!.temperature.round()}°C',
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          style: TextStyle(color: theme.colorScheme.onSurface),
                          decoration: InputDecoration(
                            hintText: 'Search parking locations...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: theme.brightness == Brightness.dark
                                  ? Colors.grey.shade500
                                  : Colors.grey,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: theme.brightness == Brightness.dark
                                  ? Colors.grey.shade400
                                  : Colors.grey,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: theme.brightness == Brightness.dark
                                          ? Colors.grey.shade400
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : Icon(
                                    Icons.tune,
                                    color: theme.brightness == Brightness.dark
                                        ? Colors.grey.shade400
                                        : Colors.grey,
                                  ),
                          ),
                        ),
                      ),

                      // Show filter chips only when search is focused
                      if (_isSearchFocused) ...[
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              FilterChip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _showFavoritesOnly
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 18,
                                      color: _showFavoritesOnly
                                          ? Colors.red
                                          : null,
                                    ),
                                    const SizedBox(width: 6),
                                    const Text('Favorites'),
                                  ],
                                ),
                                selected: _showFavoritesOnly,
                                onSelected: (selected) {
                                  setState(() {
                                    _showFavoritesOnly = selected;
                                  });
                                },
                                selectedColor:
                                    Colors.red.withValues(alpha: 0.15),
                                checkmarkColor: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Parking Lots Grid
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Unfocus search field when tapping on the parking lots area
                  _searchFocusNode.unfocus();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: _filteredParkingLots.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No parking locations found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try a different search term',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          controller: _scrollController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _filteredParkingLots.length,
                          itemBuilder: (context, index) {
                            return _buildParkingCard(
                                _filteredParkingLots[index]);
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
        // Floating Chat Button
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/chat');
            },
            backgroundColor: AppColors.redButton,
            elevation: 6,
            child: const Icon(
              Icons.chat_bubble_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReservationsTab() {
    return const ReservationsTabContent();
  }

  Widget _buildPaymentTab() {
    return const PaymentTabContent();
  }

  Widget _buildParkingCard(ParkingLot lot) {
    final theme = Theme.of(context);
    final availabilityPercent = lot.availableSlots / lot.totalSlots;
    Color availabilityColor;
    String availabilityText;

    if (availabilityPercent > 0.5) {
      availabilityColor = Colors.green;
      availabilityText = 'Available';
    } else if (availabilityPercent > 0.2) {
      availabilityColor = Colors.orange;
      availabilityText = 'Limited';
    } else {
      availabilityColor = Colors.red;
      availabilityText = 'Almost Full';
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          buildSmoothRoute(ParkingLotDetailsScreen(lot: lot)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with badge overlay
            Stack(
              children: [
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: AssetImage(lot.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Gradient overlay for better text visibility
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Available badge
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: availabilityColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      availabilityText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Rating badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 12),
                        const SizedBox(width: 3),
                        Text(
                          lot.rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Card content
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lot.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 11,
                        color: theme.brightness == Brightness.dark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          lot.location,
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.brightness == Brightness.dark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.circle, size: 6, color: availabilityColor),
                          const SizedBox(width: 4),
                          Text(
                            '${lot.availableSlots}/${lot.totalSlots}',
                            style: TextStyle(
                              fontSize: 10,
                              color: theme.brightness == Brightness.dark
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'UGX ${lot.pricePerHour}/hr',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParkingLot {
  ParkingLot({
    required this.name,
    required this.location,
    required this.totalSlots,
    required this.availableSlots,
    required this.pricePerHour,
    required this.imagePath,
    required this.rating,
  });

  final String name;
  final String location;
  final int totalSlots;
  int availableSlots;
  final int pricePerHour;
  final String imagePath;
  final double rating;

  bool get isFavorite => FavoritesService().isFavorite(name);
}

PageRouteBuilder<dynamic> buildSmoothRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
      final slide = Tween<Offset>(
        begin: const Offset(0.08, 0.02),
        end: Offset.zero,
      ).animate(fade);
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

// Reservations Tab with Sub-tabs
class ReservationsTabContent extends StatefulWidget {
  const ReservationsTabContent({super.key});

  @override
  State<ReservationsTabContent> createState() => _ReservationsTabContentState();
}

class _ReservationsTabContentState extends State<ReservationsTabContent>
    with AutomaticKeepAliveClientMixin {
  int _selectedSubTab = 0;
  final Set<int> _expandedHistoryItems = {};
  final _bookingService = BookingService();
  final _printService = PrintService();

  List<ParkingRecord> _activeBookings = [];
  List<ParkingRecord> _upcomingBookings = [];
  List<ParkingRecord> _completedBookings = [];
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);
    try {
      // Update booking statuses first
      await _bookingService.updateBookingStatuses();

      final active = await _bookingService.getActiveBookings();
      final upcoming = await _bookingService.getUpcomingBookings();
      final completed = await _bookingService.getCompletedBookings();

      if (mounted) {
        setState(() {
          _activeBookings = active;
          _upcomingBookings = upcoming;
          _completedBookings = completed;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading bookings: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh when returning to this tab
    _loadBookings();
  }

  List<ParkingRecord> get _activeReservations => _activeBookings;
  List<ParkingRecord> get _upcomingReservations => _upcomingBookings;
  List<ParkingRecord> get _historyReservations => _completedBookings;

  // Helper method to convert ParkingRecord to Map for UI compatibility
  Map<String, dynamic> _bookingToMap(ParkingRecord booking) {
    final isUpcoming = booking.entryTime.isAfter(DateTime.now());
    final dbPaymentStatus = booking.paymentStatus ?? 'pending';

    String status;
    String displayPaymentStatus;

    if (booking.exitTime != null) {
      // Session has ended - in History
      if (dbPaymentStatus == 'cancelled') {
        status = 'Cancelled';
        displayPaymentStatus = 'cancelled';
      } else if (dbPaymentStatus == 'unpaid') {
        status = 'Completed';
        displayPaymentStatus = 'unpaid';
      } else if (dbPaymentStatus == 'completed' || dbPaymentStatus == 'paid') {
        status = 'Completed';
        displayPaymentStatus = 'paid';
      } else {
        status = 'Completed';
        displayPaymentStatus = dbPaymentStatus;
      }
    } else if (isUpcoming) {
      // Session hasn't started yet - in Upcoming
      status = 'Upcoming';
      displayPaymentStatus =
          dbPaymentStatus; // Keep original: 'pending' or 'paid'
    } else {
      // Session is running - in Active
      status = 'Active';
      displayPaymentStatus =
          dbPaymentStatus; // Keep original: 'pending' or 'paid'
    }

    final duration = booking.duration != null
        ? '${(booking.duration! / 60).ceil()} Hr'
        : '2 Hr';

    return {
      'reservationId': 'RES-${booking.id}',
      'parkingRecordId': booking.id,
      'location': 'Parking Location', // You can enhance this
      'spot': booking.plateNumber,
      'address': 'Slot ${booking.parkingSlot}',
      'date':
          '${booking.entryTime.year}-${booking.entryTime.month.toString().padLeft(2, '0')}-${booking.entryTime.day.toString().padLeft(2, '0')}',
      'time':
          '${booking.entryTime.day}/${booking.entryTime.month}/${booking.entryTime.year}',
      'timeRange':
          '${booking.entryTime.hour.toString().padLeft(2, '0')}:${booking.entryTime.minute.toString().padLeft(2, '0')}',
      'duration': duration,
      'cost': 'UGX ${(booking.amountCharged ?? 0).toStringAsFixed(0)}',
      'status': status,
      'paymentStatus': displayPaymentStatus,
      'imagePath': 'assets/images/bd.jpg',
      'parkingRate': booking.amountCharged ?? 0.0,
      'serviceFee': (booking.amountCharged ?? 0.0) * 0.15,
      'totalCost': (booking.amountCharged ?? 0.0) * 1.15,
      'slotNumber': booking.parkingSlot,
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          // Pill-style Sub-tabs
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surface,
            child: Row(
              children: [
                _buildPillTab('Active Sessions', 0, _activeReservations.length),
                const SizedBox(width: 8),
                _buildPillTab('Upcoming', 1, _upcomingReservations.length),
                const SizedBox(width: 8),
                _buildPillTab('History', 2, _historyReservations.length),
              ],
            ),
          ),
          // Content
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildPillTab(String label, int index, int count) {
    final theme = Theme.of(context);
    final isSelected = _selectedSubTab == index;
    final displayLabel = index == 0 ? label.replaceAll(' Sessions', '') : label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSubTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.brightness == Brightness.dark
                    ? theme.colorScheme.surfaceContainerHighest
                    : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            index == 0 ? displayLabel : '$displayLabel ($count)',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedSubTab) {
      case 0:
        return _buildActiveSessionsContent();
      case 1:
        return _buildUpcomingContent();
      case 2:
        return _buildHistoryContent();
      default:
        return _buildActiveSessionsContent();
    }
  }

  Widget _buildActiveSessionsContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_activeReservations.isEmpty) {
      return _buildEmptyState(
        icon: Icons.event_available,
        title: 'No Active Sessions',
        subtitle: 'You don\'t have any active parking sessions',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _activeReservations.length,
      itemBuilder: (context, index) {
        return _buildModernReservationCard(
          _bookingToMap(_activeReservations[index]),
        );
      },
    );
  }

  Widget _buildUpcomingContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_upcomingReservations.isEmpty) {
      return _buildEmptyState(
        icon: Icons.schedule,
        title: 'No Upcoming Sessions',
        subtitle: 'You don\'t have any upcoming parking sessions',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _upcomingReservations.length,
      itemBuilder: (context, index) {
        return _buildModernReservationCard(
          _bookingToMap(_upcomingReservations[index]),
        );
      },
    );
  }

  Widget _buildHistoryContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_historyReservations.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        title: 'No History',
        subtitle: 'Your past reservations will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _historyReservations.length,
      itemBuilder: (context, index) {
        return _buildHistoryCard(
          _bookingToMap(_historyReservations[index]),
          index,
        );
      },
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> reservation, int index) {
    final theme = Theme.of(context);
    final isExpanded = _expandedHistoryItems.contains(index);
    final paymentStatus = reservation['paymentStatus'] ?? 'pending';

    // Determine status based on payment status
    String status;
    if (paymentStatus == 'cancelled') {
      status = 'Cancelled';
    } else if (paymentStatus == 'unpaid') {
      status = 'Unpaid';
    } else if (paymentStatus == 'completed' || paymentStatus == 'paid') {
      status = 'Completed';
    } else {
      status = reservation['status'] ?? 'Completed';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main Card Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Location and Status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reservation['location'] ?? 'Unknown Location',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            reservation['spot'] ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildStatusPill(status),
                  ],
                ),
                const SizedBox(height: 12),
                // Date Row
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      reservation['time'] ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
                // Expanded Details
                if (isExpanded) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  // Duration and Amount in expanded view
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? theme.colorScheme.surfaceContainerHighest
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Duration',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                reservation['duration'] ?? '2h 0m',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Amount',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                reservation['cost'] ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                // Action Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          // Print reservation
                          try {
                            await _printService.printBookingReceipt(
                              location:
                                  reservation['location'] ?? 'Unknown Location',
                              spot: reservation['spot'] ?? 'N/A',
                              time: reservation['time'] ?? '',
                              cost: reservation['cost'] ?? '0',
                              status: status,
                            );
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to print: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.print, size: 16),
                        label: const Text('Print'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                          side: BorderSide(
                            color: theme.brightness == Brightness.dark
                                ? theme.colorScheme.outline
                                : Colors.grey.shade300,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            if (isExpanded) {
                              _expandedHistoryItems.remove(index);
                            } else {
                              _expandedHistoryItems.add(index);
                            }
                          });
                        },
                        icon: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          size: 16,
                        ),
                        label: Text(isExpanded ? 'View Less' : 'View More'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                          side: BorderSide(
                            color: theme.brightness == Brightness.dark
                                ? theme.colorScheme.outline
                                : Colors.grey.shade300,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color bgColor;
    Color dotColor;

    switch (status.toLowerCase()) {
      case 'cancelled':
        bgColor = Colors.red.shade50;
        dotColor = Colors.red.shade600;
        break;
      case 'completed':
        bgColor = Colors.green.shade50;
        dotColor = Colors.green.shade600;
        break;
      case 'unpaid':
        bgColor = Colors.orange.shade50;
        dotColor = Colors.orange.shade600;
        break;
      default:
        bgColor = Colors.grey.shade100;
        dotColor = Colors.grey.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: dotColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernReservationCard(Map<String, dynamic> reservation) {
    final theme = Theme.of(context);
    final status = reservation['status'] ?? 'Active';
    final paymentStatus = reservation['paymentStatus'] ?? 'Payment pending';
    final reservationId = reservation['reservationId'] ?? 'Unknown';

    // Debug logging
    print(
      '🎴 Building card for $reservationId - Status: $status, Payment: $paymentStatus',
    );

    // Normalize payment status display
    String displayPaymentStatus;
    if (paymentStatus == 'paid' ||
        paymentStatus == 'Payment completed' ||
        paymentStatus == 'Paid') {
      displayPaymentStatus = 'Paid';
    } else if (paymentStatus == 'pending' ||
        paymentStatus == 'Payment pending') {
      displayPaymentStatus = 'Pending';
    } else if (paymentStatus == 'unpaid') {
      displayPaymentStatus = 'Unpaid';
    } else if (paymentStatus == 'cancelled') {
      displayPaymentStatus = 'Cancelled';
    } else {
      displayPaymentStatus = paymentStatus;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Header with Reservation ID
          Stack(
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      reservation['imagePath'] ?? 'assets/images/bd.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    reservation['reservationId'] ?? 'RES-1',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Card Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reservation['spot'] ?? 'ZCDV',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            reservation['location'] ?? 'Boazi Parking',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            reservation['address'] ??
                                '8 Nakasero Ln, Kampala, Uganda',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: status == 'Active'
                                ? Colors.green.shade500
                                : Colors.orange.shade500,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                paymentStatus.toLowerCase().contains('pending')
                                    ? Colors.orange.shade50
                                    : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            displayPaymentStatus,
                            style: TextStyle(
                              color: paymentStatus.toLowerCase().contains(
                                        'pending',
                                      )
                                  ? Colors.orange.shade700
                                  : Colors.green.shade700,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          reservation['cost'] ?? 'UGX 5000.00',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Details Grid
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? theme.colorScheme.surfaceContainerHighest
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildDetailItem(
                          'Date',
                          reservation['date'] ?? '2026-03-06',
                        ),
                      ),
                      Expanded(
                        child: _buildDetailItem(
                          'Time',
                          reservation['timeRange'] ?? '17:55 - 19:55',
                        ),
                      ),
                      Expanded(
                        child: _buildDetailItem(
                          'Duration',
                          reservation['duration'] ?? '2h 0m',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? theme.colorScheme.surfaceContainerHighest
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildDetailItem(
                          'Vehicle',
                          reservation['spot'] ?? 'ZCDV',
                        ),
                      ),
                      Expanded(
                        child: _buildDetailItem(
                          'Payment',
                          displayPaymentStatus,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // View Pass
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'View Pass',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          // Print
                          try {
                            await _printService.printBookingReceipt(
                              location:
                                  reservation['location'] ?? 'Unknown Location',
                              spot: reservation['spot'] ?? 'N/A',
                              time: reservation['time'] ??
                                  reservation['timeRange'] ??
                                  '',
                              cost: reservation['cost'] ?? '0',
                              status: reservation['status'] ?? 'Active',
                            );
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to print: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: theme.colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Print',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (paymentStatus.toLowerCase().contains('pending'))
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to Reservation Details screen to pay
                            final resId = reservation['reservationId'];
                            print(
                              '💳 Navigating to payment for reservation: $resId',
                            );
                            print(
                              '   Current payment status: ${reservation['paymentStatus']}',
                            );

                            Navigator.pushNamed(
                              context,
                              '/reservation',
                              arguments: {
                                'reservationId': reservation['reservationId'],
                                'parkingRecordId':
                                    reservation['parkingRecordId'],
                                'parkingName': reservation['location'],
                                'parkingLocation': reservation['address'],
                                'date': DateTime.tryParse(
                                      reservation['date'] ?? '',
                                    ) ??
                                    DateTime.now(),
                                'duration': reservation['duration'],
                                'hours': int.tryParse(
                                      reservation['duration']
                                              ?.toString()
                                              .replaceAll(
                                                RegExp(r'[^0-9]'),
                                                '',
                                              ) ??
                                          '2',
                                    ) ??
                                    2,
                                'parkingRate': (reservation['parkingRate']
                                            is double
                                        ? (reservation['parkingRate'] as double)
                                            .toInt()
                                        : reservation['parkingRate']) ??
                                    10000,
                                'serviceFee': (reservation['serviceFee']
                                            is double
                                        ? (reservation['serviceFee'] as double)
                                            .toInt()
                                        : reservation['serviceFee']) ??
                                    1500,
                                'totalCost': (reservation['totalCost'] is double
                                        ? (reservation['totalCost'] as double)
                                            .toInt()
                                        : reservation['totalCost']) ??
                                    11500,
                                'slotNumber': int.tryParse(
                                  reservation['slotNumber']?.toString() ?? '',
                                ),
                                'vehiclePlate': reservation['spot'],
                                'imagePath': reservation['imagePath'],
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Pay Now',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    if (paymentStatus.toLowerCase().contains('pending'))
                      const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: const Text('End Session'),
                              content: const Text(
                                'Are you sure you want to end this parking session?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    // End the session by canceling the booking
                                    try {
                                      final bookingId =
                                          reservation['parkingRecordId'];
                                      await _bookingService.cancelBooking(
                                        bookingId,
                                      );
                                      Navigator.pop(dialogContext);
                                      // Refresh the UI
                                      await _loadBookings();

                                      // Show success message
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: const Row(
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 12),
                                                Text(
                                                  'Session ended successfully',
                                                ),
                                              ],
                                            ),
                                            backgroundColor:
                                                Colors.green.shade600,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      Navigator.pop(dialogContext);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Error ending session: $e',
                                            ),
                                            backgroundColor:
                                                Colors.red.shade600,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade600,
                                  ),
                                  child: const Text('End Session'),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'End Session',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF111827),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class ParkingLotDetailsScreen extends StatefulWidget {
  const ParkingLotDetailsScreen({super.key, required this.lot});

  final ParkingLot lot;

  @override
  State<ParkingLotDetailsScreen> createState() =>
      _ParkingLotDetailsScreenState();
}

class _ParkingLotDetailsScreenState extends State<ParkingLotDetailsScreen> {
  final Set<int> _bookedSlots = {};
  int? _selectedSlot;

  @override
  void initState() {
    super.initState();
    _generateBookedSlots();
  }

  void _generateBookedSlots() {
    final random = Random(widget.lot.totalSlots * 7);
    final total = widget.lot.totalSlots;
    final bookedCount = max(4, total - widget.lot.availableSlots);
    while (_bookedSlots.length < bookedCount) {
      _bookedSlots.add(random.nextInt(total) + 1);
    }
  }

  void _openBooking(int slotNumber) {
    setState(() {
      _selectedSlot = slotNumber;
    });

    Navigator.pushNamed(
      context,
      '/booking',
      arguments: {
        'parkingName': widget.lot.name,
        'parkingLocation': widget.lot.location,
        'spacesLeft': widget.lot.availableSlots,
        'pricePerHour': widget.lot.pricePerHour,
        'slotNumber': slotNumber,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final availableCount = widget.lot.availableSlots;
    final totalCount = widget.lot.totalSlots;
    final occupancyRate =
        ((totalCount - availableCount) / totalCount * 100).toInt();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Hero Image Header with Gradient
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.lot.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.lot.isFavorite ? Colors.red : Colors.grey,
                    size: 20,
                  ),
                ),
                onPressed: () async {
                  await FavoritesService().toggleFavorite(widget.lot.name);
                  setState(() {});
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  Image.asset(widget.lot.imagePath, fit: BoxFit.cover),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  // Content
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.lot.rating.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: availableCount > 10
                                    ? Colors.green
                                    : Colors.orange,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$availableCount Available',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.lot.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white70,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                widget.lot.location,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Info Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.attach_money,
                          title: 'Price',
                          value: 'UGX ${widget.lot.pricePerHour}',
                          subtitle: 'per hour',
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.local_parking,
                          title: 'Capacity',
                          value: '$totalCount',
                          subtitle: 'total slots',
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.pie_chart,
                          title: 'Occupancy',
                          value: '$occupancyRate%',
                          subtitle: 'occupied',
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Slot Selection Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Your Parking Slot',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap on an available slot to proceed with booking',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Legend
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildLegendItem(
                            color: const Color(0xFF5B6B9E),
                            label: 'Available',
                            icon: Icons.check_circle_outline,
                          ),
                          _buildLegendItem(
                            color: Colors.green,
                            label: 'Selected',
                            icon: Icons.check_circle,
                          ),
                          _buildLegendItem(
                            color: Colors.grey.shade300,
                            label: 'Occupied',
                            icon: Icons.cancel_outlined,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Parking Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.95,
                        ),
                        itemCount: widget.lot.totalSlots,
                        itemBuilder: (context, index) {
                          final slotNumber = index + 1;
                          final isBooked = _bookedSlots.contains(slotNumber);
                          final isSelected = _selectedSlot == slotNumber;

                          return _buildParkingSlot(
                            slotNumber: slotNumber,
                            isBooked: isBooked,
                            isSelected: isSelected,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Facilities Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Facilities & Features',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildFacilityChip(Icons.security, 'CCTV Security'),
                            _buildFacilityChip(Icons.wb_sunny, '24/7 Access'),
                            _buildFacilityChip(Icons.ev_station, 'EV Charging'),
                            _buildFacilityChip(
                              Icons.accessible,
                              'Wheelchair Access',
                            ),
                            _buildFacilityChip(
                              Icons.local_car_wash,
                              'Car Wash',
                            ),
                            _buildFacilityChip(Icons.wifi, 'Free WiFi'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),

      // Bottom Action Bar
      bottomNavigationBar: _selectedSlot != null
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Slot S$_selectedSlot Selected',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'UGX ${widget.lot.pricePerHour}/hour',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _openBooking(_selectedSlot!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required IconData icon,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildParkingSlot({
    required int slotNumber,
    required bool isBooked,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    Color bgColor;
    Color borderColor;
    Color iconColor;
    Color textColor;

    if (isBooked) {
      bgColor = theme.brightness == Brightness.dark
          ? theme.colorScheme.surfaceContainerHighest
          : Colors.grey.shade100;
      borderColor = theme.brightness == Brightness.dark
          ? theme.colorScheme.outline
          : Colors.grey.shade300;
      iconColor = theme.colorScheme.onSurface.withValues(alpha: 0.4);
      textColor = theme.colorScheme.onSurface.withValues(alpha: 0.4);
    } else if (isSelected) {
      bgColor = Colors.green.shade50;
      borderColor = Colors.green;
      iconColor = Colors.green;
      textColor = Colors.green.shade700;
    } else {
      bgColor = theme.colorScheme.primary.withValues(alpha: 0.05);
      borderColor = theme.colorScheme.primary.withValues(alpha: 0.3);
      iconColor = theme.colorScheme.primary;
      textColor = theme.colorScheme.primary;
    }

    return GestureDetector(
      onTap: isBooked ? null : () => _openBooking(slotNumber),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 2.5 : 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isBooked ? Icons.cancel : Icons.local_parking,
              size: 24,
              color: iconColor,
            ),
            const SizedBox(height: 4),
            Text(
              'S$slotNumber',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityChip(IconData icon, String label) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Payment Tab Content with Beautiful Cards
class PaymentTabContent extends StatefulWidget {
  const PaymentTabContent({super.key});

  @override
  State<PaymentTabContent> createState() => _PaymentTabContentState();
}

class _PaymentTabContentState extends State<PaymentTabContent> {
  bool _showAllHistory = false;
  final int _maxVisibleHistory = 3;
  final _bookingService = BookingService();
  List<ParkingRecord> _allBookings = [];
  List<ParkingRecord> _activeBookings = [];
  bool _isLoading = true;
  PreferencesService? _prefsService;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _loadBookings();
  }

  Future<void> _initPrefs() async {
    _prefsService = await PreferencesService.getInstance();
    if (mounted) setState(() {});
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);
    try {
      await _bookingService.updateBookingStatuses();
      final bookings = await _bookingService.getAllBookings();
      final active = await _bookingService.getActiveBookings();
      if (mounted) {
        setState(() {
          _allBookings = bookings;
          _activeBookings = active;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading bookings: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  double get _totalSpent {
    double total = 0;
    for (final booking in _allBookings) {
      total += booking.amountCharged ?? 0;
    }
    return total;
  }

  double get _activeSessionCost {
    double total = 0;
    for (final booking in _activeBookings) {
      if (booking.paymentStatus == 'paid' ||
          booking.paymentStatus == 'completed') {
        total += booking.amountCharged ?? 0;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final visiblePayments = _showAllHistory
        ? _allBookings
        : _allBookings.take(_maxVisibleHistory).toList();

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Secure Badge
            _buildHeader(),
            const SizedBox(height: 20),

            // Stats Cards
            _buildStatsCards(),
            const SizedBox(height: 24),

            // Payment Methods Section
            _buildPaymentMethodsSection(),
            const SizedBox(height: 24),

            // Billing History Section
            _buildBillingHistorySection(visiblePayments, _allBookings.length),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payments & Billing',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your payment methods and view history',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Secure',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    final hasActiveSession =
        _activeBookings.isNotEmpty && _activeSessionCost > 0;
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Total Spent (Monthly)',
            value: 'UGX ${_totalSpent.toStringAsFixed(2)}',
            icon: Icons.trending_up,
            iconColor: Colors.blue,
            meta: '0% from last month',
            metaColor: Colors.grey,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Active Session Cost',
            value: 'UGX ${_activeSessionCost.toStringAsFixed(2)}',
            icon: Icons.access_time,
            iconColor: hasActiveSession ? Colors.orange : Colors.grey,
            meta: hasActiveSession ? 'Currently active' : 'No active session',
            metaColor: hasActiveSession ? Colors.orange : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required String meta,
    required Color metaColor,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            meta,
            style: TextStyle(fontSize: 11, color: metaColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsSection() {
    final theme = Theme.of(context);
    final mtnNumber = _prefsService?.getMtnNumber();
    final airtelNumber = _prefsService?.getAirtelNumber();
    final mastercardNumber = _prefsService?.getMastercardNumber();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Saved Payment Methods',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add New'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPaymentMethodCard(
                  title: 'MTN Mobile Money',
                  subtitle: mtnNumber ?? 'Add during payment',
                  imagePath: 'assets/lines/mtn.png',
                  buttonText: 'Add',
                  phoneNumber: mtnNumber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPaymentMethodCard(
                  title: 'Airtel Money',
                  subtitle: airtelNumber ?? 'Add during payment',
                  imagePath: 'assets/lines/aritel.png',
                  buttonText: 'Add',
                  phoneNumber: airtelNumber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodCard(
            title: 'Visa or Mastercard',
            subtitle: mastercardNumber ?? 'Add a card during payment',
            imagePath: null,
            buttonText: 'Manage',
            icon: Icons.credit_card,
            phoneNumber: mastercardNumber,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required String title,
    required String subtitle,
    String? imagePath,
    IconData? icon,
    required String buttonText,
    String? phoneNumber,
  }) {
    final theme = Theme.of(context);
    final bool hasPaymentMethod = phoneNumber != null && phoneNumber.isNotEmpty;

    // If payment method is saved and has image, show full background design
    if (hasPaymentMethod && imagePath != null) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.6),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    phoneNumber,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // Default card design (when no payment method is saved)
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? theme.colorScheme.surfaceContainerHighest
            : const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? theme.colorScheme.outline
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          if (imagePath != null)
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            )
          else if (icon != null)
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 28, color: theme.colorScheme.primary),
            ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingHistorySection(
    List<ParkingRecord> visiblePayments,
    int totalCount,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Billing History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$totalCount',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (visiblePayments.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 60,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No transactions yet',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          else
            ...visiblePayments.map((payment) => _buildHistoryItem(payment)),
          if (totalCount > _maxVisibleHistory)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showAllHistory = !_showAllHistory;
                    });
                  },
                  icon: Icon(
                    _showAllHistory
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                  ),
                  label: Text(
                    _showAllHistory
                        ? 'Show Less'
                        : 'View All (${totalCount - _maxVisibleHistory} more)',
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(ParkingRecord payment) {
    final theme = Theme.of(context);
    final provider = payment.paymentMethod ?? 'Cash';
    final phone = payment.plateNumber; // Use plate number
    final location = 'Slot ${payment.parkingSlot}';
    final time =
        '${payment.entryTime.day}/${payment.entryTime.month}/${payment.entryTime.year}';
    final cost = 'UGX ${(payment.amountCharged ?? 0).toStringAsFixed(0)}';

    Color providerColor = Colors.grey;
    if (provider.toLowerCase().contains('mtn')) {
      providerColor = Colors.yellow.shade700;
    } else if (provider.toLowerCase().contains('airtel')) {
      providerColor = Colors.red.shade600;
    } else if (provider == 'Africell') {
      providerColor = Colors.blue.shade700;
    } else if (provider == 'M-Cash') {
      providerColor = Colors.green.shade700;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? theme.colorScheme.surfaceContainerHighest
            : const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? theme.colorScheme.outline
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            time,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 2,
                child: Text(
                  cost,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: providerColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: providerColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    provider,
                    style: TextStyle(
                      color: providerColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.phone_android,
                size: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  phone,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check_circle, size: 14, color: Colors.green),
                    SizedBox(width: 4),
                    Text(
                      'Paid',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
