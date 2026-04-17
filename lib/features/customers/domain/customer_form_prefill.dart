/// Passed via [GoRouterState.extra] for AI-assisted or deep-linked customer creation.
class CustomerFormPrefill {
  const CustomerFormPrefill({
    this.name,
    this.phone,
    this.notes,
    this.email,
    this.preferredLocation,
  });

  final String? name;
  final String? phone;
  final String? notes;
  final String? email;
  final String? preferredLocation;
}
