import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme_provider.dart';

class BursariesPage extends StatelessWidget {
  const BursariesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E3A8A),
            elevation: 0,
            title: const Text(
              'Bursaries',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        '12',
                        'Active',
                        Colors.green,
                        themeProvider,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        '5',
                        'Pending',
                        Colors.orange,
                        themeProvider,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        '3',
                        'Closed',
                        Colors.red,
                        themeProvider,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Bursaries List
                Expanded(
                  child: ListView.builder(
                    itemCount: 8, // Sample data
                    itemBuilder: (context, index) {
                      final statuses = ['Active', 'Pending', 'Closed'];
                      final colors = [Colors.green, Colors.orange, Colors.red];
                      final status = statuses[index % 3];
                      final color = colors[index % 3];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: themeProvider.surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: themeProvider.borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Bursary Program ${index + 1}',
                                    style: TextStyle(
                                      color: themeProvider.textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: color,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Amount: \$${(index + 1) * 1000}',
                              style: TextStyle(
                                color: themeProvider.subtitleColor,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Applications: ${(index + 1) * 15}',
                              style: TextStyle(
                                color: themeProvider.subtitleColor,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Deadline: Dec ${15 + index}, 2024',
                                  style: TextStyle(
                                    color: themeProvider.subtitleColor,
                                    fontSize: 12,
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: themeProvider.subtitleColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Add new bursary
            },
            backgroundColor: const Color(0xFF1E3A8A),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String number,
    String label,
    Color color,
    ThemeProvider themeProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeProvider.borderColor),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: themeProvider.subtitleColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
