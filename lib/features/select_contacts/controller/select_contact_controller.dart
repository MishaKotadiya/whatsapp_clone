import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/select_contacts/repository/select_contact_repository.dart';

final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return SelectContactController(ref, selectContactRepository);
});

final getContactsProvider = FutureProvider((ref){
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return selectContactRepository.getContacts();
});

class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;

  SelectContactController(this.ref, this.selectContactRepository);

  void selectContact(Contact selectedContact, BuildContext context) {
     selectContactRepository.selectContact(selectedContact, context);
  }

}