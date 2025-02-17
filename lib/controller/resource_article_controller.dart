import 'package:buddi/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/resource_company_model.dart';
import '../models/resources_model.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ArticleController {
  static Future<void> getCompanies(String? id) async {
    QuerySnapshot snapShot = await _firestore.collection('resource').doc(id).collection('companies').get();
    Constants.resourceCompaniesList = [];
    snapShot.docs.forEach((element) {
      ResourceCompaniesModel resources = ResourceCompaniesModel.fromMap(element.data() as Map<String, dynamic>);
      Constants.resourceCompaniesList!.add(resources);
    });
    return;
  }

  static Future<void> getResources() async {
    QuerySnapshot snapShot = await _firestore.collection('resource').get();
    Constants.resourcesList = [];
    snapShot.docs.forEach((element) {
      ResourcesModel resources = ResourcesModel.fromMap(element.data() as Map<String, dynamic>);
      Constants.resourcesList!.add(resources);
    });
    return;
  }

}

