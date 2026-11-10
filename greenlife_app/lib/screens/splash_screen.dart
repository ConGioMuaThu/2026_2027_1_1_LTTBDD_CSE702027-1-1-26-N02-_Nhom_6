import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:greenlife_app/config/app_routes.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/utils/app_constants.dart';

class GreenLifeSplash extends StatefulWidget {
  const GreenLifeSplash({
    super.key,
    required this.home,
  });

  final Widget home;

  @override
  State<GreenLifeSplash> createState() => _GreenLifeSplashState();
}

class _GreenLifeSplashState extends State<GreenLifeSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.splashDuration,
    );
    _controller.forward();

    Future.delayed(AppConstants.splashDuration, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        AppRoutes.fadeScale(widget.home),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress = _controller.value;
        final soilLift = Curves.easeOutCubic.transform((progress / 0.38).clamp(0.0, 1.0));
        final sproutRise = Curves.easeOutBack.transform(((progress - 0.2) / 0.62).clamp(0.0, 1.0));
        final leafOpen = Curves.easeOutCubic.transform(((progress - 0.42) / 0.38).clamp(0.0, 1.0));
        final glow = Curves.easeInOut.transform(((progress - 0.7) / 0.3).clamp(0.0, 1.0));
        final nameFade = Curves.easeOutCubic.transform(((progress - 0.7) / 0.3).clamp(0.0, 1.0));

        return Scaffold(
          backgroundColor: const Color(0xFFF3F7F0),
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/backgrounds/splash_bg.png'),
                fit: BoxFit.cover,
              ),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFF3F7F0),
                  const Color(0xFFF8FBF6).withValues(alpha: 0.96),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: CustomPaint(
                      painter: _SproutPainter(
                        progress: progress,
                        soilLift: soilLift,
                        sproutRise: sproutRise,
                        leafOpen: leafOpen,
                        glow: glow,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Transform.translate(
                    offset: Offset(0, (1 - nameFade) * 18),
                    child: Opacity(
                      opacity: nameFade,
                      child: Text(
                        strings.appName,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF234C37),
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Opacity(
                    opacity: (progress > 0.8 ? (progress - 0.8) / 0.2 : 0.0).clamp(0.0, 1.0),
                    child: Text(
                      strings.initMessage,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF5D7062),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SproutPainter extends CustomPainter {
  final double progress;
  final double soilLift;
  final double sproutRise;
  final double leafOpen;
  final double glow;

  _SproutPainter({
    required this.progress,
    required this.soilLift,
    required this.sproutRise,
    required this.leafOpen,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final baseY = size.height * 0.76;
    final sway = math.sin(progress * 12.0) * (1.0 - sproutRise) * 4.0;

    final soilShadow = Paint()
      ..color = const Color(0xFFB5C5B4).withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, baseY + 42),
        width: 138,
        height: 22,
      ),
      soilShadow,
    );

    final mound = Rect.fromCenter(
      center: Offset(centerX, baseY + 10),
      width: 152,
      height: 68,
    );
    final soilPaint = Paint()..color = const Color(0xFF7A5B43);
    canvas.drawOval(mound, soilPaint);

    final topMound = Rect.fromCenter(
      center: Offset(centerX, baseY - 2),
      width: 122,
      height: 48,
    );
    final soilHighlight = Paint()..color = const Color(0xFF9B7E68);
    canvas.drawOval(topMound, soilHighlight);

    final tinyCrackPaint = Paint()
      ..color = const Color(0xFF5E4337).withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(centerX - 28, baseY + 10),
      Offset(centerX - 12, baseY + 20),
      tinyCrackPaint,
    );
    canvas.drawLine(
      Offset(centerX + 24, baseY + 8),
      Offset(centerX + 10, baseY + 18),
      tinyCrackPaint,
    );

    final stemBottom = Offset(centerX + sway * 0.25, baseY);
    final stemTop = Offset(centerX + sway * 0.7, baseY - 62 - sproutRise * 82);
    final stemPaint = Paint()
      ..color = const Color(0xFF3BA15E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(stemBottom, stemTop, stemPaint);

    final stemShadow = Paint()
      ..color = const Color(0xFF1F7C4D).withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(centerX + 3, baseY + 2),
      Offset(centerX + 3, stemTop.dy + 6),
      stemShadow,
    );

    final leafPaint = Paint()..color = const Color(0xFF5EC76F);
    final leafScale = 0.15 + leafOpen * 0.7;

    final leftLeaf = Path()
      ..moveTo(centerX + sway * 0.6, stemTop.dy + 10)
      ..quadraticBezierTo(
        centerX - 18 - sway * 0.5,
        stemTop.dy - 6 - leafScale * 10,
        centerX - 36,
        stemTop.dy - 22,
      )
      ..quadraticBezierTo(
        centerX - 10,
        stemTop.dy - 18,
        centerX + sway * 0.6,
        stemTop.dy + 10,
      )
      ..close();

    final rightLeaf = Path()
      ..moveTo(centerX + sway * 0.6, stemTop.dy + 8)
      ..quadraticBezierTo(
        centerX + 18 + sway * 0.5,
        stemTop.dy - 8 - leafScale * 10,
        centerX + 36,
        stemTop.dy - 22,
      )
      ..quadraticBezierTo(
        centerX + 12,
        stemTop.dy - 18,
        centerX + sway * 0.6,
        stemTop.dy + 8,
      )
      ..close();

    if (leafOpen > 0.12) {
      canvas.drawPath(leftLeaf, leafPaint);
      canvas.drawPath(rightLeaf, leafPaint);
    }

    final topLeafPaint = Paint()..color = const Color(0xFF75D97B);
    final topLeaf = Path()
      ..moveTo(centerX + sway * 0.5, stemTop.dy - 8)
      ..quadraticBezierTo(
        centerX - 10 + sway * 0.3,
        stemTop.dy - 20 - leafScale * 8,
        centerX - 18,
        stemTop.dy - 36,
      )
      ..quadraticBezierTo(
        centerX + 8,
        stemTop.dy - 26,
        centerX + sway * 0.5,
        stemTop.dy - 8,
      )
      ..close();
    if (leafOpen > 0.45) {
      canvas.drawPath(topLeaf, topLeafPaint);
    }

    final budPaint = Paint()..color = const Color(0xFF9BE7A2);
    final budRadius = 5.5 + (leafOpen * 5.5);
    canvas.drawCircle(
      Offset(centerX + sway * 0.4, stemTop.dy - 14),
      budRadius,
      budPaint,
    );

    final glowPaint = Paint()
      ..color = Color.fromARGB((120 * glow).round(), 143, 214, 155)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(centerX + 10 + sway, stemTop.dy - 60),
      18 + glow * 18,
      glowPaint,
    );

    if (progress > 0.75) {
      final sparklePaint = Paint()..color = const Color(0xFFFFFFFF).withValues(alpha: 0.82);
      final sparkles = [
        Offset(centerX - 54, stemTop.dy - 86),
        Offset(centerX + 58, stemTop.dy - 96),
        Offset(centerX + 30, stemTop.dy - 126),
      ];
      for (final point in sparkles) {
        canvas.drawCircle(point, 2.8 + glow * 1.4, sparklePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SproutPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.soilLift != soilLift ||
        oldDelegate.sproutRise != sproutRise ||
        oldDelegate.leafOpen != leafOpen ||
        oldDelegate.glow != glow;
  }
}