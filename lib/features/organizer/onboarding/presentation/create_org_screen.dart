import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/illustrations.dart';
import '../../../../core/theme/motion.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/ui/hero_scaffold.dart';
import '../../../../core/ui/pill_button.dart';
import '../../../../core/ui/stagger.dart';
import '../../../../core/util/slugify.dart';
import '../../../../core/widgets/error_banner.dart';
import '../../orgs/domain/orgs_repository.dart';
import '../application/create_org_controller.dart';
import '../application/organize_intent.dart';

/// Step 1 of organizer setup (API-CONTRACT #35): name the organization and
/// pick its address. The address follows the name until it is edited, and
/// is checked live so the button never fails on something the form could
/// have caught. Success moves straight on to the first event.
class CreateOrgScreen extends ConsumerStatefulWidget {
  const CreateOrgScreen({super.key});

  @override
  ConsumerState<CreateOrgScreen> createState() => _CreateOrgScreenState();
}

class _CreateOrgScreenState extends ConsumerState<CreateOrgScreen> {
  final _name = TextEditingController();
  final _slug = TextEditingController();
  bool _slugEdited = false;
  bool _busy = false;
  String? _error;
  Map<String, String> _fieldErrors = const {};

  Timer? _debounce;
  SlugAvailability? _availability;
  bool _checking = false;

  String get _publicHost => Uri.parse(AppConfig.publicOrigin).host;

  @override
  void initState() {
    super.initState();
    // Arriving here is what the intent was for; clear it so a later sign-in
    // is not routed back.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(organizeIntentProvider.notifier).set(false);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _name.dispose();
    _slug.dispose();
    super.dispose();
  }

  void _onNameChanged(String value) {
    if (!_slugEdited) {
      _slug.text = slugify(value);
      _scheduleCheck();
    }
    setState(() => _fieldErrors = {..._fieldErrors}..remove('name'));
  }

  void _onSlugChanged(String value) {
    _slugEdited = true;
    final cleaned = slugify(value);
    if (cleaned != value) {
      _slug.value = TextEditingValue(
        text: cleaned,
        selection: TextSelection.collapsed(offset: cleaned.length),
      );
    }
    _scheduleCheck();
    setState(() => _fieldErrors = {..._fieldErrors}..remove('slug'));
  }

  /// Local shape/reserved checks are instant; only a plausible slug goes to
  /// the server, after a pause in typing.
  void _scheduleCheck() {
    _debounce?.cancel();
    final slug = _slug.text;
    if (slug.isEmpty) {
      setState(() {
        _availability = null;
        _checking = false;
      });
      return;
    }
    if (!isUsableSlug(slug)) {
      setState(() {
        _availability = SlugAvailability(
          slug,
          available: false,
          problem: isReservedSlug(slug) ? SlugProblem.reserved : SlugProblem.invalid,
        );
        _checking = false;
      });
      return;
    }
    setState(() => _checking = true);
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      try {
        final result = await ref.read(createOrgProvider.notifier).check(slug);
        if (!mounted || _slug.text != slug) return;
        setState(() {
          _availability = result;
          _checking = false;
        });
      } catch (_) {
        // A failed check is not an error the person can act on; the submit
        // will report anything real.
        if (mounted && _slug.text == slug) setState(() => _checking = false);
      }
    });
  }

  Future<void> _submit() async {
    final fields = <String, String>{};
    final name = _name.text.trim();
    if (name.length < 2) fields['name'] = 'Organization name is too short.';
    if (name.length > 60) fields['name'] = 'Organization name is too long.';
    final slug = _slug.text;
    if (!isUsableSlug(slug)) {
      fields['slug'] = SlugAvailability(
        slug,
        available: false,
        problem: isReservedSlug(slug) ? SlugProblem.reserved : SlugProblem.invalid,
      ).message!;
    }
    if (fields.isNotEmpty) {
      setState(() {
        _fieldErrors = fields;
        _error = null;
      });
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
      _fieldErrors = const {};
    });
    try {
      await ref.read(createOrgProvider.notifier).submit(name: name, slug: slug);
      if (!mounted) return;
      context.go(Routes.orgFirstEvent);
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() {
        _fieldErrors = e.fieldErrors;
        _error = e.fieldErrors.isEmpty ? e.message : null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = "Couldn't create the organization. Try again.");
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final slug = _slug.text;
    final availability = _availability;
    final slugError = _fieldErrors['slug'] ??
        (availability != null && availability.slug == slug && !availability.available
            ? availability.message
            : null);
    final slugOk = !_checking &&
        slugError == null &&
        availability != null &&
        availability.slug == slug &&
        availability.available;

    return HeroScaffold(
      image: const AssetImage(Illustrations.org),
      heroFraction: 0.34,
      imageAlignment: Alignment.bottomCenter,
      eyebrow: 'Step 1 of 2',
      title: 'Set up your organization',
      subtitle: 'Takes a minute',
      children: [
        StaggeredColumn(
          children: [
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: Spacing.x3),
                child: ErrorBanner(message: _error!),
              ),
            Container(
              padding: const EdgeInsets.all(Spacing.gutter),
              decoration: BoxDecoration(
                color: p.surface,
                borderRadius: BorderRadius.circular(Radii.card),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _name,
                    enabled: !_busy,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    onChanged: _onNameChanged,
                    decoration: InputDecoration(
                      labelText: 'Organization name',
                      hintText: 'Acme Meetups',
                      errorText: _fieldErrors['name'],
                    ),
                  ),
                  const SizedBox(height: Spacing.x3),
                  TextField(
                    controller: _slug,
                    enabled: !_busy,
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    onChanged: _onSlugChanged,
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      labelText: 'Address',
                      hintText: 'acme',
                      prefixText: '$_publicHost/',
                      prefixStyle: AppType.body.copyWith(color: p.muted),
                      errorText: slugError,
                      errorMaxLines: 3,
                      suffixIcon: _checking
                          ? const Padding(
                              padding: EdgeInsets.all(14),
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : slugOk
                              ? Icon(Icons.check_circle, color: p.success)
                              : null,
                    ),
                  ),
                  AnimatedSize(
                    duration: Motion.base,
                    curve: Motion.move,
                    alignment: Alignment.topLeft,
                    child: slugOk
                        ? Padding(
                            padding: const EdgeInsets.only(top: Spacing.x2, left: Spacing.x3),
                            child: Text(
                              '$_publicHost/$slug is yours',
                              style: AppType.small.copyWith(color: p.success),
                            ),
                          )
                        : const SizedBox(width: double.infinity),
                  ),
                  const SizedBox(height: Spacing.x2),
                  Text(
                    'People open this link to see your events. You can\'t '
                    'change it later.',
                    style: AppType.small.copyWith(color: p.muted),
                  ),
                  const SizedBox(height: Spacing.x5),
                  PillButton(
                    label: 'Create organization',
                    icon: Icons.arrow_forward,
                    trailingIcon: true,
                    loading: _busy,
                    onPressed: _busy ? null : _submit,
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.x4),
            Row(
              children: [
                Icon(Icons.verified_user_outlined, size: 18, color: p.muted),
                const SizedBox(width: Spacing.x2),
                Expanded(
                  child: Text(
                    "You'll be the admin. Invite your team from the Team tab.",
                    style: AppType.small.copyWith(color: p.muted),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
