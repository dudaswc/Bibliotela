import 'package:bibliotela_design_system/bibliotela_design_system.dart';
import 'package:flutter/material.dart';

import 'login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({required this.viewModel, super.key});

  final LoginViewModel viewModel;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: ListenableBuilder(
                listenable: viewModel,
                builder: (context, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          boxShadow: const [AppShadows.appIcon],
                        ),
                        child: Icon(
                          Icons.auto_stories_rounded,
                          size: 34,
                          color: colors.onPrimary,
                        ),
                      ),
                    ),
                    const Gap.lg(),
                    Text(
                      'Bibliotela',
                      style: AppTypography.headlineMedium.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    const Gap.xs(),
                    Text(
                      'Tudo que você leu e assistiu.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: colors.onSurfaceMuted,
                      ),
                    ),
                    const Gap.xl(),
                    DsTextField(
                      key: const Key('login_email'),
                      label: 'E-mail',
                      hint: 'voce@exemplo.com',
                      prefixIcon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      errorText: viewModel.emailError,
                      onChanged: viewModel.onEmailChanged,
                    ),
                    const Gap.md(),
                    DsPasswordField(
                      key: const Key('login_password'),
                      errorText: viewModel.passwordError,
                      onChanged: viewModel.onPasswordChanged,
                    ),
                    const Gap.lg(),
                    if (viewModel.errorMessage != null) ...[
                      DsInlineMessage(viewModel.errorMessage!),
                      const Gap.md(),
                    ],
                    DsActionButton(
                      key: const Key('login_submit'),
                      viewModel: ActionButtonViewModel(
                        label: 'Entrar',
                        state: viewModel.isLoading
                            ? ComponentState.loading
                            : ComponentState.defaultState,
                      ),
                      onPressed: viewModel.submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
