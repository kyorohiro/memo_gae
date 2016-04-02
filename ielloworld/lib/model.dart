library check.model;

import 'package:gcloud/db.dart';

@Kind()
class ItemsRoot extends Model {}

@Kind()
class Item extends Model {
  @StringProperty()
  String name;
}
