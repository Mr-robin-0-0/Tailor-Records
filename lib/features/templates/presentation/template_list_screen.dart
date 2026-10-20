import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/apple_ui.dart';
import '../../customers/application/customer_notifier.dart';
import '../application/template_notifier.dart';
import '../data/measurement_template.dart';
import 'template_builder_screen.dart';

class TemplateListScreen extends ConsumerWidget {
  const TemplateListScreen({super.key});

  Future<void> _openTemplateBuilder(BuildContext context, {MeasurementTemplate? template}) async {
    final result = await Navigator.of(context).push<String>(
      appPageRoute((_) => TemplateBuilderScreen(templateToEdit: template)),
    );
    if (!context.mounted || result == null) return;
    if (result == 'created') {
      showAppleSnackBar(context, 'Template created');
    } else if (result == 'saved') {
      showAppleSnackBar(context, 'Template saved');
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, int id, String name) async {
    final confirmed = await showAppleConfirmDialog(
      context,
      title: 'Delete Template?',
      message:
          'Delete "$name"? This removes all "$name" measurements from every customer. This cannot be undone.',
      confirm: 'Delete',
      destructive: true,
    );
    if (confirmed != true) return;

    ref.read(customerProvider.notifier).removeTemplateFromAllCustomers(name);
    ref.read(templateProvider.notifier).deleteTemplate(id);
    showAppleSnackBar(context, 'Template deleted');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(templateProvider);

    return Scaffold(
      backgroundColor: AppColors.groupedBackground(context),
      appBar: appleAppBar(
        context,
        title: 'Templates',
        leading: CupertinoNavigationBarBackButton(
          color: AppColors.systemBlue,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: templates.isEmpty
          ? AppleEmptyState(
              icon: CupertinoIcons.doc_text,
              title: 'No templates',
              message: 'Create forms like Men\'s Suit or Kurta to record measurements consistently.',
              actionLabel: 'Create Template',
              onAction: () => _openTemplateBuilder(context),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 96),
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppleInsetGroup(
                    children: [
                      ApplePressable(
                        onTap: () => _openTemplateBuilder(context, template: template),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(template.templateName, style: appleRowTitle(context)),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${template.fieldNames.length} fields',
                                            style: appleRowSubtitle(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.chevron_right, size: 22, color: AppColors.secondaryLabel(context)),
                                  ],
                                ),
                                if (template.fieldNames.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 8,
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: template.fieldNames.map((field) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.tertiaryFill(context),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          field,
                                          style: appleRowSubtitle(context).copyWith(fontSize: 13),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      AppleListRow(
                        title: 'Delete template',
                        showChevron: false,
                        onTap: () => _confirmDelete(context, ref, template.id, template.templateName),
                        trailing: const Icon(CupertinoIcons.delete, color: AppColors.systemRed, size: 22),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: templates.isEmpty
          ? null
          : FloatingActionButton(
              heroTag: 'template_fab',
              onPressed: () => _openTemplateBuilder(context),
              child: const Icon(CupertinoIcons.add),
            ),
    );
  }
}
