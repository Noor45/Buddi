enum GroupCategories {
  School,
  Life,
  Friends_And_Roommates,
  Relationships,
  Activism,
  Athletics,
  Post_Graduate,
  Habit,
}

extension GroupsExtension on GroupCategories {
  String get displayTitle {
    switch (this) {
      case GroupCategories.Activism:
        return 'Activism';
      case GroupCategories.Athletics:
        return 'Athletics';
      case GroupCategories.Friends_And_Roommates:
        return 'Friends and Roomates';
      case GroupCategories.Habit:
        return 'Habits';
      case GroupCategories.Post_Graduate:
        return 'Post Graduates';
      case GroupCategories.Relationships:
        return 'Relationships';
      case GroupCategories.School:
        return 'School';
      case GroupCategories.Life:
        return 'Life';
    }
  }

  String get imagesPath {
    switch (this) {
      case GroupCategories.Activism:
        return 'assets/images/activism.jpg';
      case GroupCategories.Athletics:
        return 'assets/images/athletics.jpg';
      case GroupCategories.Friends_And_Roommates:
        return 'assets/images/friends_and_rommate.jpg';
      case GroupCategories.Habit:
        return 'assets/images/habit.jpg';
      case GroupCategories.Post_Graduate:
        return 'assets/images/post_graduate.jpg';
      case GroupCategories.Relationships:
        return 'assets/images/relationships.jpg';
      case GroupCategories.School:
        return 'assets/images/school.jpg';
      case GroupCategories.Life:
        return 'assets/images/life.jpg';
    }
  }

  String get id {
    switch (this) {
      case GroupCategories.Activism:
        return 'd1hw2xohakg';
      case GroupCategories.Athletics:
        return 'ox36pgjvoyc';
      case GroupCategories.Friends_And_Roommates:
        return '79GF65WGcUvpzzntI1G3';
      case GroupCategories.Habit:
        return 'q2q56ajxddk';
      case GroupCategories.Post_Graduate:
        return '6j2ugz0qihq';
      case GroupCategories.Relationships:
        return '7jrf1h977k5';
      case GroupCategories.School:
        return 'TiaPE5WGEq5NDeNV6QIT';
      case GroupCategories.Life:
        return 'NfBIly7q9GbzDbU9mWaR';
    }
  }
}
