class Account {
  String name = '';
  String id = '';
  int passwordIndex = 0;
  int passwordLength = 0;

  Account(this.name, this.id, this.passwordIndex, this.passwordLength);

  String toJsonObjectString() {
    return '"$name": {"id": "$id", "passIndex": $passwordIndex, "passLength": $passwordLength}';
  }
}
