// Define a provider to manage the state of the selected master type
import 'package:flutter_riverpod/flutter_riverpod.dart';

final masterTypeProvider =
    StateProvider<List<String?>>((ref) => ['Style', null, null]);
// Define a provider for the checkbox state
final checkboxProvider = StateProvider<bool>((ref) => false);