import 'package:hive_ce/hive.dart';

import '../models/task.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([AdapterSpec<Task>()], firstTypeId: 0)
class HiveAdapters {}
