import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const ClearPaintApp(),
    ),
  );
}

// ==========================================
// STATE MANAGEMENT
// ==========================================

class Estimate {
  final String id;
  final String roomName;
  final double length;
  final double width;
  final double height;
  final bool paintWalls;
  final bool paintCeiling;
  final double doorsWindowsArea;
  final int coats;
  final double coverage;
  final double wasteAllowance;
  final DateTime date;

  // Calculated fields
  final double totalLiters;

  Estimate({
    required this.id,
    required this.roomName,
    required this.length,
    required this.width,
    required this.height,
    required this.paintWalls,
    required this.paintCeiling,
    required this.doorsWindowsArea,
    required this.coats,
    required this.coverage,
    required this.wasteAllowance,
    required this.date,
    required this.totalLiters,
  });
}

class AppState extends ChangeNotifier {
  bool _isDarkMode = false;
  List<Estimate> _savedEstimates = [];

  bool get isDarkMode => _isDarkMode;
  List<Estimate> get savedEstimates => List.unmodifiable(_savedEstimates);

  void toggleTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }

  void saveEstimate(Estimate estimate) {
    _savedEstimates.insert(0, estimate);
    notifyListeners();
  }

  void deleteEstimate(String id) {
    _savedEstimates.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}

// ==========================================
// THEME & CONSTANTS
// ==========================================

class AppColors {
  static const Color primary = Color(0xFF1E6654); // Deep Green
  static const Color backgroundLight = Color(0xFFF6F5F0); // Cream
  static const Color cardLight = Colors.white;
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textGrey = Color(0xFF757575);
  static const Color accentLight = Color(0xFFA8D5C5); // Light Green

  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFFF6F5F0);
  static const Color inputDark = Color(0xFF2C2C2C);
}

ThemeData get lightTheme => ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.backgroundLight,
  primaryColor: AppColors.primary,
  cardColor: AppColors.cardLight,
  dividerColor: Colors.grey.shade300,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    surface: AppColors.cardLight,
    onSurface: AppColors.textDark,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textDark, letterSpacing: -1),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.textGrey),
  ),
  useMaterial3: true,
);

ThemeData get darkTheme => ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  primaryColor: AppColors.accentLight,
  cardColor: AppColors.cardDark,
  dividerColor: Colors.grey.shade800,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.accentLight,
    surface: AppColors.cardDark,
    onSurface: AppColors.textLight,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textLight, letterSpacing: -1),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textLight),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.textGrey),
  ),
  useMaterial3: true,
);

class ClearPaintApp extends StatelessWidget {
  const ClearPaintApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return MaterialApp(
      title: 'Clear Paint',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const MainNavigator(),
    );
  }
}

// ==========================================
// NAVIGATION & LAYOUT
// ==========================================

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const EstimateInputScreen(),
    const SavedScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: Theme.of(context).cardColor,
        indicatorColor: Theme.of(context).brightness == Brightness.light
            ? AppColors.accentLight.withOpacity(0.5)
            : AppColors.primary.withOpacity(0.5),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.edit_outlined), label: 'Estimate'),
          NavigationDestination(icon: Icon(Icons.bookmark_border), label: 'Saved'),
          NavigationDestination(icon: Icon(Icons.tune), label: 'Settings'),
        ],
      ),
    );
  }
}

// ==========================================
// SHARED WIDGETS
// ==========================================

class AppHeader extends StatelessWidget {
  final String subtitle;
  const AppHeader({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.format_paint,
              color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Clear Paint', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
              Text(subtitle, style: TextStyle(fontSize: 10, letterSpacing: 1.2, color: Theme.of(context).textTheme.bodyMedium?.color)),
            ],
          ),
          const Spacer(),
          // Profile placeholder
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFFC4A470), // Gold/Brown color
              shape: BoxShape.circle,
            ),
          )
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String number;
  final String title;
  const SectionTitle({super.key, required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
      child: Row(
        children: [
          Text(number, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String suffix;
  final TextEditingController controller;
  final bool isDark;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.suffix,
    required this.controller,
    required this.isDark,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputDark : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: onChanged,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixText: suffix,
              suffixStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// SCREEN 1: ESTIMATE INPUT
// ==========================================

class EstimateInputScreen extends StatefulWidget {
  const EstimateInputScreen({super.key});

  @override
  State<EstimateInputScreen> createState() => _EstimateInputScreenState();
}

class _EstimateInputScreenState extends State<EstimateInputScreen> {
  final _lengthController = TextEditingController(text: '4');
  final _widthController = TextEditingController(text: '3');
  final _heightController = TextEditingController(text: '2.5');
  final _doorsController = TextEditingController(text: '3');
  final _coverageController = TextEditingController(text: '10');

  bool _paintWalls = true;
  bool _paintCeiling = false;
  int _coats = 2;
  int _waste = 10;

  void _calculateAndNavigate() {
    double l = double.tryParse(_lengthController.text) ?? 0;
    double w = double.tryParse(_widthController.text) ?? 0;
    double h = double.tryParse(_heightController.text) ?? 0;
    double doors = double.tryParse(_doorsController.text) ?? 0;
    double coverage = double.tryParse(_coverageController.text) ?? 10;

    double wallArea = 2 * (l + w) * h;
    double ceilingArea = l * w;
    double grossArea = 0;

    if (_paintWalls) grossArea += wallArea;
    if (_paintCeiling) grossArea += ceilingArea;

    double netArea = grossArea - doors;
    if (netArea < 0) netArea = 0;

    double totalLiters = (netArea * _coats) / coverage;
    double finalLiters = totalLiters * (1 + (_waste / 100));

    final estimate = Estimate(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      roomName: 'Living room', // Hardcoded for demo purposes
      length: l, width: w, height: h,
      paintWalls: _paintWalls, paintCeiling: _paintCeiling,
      doorsWindowsArea: doors, coats: _coats, coverage: coverage, wasteAllowance: _waste.toDouble(),
      date: DateTime.now(),
      totalLiters: finalLiters,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(estimate: estimate)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppHeader(subtitle: 'QUANTITY ESTIMATOR'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('A little measure.\nA clear estimate.',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(height: 1.1)),
                const SizedBox(height: 8),
                const Text('Plan your paint, without the guesswork.', style: TextStyle(color: AppColors.textGrey)),
                const SizedBox(height: 24),

                // Room Name Selector
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.home_outlined, size: 20),
                      const SizedBox(width: 8),
                      const Text('Living room', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Icon(Icons.edit_outlined, size: 18, color: Theme.of(context).primaryColor),
                    ],
                  ),
                ),

                const SectionTitle(number: '01', title: 'Room dimensions'),

                // Metric / Imperial Toggle
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.primary.withOpacity(0.3) : const Color(0xFFD3EADD),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isDark ? AppColors.primary : AppColors.primary),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check, size: 16, color: isDark ? AppColors.accentLight : AppColors.primary),
                              const SizedBox(width: 4),
                              Text('Metric · m', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.accentLight : AppColors.primary)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(child: Text('Imperial · ft', style: TextStyle(color: Colors.grey.shade500))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Dimensions Input
                Row(
                  children: [
                    Expanded(child: CustomTextField(label: 'Length', suffix: 'm', controller: _lengthController, isDark: isDark)),
                    const SizedBox(width: 12),
                    Expanded(child: CustomTextField(label: 'Width', suffix: 'm', controller: _widthController, isDark: isDark)),
                    const SizedBox(width: 12),
                    Expanded(child: CustomTextField(label: 'Height', suffix: 'm', controller: _heightController, isDark: isDark)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.info_outline, size: 14, color: AppColors.textGrey),
                    SizedBox(width: 4),
                    Text('Inside measurements, from floor to ceiling.', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                  ],
                ),

                const SectionTitle(number: '02', title: 'What are you painting?'),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _paintWalls = !_paintWalls),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _paintWalls ? (isDark ? AppColors.primary.withOpacity(0.3) : const Color(0xFFD3EADD)) : (isDark ? AppColors.cardDark : Colors.white),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _paintWalls ? AppColors.primary : (isDark ? Colors.grey.shade800 : Colors.grey.shade300)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(_paintWalls ? Icons.check_box : Icons.check_box_outline_blank,
                                  color: _paintWalls ? (isDark ? AppColors.accentLight : AppColors.primary) : Colors.grey),
                              const SizedBox(width: 8),
                              const Text('Walls', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _paintCeiling = !_paintCeiling),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _paintCeiling ? (isDark ? AppColors.primary.withOpacity(0.3) : const Color(0xFFD3EADD)) : (isDark ? AppColors.cardDark : Colors.white),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _paintCeiling ? AppColors.primary : (isDark ? Colors.grey.shade800 : Colors.grey.shade300)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(_paintCeiling ? Icons.check_box : Icons.check_box_outline_blank,
                                  color: _paintCeiling ? (isDark ? AppColors.accentLight : AppColors.primary) : Colors.grey),
                              const SizedBox(width: 8),
                              const Text('Ceiling', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                CustomTextField(label: 'Doors & windows · total area to subtract', suffix: 'm²', controller: _doorsController, isDark: isDark),
                const SizedBox(height: 4),
                const Text('Add up the openings you won\'t paint. Use 0 if none.', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),

                const SectionTitle(number: '03', title: 'Paint & finish'),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Coats', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                          const SizedBox(height: 6),
                          Container(
                            height: 54,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.inputDark : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () => setState(() => _coats > 1 ? _coats-- : null),
                                ),
                                Text('$_coats', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => setState(() => _coats++),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(label: 'Coverage per coat', suffix: 'm²/L', controller: _coverageController, isDark: isDark),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Waste allowance', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('For roller loss and touch-ups', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                      ],
                    ),
                    Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.inputDark : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$_waste', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Text(' %', style: TextStyle(color: AppColors.textGrey)),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Coverage varies by paint. You can edit this to match the tin.', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                const SizedBox(height: 24),

                // Calculate Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _calculateAndNavigate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.accentLight : AppColors.accentLight,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_forward, size: 20),
                        SizedBox(width: 8),
                        Text('Calculate paint', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text('An estimate for your project, not a purchase order.', style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
                ),
                const SizedBox(height: 30),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// SCREEN 2: RESULT SCREEN
// ==========================================

class ResultScreen extends StatelessWidget {
  final Estimate estimate;
  const ResultScreen({super.key, required this.estimate});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Recalculate breakdown for display
    double wallArea = 2 * (estimate.length + estimate.width) * estimate.height;
    double ceilingArea = estimate.length * estimate.width;
    double grossArea = 0;
    if (estimate.paintWalls) grossArea += wallArea;
    if (estimate.paintCeiling) grossArea += ceilingArea;

    double netArea = grossArea - estimate.doorsWindowsArea;
    double baseLiters = (netArea * estimate.coats) / estimate.coverage;
    double wasteLiters = baseLiters * (estimate.wasteAllowance / 100);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Estimate Result', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text('PAINT ESTIMATE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppColors.textGrey)),
            const SizedBox(height: 8),
            Text('Your room, covered.', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 8),
            Text('${estimate.roomName} · ${estimate.paintWalls ? 'Walls' : ''}${estimate.paintWalls && estimate.paintCeiling ? ' + ' : ''}${estimate.paintCeiling ? 'Ceiling' : ''} only',
                style: const TextStyle(color: AppColors.textGrey)),
            const SizedBox(height: 24),

            // Main Result Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Paint required', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
                      Icon(Icons.format_paint, color: Colors.white70),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(estimate.totalLiters.toStringAsFixed(2),
                          style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold, letterSpacing: -2)),
                      const SizedBox(width: 4),
                      const Text('L', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w300)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Includes ${estimate.wasteAllowance.toStringAsFixed(0)}% waste allowance', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(color: Colors.white24, height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStat('${netArea.toStringAsFixed(0)} m²', 'Net wall area'),
                      _buildStat('${estimate.coats}', 'Coats'),
                      _buildStat('${estimate.coverage.toStringAsFixed(0)} m²/L', 'Per coat'),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('How we worked it out', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                Icon(Icons.calculate_outlined, color: Theme.of(context).primaryColor),
              ],
            ),
            const SizedBox(height: 16),

            // Breakdown List
            _buildBreakdownRow('Gross wall area', '${grossArea.toStringAsFixed(0)} m²', '2 × (${estimate.length} + ${estimate.width} m) × ${estimate.height} m', isDark),
            _buildBreakdownRow('Doors & windows', '– ${estimate.doorsWindowsArea.toStringAsFixed(0)} m²', '', isDark),
            _buildBreakdownRow('Net paintable area', '${netArea.toStringAsFixed(0)} m²', '', isDark, isBold: true),
            _buildBreakdownRow('Paint for ${estimate.coats} coats', '${baseLiters.toStringAsFixed(2)} L', '${netArea.toStringAsFixed(0)} m² × ${estimate.coats} coats ÷ ${estimate.coverage} m²/L', isDark),
            _buildBreakdownRow('Waste allowance · ${estimate.wasteAllowance.toStringAsFixed(0)}%', '+ ${wasteLiters.toStringAsFixed(2)} L', '', isDark),
            _buildBreakdownRow('Total paint required', '${estimate.totalLiters.toStringAsFixed(2)} L', '', isDark, isBold: true, isPrimary: true),

            const SizedBox(height: 16),

            // Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : const Color(0xFFFDF6E3), // Light cream/yellow tint
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.orange.withOpacity(0.3)),
              ),
              child: const Text(
                'Check the paint manufacturer\'s coverage before buying. Surface texture and colour changes can affect how much you need.',
                style: TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.5),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  Provider.of<AppState>(context, listen: false).saveEstimate(estimate);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Estimate saved to your projects!')),
                  );
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.bookmark_border),
                label: const Text('Save estimate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit inputs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? AppColors.textLight : AppColors.textDark,
                  side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildBreakdownRow(String title, String value, String subtitle, bool isDark, {bool isBold = false, bool isPrimary = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 14)),
              Text(value, style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.primary
              )),
            ],
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
          ]
        ],
      ),
    );
  }
}

// ==========================================
// SCREEN 3: SAVED ESTIMATES
// ==========================================

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final estimates = appState.savedEstimates;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppHeader(subtitle: 'QUANTITY ESTIMATOR'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('SAVED ESTIMATES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppColors.textGrey)),
              const SizedBox(height: 8),
              Text('Plans worth keeping.', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 8),
              const Text('Your room estimates, ready when you are.', style: TextStyle(color: AppColors.textGrey)),
              const SizedBox(height: 24),

              // Stats Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('HOME PROJECT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey)),
                        const SizedBox(height: 4),
                        const Text('A fresh start', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${estimates.length}', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                        const Text('saved rooms', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('All estimates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Newest first', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        Expanded(
          child: estimates.isEmpty
              ? Center(child: Text('No saved estimates yet.', style: TextStyle(color: isDark ? Colors.white54 : Colors.black54)))
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: estimates.length,
            itemBuilder: (context, index) {
              final est = estimates[index];
              return Dismissible(
                key: Key(est.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) => appState.deleteEstimate(est.id),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.primary.withOpacity(0.2) : const Color(0xFFD3EADD),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.weekend_outlined, color: isDark ? AppColors.accentLight : AppColors.primary),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(est.roomName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('${est.length} × ${est.width} × ${est.height} m', style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                            const SizedBox(height: 8),
                            Text('${est.paintWalls ? 'Walls' : ''}${est.paintWalls && est.paintCeiling ? ' + ' : ''}${est.paintCeiling ? 'Ceiling' : ''} · ${est.coats} coats', style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${est.totalLiters.toStringAsFixed(2)} L', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).primaryColor)),
                          const SizedBox(height: 4),
                          Text(DateFormat('dd MMM yyyy').format(est.date), style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // New Estimate Button
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                // Find the Navigator and switch tab to index 0
                final navState = context.findAncestorStateOfType<_MainNavigatorState>();
                navState?.setState(() { navState._currentIndex = 0; });
              },
              icon: const Icon(Icons.add),
              label: const Text('New estimate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        )
      ],
    );
  }
}

// ==========================================
// SCREEN 4: SETTINGS
// ==========================================

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = appState.isDarkMode;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppHeader(subtitle: 'QUANTITY ESTIMATOR'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('SETTINGS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppColors.textGrey)),
                const SizedBox(height: 8),
                Text('Make it your own.', style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 8),
                const Text('A few practical preferences for every project.', style: TextStyle(color: AppColors.textGrey)),
                const SizedBox(height: 24),

                const Text('ESTIMATING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 1)),
                const SizedBox(height: 8),

                _buildSettingItem(context, Icons.straighten, 'Preferred units', 'Metres, square metres & litres', 'Metric'),
                _buildSettingItem(context, Icons.opacity, 'Default coverage', 'Per coat - editable in each estimate', '10 m²/L'),
                _buildSettingItem(context, Icons.percent, 'Waste allowance', 'A little extra for the job', '10%'),

                const SizedBox(height: 24),
                const Text('LOOK & FEEL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 1)),
                const SizedBox(height: 8),

                // Appearance Switcher
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.light_mode_outlined, size: 20, color: isDark ? Colors.grey.shade400 : AppColors.textDark),
                      const SizedBox(width: 16),
                      const Expanded(child: Text('Appearance', style: TextStyle(fontWeight: FontWeight.w500))),
                      Text(isDark ? 'Dark' : 'Light', style: const TextStyle(color: AppColors.textGrey, fontSize: 14)),
                      const SizedBox(width: 8),
                      Switch(
                        value: isDark,
                        activeColor: AppColors.primary,
                        onChanged: (val) => appState.toggleTheme(val),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Text('ABOUT & SUPPORT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textGrey, letterSpacing: 1)),
                const SizedBox(height: 8),

                _buildLinkItem(context, Icons.shield_outlined, 'Privacy Policy'),
                _buildLinkItem(context, Icons.description_outlined, 'Terms & Conditions'),
                _buildLinkItem(context, Icons.mail_outline, 'Contact Us'),
                _buildLinkItem(context, Icons.share_outlined, 'Share App'),
                _buildLinkItem(context, Icons.star_border, 'Rate App'),

                const SizedBox(height: 40),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Clear Paint', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('Version not assigned', style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Thoughtful estimates. A fresh coat of confidence.', style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
                const SizedBox(height: 40),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, IconData icon, String title, String subtitle, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: isDark ? Colors.grey.shade400 : AppColors.textDark),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
              ],
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 14, color: AppColors.textGrey)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 16, color: AppColors.textGrey),
        ],
      ),
    );
  }

  Widget _buildLinkItem(BuildContext context, IconData icon, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: isDark ? Colors.grey.shade400 : AppColors.textDark),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500))),
          const Icon(Icons.arrow_outward, size: 16, color: AppColors.textGrey),
        ],
      ),
    );
  }
}