class Account {
  String uuid;
  String? name;
  String? avatar;

  Account({
    required this.uuid,
    this.name,
    this.avatar,
  });

  Account copyWith({
    String? uuid,
    String? name,
    String? avatar,
  }) =>
      Account(
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
      );
}
