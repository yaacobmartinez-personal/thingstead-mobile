// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedAttendeesTable extends CachedAttendees
    with TableInfo<$CachedAttendeesTable, CachedAttendee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedAttendeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _orgSlugMeta = const VerificationMeta(
    'orgSlug',
  );
  @override
  late final GeneratedColumn<String> orgSlug = GeneratedColumn<String>(
    'org_slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventSlugMeta = const VerificationMeta(
    'eventSlug',
  );
  @override
  late final GeneratedColumn<String> eventSlug = GeneratedColumn<String>(
    'event_slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkedInAtMeta = const VerificationMeta(
    'checkedInAt',
  );
  @override
  late final GeneratedColumn<DateTime> checkedInAt = GeneratedColumn<DateTime>(
    'checked_in_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _erasedMeta = const VerificationMeta('erased');
  @override
  late final GeneratedColumn<bool> erased = GeneratedColumn<bool>(
    'erased',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("erased" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _checkInTokenMeta = const VerificationMeta(
    'checkInToken',
  );
  @override
  late final GeneratedColumn<String> checkInToken = GeneratedColumn<String>(
    'check_in_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    orgSlug,
    eventSlug,
    id,
    name,
    email,
    status,
    checkedInAt,
    erased,
    checkInToken,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_attendees';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedAttendee> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('org_slug')) {
      context.handle(
        _orgSlugMeta,
        orgSlug.isAcceptableOrUnknown(data['org_slug']!, _orgSlugMeta),
      );
    } else if (isInserting) {
      context.missing(_orgSlugMeta);
    }
    if (data.containsKey('event_slug')) {
      context.handle(
        _eventSlugMeta,
        eventSlug.isAcceptableOrUnknown(data['event_slug']!, _eventSlugMeta),
      );
    } else if (isInserting) {
      context.missing(_eventSlugMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('checked_in_at')) {
      context.handle(
        _checkedInAtMeta,
        checkedInAt.isAcceptableOrUnknown(
          data['checked_in_at']!,
          _checkedInAtMeta,
        ),
      );
    }
    if (data.containsKey('erased')) {
      context.handle(
        _erasedMeta,
        erased.isAcceptableOrUnknown(data['erased']!, _erasedMeta),
      );
    }
    if (data.containsKey('check_in_token')) {
      context.handle(
        _checkInTokenMeta,
        checkInToken.isAcceptableOrUnknown(
          data['check_in_token']!,
          _checkInTokenMeta,
        ),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {orgSlug, eventSlug, id};
  @override
  CachedAttendee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedAttendee(
      orgSlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_slug'],
      )!,
      eventSlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_slug'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      checkedInAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}checked_in_at'],
      ),
      erased: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}erased'],
      )!,
      checkInToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}check_in_token'],
      ),
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $CachedAttendeesTable createAlias(String alias) {
    return $CachedAttendeesTable(attachedDatabase, alias);
  }
}

class CachedAttendee extends DataClass implements Insertable<CachedAttendee> {
  final String orgSlug;
  final String eventSlug;
  final String id;
  final String? name;
  final String? email;

  /// Wire value: CONFIRMED | WAITLIST | CANCELLED.
  final String status;
  final DateTime? checkedInAt;
  final bool erased;
  final String? checkInToken;
  final DateTime fetchedAt;
  const CachedAttendee({
    required this.orgSlug,
    required this.eventSlug,
    required this.id,
    this.name,
    this.email,
    required this.status,
    this.checkedInAt,
    required this.erased,
    this.checkInToken,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['org_slug'] = Variable<String>(orgSlug);
    map['event_slug'] = Variable<String>(eventSlug);
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || checkedInAt != null) {
      map['checked_in_at'] = Variable<DateTime>(checkedInAt);
    }
    map['erased'] = Variable<bool>(erased);
    if (!nullToAbsent || checkInToken != null) {
      map['check_in_token'] = Variable<String>(checkInToken);
    }
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  CachedAttendeesCompanion toCompanion(bool nullToAbsent) {
    return CachedAttendeesCompanion(
      orgSlug: Value(orgSlug),
      eventSlug: Value(eventSlug),
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      status: Value(status),
      checkedInAt: checkedInAt == null && nullToAbsent
          ? const Value.absent()
          : Value(checkedInAt),
      erased: Value(erased),
      checkInToken: checkInToken == null && nullToAbsent
          ? const Value.absent()
          : Value(checkInToken),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory CachedAttendee.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedAttendee(
      orgSlug: serializer.fromJson<String>(json['orgSlug']),
      eventSlug: serializer.fromJson<String>(json['eventSlug']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      email: serializer.fromJson<String?>(json['email']),
      status: serializer.fromJson<String>(json['status']),
      checkedInAt: serializer.fromJson<DateTime?>(json['checkedInAt']),
      erased: serializer.fromJson<bool>(json['erased']),
      checkInToken: serializer.fromJson<String?>(json['checkInToken']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'orgSlug': serializer.toJson<String>(orgSlug),
      'eventSlug': serializer.toJson<String>(eventSlug),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'email': serializer.toJson<String?>(email),
      'status': serializer.toJson<String>(status),
      'checkedInAt': serializer.toJson<DateTime?>(checkedInAt),
      'erased': serializer.toJson<bool>(erased),
      'checkInToken': serializer.toJson<String?>(checkInToken),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  CachedAttendee copyWith({
    String? orgSlug,
    String? eventSlug,
    String? id,
    Value<String?> name = const Value.absent(),
    Value<String?> email = const Value.absent(),
    String? status,
    Value<DateTime?> checkedInAt = const Value.absent(),
    bool? erased,
    Value<String?> checkInToken = const Value.absent(),
    DateTime? fetchedAt,
  }) => CachedAttendee(
    orgSlug: orgSlug ?? this.orgSlug,
    eventSlug: eventSlug ?? this.eventSlug,
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    email: email.present ? email.value : this.email,
    status: status ?? this.status,
    checkedInAt: checkedInAt.present ? checkedInAt.value : this.checkedInAt,
    erased: erased ?? this.erased,
    checkInToken: checkInToken.present ? checkInToken.value : this.checkInToken,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  CachedAttendee copyWithCompanion(CachedAttendeesCompanion data) {
    return CachedAttendee(
      orgSlug: data.orgSlug.present ? data.orgSlug.value : this.orgSlug,
      eventSlug: data.eventSlug.present ? data.eventSlug.value : this.eventSlug,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      status: data.status.present ? data.status.value : this.status,
      checkedInAt: data.checkedInAt.present
          ? data.checkedInAt.value
          : this.checkedInAt,
      erased: data.erased.present ? data.erased.value : this.erased,
      checkInToken: data.checkInToken.present
          ? data.checkInToken.value
          : this.checkInToken,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedAttendee(')
          ..write('orgSlug: $orgSlug, ')
          ..write('eventSlug: $eventSlug, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('status: $status, ')
          ..write('checkedInAt: $checkedInAt, ')
          ..write('erased: $erased, ')
          ..write('checkInToken: $checkInToken, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    orgSlug,
    eventSlug,
    id,
    name,
    email,
    status,
    checkedInAt,
    erased,
    checkInToken,
    fetchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedAttendee &&
          other.orgSlug == this.orgSlug &&
          other.eventSlug == this.eventSlug &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.status == this.status &&
          other.checkedInAt == this.checkedInAt &&
          other.erased == this.erased &&
          other.checkInToken == this.checkInToken &&
          other.fetchedAt == this.fetchedAt);
}

class CachedAttendeesCompanion extends UpdateCompanion<CachedAttendee> {
  final Value<String> orgSlug;
  final Value<String> eventSlug;
  final Value<String> id;
  final Value<String?> name;
  final Value<String?> email;
  final Value<String> status;
  final Value<DateTime?> checkedInAt;
  final Value<bool> erased;
  final Value<String?> checkInToken;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const CachedAttendeesCompanion({
    this.orgSlug = const Value.absent(),
    this.eventSlug = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.status = const Value.absent(),
    this.checkedInAt = const Value.absent(),
    this.erased = const Value.absent(),
    this.checkInToken = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedAttendeesCompanion.insert({
    required String orgSlug,
    required String eventSlug,
    required String id,
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    required String status,
    this.checkedInAt = const Value.absent(),
    this.erased = const Value.absent(),
    this.checkInToken = const Value.absent(),
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : orgSlug = Value(orgSlug),
       eventSlug = Value(eventSlug),
       id = Value(id),
       status = Value(status),
       fetchedAt = Value(fetchedAt);
  static Insertable<CachedAttendee> custom({
    Expression<String>? orgSlug,
    Expression<String>? eventSlug,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? status,
    Expression<DateTime>? checkedInAt,
    Expression<bool>? erased,
    Expression<String>? checkInToken,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (orgSlug != null) 'org_slug': orgSlug,
      if (eventSlug != null) 'event_slug': eventSlug,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (status != null) 'status': status,
      if (checkedInAt != null) 'checked_in_at': checkedInAt,
      if (erased != null) 'erased': erased,
      if (checkInToken != null) 'check_in_token': checkInToken,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedAttendeesCompanion copyWith({
    Value<String>? orgSlug,
    Value<String>? eventSlug,
    Value<String>? id,
    Value<String?>? name,
    Value<String?>? email,
    Value<String>? status,
    Value<DateTime?>? checkedInAt,
    Value<bool>? erased,
    Value<String?>? checkInToken,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return CachedAttendeesCompanion(
      orgSlug: orgSlug ?? this.orgSlug,
      eventSlug: eventSlug ?? this.eventSlug,
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      status: status ?? this.status,
      checkedInAt: checkedInAt ?? this.checkedInAt,
      erased: erased ?? this.erased,
      checkInToken: checkInToken ?? this.checkInToken,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (orgSlug.present) {
      map['org_slug'] = Variable<String>(orgSlug.value);
    }
    if (eventSlug.present) {
      map['event_slug'] = Variable<String>(eventSlug.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (checkedInAt.present) {
      map['checked_in_at'] = Variable<DateTime>(checkedInAt.value);
    }
    if (erased.present) {
      map['erased'] = Variable<bool>(erased.value);
    }
    if (checkInToken.present) {
      map['check_in_token'] = Variable<String>(checkInToken.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedAttendeesCompanion(')
          ..write('orgSlug: $orgSlug, ')
          ..write('eventSlug: $eventSlug, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('status: $status, ')
          ..write('checkedInAt: $checkedInAt, ')
          ..write('erased: $erased, ')
          ..write('checkInToken: $checkInToken, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedEventsTable extends CachedEvents
    with TableInfo<$CachedEventsTable, CachedEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _orgSlugMeta = const VerificationMeta(
    'orgSlug',
  );
  @override
  late final GeneratedColumn<String> orgSlug = GeneratedColumn<String>(
    'org_slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startsAtMeta = const VerificationMeta(
    'startsAt',
  );
  @override
  late final GeneratedColumn<DateTime> startsAt = GeneratedColumn<DateTime>(
    'starts_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endsAtMeta = const VerificationMeta('endsAt');
  @override
  late final GeneratedColumn<DateTime> endsAt = GeneratedColumn<DateTime>(
    'ends_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capacityMeta = const VerificationMeta(
    'capacity',
  );
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
    'capacity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confirmedMeta = const VerificationMeta(
    'confirmed',
  );
  @override
  late final GeneratedColumn<int> confirmed = GeneratedColumn<int>(
    'confirmed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _checkedInMeta = const VerificationMeta(
    'checkedIn',
  );
  @override
  late final GeneratedColumn<int> checkedIn = GeneratedColumn<int>(
    'checked_in',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    orgSlug,
    slug,
    title,
    startsAt,
    endsAt,
    timezone,
    capacity,
    status,
    confirmed,
    checkedIn,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('org_slug')) {
      context.handle(
        _orgSlugMeta,
        orgSlug.isAcceptableOrUnknown(data['org_slug']!, _orgSlugMeta),
      );
    } else if (isInserting) {
      context.missing(_orgSlugMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('starts_at')) {
      context.handle(
        _startsAtMeta,
        startsAt.isAcceptableOrUnknown(data['starts_at']!, _startsAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startsAtMeta);
    }
    if (data.containsKey('ends_at')) {
      context.handle(
        _endsAtMeta,
        endsAt.isAcceptableOrUnknown(data['ends_at']!, _endsAtMeta),
      );
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    } else if (isInserting) {
      context.missing(_timezoneMeta);
    }
    if (data.containsKey('capacity')) {
      context.handle(
        _capacityMeta,
        capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('confirmed')) {
      context.handle(
        _confirmedMeta,
        confirmed.isAcceptableOrUnknown(data['confirmed']!, _confirmedMeta),
      );
    }
    if (data.containsKey('checked_in')) {
      context.handle(
        _checkedInMeta,
        checkedIn.isAcceptableOrUnknown(data['checked_in']!, _checkedInMeta),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {orgSlug, slug};
  @override
  CachedEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedEvent(
      orgSlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_slug'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      startsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}starts_at'],
      )!,
      endsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ends_at'],
      ),
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      )!,
      capacity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}capacity'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      confirmed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}confirmed'],
      )!,
      checkedIn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}checked_in'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $CachedEventsTable createAlias(String alias) {
    return $CachedEventsTable(attachedDatabase, alias);
  }
}

class CachedEvent extends DataClass implements Insertable<CachedEvent> {
  final String orgSlug;
  final String slug;
  final String title;
  final DateTime startsAt;
  final DateTime? endsAt;
  final String timezone;
  final int? capacity;

  /// Wire value: DRAFT | PUBLISHED | CLOSED.
  final String status;
  final int confirmed;
  final int checkedIn;
  final DateTime fetchedAt;
  const CachedEvent({
    required this.orgSlug,
    required this.slug,
    required this.title,
    required this.startsAt,
    this.endsAt,
    required this.timezone,
    this.capacity,
    required this.status,
    required this.confirmed,
    required this.checkedIn,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['org_slug'] = Variable<String>(orgSlug);
    map['slug'] = Variable<String>(slug);
    map['title'] = Variable<String>(title);
    map['starts_at'] = Variable<DateTime>(startsAt);
    if (!nullToAbsent || endsAt != null) {
      map['ends_at'] = Variable<DateTime>(endsAt);
    }
    map['timezone'] = Variable<String>(timezone);
    if (!nullToAbsent || capacity != null) {
      map['capacity'] = Variable<int>(capacity);
    }
    map['status'] = Variable<String>(status);
    map['confirmed'] = Variable<int>(confirmed);
    map['checked_in'] = Variable<int>(checkedIn);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  CachedEventsCompanion toCompanion(bool nullToAbsent) {
    return CachedEventsCompanion(
      orgSlug: Value(orgSlug),
      slug: Value(slug),
      title: Value(title),
      startsAt: Value(startsAt),
      endsAt: endsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endsAt),
      timezone: Value(timezone),
      capacity: capacity == null && nullToAbsent
          ? const Value.absent()
          : Value(capacity),
      status: Value(status),
      confirmed: Value(confirmed),
      checkedIn: Value(checkedIn),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory CachedEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedEvent(
      orgSlug: serializer.fromJson<String>(json['orgSlug']),
      slug: serializer.fromJson<String>(json['slug']),
      title: serializer.fromJson<String>(json['title']),
      startsAt: serializer.fromJson<DateTime>(json['startsAt']),
      endsAt: serializer.fromJson<DateTime?>(json['endsAt']),
      timezone: serializer.fromJson<String>(json['timezone']),
      capacity: serializer.fromJson<int?>(json['capacity']),
      status: serializer.fromJson<String>(json['status']),
      confirmed: serializer.fromJson<int>(json['confirmed']),
      checkedIn: serializer.fromJson<int>(json['checkedIn']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'orgSlug': serializer.toJson<String>(orgSlug),
      'slug': serializer.toJson<String>(slug),
      'title': serializer.toJson<String>(title),
      'startsAt': serializer.toJson<DateTime>(startsAt),
      'endsAt': serializer.toJson<DateTime?>(endsAt),
      'timezone': serializer.toJson<String>(timezone),
      'capacity': serializer.toJson<int?>(capacity),
      'status': serializer.toJson<String>(status),
      'confirmed': serializer.toJson<int>(confirmed),
      'checkedIn': serializer.toJson<int>(checkedIn),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  CachedEvent copyWith({
    String? orgSlug,
    String? slug,
    String? title,
    DateTime? startsAt,
    Value<DateTime?> endsAt = const Value.absent(),
    String? timezone,
    Value<int?> capacity = const Value.absent(),
    String? status,
    int? confirmed,
    int? checkedIn,
    DateTime? fetchedAt,
  }) => CachedEvent(
    orgSlug: orgSlug ?? this.orgSlug,
    slug: slug ?? this.slug,
    title: title ?? this.title,
    startsAt: startsAt ?? this.startsAt,
    endsAt: endsAt.present ? endsAt.value : this.endsAt,
    timezone: timezone ?? this.timezone,
    capacity: capacity.present ? capacity.value : this.capacity,
    status: status ?? this.status,
    confirmed: confirmed ?? this.confirmed,
    checkedIn: checkedIn ?? this.checkedIn,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  CachedEvent copyWithCompanion(CachedEventsCompanion data) {
    return CachedEvent(
      orgSlug: data.orgSlug.present ? data.orgSlug.value : this.orgSlug,
      slug: data.slug.present ? data.slug.value : this.slug,
      title: data.title.present ? data.title.value : this.title,
      startsAt: data.startsAt.present ? data.startsAt.value : this.startsAt,
      endsAt: data.endsAt.present ? data.endsAt.value : this.endsAt,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      status: data.status.present ? data.status.value : this.status,
      confirmed: data.confirmed.present ? data.confirmed.value : this.confirmed,
      checkedIn: data.checkedIn.present ? data.checkedIn.value : this.checkedIn,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedEvent(')
          ..write('orgSlug: $orgSlug, ')
          ..write('slug: $slug, ')
          ..write('title: $title, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt, ')
          ..write('timezone: $timezone, ')
          ..write('capacity: $capacity, ')
          ..write('status: $status, ')
          ..write('confirmed: $confirmed, ')
          ..write('checkedIn: $checkedIn, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    orgSlug,
    slug,
    title,
    startsAt,
    endsAt,
    timezone,
    capacity,
    status,
    confirmed,
    checkedIn,
    fetchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedEvent &&
          other.orgSlug == this.orgSlug &&
          other.slug == this.slug &&
          other.title == this.title &&
          other.startsAt == this.startsAt &&
          other.endsAt == this.endsAt &&
          other.timezone == this.timezone &&
          other.capacity == this.capacity &&
          other.status == this.status &&
          other.confirmed == this.confirmed &&
          other.checkedIn == this.checkedIn &&
          other.fetchedAt == this.fetchedAt);
}

class CachedEventsCompanion extends UpdateCompanion<CachedEvent> {
  final Value<String> orgSlug;
  final Value<String> slug;
  final Value<String> title;
  final Value<DateTime> startsAt;
  final Value<DateTime?> endsAt;
  final Value<String> timezone;
  final Value<int?> capacity;
  final Value<String> status;
  final Value<int> confirmed;
  final Value<int> checkedIn;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const CachedEventsCompanion({
    this.orgSlug = const Value.absent(),
    this.slug = const Value.absent(),
    this.title = const Value.absent(),
    this.startsAt = const Value.absent(),
    this.endsAt = const Value.absent(),
    this.timezone = const Value.absent(),
    this.capacity = const Value.absent(),
    this.status = const Value.absent(),
    this.confirmed = const Value.absent(),
    this.checkedIn = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedEventsCompanion.insert({
    required String orgSlug,
    required String slug,
    required String title,
    required DateTime startsAt,
    this.endsAt = const Value.absent(),
    required String timezone,
    this.capacity = const Value.absent(),
    required String status,
    this.confirmed = const Value.absent(),
    this.checkedIn = const Value.absent(),
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : orgSlug = Value(orgSlug),
       slug = Value(slug),
       title = Value(title),
       startsAt = Value(startsAt),
       timezone = Value(timezone),
       status = Value(status),
       fetchedAt = Value(fetchedAt);
  static Insertable<CachedEvent> custom({
    Expression<String>? orgSlug,
    Expression<String>? slug,
    Expression<String>? title,
    Expression<DateTime>? startsAt,
    Expression<DateTime>? endsAt,
    Expression<String>? timezone,
    Expression<int>? capacity,
    Expression<String>? status,
    Expression<int>? confirmed,
    Expression<int>? checkedIn,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (orgSlug != null) 'org_slug': orgSlug,
      if (slug != null) 'slug': slug,
      if (title != null) 'title': title,
      if (startsAt != null) 'starts_at': startsAt,
      if (endsAt != null) 'ends_at': endsAt,
      if (timezone != null) 'timezone': timezone,
      if (capacity != null) 'capacity': capacity,
      if (status != null) 'status': status,
      if (confirmed != null) 'confirmed': confirmed,
      if (checkedIn != null) 'checked_in': checkedIn,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedEventsCompanion copyWith({
    Value<String>? orgSlug,
    Value<String>? slug,
    Value<String>? title,
    Value<DateTime>? startsAt,
    Value<DateTime?>? endsAt,
    Value<String>? timezone,
    Value<int?>? capacity,
    Value<String>? status,
    Value<int>? confirmed,
    Value<int>? checkedIn,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return CachedEventsCompanion(
      orgSlug: orgSlug ?? this.orgSlug,
      slug: slug ?? this.slug,
      title: title ?? this.title,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      timezone: timezone ?? this.timezone,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      confirmed: confirmed ?? this.confirmed,
      checkedIn: checkedIn ?? this.checkedIn,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (orgSlug.present) {
      map['org_slug'] = Variable<String>(orgSlug.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startsAt.present) {
      map['starts_at'] = Variable<DateTime>(startsAt.value);
    }
    if (endsAt.present) {
      map['ends_at'] = Variable<DateTime>(endsAt.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (confirmed.present) {
      map['confirmed'] = Variable<int>(confirmed.value);
    }
    if (checkedIn.present) {
      map['checked_in'] = Variable<int>(checkedIn.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedEventsCompanion(')
          ..write('orgSlug: $orgSlug, ')
          ..write('slug: $slug, ')
          ..write('title: $title, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt, ')
          ..write('timezone: $timezone, ')
          ..write('capacity: $capacity, ')
          ..write('status: $status, ')
          ..write('confirmed: $confirmed, ')
          ..write('checkedIn: $checkedIn, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ListMetaTable extends ListMeta
    with TableInfo<$ListMetaTable, ListMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _orgSlugMeta = const VerificationMeta(
    'orgSlug',
  );
  @override
  late final GeneratedColumn<String> orgSlug = GeneratedColumn<String>(
    'org_slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventSlugMeta = const VerificationMeta(
    'eventSlug',
  );
  @override
  late final GeneratedColumn<String> eventSlug = GeneratedColumn<String>(
    'event_slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capacityMeta = const VerificationMeta(
    'capacity',
  );
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
    'capacity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waitlistMeta = const VerificationMeta(
    'waitlist',
  );
  @override
  late final GeneratedColumn<int> waitlist = GeneratedColumn<int>(
    'waitlist',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    orgSlug,
    eventSlug,
    title,
    timezone,
    capacity,
    waitlist,
    fetchedAt,
    lastSyncedAt,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'list_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<ListMetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('org_slug')) {
      context.handle(
        _orgSlugMeta,
        orgSlug.isAcceptableOrUnknown(data['org_slug']!, _orgSlugMeta),
      );
    } else if (isInserting) {
      context.missing(_orgSlugMeta);
    }
    if (data.containsKey('event_slug')) {
      context.handle(
        _eventSlugMeta,
        eventSlug.isAcceptableOrUnknown(data['event_slug']!, _eventSlugMeta),
      );
    } else if (isInserting) {
      context.missing(_eventSlugMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    } else if (isInserting) {
      context.missing(_timezoneMeta);
    }
    if (data.containsKey('capacity')) {
      context.handle(
        _capacityMeta,
        capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta),
      );
    }
    if (data.containsKey('waitlist')) {
      context.handle(
        _waitlistMeta,
        waitlist.isAcceptableOrUnknown(data['waitlist']!, _waitlistMeta),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {orgSlug, eventSlug};
  @override
  ListMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListMetaData(
      orgSlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_slug'],
      )!,
      eventSlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_slug'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      )!,
      capacity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}capacity'],
      ),
      waitlist: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}waitlist'],
      ),
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $ListMetaTable createAlias(String alias) {
    return $ListMetaTable(attachedDatabase, alias);
  }
}

class ListMetaData extends DataClass implements Insertable<ListMetaData> {
  final String orgSlug;
  final String eventSlug;
  final String title;
  final String timezone;
  final int? capacity;
  final int? waitlist;
  final DateTime fetchedAt;
  final DateTime? lastSyncedAt;
  final String? lastError;
  const ListMetaData({
    required this.orgSlug,
    required this.eventSlug,
    required this.title,
    required this.timezone,
    this.capacity,
    this.waitlist,
    required this.fetchedAt,
    this.lastSyncedAt,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['org_slug'] = Variable<String>(orgSlug);
    map['event_slug'] = Variable<String>(eventSlug);
    map['title'] = Variable<String>(title);
    map['timezone'] = Variable<String>(timezone);
    if (!nullToAbsent || capacity != null) {
      map['capacity'] = Variable<int>(capacity);
    }
    if (!nullToAbsent || waitlist != null) {
      map['waitlist'] = Variable<int>(waitlist);
    }
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  ListMetaCompanion toCompanion(bool nullToAbsent) {
    return ListMetaCompanion(
      orgSlug: Value(orgSlug),
      eventSlug: Value(eventSlug),
      title: Value(title),
      timezone: Value(timezone),
      capacity: capacity == null && nullToAbsent
          ? const Value.absent()
          : Value(capacity),
      waitlist: waitlist == null && nullToAbsent
          ? const Value.absent()
          : Value(waitlist),
      fetchedAt: Value(fetchedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory ListMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListMetaData(
      orgSlug: serializer.fromJson<String>(json['orgSlug']),
      eventSlug: serializer.fromJson<String>(json['eventSlug']),
      title: serializer.fromJson<String>(json['title']),
      timezone: serializer.fromJson<String>(json['timezone']),
      capacity: serializer.fromJson<int?>(json['capacity']),
      waitlist: serializer.fromJson<int?>(json['waitlist']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'orgSlug': serializer.toJson<String>(orgSlug),
      'eventSlug': serializer.toJson<String>(eventSlug),
      'title': serializer.toJson<String>(title),
      'timezone': serializer.toJson<String>(timezone),
      'capacity': serializer.toJson<int?>(capacity),
      'waitlist': serializer.toJson<int?>(waitlist),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  ListMetaData copyWith({
    String? orgSlug,
    String? eventSlug,
    String? title,
    String? timezone,
    Value<int?> capacity = const Value.absent(),
    Value<int?> waitlist = const Value.absent(),
    DateTime? fetchedAt,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
  }) => ListMetaData(
    orgSlug: orgSlug ?? this.orgSlug,
    eventSlug: eventSlug ?? this.eventSlug,
    title: title ?? this.title,
    timezone: timezone ?? this.timezone,
    capacity: capacity.present ? capacity.value : this.capacity,
    waitlist: waitlist.present ? waitlist.value : this.waitlist,
    fetchedAt: fetchedAt ?? this.fetchedAt,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  ListMetaData copyWithCompanion(ListMetaCompanion data) {
    return ListMetaData(
      orgSlug: data.orgSlug.present ? data.orgSlug.value : this.orgSlug,
      eventSlug: data.eventSlug.present ? data.eventSlug.value : this.eventSlug,
      title: data.title.present ? data.title.value : this.title,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      waitlist: data.waitlist.present ? data.waitlist.value : this.waitlist,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListMetaData(')
          ..write('orgSlug: $orgSlug, ')
          ..write('eventSlug: $eventSlug, ')
          ..write('title: $title, ')
          ..write('timezone: $timezone, ')
          ..write('capacity: $capacity, ')
          ..write('waitlist: $waitlist, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    orgSlug,
    eventSlug,
    title,
    timezone,
    capacity,
    waitlist,
    fetchedAt,
    lastSyncedAt,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListMetaData &&
          other.orgSlug == this.orgSlug &&
          other.eventSlug == this.eventSlug &&
          other.title == this.title &&
          other.timezone == this.timezone &&
          other.capacity == this.capacity &&
          other.waitlist == this.waitlist &&
          other.fetchedAt == this.fetchedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.lastError == this.lastError);
}

class ListMetaCompanion extends UpdateCompanion<ListMetaData> {
  final Value<String> orgSlug;
  final Value<String> eventSlug;
  final Value<String> title;
  final Value<String> timezone;
  final Value<int?> capacity;
  final Value<int?> waitlist;
  final Value<DateTime> fetchedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<String?> lastError;
  final Value<int> rowid;
  const ListMetaCompanion({
    this.orgSlug = const Value.absent(),
    this.eventSlug = const Value.absent(),
    this.title = const Value.absent(),
    this.timezone = const Value.absent(),
    this.capacity = const Value.absent(),
    this.waitlist = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ListMetaCompanion.insert({
    required String orgSlug,
    required String eventSlug,
    required String title,
    required String timezone,
    this.capacity = const Value.absent(),
    this.waitlist = const Value.absent(),
    required DateTime fetchedAt,
    this.lastSyncedAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : orgSlug = Value(orgSlug),
       eventSlug = Value(eventSlug),
       title = Value(title),
       timezone = Value(timezone),
       fetchedAt = Value(fetchedAt);
  static Insertable<ListMetaData> custom({
    Expression<String>? orgSlug,
    Expression<String>? eventSlug,
    Expression<String>? title,
    Expression<String>? timezone,
    Expression<int>? capacity,
    Expression<int>? waitlist,
    Expression<DateTime>? fetchedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (orgSlug != null) 'org_slug': orgSlug,
      if (eventSlug != null) 'event_slug': eventSlug,
      if (title != null) 'title': title,
      if (timezone != null) 'timezone': timezone,
      if (capacity != null) 'capacity': capacity,
      if (waitlist != null) 'waitlist': waitlist,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ListMetaCompanion copyWith({
    Value<String>? orgSlug,
    Value<String>? eventSlug,
    Value<String>? title,
    Value<String>? timezone,
    Value<int?>? capacity,
    Value<int?>? waitlist,
    Value<DateTime>? fetchedAt,
    Value<DateTime?>? lastSyncedAt,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return ListMetaCompanion(
      orgSlug: orgSlug ?? this.orgSlug,
      eventSlug: eventSlug ?? this.eventSlug,
      title: title ?? this.title,
      timezone: timezone ?? this.timezone,
      capacity: capacity ?? this.capacity,
      waitlist: waitlist ?? this.waitlist,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (orgSlug.present) {
      map['org_slug'] = Variable<String>(orgSlug.value);
    }
    if (eventSlug.present) {
      map['event_slug'] = Variable<String>(eventSlug.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (waitlist.present) {
      map['waitlist'] = Variable<int>(waitlist.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListMetaCompanion(')
          ..write('orgSlug: $orgSlug, ')
          ..write('eventSlug: $eventSlug, ')
          ..write('title: $title, ')
          ..write('timezone: $timezone, ')
          ..write('capacity: $capacity, ')
          ..write('waitlist: $waitlist, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingCheckinsTable extends PendingCheckins
    with TableInfo<$PendingCheckinsTable, PendingCheckin> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingCheckinsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orgSlugMeta = const VerificationMeta(
    'orgSlug',
  );
  @override
  late final GeneratedColumn<String> orgSlug = GeneratedColumn<String>(
    'org_slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventSlugMeta = const VerificationMeta(
    'eventSlug',
  );
  @override
  late final GeneratedColumn<String> eventSlug = GeneratedColumn<String>(
    'event_slug',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _registrationIdMeta = const VerificationMeta(
    'registrationId',
  );
  @override
  late final GeneratedColumn<String> registrationId = GeneratedColumn<String>(
    'registration_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _desiredCheckedInMeta = const VerificationMeta(
    'desiredCheckedIn',
  );
  @override
  late final GeneratedColumn<bool> desiredCheckedIn = GeneratedColumn<bool>(
    'desired_checked_in',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("desired_checked_in" IN (0, 1))',
    ),
  );
  static const VerificationMeta _attendeeNameMeta = const VerificationMeta(
    'attendeeName',
  );
  @override
  late final GeneratedColumn<String> attendeeName = GeneratedColumn<String>(
    'attendee_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientAtMeta = const VerificationMeta(
    'clientAt',
  );
  @override
  late final GeneratedColumn<DateTime> clientAt = GeneratedColumn<DateTime>(
    'client_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _serverOutcomeMeta = const VerificationMeta(
    'serverOutcome',
  );
  @override
  late final GeneratedColumn<String> serverOutcome = GeneratedColumn<String>(
    'server_outcome',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverCheckedInAtMeta = const VerificationMeta(
    'serverCheckedInAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverCheckedInAt =
      GeneratedColumn<DateTime>(
        'server_checked_in_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
    'resolved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orgSlug,
    eventSlug,
    kind,
    registrationId,
    code,
    desiredCheckedIn,
    attendeeName,
    clientAt,
    createdAt,
    attempts,
    nextAttemptAt,
    lastError,
    state,
    serverOutcome,
    serverCheckedInAt,
    resolvedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_checkins';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingCheckin> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('org_slug')) {
      context.handle(
        _orgSlugMeta,
        orgSlug.isAcceptableOrUnknown(data['org_slug']!, _orgSlugMeta),
      );
    } else if (isInserting) {
      context.missing(_orgSlugMeta);
    }
    if (data.containsKey('event_slug')) {
      context.handle(
        _eventSlugMeta,
        eventSlug.isAcceptableOrUnknown(data['event_slug']!, _eventSlugMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('registration_id')) {
      context.handle(
        _registrationIdMeta,
        registrationId.isAcceptableOrUnknown(
          data['registration_id']!,
          _registrationIdMeta,
        ),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('desired_checked_in')) {
      context.handle(
        _desiredCheckedInMeta,
        desiredCheckedIn.isAcceptableOrUnknown(
          data['desired_checked_in']!,
          _desiredCheckedInMeta,
        ),
      );
    }
    if (data.containsKey('attendee_name')) {
      context.handle(
        _attendeeNameMeta,
        attendeeName.isAcceptableOrUnknown(
          data['attendee_name']!,
          _attendeeNameMeta,
        ),
      );
    }
    if (data.containsKey('client_at')) {
      context.handle(
        _clientAtMeta,
        clientAt.isAcceptableOrUnknown(data['client_at']!, _clientAtMeta),
      );
    } else if (isInserting) {
      context.missing(_clientAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextAttemptAtMeta);
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('server_outcome')) {
      context.handle(
        _serverOutcomeMeta,
        serverOutcome.isAcceptableOrUnknown(
          data['server_outcome']!,
          _serverOutcomeMeta,
        ),
      );
    }
    if (data.containsKey('server_checked_in_at')) {
      context.handle(
        _serverCheckedInAtMeta,
        serverCheckedInAt.isAcceptableOrUnknown(
          data['server_checked_in_at']!,
          _serverCheckedInAtMeta,
        ),
      );
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingCheckin map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingCheckin(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orgSlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}org_slug'],
      )!,
      eventSlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_slug'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      registrationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registration_id'],
      ),
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      desiredCheckedIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}desired_checked_in'],
      ),
      attendeeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attendee_name'],
      ),
      clientAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}client_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      serverOutcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_outcome'],
      ),
      serverCheckedInAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_checked_in_at'],
      ),
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resolved_at'],
      ),
    );
  }

  @override
  $PendingCheckinsTable createAlias(String alias) {
    return $PendingCheckinsTable(attachedDatabase, alias);
  }
}

class PendingCheckin extends DataClass implements Insertable<PendingCheckin> {
  final String id;
  final String orgSlug;

  /// Null for a blind scan made without an event pinned.
  final String? eventSlug;

  /// manual | scan.
  final String kind;

  /// Known for manual toggles and for scans resolved against the cache.
  final String? registrationId;

  /// The raw scanned value, for replaying a scan.
  final String? code;
  final bool? desiredCheckedIn;

  /// Display only, so the attention list can name the person.
  final String? attendeeName;

  /// When the door action happened (sent as `at` once API-CONTRACT #24 ships).
  final DateTime clientAt;
  final DateTime createdAt;
  final int attempts;
  final DateTime nextAttemptAt;
  final String? lastError;

  /// pending | syncing | synced | attention.
  final String state;
  final String? serverOutcome;
  final DateTime? serverCheckedInAt;
  final DateTime? resolvedAt;
  const PendingCheckin({
    required this.id,
    required this.orgSlug,
    this.eventSlug,
    required this.kind,
    this.registrationId,
    this.code,
    this.desiredCheckedIn,
    this.attendeeName,
    required this.clientAt,
    required this.createdAt,
    required this.attempts,
    required this.nextAttemptAt,
    this.lastError,
    required this.state,
    this.serverOutcome,
    this.serverCheckedInAt,
    this.resolvedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['org_slug'] = Variable<String>(orgSlug);
    if (!nullToAbsent || eventSlug != null) {
      map['event_slug'] = Variable<String>(eventSlug);
    }
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || registrationId != null) {
      map['registration_id'] = Variable<String>(registrationId);
    }
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || desiredCheckedIn != null) {
      map['desired_checked_in'] = Variable<bool>(desiredCheckedIn);
    }
    if (!nullToAbsent || attendeeName != null) {
      map['attendee_name'] = Variable<String>(attendeeName);
    }
    map['client_at'] = Variable<DateTime>(clientAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || serverOutcome != null) {
      map['server_outcome'] = Variable<String>(serverOutcome);
    }
    if (!nullToAbsent || serverCheckedInAt != null) {
      map['server_checked_in_at'] = Variable<DateTime>(serverCheckedInAt);
    }
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    return map;
  }

  PendingCheckinsCompanion toCompanion(bool nullToAbsent) {
    return PendingCheckinsCompanion(
      id: Value(id),
      orgSlug: Value(orgSlug),
      eventSlug: eventSlug == null && nullToAbsent
          ? const Value.absent()
          : Value(eventSlug),
      kind: Value(kind),
      registrationId: registrationId == null && nullToAbsent
          ? const Value.absent()
          : Value(registrationId),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      desiredCheckedIn: desiredCheckedIn == null && nullToAbsent
          ? const Value.absent()
          : Value(desiredCheckedIn),
      attendeeName: attendeeName == null && nullToAbsent
          ? const Value.absent()
          : Value(attendeeName),
      clientAt: Value(clientAt),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
      nextAttemptAt: Value(nextAttemptAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      state: Value(state),
      serverOutcome: serverOutcome == null && nullToAbsent
          ? const Value.absent()
          : Value(serverOutcome),
      serverCheckedInAt: serverCheckedInAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverCheckedInAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
    );
  }

  factory PendingCheckin.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingCheckin(
      id: serializer.fromJson<String>(json['id']),
      orgSlug: serializer.fromJson<String>(json['orgSlug']),
      eventSlug: serializer.fromJson<String?>(json['eventSlug']),
      kind: serializer.fromJson<String>(json['kind']),
      registrationId: serializer.fromJson<String?>(json['registrationId']),
      code: serializer.fromJson<String?>(json['code']),
      desiredCheckedIn: serializer.fromJson<bool?>(json['desiredCheckedIn']),
      attendeeName: serializer.fromJson<String?>(json['attendeeName']),
      clientAt: serializer.fromJson<DateTime>(json['clientAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      nextAttemptAt: serializer.fromJson<DateTime>(json['nextAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      state: serializer.fromJson<String>(json['state']),
      serverOutcome: serializer.fromJson<String?>(json['serverOutcome']),
      serverCheckedInAt: serializer.fromJson<DateTime?>(
        json['serverCheckedInAt'],
      ),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orgSlug': serializer.toJson<String>(orgSlug),
      'eventSlug': serializer.toJson<String?>(eventSlug),
      'kind': serializer.toJson<String>(kind),
      'registrationId': serializer.toJson<String?>(registrationId),
      'code': serializer.toJson<String?>(code),
      'desiredCheckedIn': serializer.toJson<bool?>(desiredCheckedIn),
      'attendeeName': serializer.toJson<String?>(attendeeName),
      'clientAt': serializer.toJson<DateTime>(clientAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
      'nextAttemptAt': serializer.toJson<DateTime>(nextAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
      'state': serializer.toJson<String>(state),
      'serverOutcome': serializer.toJson<String?>(serverOutcome),
      'serverCheckedInAt': serializer.toJson<DateTime?>(serverCheckedInAt),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
    };
  }

  PendingCheckin copyWith({
    String? id,
    String? orgSlug,
    Value<String?> eventSlug = const Value.absent(),
    String? kind,
    Value<String?> registrationId = const Value.absent(),
    Value<String?> code = const Value.absent(),
    Value<bool?> desiredCheckedIn = const Value.absent(),
    Value<String?> attendeeName = const Value.absent(),
    DateTime? clientAt,
    DateTime? createdAt,
    int? attempts,
    DateTime? nextAttemptAt,
    Value<String?> lastError = const Value.absent(),
    String? state,
    Value<String?> serverOutcome = const Value.absent(),
    Value<DateTime?> serverCheckedInAt = const Value.absent(),
    Value<DateTime?> resolvedAt = const Value.absent(),
  }) => PendingCheckin(
    id: id ?? this.id,
    orgSlug: orgSlug ?? this.orgSlug,
    eventSlug: eventSlug.present ? eventSlug.value : this.eventSlug,
    kind: kind ?? this.kind,
    registrationId: registrationId.present
        ? registrationId.value
        : this.registrationId,
    code: code.present ? code.value : this.code,
    desiredCheckedIn: desiredCheckedIn.present
        ? desiredCheckedIn.value
        : this.desiredCheckedIn,
    attendeeName: attendeeName.present ? attendeeName.value : this.attendeeName,
    clientAt: clientAt ?? this.clientAt,
    createdAt: createdAt ?? this.createdAt,
    attempts: attempts ?? this.attempts,
    nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
    lastError: lastError.present ? lastError.value : this.lastError,
    state: state ?? this.state,
    serverOutcome: serverOutcome.present
        ? serverOutcome.value
        : this.serverOutcome,
    serverCheckedInAt: serverCheckedInAt.present
        ? serverCheckedInAt.value
        : this.serverCheckedInAt,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
  );
  PendingCheckin copyWithCompanion(PendingCheckinsCompanion data) {
    return PendingCheckin(
      id: data.id.present ? data.id.value : this.id,
      orgSlug: data.orgSlug.present ? data.orgSlug.value : this.orgSlug,
      eventSlug: data.eventSlug.present ? data.eventSlug.value : this.eventSlug,
      kind: data.kind.present ? data.kind.value : this.kind,
      registrationId: data.registrationId.present
          ? data.registrationId.value
          : this.registrationId,
      code: data.code.present ? data.code.value : this.code,
      desiredCheckedIn: data.desiredCheckedIn.present
          ? data.desiredCheckedIn.value
          : this.desiredCheckedIn,
      attendeeName: data.attendeeName.present
          ? data.attendeeName.value
          : this.attendeeName,
      clientAt: data.clientAt.present ? data.clientAt.value : this.clientAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      state: data.state.present ? data.state.value : this.state,
      serverOutcome: data.serverOutcome.present
          ? data.serverOutcome.value
          : this.serverOutcome,
      serverCheckedInAt: data.serverCheckedInAt.present
          ? data.serverCheckedInAt.value
          : this.serverCheckedInAt,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingCheckin(')
          ..write('id: $id, ')
          ..write('orgSlug: $orgSlug, ')
          ..write('eventSlug: $eventSlug, ')
          ..write('kind: $kind, ')
          ..write('registrationId: $registrationId, ')
          ..write('code: $code, ')
          ..write('desiredCheckedIn: $desiredCheckedIn, ')
          ..write('attendeeName: $attendeeName, ')
          ..write('clientAt: $clientAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('state: $state, ')
          ..write('serverOutcome: $serverOutcome, ')
          ..write('serverCheckedInAt: $serverCheckedInAt, ')
          ..write('resolvedAt: $resolvedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orgSlug,
    eventSlug,
    kind,
    registrationId,
    code,
    desiredCheckedIn,
    attendeeName,
    clientAt,
    createdAt,
    attempts,
    nextAttemptAt,
    lastError,
    state,
    serverOutcome,
    serverCheckedInAt,
    resolvedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingCheckin &&
          other.id == this.id &&
          other.orgSlug == this.orgSlug &&
          other.eventSlug == this.eventSlug &&
          other.kind == this.kind &&
          other.registrationId == this.registrationId &&
          other.code == this.code &&
          other.desiredCheckedIn == this.desiredCheckedIn &&
          other.attendeeName == this.attendeeName &&
          other.clientAt == this.clientAt &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lastError == this.lastError &&
          other.state == this.state &&
          other.serverOutcome == this.serverOutcome &&
          other.serverCheckedInAt == this.serverCheckedInAt &&
          other.resolvedAt == this.resolvedAt);
}

class PendingCheckinsCompanion extends UpdateCompanion<PendingCheckin> {
  final Value<String> id;
  final Value<String> orgSlug;
  final Value<String?> eventSlug;
  final Value<String> kind;
  final Value<String?> registrationId;
  final Value<String?> code;
  final Value<bool?> desiredCheckedIn;
  final Value<String?> attendeeName;
  final Value<DateTime> clientAt;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  final Value<DateTime> nextAttemptAt;
  final Value<String?> lastError;
  final Value<String> state;
  final Value<String?> serverOutcome;
  final Value<DateTime?> serverCheckedInAt;
  final Value<DateTime?> resolvedAt;
  final Value<int> rowid;
  const PendingCheckinsCompanion({
    this.id = const Value.absent(),
    this.orgSlug = const Value.absent(),
    this.eventSlug = const Value.absent(),
    this.kind = const Value.absent(),
    this.registrationId = const Value.absent(),
    this.code = const Value.absent(),
    this.desiredCheckedIn = const Value.absent(),
    this.attendeeName = const Value.absent(),
    this.clientAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.state = const Value.absent(),
    this.serverOutcome = const Value.absent(),
    this.serverCheckedInAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingCheckinsCompanion.insert({
    required String id,
    required String orgSlug,
    this.eventSlug = const Value.absent(),
    required String kind,
    this.registrationId = const Value.absent(),
    this.code = const Value.absent(),
    this.desiredCheckedIn = const Value.absent(),
    this.attendeeName = const Value.absent(),
    required DateTime clientAt,
    required DateTime createdAt,
    this.attempts = const Value.absent(),
    required DateTime nextAttemptAt,
    this.lastError = const Value.absent(),
    this.state = const Value.absent(),
    this.serverOutcome = const Value.absent(),
    this.serverCheckedInAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orgSlug = Value(orgSlug),
       kind = Value(kind),
       clientAt = Value(clientAt),
       createdAt = Value(createdAt),
       nextAttemptAt = Value(nextAttemptAt);
  static Insertable<PendingCheckin> custom({
    Expression<String>? id,
    Expression<String>? orgSlug,
    Expression<String>? eventSlug,
    Expression<String>? kind,
    Expression<String>? registrationId,
    Expression<String>? code,
    Expression<bool>? desiredCheckedIn,
    Expression<String>? attendeeName,
    Expression<DateTime>? clientAt,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
    Expression<DateTime>? nextAttemptAt,
    Expression<String>? lastError,
    Expression<String>? state,
    Expression<String>? serverOutcome,
    Expression<DateTime>? serverCheckedInAt,
    Expression<DateTime>? resolvedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orgSlug != null) 'org_slug': orgSlug,
      if (eventSlug != null) 'event_slug': eventSlug,
      if (kind != null) 'kind': kind,
      if (registrationId != null) 'registration_id': registrationId,
      if (code != null) 'code': code,
      if (desiredCheckedIn != null) 'desired_checked_in': desiredCheckedIn,
      if (attendeeName != null) 'attendee_name': attendeeName,
      if (clientAt != null) 'client_at': clientAt,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lastError != null) 'last_error': lastError,
      if (state != null) 'state': state,
      if (serverOutcome != null) 'server_outcome': serverOutcome,
      if (serverCheckedInAt != null) 'server_checked_in_at': serverCheckedInAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingCheckinsCompanion copyWith({
    Value<String>? id,
    Value<String>? orgSlug,
    Value<String?>? eventSlug,
    Value<String>? kind,
    Value<String?>? registrationId,
    Value<String?>? code,
    Value<bool?>? desiredCheckedIn,
    Value<String?>? attendeeName,
    Value<DateTime>? clientAt,
    Value<DateTime>? createdAt,
    Value<int>? attempts,
    Value<DateTime>? nextAttemptAt,
    Value<String?>? lastError,
    Value<String>? state,
    Value<String?>? serverOutcome,
    Value<DateTime?>? serverCheckedInAt,
    Value<DateTime?>? resolvedAt,
    Value<int>? rowid,
  }) {
    return PendingCheckinsCompanion(
      id: id ?? this.id,
      orgSlug: orgSlug ?? this.orgSlug,
      eventSlug: eventSlug ?? this.eventSlug,
      kind: kind ?? this.kind,
      registrationId: registrationId ?? this.registrationId,
      code: code ?? this.code,
      desiredCheckedIn: desiredCheckedIn ?? this.desiredCheckedIn,
      attendeeName: attendeeName ?? this.attendeeName,
      clientAt: clientAt ?? this.clientAt,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastError: lastError ?? this.lastError,
      state: state ?? this.state,
      serverOutcome: serverOutcome ?? this.serverOutcome,
      serverCheckedInAt: serverCheckedInAt ?? this.serverCheckedInAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orgSlug.present) {
      map['org_slug'] = Variable<String>(orgSlug.value);
    }
    if (eventSlug.present) {
      map['event_slug'] = Variable<String>(eventSlug.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (registrationId.present) {
      map['registration_id'] = Variable<String>(registrationId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (desiredCheckedIn.present) {
      map['desired_checked_in'] = Variable<bool>(desiredCheckedIn.value);
    }
    if (attendeeName.present) {
      map['attendee_name'] = Variable<String>(attendeeName.value);
    }
    if (clientAt.present) {
      map['client_at'] = Variable<DateTime>(clientAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (serverOutcome.present) {
      map['server_outcome'] = Variable<String>(serverOutcome.value);
    }
    if (serverCheckedInAt.present) {
      map['server_checked_in_at'] = Variable<DateTime>(serverCheckedInAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingCheckinsCompanion(')
          ..write('id: $id, ')
          ..write('orgSlug: $orgSlug, ')
          ..write('eventSlug: $eventSlug, ')
          ..write('kind: $kind, ')
          ..write('registrationId: $registrationId, ')
          ..write('code: $code, ')
          ..write('desiredCheckedIn: $desiredCheckedIn, ')
          ..write('attendeeName: $attendeeName, ')
          ..write('clientAt: $clientAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('state: $state, ')
          ..write('serverOutcome: $serverOutcome, ')
          ..write('serverCheckedInAt: $serverCheckedInAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedAttendeesTable cachedAttendees = $CachedAttendeesTable(
    this,
  );
  late final $CachedEventsTable cachedEvents = $CachedEventsTable(this);
  late final $ListMetaTable listMeta = $ListMetaTable(this);
  late final $PendingCheckinsTable pendingCheckins = $PendingCheckinsTable(
    this,
  );
  late final Index idxCachedAttendeesToken = Index(
    'idx_cached_attendees_token',
    'CREATE INDEX idx_cached_attendees_token ON cached_attendees (org_slug, check_in_token)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedAttendees,
    cachedEvents,
    listMeta,
    pendingCheckins,
    idxCachedAttendeesToken,
  ];
}

typedef $$CachedAttendeesTableCreateCompanionBuilder =
    CachedAttendeesCompanion Function({
      required String orgSlug,
      required String eventSlug,
      required String id,
      Value<String?> name,
      Value<String?> email,
      required String status,
      Value<DateTime?> checkedInAt,
      Value<bool> erased,
      Value<String?> checkInToken,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$CachedAttendeesTableUpdateCompanionBuilder =
    CachedAttendeesCompanion Function({
      Value<String> orgSlug,
      Value<String> eventSlug,
      Value<String> id,
      Value<String?> name,
      Value<String?> email,
      Value<String> status,
      Value<DateTime?> checkedInAt,
      Value<bool> erased,
      Value<String?> checkInToken,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$CachedAttendeesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedAttendeesTable> {
  $$CachedAttendeesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get orgSlug => $composableBuilder(
    column: $table.orgSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventSlug => $composableBuilder(
    column: $table.eventSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkedInAt => $composableBuilder(
    column: $table.checkedInAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get erased => $composableBuilder(
    column: $table.erased,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checkInToken => $composableBuilder(
    column: $table.checkInToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedAttendeesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedAttendeesTable> {
  $$CachedAttendeesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get orgSlug => $composableBuilder(
    column: $table.orgSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventSlug => $composableBuilder(
    column: $table.eventSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkedInAt => $composableBuilder(
    column: $table.checkedInAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get erased => $composableBuilder(
    column: $table.erased,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checkInToken => $composableBuilder(
    column: $table.checkInToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedAttendeesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedAttendeesTable> {
  $$CachedAttendeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get orgSlug =>
      $composableBuilder(column: $table.orgSlug, builder: (column) => column);

  GeneratedColumn<String> get eventSlug =>
      $composableBuilder(column: $table.eventSlug, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get checkedInAt => $composableBuilder(
    column: $table.checkedInAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get erased =>
      $composableBuilder(column: $table.erased, builder: (column) => column);

  GeneratedColumn<String> get checkInToken => $composableBuilder(
    column: $table.checkInToken,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$CachedAttendeesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedAttendeesTable,
          CachedAttendee,
          $$CachedAttendeesTableFilterComposer,
          $$CachedAttendeesTableOrderingComposer,
          $$CachedAttendeesTableAnnotationComposer,
          $$CachedAttendeesTableCreateCompanionBuilder,
          $$CachedAttendeesTableUpdateCompanionBuilder,
          (
            CachedAttendee,
            BaseReferences<
              _$AppDatabase,
              $CachedAttendeesTable,
              CachedAttendee
            >,
          ),
          CachedAttendee,
          PrefetchHooks Function()
        > {
  $$CachedAttendeesTableTableManager(
    _$AppDatabase db,
    $CachedAttendeesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedAttendeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedAttendeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedAttendeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> orgSlug = const Value.absent(),
                Value<String> eventSlug = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> checkedInAt = const Value.absent(),
                Value<bool> erased = const Value.absent(),
                Value<String?> checkInToken = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedAttendeesCompanion(
                orgSlug: orgSlug,
                eventSlug: eventSlug,
                id: id,
                name: name,
                email: email,
                status: status,
                checkedInAt: checkedInAt,
                erased: erased,
                checkInToken: checkInToken,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String orgSlug,
                required String eventSlug,
                required String id,
                Value<String?> name = const Value.absent(),
                Value<String?> email = const Value.absent(),
                required String status,
                Value<DateTime?> checkedInAt = const Value.absent(),
                Value<bool> erased = const Value.absent(),
                Value<String?> checkInToken = const Value.absent(),
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedAttendeesCompanion.insert(
                orgSlug: orgSlug,
                eventSlug: eventSlug,
                id: id,
                name: name,
                email: email,
                status: status,
                checkedInAt: checkedInAt,
                erased: erased,
                checkInToken: checkInToken,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedAttendeesTable, CachedAttendee>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedAttendeesTable,
                    CachedAttendee
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedAttendeesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedAttendeesTable,
      CachedAttendee,
      $$CachedAttendeesTableFilterComposer,
      $$CachedAttendeesTableOrderingComposer,
      $$CachedAttendeesTableAnnotationComposer,
      $$CachedAttendeesTableCreateCompanionBuilder,
      $$CachedAttendeesTableUpdateCompanionBuilder,
      (
        CachedAttendee,
        BaseReferences<_$AppDatabase, $CachedAttendeesTable, CachedAttendee>,
      ),
      CachedAttendee,
      PrefetchHooks Function()
    >;
typedef $$CachedEventsTableCreateCompanionBuilder =
    CachedEventsCompanion Function({
      required String orgSlug,
      required String slug,
      required String title,
      required DateTime startsAt,
      Value<DateTime?> endsAt,
      required String timezone,
      Value<int?> capacity,
      required String status,
      Value<int> confirmed,
      Value<int> checkedIn,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$CachedEventsTableUpdateCompanionBuilder =
    CachedEventsCompanion Function({
      Value<String> orgSlug,
      Value<String> slug,
      Value<String> title,
      Value<DateTime> startsAt,
      Value<DateTime?> endsAt,
      Value<String> timezone,
      Value<int?> capacity,
      Value<String> status,
      Value<int> confirmed,
      Value<int> checkedIn,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$CachedEventsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedEventsTable> {
  $$CachedEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get orgSlug => $composableBuilder(
    column: $table.orgSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endsAt => $composableBuilder(
    column: $table.endsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get confirmed => $composableBuilder(
    column: $table.confirmed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get checkedIn => $composableBuilder(
    column: $table.checkedIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedEventsTable> {
  $$CachedEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get orgSlug => $composableBuilder(
    column: $table.orgSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endsAt => $composableBuilder(
    column: $table.endsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get confirmed => $composableBuilder(
    column: $table.confirmed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get checkedIn => $composableBuilder(
    column: $table.checkedIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedEventsTable> {
  $$CachedEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get orgSlug =>
      $composableBuilder(column: $table.orgSlug, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get startsAt =>
      $composableBuilder(column: $table.startsAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endsAt =>
      $composableBuilder(column: $table.endsAt, builder: (column) => column);

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get confirmed =>
      $composableBuilder(column: $table.confirmed, builder: (column) => column);

  GeneratedColumn<int> get checkedIn =>
      $composableBuilder(column: $table.checkedIn, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$CachedEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedEventsTable,
          CachedEvent,
          $$CachedEventsTableFilterComposer,
          $$CachedEventsTableOrderingComposer,
          $$CachedEventsTableAnnotationComposer,
          $$CachedEventsTableCreateCompanionBuilder,
          $$CachedEventsTableUpdateCompanionBuilder,
          (
            CachedEvent,
            BaseReferences<_$AppDatabase, $CachedEventsTable, CachedEvent>,
          ),
          CachedEvent,
          PrefetchHooks Function()
        > {
  $$CachedEventsTableTableManager(_$AppDatabase db, $CachedEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> orgSlug = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> startsAt = const Value.absent(),
                Value<DateTime?> endsAt = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<int?> capacity = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> confirmed = const Value.absent(),
                Value<int> checkedIn = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedEventsCompanion(
                orgSlug: orgSlug,
                slug: slug,
                title: title,
                startsAt: startsAt,
                endsAt: endsAt,
                timezone: timezone,
                capacity: capacity,
                status: status,
                confirmed: confirmed,
                checkedIn: checkedIn,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String orgSlug,
                required String slug,
                required String title,
                required DateTime startsAt,
                Value<DateTime?> endsAt = const Value.absent(),
                required String timezone,
                Value<int?> capacity = const Value.absent(),
                required String status,
                Value<int> confirmed = const Value.absent(),
                Value<int> checkedIn = const Value.absent(),
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedEventsCompanion.insert(
                orgSlug: orgSlug,
                slug: slug,
                title: title,
                startsAt: startsAt,
                endsAt: endsAt,
                timezone: timezone,
                capacity: capacity,
                status: status,
                confirmed: confirmed,
                checkedIn: checkedIn,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedEventsTable, CachedEvent>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedEventsTable,
                    CachedEvent
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedEventsTable,
      CachedEvent,
      $$CachedEventsTableFilterComposer,
      $$CachedEventsTableOrderingComposer,
      $$CachedEventsTableAnnotationComposer,
      $$CachedEventsTableCreateCompanionBuilder,
      $$CachedEventsTableUpdateCompanionBuilder,
      (
        CachedEvent,
        BaseReferences<_$AppDatabase, $CachedEventsTable, CachedEvent>,
      ),
      CachedEvent,
      PrefetchHooks Function()
    >;
typedef $$ListMetaTableCreateCompanionBuilder = ListMetaCompanion Function({
  required String orgSlug,
  required String eventSlug,
  required String title,
  required String timezone,
  Value<int?> capacity,
  Value<int?> waitlist,
  required DateTime fetchedAt,
  Value<DateTime?> lastSyncedAt,
  Value<String?> lastError,
  Value<int> rowid,
});
typedef $$ListMetaTableUpdateCompanionBuilder = ListMetaCompanion Function({
  Value<String> orgSlug,
  Value<String> eventSlug,
  Value<String> title,
  Value<String> timezone,
  Value<int?> capacity,
  Value<int?> waitlist,
  Value<DateTime> fetchedAt,
  Value<DateTime?> lastSyncedAt,
  Value<String?> lastError,
  Value<int> rowid,
});

class $$ListMetaTableFilterComposer
    extends Composer<_$AppDatabase, $ListMetaTable> {
  $$ListMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get orgSlug => $composableBuilder(
    column: $table.orgSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventSlug => $composableBuilder(
    column: $table.eventSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get waitlist => $composableBuilder(
    column: $table.waitlist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ListMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $ListMetaTable> {
  $$ListMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get orgSlug => $composableBuilder(
    column: $table.orgSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventSlug => $composableBuilder(
    column: $table.eventSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get waitlist => $composableBuilder(
    column: $table.waitlist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ListMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListMetaTable> {
  $$ListMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get orgSlug =>
      $composableBuilder(column: $table.orgSlug, builder: (column) => column);

  GeneratedColumn<String> get eventSlug =>
      $composableBuilder(column: $table.eventSlug, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<int> get waitlist =>
      $composableBuilder(column: $table.waitlist, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$ListMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ListMetaTable,
          ListMetaData,
          $$ListMetaTableFilterComposer,
          $$ListMetaTableOrderingComposer,
          $$ListMetaTableAnnotationComposer,
          $$ListMetaTableCreateCompanionBuilder,
          $$ListMetaTableUpdateCompanionBuilder,
          (
            ListMetaData,
            BaseReferences<_$AppDatabase, $ListMetaTable, ListMetaData>,
          ),
          ListMetaData,
          PrefetchHooks Function()
        > {
  $$ListMetaTableTableManager(_$AppDatabase db, $ListMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> orgSlug = const Value.absent(),
                Value<String> eventSlug = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<int?> capacity = const Value.absent(),
                Value<int?> waitlist = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ListMetaCompanion(
                orgSlug: orgSlug,
                eventSlug: eventSlug,
                title: title,
                timezone: timezone,
                capacity: capacity,
                waitlist: waitlist,
                fetchedAt: fetchedAt,
                lastSyncedAt: lastSyncedAt,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String orgSlug,
                required String eventSlug,
                required String title,
                required String timezone,
                Value<int?> capacity = const Value.absent(),
                Value<int?> waitlist = const Value.absent(),
                required DateTime fetchedAt,
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ListMetaCompanion.insert(
                orgSlug: orgSlug,
                eventSlug: eventSlug,
                title: title,
                timezone: timezone,
                capacity: capacity,
                waitlist: waitlist,
                fetchedAt: fetchedAt,
                lastSyncedAt: lastSyncedAt,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ListMetaTable, ListMetaData>(table),
                  BaseReferences<_$AppDatabase, $ListMetaTable, ListMetaData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ListMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ListMetaTable,
      ListMetaData,
      $$ListMetaTableFilterComposer,
      $$ListMetaTableOrderingComposer,
      $$ListMetaTableAnnotationComposer,
      $$ListMetaTableCreateCompanionBuilder,
      $$ListMetaTableUpdateCompanionBuilder,
      (
        ListMetaData,
        BaseReferences<_$AppDatabase, $ListMetaTable, ListMetaData>,
      ),
      ListMetaData,
      PrefetchHooks Function()
    >;
typedef $$PendingCheckinsTableCreateCompanionBuilder =
    PendingCheckinsCompanion Function({
      required String id,
      required String orgSlug,
      Value<String?> eventSlug,
      required String kind,
      Value<String?> registrationId,
      Value<String?> code,
      Value<bool?> desiredCheckedIn,
      Value<String?> attendeeName,
      required DateTime clientAt,
      required DateTime createdAt,
      Value<int> attempts,
      required DateTime nextAttemptAt,
      Value<String?> lastError,
      Value<String> state,
      Value<String?> serverOutcome,
      Value<DateTime?> serverCheckedInAt,
      Value<DateTime?> resolvedAt,
      Value<int> rowid,
    });
typedef $$PendingCheckinsTableUpdateCompanionBuilder =
    PendingCheckinsCompanion Function({
      Value<String> id,
      Value<String> orgSlug,
      Value<String?> eventSlug,
      Value<String> kind,
      Value<String?> registrationId,
      Value<String?> code,
      Value<bool?> desiredCheckedIn,
      Value<String?> attendeeName,
      Value<DateTime> clientAt,
      Value<DateTime> createdAt,
      Value<int> attempts,
      Value<DateTime> nextAttemptAt,
      Value<String?> lastError,
      Value<String> state,
      Value<String?> serverOutcome,
      Value<DateTime?> serverCheckedInAt,
      Value<DateTime?> resolvedAt,
      Value<int> rowid,
    });

class $$PendingCheckinsTableFilterComposer
    extends Composer<_$AppDatabase, $PendingCheckinsTable> {
  $$PendingCheckinsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orgSlug => $composableBuilder(
    column: $table.orgSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventSlug => $composableBuilder(
    column: $table.eventSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get registrationId => $composableBuilder(
    column: $table.registrationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get desiredCheckedIn => $composableBuilder(
    column: $table.desiredCheckedIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attendeeName => $composableBuilder(
    column: $table.attendeeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clientAt => $composableBuilder(
    column: $table.clientAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverOutcome => $composableBuilder(
    column: $table.serverOutcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverCheckedInAt => $composableBuilder(
    column: $table.serverCheckedInAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingCheckinsTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingCheckinsTable> {
  $$PendingCheckinsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orgSlug => $composableBuilder(
    column: $table.orgSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventSlug => $composableBuilder(
    column: $table.eventSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registrationId => $composableBuilder(
    column: $table.registrationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get desiredCheckedIn => $composableBuilder(
    column: $table.desiredCheckedIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attendeeName => $composableBuilder(
    column: $table.attendeeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clientAt => $composableBuilder(
    column: $table.clientAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverOutcome => $composableBuilder(
    column: $table.serverOutcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverCheckedInAt => $composableBuilder(
    column: $table.serverCheckedInAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingCheckinsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingCheckinsTable> {
  $$PendingCheckinsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orgSlug =>
      $composableBuilder(column: $table.orgSlug, builder: (column) => column);

  GeneratedColumn<String> get eventSlug =>
      $composableBuilder(column: $table.eventSlug, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get registrationId => $composableBuilder(
    column: $table.registrationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<bool> get desiredCheckedIn => $composableBuilder(
    column: $table.desiredCheckedIn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get attendeeName => $composableBuilder(
    column: $table.attendeeName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get clientAt =>
      $composableBuilder(column: $table.clientAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get serverOutcome => $composableBuilder(
    column: $table.serverOutcome,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serverCheckedInAt => $composableBuilder(
    column: $table.serverCheckedInAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );
}

class $$PendingCheckinsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingCheckinsTable,
          PendingCheckin,
          $$PendingCheckinsTableFilterComposer,
          $$PendingCheckinsTableOrderingComposer,
          $$PendingCheckinsTableAnnotationComposer,
          $$PendingCheckinsTableCreateCompanionBuilder,
          $$PendingCheckinsTableUpdateCompanionBuilder,
          (
            PendingCheckin,
            BaseReferences<
              _$AppDatabase,
              $PendingCheckinsTable,
              PendingCheckin
            >,
          ),
          PendingCheckin,
          PrefetchHooks Function()
        > {
  $$PendingCheckinsTableTableManager(
    _$AppDatabase db,
    $PendingCheckinsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingCheckinsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingCheckinsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingCheckinsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orgSlug = const Value.absent(),
                Value<String?> eventSlug = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> registrationId = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<bool?> desiredCheckedIn = const Value.absent(),
                Value<String?> attendeeName = const Value.absent(),
                Value<DateTime> clientAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String?> serverOutcome = const Value.absent(),
                Value<DateTime?> serverCheckedInAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingCheckinsCompanion(
                id: id,
                orgSlug: orgSlug,
                eventSlug: eventSlug,
                kind: kind,
                registrationId: registrationId,
                code: code,
                desiredCheckedIn: desiredCheckedIn,
                attendeeName: attendeeName,
                clientAt: clientAt,
                createdAt: createdAt,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                state: state,
                serverOutcome: serverOutcome,
                serverCheckedInAt: serverCheckedInAt,
                resolvedAt: resolvedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orgSlug,
                Value<String?> eventSlug = const Value.absent(),
                required String kind,
                Value<String?> registrationId = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<bool?> desiredCheckedIn = const Value.absent(),
                Value<String?> attendeeName = const Value.absent(),
                required DateTime clientAt,
                required DateTime createdAt,
                Value<int> attempts = const Value.absent(),
                required DateTime nextAttemptAt,
                Value<String?> lastError = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String?> serverOutcome = const Value.absent(),
                Value<DateTime?> serverCheckedInAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingCheckinsCompanion.insert(
                id: id,
                orgSlug: orgSlug,
                eventSlug: eventSlug,
                kind: kind,
                registrationId: registrationId,
                code: code,
                desiredCheckedIn: desiredCheckedIn,
                attendeeName: attendeeName,
                clientAt: clientAt,
                createdAt: createdAt,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                state: state,
                serverOutcome: serverOutcome,
                serverCheckedInAt: serverCheckedInAt,
                resolvedAt: resolvedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PendingCheckinsTable, PendingCheckin>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PendingCheckinsTable,
                    PendingCheckin
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingCheckinsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingCheckinsTable,
      PendingCheckin,
      $$PendingCheckinsTableFilterComposer,
      $$PendingCheckinsTableOrderingComposer,
      $$PendingCheckinsTableAnnotationComposer,
      $$PendingCheckinsTableCreateCompanionBuilder,
      $$PendingCheckinsTableUpdateCompanionBuilder,
      (
        PendingCheckin,
        BaseReferences<_$AppDatabase, $PendingCheckinsTable, PendingCheckin>,
      ),
      PendingCheckin,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedAttendeesTableTableManager get cachedAttendees =>
      $$CachedAttendeesTableTableManager(_db, _db.cachedAttendees);
  $$CachedEventsTableTableManager get cachedEvents =>
      $$CachedEventsTableTableManager(_db, _db.cachedEvents);
  $$ListMetaTableTableManager get listMeta =>
      $$ListMetaTableTableManager(_db, _db.listMeta);
  $$PendingCheckinsTableTableManager get pendingCheckins =>
      $$PendingCheckinsTableTableManager(_db, _db.pendingCheckins);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'365ef3f215d780c29a21b6328f0b547a8363c6a6';
