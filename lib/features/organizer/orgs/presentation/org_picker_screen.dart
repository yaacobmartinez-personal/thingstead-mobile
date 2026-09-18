import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../auth/application/auth_controller.dart';
import 'org_picker_sheet.dart';

/// Full-screen org chooser (`/o/orgs`). Pull to refresh memberships.
class OrgPickerScreen extends ConsumerWidget {
  const OrgPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your organizations')),
      body: RefreshIndicator(
        onRefresh: () => ref.read(authControllerProvider.notifier).refreshOrgs(),
        child: ListView(
          children: [
            OrgList(onPicked: (_) => context.go(Routes.orgEvents)),
          ],
        ),
      ),
    );
  }
}
