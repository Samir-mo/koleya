import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/core/widgets/custom_text_button.dart';
import 'package:gate_buddy/core/widgets/ui/dialogs/app_dialogs.dart';
import 'package:gate_buddy/features/boarding_pass_scan/logic/cubit/boarding_pass_scan_cubit.dart';
import 'package:gate_buddy/features/boarding_pass_scan/logic/cubit/boarding_pass_scan_state.dart';
import 'package:gate_buddy/features/boarding_pass_scan/ui/widgets/scan_hint_card.dart';
import 'package:gate_buddy/features/boarding_pass_scan/ui/widgets/scanner_overlay.dart';
import 'package:gate_buddy/features/tracked_flight/ui/tracked_flight_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BoardingPassScannerScreen extends StatefulWidget {
  const BoardingPassScannerScreen({super.key});

  @override
  State<BoardingPassScannerScreen> createState() =>
      _BoardingPassScannerScreenState();
}

class _BoardingPassScannerScreenState
    extends State<BoardingPassScannerScreen> {
  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      formats: const [BarcodeFormat.pdf417, BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.normal,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BoardingPassScanCubit, BoardingPassScanState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == BoardingPassScanStatus.parsed) {
          context.read<BoardingPassScanCubit>().submit();
        } else if (state.status == BoardingPassScanStatus.submitted &&
            state.flight != null) {
          Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(
              builder: (_) => TrackedFlightScreen(flight: state.flight),
            ),
          );
        } else if (state.status == BoardingPassScanStatus.failure) {
          final cubit = context.read<BoardingPassScanCubit>();
          AppDialogs.showError(
            context,
            message: (state.error?.startsWith('boarding_pass.') == true)
                ? state.error!.tr()
                : (state.error ?? 'errors.unknown'.tr()),
          );
          Future.delayed(const Duration(milliseconds: 300), cubit.resumeScanning);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: BlocBuilder<BoardingPassScanCubit, BoardingPassScanState>(
          builder: (context, state) {
            final isProcessing =
                state.status == BoardingPassScanStatus.parsing ||
                state.status == BoardingPassScanStatus.submitting ||
                state.status == BoardingPassScanStatus.parsed;

            return Stack(
              fit: StackFit.expand,
              children: [
                // ── Camera ───────────────────────────────────────────────
                MobileScanner(
                  controller: _controller,
                  onDetect: (capture) {
                    if (capture.barcodes.isEmpty) return;
                    final raw = capture.barcodes.first.rawValue;
                    if (raw != null) {
                      context
                          .read<BoardingPassScanCubit>()
                          .onBarcodeDetected(raw);
                    }
                  },
                ),

                // ── Dark overlay + scan frame ─────────────────────────────
                const ScannerOverlay(),

                // ── Top bar ───────────────────────────────────────────────
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: rw(16), vertical: rh(8)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: rw(40),
                            height: rw(40),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: AppColors.white,
                              size: rr(18),
                            ),
                          ),
                        ),
                        horizontalSpacing(12),
                        Text(
                          'boarding_pass.scan_title'.tr(),
                          style: AppTextStyles.font18Bold
                              .copyWith(color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Parse failure inline card ─────────────────────────────
                if (state.status == BoardingPassScanStatus.parseFailure)
                  Positioned(
                    bottom: rh(120),
                    left: rw(24),
                    right: rw(24),
                    child: _ParseFailureCard(
                      onRetry: () =>
                          context.read<BoardingPassScanCubit>().resumeScanning(),
                    ),
                  ),

                // ── Bottom hint ───────────────────────────────────────────
                if (state.status == BoardingPassScanStatus.scanning ||
                    state.status == BoardingPassScanStatus.parseFailure)
                  Positioned(
                    bottom: rh(48),
                    left: 0,
                    right: 0,
                    child: const ScanHintCard(),
                  ),

                // ── Processing overlay ────────────────────────────────────
                if (isProcessing)
                  Container(
                    color: AppColors.black.withValues(alpha: 0.55),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                              color: AppColors.secondary200),
                          verticalSpacing(16),
                          Text(
                            state.status == BoardingPassScanStatus.submitting ||
                                    state.status ==
                                        BoardingPassScanStatus.parsed
                                ? 'boarding_pass.submitting'.tr()
                                : 'boarding_pass.parsing'.tr(),
                            style: AppTextStyles.font16Regular
                                .copyWith(color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ParseFailureCard extends StatelessWidget {
  final VoidCallback onRetry;
  const _ParseFailureCard({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(rw(16)),
      decoration: BoxDecoration(
        color: AppColors.red200.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(rr(14)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded,
              color: AppColors.white, size: rr(22)),
          horizontalSpacing(12),
          Expanded(
            child: Text(
              'boarding_pass.failure_invalid'.tr(),
              style:
                  AppTextStyles.font12Regular.copyWith(color: AppColors.white),
            ),
          ),
          horizontalSpacing(12),
          CustomTextButton.text(
            text: 'boarding_pass.try_again'.tr(),
            onPressed: onRetry,
            foregroundColor: AppColors.white,
          ),
        ],
      ),
    );
  }
}
