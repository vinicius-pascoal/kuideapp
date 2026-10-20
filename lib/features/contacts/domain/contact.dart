enum ContactCategory { family, doctor, other }
extension ContactCategoryLabel on ContactCategory { String get label => switch (this) { ContactCategory.family => 'Família', ContactCategory.doctor => 'Médicos', ContactCategory.other => 'Outros' }; }
class Contact { const Contact({required this.id, required this.name, required this.relationship, required this.phone, required this.category, this.showOnHome = false}); final String id; final String name; final String relationship; final String phone; final ContactCategory category; final bool showOnHome; }
