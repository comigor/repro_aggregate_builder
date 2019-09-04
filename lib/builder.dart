import 'dart:async';
import 'package:build/build.dart';
import 'package:glob/glob.dart';

Builder concatBuilder(BuilderOptions options) => _ConcatBuilder('lib');

class _ConcatBuilder implements Builder {
  final String _input;

  _ConcatBuilder(this._input) {
    buildExtensions = {
      '\$$_input\$': ['concat.txt'],
    };
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    final results = StringBuffer();
    await for (final asset in buildStep.findAssets(Glob('data/*.txt'))) {
      results.writeln(await buildStep.readAsString(asset));
    }
    final output = AssetId(buildStep.inputId.package, '$_input/concat.txt');
    await buildStep.writeAsString(output, results.toString());
  }

  @override
  Map<String, List<String>> buildExtensions;
}
