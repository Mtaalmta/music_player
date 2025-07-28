import 'package:flutter/material.dart';
          import 'package:provider/provider.dart';
          import '/theme_provider.dart';

          class HomeScreen extends StatefulWidget {
            const HomeScreen({super.key});

            @override
            State<HomeScreen> createState() => _HomeScreenState();
          }

          class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
            late AnimationController _welcomeController;
            late Animation<double> _welcomeAnimation;
            late AnimationController _gridController;
            late List<Animation<double>> _gridAnimations;
            late AnimationController _recentActivitiesController;
            late Animation<Offset> _appBarSlideAnimation;
            late List<Animation<Offset>> _recentActivitiesAnimations;

            static const List<IconData> _quickIcons = [
              Icons.music_note,
              Icons.photo,
              Icons.folder,
              Icons.settings,
            ];
            static const List<String> _quickLabels = [
              'Music',
              'Gallery',
              'Folders',
              'Settings',
            ];
            static const List<IconData> _activityIcons = [
              Icons.music_note,
              Icons.photo,
            ];
            static const List<String> _activityTitles = [
              'Played: Sample Track',
              'Viewed: Sample Photo',
            ];
            static const List<String> _activitySubtitles = [
              'Sample Artist',
              'Gallery',
            ];

            @override
            void initState() {
              super.initState();
              _welcomeController = AnimationController(
                vsync: this,
                duration: const Duration(milliseconds: 800),
              );
              _welcomeAnimation = CurvedAnimation(
                parent: _welcomeController,
                curve: Curves.easeIn,
              );
              _welcomeController.forward();

              _gridController = AnimationController(
                vsync: this,
                duration: const Duration(milliseconds: 1200),
              );
              _gridAnimations = List.generate(4, (i) {
                return CurvedAnimation(
                  parent: _gridController,
                  curve: Interval(i * 0.15, 1.0, curve: Curves.easeOutBack),
                );
              });
              _gridController.forward();

              _recentActivitiesController = AnimationController(
                vsync: this,
                duration: const Duration(milliseconds: 800),
              );
              _appBarSlideAnimation = Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _recentActivitiesController,
                curve: Curves.easeOut,
              ));

              _recentActivitiesAnimations = List.generate(2, (i) {
                return Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _recentActivitiesController,
                  curve: Interval(i * 0.2, 1.0, curve: Curves.easeOut),
                ));
              });
              _recentActivitiesController.forward();
            }

            @override
            void dispose() {
              _welcomeController.dispose();
              _gridController.dispose();
              _recentActivitiesController.dispose();
              super.dispose();
            }

            @override
            Widget build(BuildContext context) {
              final colorScheme = Theme.of(context).colorScheme;
              final themeProvider = Provider.of<ThemeProvider>(context);

              return Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(56),
                  child: SlideTransition(
                    position: _appBarSlideAnimation,
                    child: AppBar(
                      title: const Text('Home'),
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                      elevation: 0,
                      actions: [
                        IconButton(
                          icon: Icon(
                            themeProvider.themeMode == ThemeMode.light
                                ? Icons.dark_mode
                                : Icons.light_mode,
                          ),
                          onPressed: () {
                            themeProvider.toggleTheme();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeTransition(
                        opacity: _welcomeAnimation,
                        child: Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 180,
                        child: GridView.builder(
                          itemCount: _quickIcons.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            return ScaleTransition(
                              scale: _gridAnimations[i],
                              child: Card(
                                elevation: 2,
                                color: colorScheme.secondaryContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    // Navigation handled by MainScreen, or use Navigator if needed
                                  },
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(_quickIcons[i], size: 40, color: colorScheme.primary),
                                        const SizedBox(height: 10),
                                        Text(
                                          _quickLabels[i],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.onSecondaryContainer,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Recent Activities',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _activityIcons.length,
                          itemBuilder: (context, index) {
                            return SlideTransition(
                              position: _recentActivitiesAnimations[index],
                              child: Card(
                                child: ListTile(
                                  leading: Icon(_activityIcons[index], color: colorScheme.primary),
                                  title: Text(_activityTitles[index]),
                                  subtitle: Text(_activitySubtitles[index]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }