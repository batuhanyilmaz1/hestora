import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../domain/customer_form_prefill.dart';

enum CustomerContactImportStatus {
  success,
  denied,
  unsupported,
  empty,
}

class CustomerContactOption {
  const CustomerContactOption({
    required this.name,
    this.phone,
  });

  final String name;
  final String? phone;

  CustomerFormPrefill toPrefill() {
    return CustomerFormPrefill(
      name: name,
      phone: phone,
    );
  }
}

class CustomerContactImportResult {
  const CustomerContactImportResult({
    required this.status,
    this.contacts = const <CustomerContactOption>[],
  });

  final CustomerContactImportStatus status;
  final List<CustomerContactOption> contacts;
}

class CustomerContactsService {
  const CustomerContactsService();

  Future<CustomerContactImportResult> loadContacts() async {
    if (kIsWeb) {
      return const CustomerContactImportResult(
        status: CustomerContactImportStatus.unsupported,
      );
    }

    final granted = await FlutterContacts.requestPermission(readonly: true);
    if (!granted) {
      return const CustomerContactImportResult(
        status: CustomerContactImportStatus.denied,
      );
    }

    final contacts = await FlutterContacts.getContacts(withProperties: true);
    final options = contacts
        .map(_toOption)
        .whereType<CustomerContactOption>()
        .toList(growable: false)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    if (options.isEmpty) {
      return const CustomerContactImportResult(
        status: CustomerContactImportStatus.empty,
      );
    }

    return CustomerContactImportResult(
      status: CustomerContactImportStatus.success,
      contacts: options,
    );
  }

  CustomerContactOption? _toOption(Contact contact) {
    final name = contact.displayName.trim();
    final phone = contact.phones.isNotEmpty ? contact.phones.first.number.trim() : null;
    if (name.isEmpty && (phone == null || phone.isEmpty)) {
      return null;
    }

    return CustomerContactOption(
      name: name.isNotEmpty ? name : (phone ?? 'Unknown'),
      phone: phone?.isEmpty == true ? null : phone,
    );
  }
}

final customerContactsServiceProvider = Provider<CustomerContactsService>((ref) {
  return const CustomerContactsService();
});
