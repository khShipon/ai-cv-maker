import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/models/cv_model.dart';
import '../../../core/services/local_storage_service.dart';
import '../widgets/cv_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/quick_action_button.dart';
import '../../cv_builder/screens/ai_cv_builder_screen.dart';
import '../../cv_builder/screens/manual_cv_builder_screen.dart';
import '../../templates/screens/templates_screen.dart';
import 'package:uuid/uuid.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<CVModel> _cvs = [];
  List<CVModel> _coverLetters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final cvs = await LocalStorageService.getCVs();
      final coverLetters = await LocalStorageService.getCoverLetters();

      setState(() {
        _cvs = cvs;
        _coverLetters = coverLetters;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error loading data: $e');
    }
  }

  void _navigateToAIBuilder() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(builder: (context) => const AICVBuilderScreen()),
        )
        .then((_) => _loadData());
  }

  void _navigateToManualBuilder() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => const ManualCVBuilderScreen(),
          ),
        )
        .then((_) => _loadData());
  }

  void _navigateToTemplates() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const TemplatesScreen()));
  }

  void _navigateToCoverLetters() {
    // TODO: Navigate to Cover Letters
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Cover Letters coming soon!')));
  }

  Future<void> _createDemoCV() async {
    const uuid = Uuid();
    final demoCV = CVModel(
      id: uuid.v4(),
      title: 'Software Engineer CV',
      status: 'ready',
      lastEdited: DateTime.now(),
      created: DateTime.now(),
      data: {
        'personalInfo': {
          'name': 'John Doe',
          'email': 'john.doe@email.com',
          'phone': '+1 (555) 123-4567',
          'location': 'San Francisco, CA',
          'linkedin': 'linkedin.com/in/johndoe',
          'summary':
              'Experienced software engineer with 5+ years of experience in full-stack development. Passionate about creating scalable web applications and leading development teams.',
        },
        'experience': [
          {
            'title': 'Senior Software Engineer',
            'company': 'Tech Corp',
            'duration': '2022 - Present',
            'description':
                'Lead development of microservices architecture serving 1M+ users',
            'achievements': [
              'Reduced API response time by 40% through optimization',
              'Led team of 5 developers on critical product features',
              'Implemented CI/CD pipeline reducing deployment time by 60%',
            ],
          },
          {
            'title': 'Software Engineer',
            'company': 'StartupXYZ',
            'duration': '2020 - 2022',
            'description':
                'Developed full-stack web applications using React and Node.js',
            'achievements': [
              'Built user authentication system handling 10K+ users',
              'Developed real-time chat feature using WebSocket',
              'Improved code coverage from 60% to 90%',
            ],
          },
        ],
        'education': [
          {
            'degree': 'Bachelor of Science in Computer Science',
            'institution': 'University of California, Berkeley',
            'year': '2020',
            'gpa': '3.8',
          },
        ],
        'skills': {
          'technical': [
            'JavaScript',
            'Python',
            'React',
            'Node.js',
            'AWS',
            'Docker',
          ],
          'soft': [
            'Leadership',
            'Problem Solving',
            'Communication',
            'Team Collaboration',
          ],
          'languages': ['English (Native)', 'Spanish (Conversational)'],
        },
        'projects': [
          {
            'name': 'E-commerce Platform',
            'description':
                'Built a full-stack e-commerce platform with payment integration',
            'technologies': ['React', 'Node.js', 'MongoDB', 'Stripe'],
            'link': 'github.com/johndoe/ecommerce',
          },
        ],
        'certifications': [
          {
            'name': 'AWS Certified Solutions Architect',
            'issuer': 'Amazon Web Services',
            'date': '2023',
          },
        ],
      },
    );

    await LocalStorageService.saveCV(demoCV);
    _loadData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Demo CV created successfully!'),
          backgroundColor: AppTheme.primaryTeal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            DashboardHeader(
              userName:
                  FirebaseService.currentUser?.displayName ?? 'Guest User',
              onProfileTap: () {
                // Navigate to profile screen
              },
            ),

            // Tab bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: const EdgeInsets.all(4),
                labelColor: Colors.white,
                unselectedLabelColor: AppTheme.mediumGray,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'My CVs'),
                  Tab(text: 'Cover Letters'),
                  Tab(text: 'Templates'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCVsTab(),
                  _buildCoverLettersTab(),
                  _buildTemplatesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createDemoCV,
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Demo CV'),
      ),
    );
  }

  Widget _buildCVsTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Quick actions
          Row(
            children: [
              Expanded(
                child: QuickActionButton(
                  title: 'Start with AI',
                  subtitle: 'AI-powered CV generation',
                  icon: Icons.auto_awesome,
                  color: AppTheme.primaryTeal,
                  onTap: _navigateToAIBuilder,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickActionButton(
                  title: 'Start with Custom Builder',
                  subtitle: 'Build manually step by step',
                  icon: Icons.edit_outlined,
                  color: AppTheme.primaryBlue,
                  onTap: _navigateToManualBuilder,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // CVs list
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _cvs.isEmpty
                    ? _buildEmptyState(
                      'No CVs yet',
                      'Create your first CV using AI or our custom builder',
                      Icons.description_outlined,
                    )
                    : ListView.builder(
                      itemCount: _cvs.length,
                      itemBuilder: (context, index) {
                        return CVCard(
                          cv: _cvs[index],
                          onTap: () {
                            // Navigate to CV details/edit
                          },
                          onDelete: () async {
                            await LocalStorageService.deleteCV(_cvs[index].id);
                            _loadData();
                          },
                          onDownload: () {
                            // Implement PDF download
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverLettersTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Create cover letter button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _navigateToCoverLetters,
              icon: const Icon(Icons.add),
              label: const Text('Create Cover Letter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryTeal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Cover letters list
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _coverLetters.isEmpty
                    ? _buildEmptyState(
                      'No cover letters yet',
                      'Create personalized cover letters for your job applications',
                      Icons.mail_outline,
                    )
                    : ListView.builder(
                      itemCount: _coverLetters.length,
                      itemBuilder: (context, index) {
                        return CVCard(
                          cv: _coverLetters[index],
                          onTap: () {
                            // Navigate to cover letter details/edit
                          },
                          onDelete: () async {
                            await LocalStorageService.deleteCoverLetter(
                              _coverLetters[index].id,
                            );
                            _loadData();
                          },
                          onDownload: () {
                            // Implement PDF download
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Browse templates button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _navigateToTemplates,
              icon: const Icon(Icons.palette_outlined),
              label: const Text('Browse Templates'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Template categories or featured templates
          Expanded(
            child: _buildEmptyState(
              'Professional Templates',
              'Choose from our collection of ATS-optimized templates',
              Icons.article_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.lightGray.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: AppTheme.mediumGray),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppTheme.mediumGray),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: AppTheme.mediumGray,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'Templates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_outlined),
            activeIcon: Icon(Icons.build),
            label: 'Builder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
