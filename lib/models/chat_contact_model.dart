class ChatContactModel {
  final String name;
  final String profilePic;
  // final String lastMessage;
  // final DateTime timeSent;
  final bool isOnline;
  final String contactId;
  ChatContactModel({
    required this.name,
    required this.profilePic,
    required this.isOnline,
    required this.contactId,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'contactId': contactId,
    };
  }

  factory ChatContactModel.fromMap(Map<String, dynamic> map) {
    return ChatContactModel(
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
      contactId: map['contactId'] ?? '',
    );
  }
}
