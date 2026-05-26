import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _cardController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _cardFade;

  final TextEditingController _searchController = TextEditingController();
  int _selectedCategory = 0;
  bool _isSearchFocused = false;

  final List<String> _categories = [
    'All', 'Tech', 'Fashion', 'Home', 'Beauty', 'Toys', 'Sports',
  ];

  final List<Map<String, dynamic>> _trendingDeals = [
    {
      'name': 'Sony WH-1000XM5',
      'category': 'Tech',
      'bestPrice': '₹24,990',
      'originalPrice': '₹34,990',
      'discount': '29%',
      'stores': 8,
      'rating': 4.7,
      'trend': 'dropping',
      'aiScore': 94,
    },
    {
      'name': 'Nike Air Max 270',
      'category': 'Fashion',
      'bestPrice': '₹7,499',
      'originalPrice': '₹12,995',
      'discount': '42%',
      'stores': 5,
      'rating': 4.5,
      'trend': 'stable',
      'aiScore': 87,
    },
    {
      'name': 'Dyson V12 Detect',
      'category': 'Home',
      'bestPrice': '₹44,900',
      'originalPrice': '₹52,900',
      'discount': '15%',
      'stores': 4,
      'rating': 4.8,
      'trend': 'dropping',
      'aiScore': 91,
    },
    {
      'name': 'iPad Air M2',
      'category': 'Tech',
      'bestPrice': '₹59,900',
      'originalPrice': '₹69,900',
      'discount': '14%',
      'stores': 6,
      'rating': 4.9,
      'trend': 'rising',
      'aiScore': 78,
    },
  ];

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _cardFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      _headerController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _cardController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0E),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([_headerController, _cardController]),
          builder: (context, child) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SlideTransition(
                    position: _headerSlide,
                    child: FadeTransition(
                      opacity: _headerFade,
                      child: _buildHeader(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _headerFade,
                    child: _buildSearchBar(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _headerFade,
                    child: _buildCategories(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _cardFade,
                    child: _buildAIBanner(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _cardFade,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Trending deals',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFE8E0CC),
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            'See all',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFFE8C547).withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return FadeTransition(
                        opacity: _cardFade,
                        child: TweenAnimationBuilder<Offset>(
                          tween: Tween(
                            begin: const Offset(0, 40),
                            end: Offset.zero,
                          ),
                          duration: Duration(milliseconds: 500 + (index * 100)),
                          curve: Curves.easeOut,
                          builder: (context, offset, child) {
                            return Transform.translate(
                              offset: offset,
                              child: child,
                            );
                          },
                          child: _buildDealCard(_trendingDeals[index]),
                        ),
                      );
                    },
                    childCount: _trendingDeals.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good evening 👋',
                style: TextStyle(
                  fontSize: 13,
                  color: const Color(0xFFE8E0CC).withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Find your best deal.',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE8E0CC),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF13131E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1e1e2a), width: 0.5),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFFE8C547),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: const Color(0xFF13131E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _isSearchFocused
                ? const Color(0xFFE8C547).withOpacity(0.5)
                : const Color(0xFF1e1e2a),
            width: _isSearchFocused ? 1.0 : 0.5,
          ),
          boxShadow: _isSearchFocused
              ? [
                  BoxShadow(
                    color: const Color(0xFFE8C547).withOpacity(0.08),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: TextField(
          controller: _searchController,
          onTap: () => setState(() => _isSearchFocused = true),
          onEditingComplete: () => setState(() => _isSearchFocused = false),
          style: const TextStyle(color: Color(0xFFE8E0CC), fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search any product...',
            hintStyle: TextStyle(
              color: const Color(0xFFE8E0CC).withOpacity(0.25),
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFFE8C547),
              size: 20,
            ),
            suffixIcon: Icon(
              Icons.tune_rounded,
              color: const Color(0xFFE8E0CC).withOpacity(0.3),
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFE8C547)
                    : const Color(0xFF13131E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFE8C547)
                      : const Color(0xFF1e1e2a),
                  width: 0.5,
                ),
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF0A0A0E)
                      : const Color(0xFF6a6a7a),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAIBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1a1500), Color(0xFF13131E)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE8C547).withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFE8C547).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Color(0xFFE8C547),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Price Intelligence',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE8E0CC),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Analysing 50+ stores in real time',
                    style: TextStyle(fontSize: 11, color: Color(0xFF6a6a7a)),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFE8C547),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Active',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0A0A0E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDealCard(Map<String, dynamic> deal) {
    final trendColor = deal['trend'] == 'dropping'
        ? const Color(0xFF2ECC71)
        : deal['trend'] == 'rising'
            ? const Color(0xFFE8314A)
            : const Color(0xFF6a6a7a);

    final trendIcon = deal['trend'] == 'dropping'
        ? Icons.trending_down_rounded
        : deal['trend'] == 'rising'
            ? Icons.trending_up_rounded
            : Icons.trending_flat_rounded;

    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF10101A),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF1e1e2a), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    deal['name'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE8E0CC),
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0e1a0a),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF2ECC71).withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome,
                          size: 10, color: Color(0xFF2ECC71)),
                      const SizedBox(width: 3),
                      Text(
                        '${deal['aiScore']}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2ECC71),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  deal['bestPrice'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE8C547),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  deal['originalPrice'],
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color(0xFFE8E0CC).withOpacity(0.3),
                    decoration: TextDecoration.lineThrough,
                    decorationColor: const Color(0xFFE8E0CC).withOpacity(0.3),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2ECC71).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '-${deal['discount']}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2ECC71),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(trendIcon, size: 14, color: trendColor),
                const SizedBox(width: 4),
                Text(
                  'Price ${deal['trend']}',
                  style: TextStyle(fontSize: 11, color: trendColor),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.storefront_outlined,
                    size: 13, color: Color(0xFF6a6a7a)),
                const SizedBox(width: 4),
                Text(
                  '${deal['stores']} stores',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6a6a7a),
                  ),
                ),
                const Spacer(),
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      i < (deal['rating'] as double).floor()
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 12,
                      color: const Color(0xFFE8C547),
                    );
                  }),
                ),
                const SizedBox(width: 4),
                Text(
                  '${deal['rating']}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6a6a7a),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D16),
        border: Border(
          top: BorderSide(color: Color(0xFF1e1e2a), width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_rounded, 'Home', true),
          _navItem(Icons.search_rounded, 'Search', false),
          _navItem(Icons.bookmark_outline_rounded, 'Saved', false),
          _navItem(Icons.person_outline_rounded, 'Profile', false),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFFE8C547) : const Color(0xFF3a3a4a),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive
                ? const Color(0xFFE8C547)
                : const Color(0xFF3a3a4a),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}