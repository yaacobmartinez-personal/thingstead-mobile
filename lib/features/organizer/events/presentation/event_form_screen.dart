import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/time/app_time.dart';
import '../../../../core/ui/pill_button.dart';
import '../../../../core/util/slugify.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/error_banner.dart';
import '../../orgs/application/selected_org_controller.dart';
import '../application/event_detail_controller.dart';
import '../domain/event_detail.dart';
import '../domain/event_input.dart';
import 'timezone_picker.dart';

/// Create (`eventSlug == null`) or edit an event. Port of the web
/// `EventForm`: the slug follows the title until edited, times are wall
/// clock in the chosen zone, and field errors show inline whether they came
/// from the local check or the server.
class EventFormScreen extends ConsumerWidget {
  const EventFormScreen({super.key, this.eventSlug, this.firstEvent = false});

  final String? eventSlug;

  /// Step 2 of organizer setup: friendlier copy, "Skip for now" instead of
  /// Cancel, and success lands on the welcome page rather than the event.
  final bool firstEvent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final org = ref.watch(selectedOrgProvider);
    if (org == null) return const Scaffold(body: SizedBox.shrink());
    final slug = eventSlug;
    if (slug == null) {
      return _EventForm(
        org: org.slug,
        publicHost: _publicHost(org.slug),
        firstEvent: firstEvent,
      );
    }
    final detail = ref.watch(eventDetailProvider(org.slug, slug));
    return AsyncView(
      value: detail,
      onRetry: () => ref.invalidate(eventDetailProvider(org.slug, slug)),
      loading: Scaffold(
        appBar: AppBar(title: const Text('Edit event')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      data: (event) => _EventForm(
        org: org.slug,
        publicHost: _publicHost(org.slug),
        existing: event,
      ),
    );
  }

  static String _publicHost(String org) =>
      '${Uri.parse(AppConfig.publicOrigin).host}/$org';
}

class _EventForm extends ConsumerStatefulWidget {
  const _EventForm({
    required this.org,
    required this.publicHost,
    this.existing,
    this.firstEvent = false,
  });

  final String org;
  final String publicHost;
  final EventDetail? existing;
  final bool firstEvent;

  @override
  ConsumerState<_EventForm> createState() => _EventFormState();
}

class _EventFormState extends ConsumerState<_EventForm> {
  late final _title = TextEditingController(text: widget.existing?.title ?? '');
  late final _slug = TextEditingController(text: widget.existing?.slug ?? '');
  late final _description = TextEditingController(
    text: widget.existing?.description ?? '',
  );
  late final _capacity = TextEditingController(
    text: widget.existing?.capacity?.toString() ?? '',
  );

  /// Once the user touches the slug it stops following the title.
  late bool _slugEdited = widget.existing != null;
  late String? _startsAt = widget.existing?.startsAtLocal;
  late String? _endsAt = widget.existing?.endsAtLocal;
  late String _timezone = widget.existing?.timezone ?? AppTime.deviceZone;
  late bool _waitlist = widget.existing?.waitlistEnabled ?? false;

  Map<String, String> _fieldErrors = const {};
  String? _error;
  bool _busy = false;

  bool get _isEdit => widget.existing != null;

  @override
  void dispose() {
    _title.dispose();
    _slug.dispose();
    _description.dispose();
    _capacity.dispose();
    super.dispose();
  }

  void _onTitleChanged(String value) {
    if (!_slugEdited) _slug.text = slugify(value);
    setState(() {});
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
    setState(() {});
  }

  EventInput _input() => EventInput(
    title: _title.text,
    slug: _slug.text,
    description: _description.text,
    startsAt: _startsAt ?? '',
    endsAt: _endsAt,
    timezone: _timezone,
    capacity: _capacity.text.trim().isEmpty
        ? null
        : int.tryParse(_capacity.text.trim()),
    waitlistEnabled: _waitlist,
  );

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final input = _input();
    final errors = {...input.validate()};
    if (_capacity.text.trim().isNotEmpty && input.capacity == null) {
      errors['capacity'] = 'Capacity must be a whole number above zero.';
    }
    if (errors.isNotEmpty) {
      setState(() {
        _fieldErrors = errors;
        _error = null;
      });
      return;
    }
    setState(() {
      _busy = true;
      _fieldErrors = const {};
      _error = null;
    });
    try {
      final actions = ref.read(eventActionsProvider.notifier);
      final existing = widget.existing;
      final event = existing == null
          ? await actions.create(widget.org, input)
          : await actions.update(widget.org, existing.slug, input);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              existing == null ? 'Event created as a draft.' : 'Event saved.',
            ),
          ),
        );
      if (widget.firstEvent) {
        context.go(Routes.orgWelcome(event.slug));
      } else if (existing != null && existing.slug == event.slug) {
        context.pop();
      } else {
        // New event, or the address changed: rebuild the stack on the new slug.
        context.go(Routes.orgEvent(event.slug));
      }
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() {
        _fieldErrors = e.fieldErrors;
        _error = e.fieldErrors.isEmpty ? e.message : null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = "Couldn't save the event. Try again.");
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final previewSlug = _slug.text.isNotEmpty
        ? _slug.text
        : slugify(_title.text);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.firstEvent
              ? 'Your first event'
              : _isEdit
                  ? 'Edit event'
                  : 'New event',
        ),
        automaticallyImplyLeading: !widget.firstEvent,
      ),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(
          Spacing.gutter,
          Spacing.x2,
          Spacing.gutter,
          Spacing.x8,
        ),
        children: [
          if (widget.firstEvent)
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.x4),
              child: Text(
                'STEP 2 OF 2',
                style: AppType.caption.copyWith(color: context.palette.limeDeep),
              ),
            ),
          if (!_isEdit)
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.x4),
              child: Text(
                widget.firstEvent
                    ? 'Just the basics for now — everything can change later. '
                        'Events start as a draft, so nothing goes live until you publish.'
                    : "Events start as a draft. Publish when you're ready to take "
                        'registrations.',
                style: TextStyle(color: context.palette.muted),
              ),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.x3),
              child: ErrorBanner(message: _error!),
            ),
          _Group(
            title: 'Basics',
            children: [
              TextField(
                controller: _title,
                enabled: !_busy,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                maxLength: EventInput.maxTitle,
                onChanged: _onTitleChanged,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Summer Meetup',
                  counterText: '',
                  errorText: _fieldErrors['title'],
                  errorMaxLines: 3,
                ),
              ),
              const SizedBox(height: Spacing.x3),
              TextField(
                controller: _slug,
                enabled: !_busy,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                onChanged: _onSlugChanged,
                decoration: InputDecoration(
                  labelText: 'Link',
                  hintText: 'summer-meetup',
                  helperText:
                      '${widget.publicHost}/${previewSlug.isEmpty ? '…' : previewSlug}',
                  helperMaxLines: 2,
                  errorText: _fieldErrors['slug'],
                  errorMaxLines: 3,
                ),
              ),
              const SizedBox(height: Spacing.x3),
              TextField(
                controller: _description,
                enabled: !_busy,
                textCapitalization: TextCapitalization.sentences,
                minLines: 3,
                maxLines: 8,
                maxLength: EventInput.maxDescription,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'What should people know before they sign up?',
                  alignLabelWithHint: true,
                  counterText: '',
                  errorText: _fieldErrors['description'],
                  errorMaxLines: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.x4),
          _Group(
            title: 'When',
            children: [
              _DateTimeField(
                label: 'Starts',
                value: _startsAt,
                enabled: !_busy,
                errorText: _fieldErrors['startsAt'],
                onChanged: (v) => setState(() => _startsAt = v),
              ),
              const SizedBox(height: Spacing.x3),
              _DateTimeField(
                label: 'Ends (optional)',
                value: _endsAt,
                enabled: !_busy,
                clearable: true,
                errorText: _fieldErrors['endsAt'],
                onChanged: (v) => setState(() => _endsAt = v),
              ),
              const SizedBox(height: Spacing.x3),
              InkWell(
                borderRadius: BorderRadius.circular(Radii.sm),
                onTap: _busy
                    ? null
                    : () async {
                        final zone = await showTimezonePicker(
                          context,
                          selected: _timezone,
                        );
                        if (zone != null && mounted) {
                          setState(() => _timezone = zone);
                        }
                      },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Timezone',
                    helperText:
                        'The times above are local to the event. Everyone sees them '
                        'in this timezone, wherever they are.',
                    helperMaxLines: 3,
                    errorText: _fieldErrors['timezone'],
                    errorMaxLines: 3,
                    suffixIcon: const Icon(Icons.unfold_more),
                  ),
                  child: Text(_timezone.replaceAll('_', ' ')),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.x4),
          _Group(
            title: 'Places',
            children: [
              TextField(
                controller: _capacity,
                enabled: !_busy,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Capacity',
                  hintText: 'Leave empty for no limit',
                  errorText: _fieldErrors['capacity'],
                  errorMaxLines: 3,
                ),
              ),
              const SizedBox(height: Spacing.x2),
              SwitchListTile(
                value: _waitlist,
                onChanged: _busy ? null : (v) => setState(() => _waitlist = v),
                contentPadding: EdgeInsets.zero,
                title: const Text('Waitlist'),
                subtitle: const Text(
                  'When the event is full, extra sign-ups join a waitlist instead of '
                  'being turned away.',
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.x5),
          PillButton(
            label: _busy
                ? 'Saving…'
                : _isEdit
                ? 'Save changes'
                : 'Create event',
            loading: _busy,
            onPressed: _busy ? null : _submit,
          ),
          const SizedBox(height: Spacing.x2),
          TextButton(
            onPressed: _busy
                ? null
                : widget.firstEvent
                    ? () => context.go(Routes.orgWelcome(null))
                    : () => context.pop(),
            child: Text(widget.firstEvent ? 'Skip for now' : 'Cancel'),
          ),
        ],
      ),
    );
  }
}

/// A wall-clock date + time ("YYYY-MM-DDTHH:mm"), picked with the platform
/// date and time dialogs. Never converts through a zone: what the user
/// picks is exactly what is sent.
class _DateTimeField extends StatelessWidget {
  const _DateTimeField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.clearable = false,
    this.errorText,
  });

  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool enabled;
  final bool clearable;
  final String? errorText;

  static final _pattern = RegExp(r'^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})');

  static DateTime? parse(String? wallClock) {
    if (wallClock == null) return null;
    final m = _pattern.firstMatch(wallClock);
    if (m == null) return null;
    return DateTime(
      int.parse(m[1]!),
      int.parse(m[2]!),
      int.parse(m[3]!),
      int.parse(m[4]!),
      int.parse(m[5]!),
    );
  }

  static String format(DateTime local) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${local.year}-${two(local.month)}-${two(local.day)}'
        'T${two(local.hour)}:${two(local.minute)}';
  }

  static String display(String wallClock) {
    final d = parse(wallClock);
    return d == null ? wallClock : DateFormat('EEE, d MMM y, h:mm a').format(d);
  }

  Future<void> _pick(BuildContext context) async {
    final current = parse(value) ?? _defaultStart();
    final date = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(current.year - 1),
      lastDate: DateTime(current.year + 5),
    );
    if (date == null || !context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current.hour, minute: current.minute),
    );
    if (time == null) return;
    onChanged(
      format(DateTime(date.year, date.month, date.day, time.hour, time.minute)),
    );
  }

  /// Tomorrow at 18:00 — a sensible first suggestion for a new event.
  static DateTime _defaultStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1, 18);
  }

  @override
  Widget build(BuildContext context) {
    final v = value;
    return InkWell(
      borderRadius: BorderRadius.circular(Radii.sm),
      onTap: enabled ? () => _pick(context) : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          errorMaxLines: 3,
          suffixIcon: clearable && v != null
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: 'Clear',
                  onPressed: enabled ? () => onChanged(null) : null,
                )
              : const Icon(Icons.calendar_today_outlined, size: 20),
        ),
        isEmpty: v == null,
        child: Text(
          v == null ? '' : display(v),
          style: TextStyle(
            color: v == null ? context.palette.faint : context.palette.ink,
          ),
        ),
      ),
    );
  }
}

/// A white card grouping related fields under a small heading.
class _Group extends StatelessWidget {
  const _Group({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Material(
      color: p.surface,
      borderRadius: BorderRadius.circular(Radii.card),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.gutter),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title.toUpperCase(),
              style: AppType.caption.copyWith(color: p.faint),
            ),
            const SizedBox(height: Spacing.x3),
            ...children,
          ],
        ),
      ),
    );
  }
}
