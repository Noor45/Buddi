// class UserModel {
//
//   String name;
//   String email;
//
//   UserModel({
//     this.name,
//     this.email,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       UserModelFields.NAME: this.name,
//       UserModelFields.EMAIL: this.email,
//     };
//   }
//
//   UserModel.fromMap(Map<String, dynamic> map) {
//     this.name = map[UserModelFields.NAME];
//     this.email = map[UserModelFields.EMAIL];
//   }
//
//   @override
//   String toString() {
//     return 'UserModel{name: $name, email: $email}';
//   }
// }
//
// class UserModelFields {
//   static const String NAME = "name";
//   static const String EMAIL = "email";
// }
