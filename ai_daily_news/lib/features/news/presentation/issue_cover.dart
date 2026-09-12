import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/paper_theme.dart';

class IssueCoverImage extends StatelessWidget {
  const IssueCoverImage({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.cover,
  });

  final String? assetPath;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final paper = context.paper;
    if (assetPath == null) {
      return ColoredBox(color: paper.surface);
    }
    return SvgPicture.asset(
      assetPath!,
      fit: fit,
      alignment: Alignment.center,
      placeholderBuilder: (_) => ColoredBox(color: paper.surface),
    );
  }
}
