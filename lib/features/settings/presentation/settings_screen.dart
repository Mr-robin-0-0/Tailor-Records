import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/apple_ui.dart';
import '../../templates/presentation/template_list_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.groupedBackground(context),
      appBar: appleAppBar(
        context,
        title: 'Settings',
        leading: CupertinoNavigationBarBackButton(
          color: AppColors.systemBlue,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16),
        children: [
          const AppleSectionLabel('Workspace'),
          AppleInsetGroup(
            children: [
              AppleListRow(
                title: 'Measurement Templates',
                subtitle: 'Forms for shirts, suits, and more',
                leading: Icon(CupertinoIcons.square_list, color: AppColors.systemBlue),
                onTap: () {
                  Navigator.of(context).push(
                    appPageRoute((_) => const TemplateListScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
