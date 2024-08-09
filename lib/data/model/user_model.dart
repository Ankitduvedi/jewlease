class UserModel {
  UserModel({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.id,
    required this.email,
    required this.pushToken,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
    required this.place,
    required this.designation,
    required this.isApproved,
    required this.tourPage,
    required this.isNewUser,
  });

  late String image;
  late String about;
  late String name;
  late String createdAt;
  late String id;
  late String email;
  late String pushToken;
  late String phoneNumber;
  late String dateOfBirth;
  late String gender;
  late bool isNewUser;
  late String place;
  late String designation;
  late int isApproved;
  late String tourPage = "";

  // Update fromJson method to include the new field
  UserModel.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    dateOfBirth = json['dateOfBirth'] ?? '';
    gender = json['gender'] ?? '';
    place = json['place'] ?? '';
    designation = json['designation'] ?? '';
    isApproved = json['isApproved'] ?? 0;
    isNewUser = json['isNewUser'] ?? false;
    tourPage = json['tourPage'] ?? "";
    // Add the new field
  }

  // Update toJson method to include the new field
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['email'] = email;
    data['push_token'] = pushToken;
    data['phoneNumber'] = phoneNumber;
    data['dateOfBirth'] = dateOfBirth;
    data['gender'] = gender;
    data['place'] = place;
    data['designation'] = designation;
    data['isApproved'] = isApproved;
    data['tourPage'] = tourPage;
    data['isNewUser'] = isNewUser;

    // Add the new field
    return data;
  }

  // Similarly, update the toMap method if needed
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'about': about,
      'name': name,
      'createdAt': createdAt,
      'id': id,
      'email': email,
      'pushToken': pushToken,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'place': place,
      'isNewUser': isNewUser,
      'designation': designation,
      // Add the new field
      'isApproved': isApproved,
      'tourPage': tourPage
    };
  }

  // If you have a factory constructor for creating an empty object, make sure to include the new field there as well
  factory UserModel.empty() {
    return UserModel(
        isNewUser: true,
        image: '',
        about: 'Hey everyone',
        name: '',
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        id: '',
        email: '',
        pushToken: '',
        dateOfBirth: '',
        gender: '',
        phoneNumber: '',
        place: '',
        designation: '',
        isApproved: 0,
        tourPage: "");
  }

  // Add a copyWith method
  UserModel copyWith({
    String? image,
    String? about,
    String? name,
    String? createdAt,
    String? id,
    String? email,
    String? pushToken,
    String? phoneNumber,
    String? dateOfBirth,
    String? gender,
    String? place,
    String? designation,
    int? isApproved,
    bool? isNewUser,
  }) {
    return UserModel(
        isNewUser: isNewUser ?? this.isNewUser,
        image: image ?? this.image,
        about: about ?? this.about,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        email: email ?? this.email,
        pushToken: pushToken ?? this.pushToken,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        gender: gender ?? this.gender,
        place: place ?? this.place,
        designation: designation ?? this.designation,
        isApproved: isApproved ?? this.isApproved,
        tourPage: tourPage);
  }
}
