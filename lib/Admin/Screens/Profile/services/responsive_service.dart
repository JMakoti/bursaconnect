import 'package:flutter/material.dart';

class ResponsiveService {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Device type detection
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (width < tabletBreakpoint) {
      return DeviceType.tablet;
    } else if (width < desktopBreakpoint) {
      return DeviceType.desktop;
    } else {
      return DeviceType.largeDesktop;
    }
  }

  // Screen size helpers
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  static bool isDesktop(BuildContext context) {
    final type = getDeviceType(context);
    return type == DeviceType.desktop || type == DeviceType.largeDesktop;
  }

  static bool isTabletOrLarger(BuildContext context) {
    return !isMobile(context);
  }

  static bool isDesktopOrLarger(BuildContext context) {
    final type = getDeviceType(context);
    return type == DeviceType.desktop || type == DeviceType.largeDesktop;
  }

  // Responsive values
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobile;
    }
  }

  // Responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    return responsive(
      context,
      mobile: const EdgeInsets.all(16),
      tablet: const EdgeInsets.all(24),
      desktop: const EdgeInsets.all(32),
    );
  }

  // Responsive margin
  static EdgeInsets responsiveMargin(BuildContext context) {
    return responsive(
      context,
      mobile: const EdgeInsets.all(8),
      tablet: const EdgeInsets.all(12),
      desktop: const EdgeInsets.all(16),
    );
  }

  // Responsive font sizes
  static double responsiveFontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return responsive(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.1,
      desktop: desktop ?? mobile * 1.2,
    );
  }

  // Responsive grid columns
  static int responsiveGridColumns(BuildContext context) {
    return responsive(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
      largeDesktop: 4,
    );
  }

  // Responsive card width
  static double responsiveCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return responsive(
      context,
      mobile: screenWidth - 32,
      tablet: (screenWidth - 64) / 2,
      desktop: (screenWidth - 96) / 3,
      largeDesktop: (screenWidth - 128) / 4,
    );
  }

  // Responsive dialog width
  static double responsiveDialogWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return responsive(
      context,
      mobile: screenWidth * 0.9,
      tablet: screenWidth * 0.7,
      desktop: screenWidth * 0.5,
      largeDesktop: screenWidth * 0.4,
    );
  }

  // Responsive layout helpers
  static Widget responsiveLayout(
    BuildContext context, {
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    return responsive(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? tablet ?? mobile,
    );
  }

  // Responsive row/column layout
  static Widget responsiveRowColumn(
    BuildContext context, {
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
  }) {
    if (isMobile(context)) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: children,
      );
    } else {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: children,
      );
    }
  }

  // Responsive wrap
  static Widget responsiveWrap(
    BuildContext context, {
    required List<Widget> children,
    WrapAlignment alignment = WrapAlignment.start,
    double spacing = 8.0,
    double runSpacing = 8.0,
  }) {
    final responsiveSpacing = responsive(
      context,
      mobile: spacing,
      tablet: spacing * 1.5,
      desktop: spacing * 2,
    );

    return Wrap(
      alignment: alignment,
      spacing: responsiveSpacing,
      runSpacing: responsiveSpacing,
      children: children,
    );
  }

  // Responsive sidebar layout
  static Widget responsiveSidebarLayout(
    BuildContext context, {
    required Widget sidebar,
    required Widget content,
    double sidebarWidth = 300,
  }) {
    if (isMobile(context)) {
      return content; // Hide sidebar on mobile
    } else {
      return Row(
        children: [
          SizedBox(width: sidebarWidth, child: sidebar),
          Expanded(child: content),
        ],
      );
    }
  }

  // Responsive navigation
  static Widget responsiveNavigation(
    BuildContext context, {
    required List<NavigationItem> items,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    if (isMobile(context)) {
      return BottomNavigationBar(
        items: items
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
      );
    } else {
      return NavigationRail(
        destinations: items
            .map(
              (item) => NavigationRailDestination(
                icon: Icon(item.icon),
                label: Text(item.label),
              ),
            )
            .toList(),
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        extended: isDesktop(context),
      );
    }
  }

  // Responsive app bar
  static PreferredSizeWidget responsiveAppBar(
    BuildContext context, {
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool automaticallyImplyLeading = true,
  }) {
    final height = responsive(
      context,
      mobile: kToolbarHeight,
      tablet: kToolbarHeight + 8,
      desktop: kToolbarHeight + 16,
    );

    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: responsiveFontSize(
              context,
              mobile: 20,
              tablet: 22,
              desktop: 24,
            ),
          ),
        ),
        actions: actions,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        toolbarHeight: height,
      ),
    );
  }

  // Responsive card
  static Widget responsiveCard(
    BuildContext context, {
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? elevation,
  }) {
    return Card(
      elevation:
          elevation ?? responsive(context, mobile: 2, tablet: 4, desktop: 6),
      margin: margin ?? responsiveMargin(context),
      child: Padding(
        padding: padding ?? responsivePadding(context),
        child: child,
      ),
    );
  }

  // Responsive grid view
  static Widget responsiveGridView(
    BuildContext context, {
    required List<Widget> children,
    double? childAspectRatio,
    double? crossAxisSpacing,
    double? mainAxisSpacing,
  }) {
    final columns = responsiveGridColumns(context);

    return GridView.count(
      crossAxisCount: columns,
      childAspectRatio: childAspectRatio ?? 1.0,
      crossAxisSpacing:
          crossAxisSpacing ??
          responsive(context, mobile: 8, tablet: 12, desktop: 16),
      mainAxisSpacing:
          mainAxisSpacing ??
          responsive(context, mobile: 8, tablet: 12, desktop: 16),
      children: children,
    );
  }

  // Responsive list view
  static Widget responsiveListView(
    BuildContext context, {
    required List<Widget> children,
    EdgeInsets? padding,
  }) {
    return ListView(
      padding: padding ?? responsivePadding(context),
      children: children,
    );
  }

  // Responsive form layout
  static Widget responsiveFormLayout(
    BuildContext context, {
    required List<Widget> fields,
    double? spacing,
  }) {
    final formSpacing =
        spacing ??
        responsive(context, mobile: 16.0, tablet: 20.0, desktop: 24.0);

    if (isMobile(context)) {
      return Column(
        children: fields
            .map(
              (field) => Padding(
                padding: EdgeInsets.only(bottom: formSpacing ?? 16),
                child: field,
              ),
            )
            .toList(),
      );
    } else {
      // Create rows of 2 fields for tablet/desktop
      final rows = <Widget>[];
      for (int i = 0; i < fields.length; i += 2) {
        if (i + 1 < fields.length) {
          rows.add(
            Row(
              children: [
                Expanded(child: fields[i]),
                SizedBox(width: formSpacing),
                Expanded(child: fields[i + 1]),
              ],
            ),
          );
        } else {
          rows.add(fields[i]);
        }
        if (i + 2 < fields.length) {
          rows.add(SizedBox(height: formSpacing));
        }
      }
      return Column(children: rows);
    }
  }

  // Responsive button layout
  static Widget responsiveButtonLayout(
    BuildContext context, {
    required List<Widget> buttons,
    MainAxisAlignment alignment = MainAxisAlignment.end,
  }) {
    if (isMobile(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons
            .map(
              (button) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: button,
              ),
            )
            .toList(),
      );
    } else {
      return Row(
        mainAxisAlignment: alignment,
        children: buttons
            .map(
              (button) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: button,
              ),
            )
            .toList(),
      );
    }
  }

  // Get safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  // Get screen dimensions
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  // Check if landscape
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Check if portrait
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }
}

// Device type enum
enum DeviceType { mobile, tablet, desktop, largeDesktop }

// Navigation item model
class NavigationItem {
  final IconData icon;
  final String label;

  NavigationItem({required this.icon, required this.label});
}
