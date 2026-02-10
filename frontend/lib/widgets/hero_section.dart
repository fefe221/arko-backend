import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:frontend/services/lead_service.dart';

class HeroSection extends StatefulWidget {
  final String title;
  final String subtitle;
  final String formTitle;
  final String formSubtitle;
  final String? formHighlight;
  final String buttonText;
  final String source;
  final String? backgroundAsset;

  const HeroSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.formTitle,
    required this.formSubtitle,
    this.formHighlight,
    required this.buttonText,
    required this.source,
    this.backgroundAsset,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = MaskedTextController(mask: '(00) 00000-0000');
  final LeadService _service = LeadService();
  static const _textPrimary = Color(0xFF686868);

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await _service.submitLead(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        source: widget.source,
      );
      if (!mounted) return;
      nameController.clear();
      emailController.clear();
      phoneController.clear();


      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => Center(
          child: Material(
            color:Colors.transparent,
            child: Container(
              width: 360 ,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 56,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Obrigado!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text("Entraremos em contato.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Fechar"),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  InputDecoration inputStyle(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    Widget textSide = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E6DE).withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.subtitle,
            style: const TextStyle(fontSize: 18, color: _textPrimary),
          ),
        ],
      ),
    );

    final formCard = Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 420),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E6DE),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.formTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: _textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.formSubtitle,
              style: const TextStyle(color: _textPrimary),
              textAlign: TextAlign.center,
            ),
            if (widget.formHighlight != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.formHighlight!,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: inputStyle("Nome"),
              textAlign: TextAlign.center,
              validator: (v) => v!.isEmpty ? "Informe seu nome" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: emailController,
              decoration: inputStyle("Email"),
              textAlign: TextAlign.center,
              validator: (v) {
                final value = (v ?? "").trim();
                final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                return emailRegex.hasMatch(value) ? null : "Email inválido";
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: phoneController,
              decoration: inputStyle("Telefone"),
              textAlign: TextAlign.center,
              validator: (v) => v!.length < 14 ? "Telefone inválido" : null,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: Text(widget.buttonText),
              ),
            )
          ],
        ),
      ),
    );

    Widget formSide = Container(
      padding: const EdgeInsets.all(24),
      decoration: widget.backgroundAsset == null
          ? null
          : BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.backgroundAsset!),
                fit: BoxFit.cover,
              ),
            ),
      child: Center(child: formCard),
    );

    final horizontalPadding = isMobile ? 20.0 : 150.0;
    final verticalPadding = isMobile ? 40.0 : 60.0;
    final content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: isMobile
          ? Column(children: [textSide, const SizedBox(height: 32), formSide])
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: textSide),
                const SizedBox(width: 40),
                Expanded(child: formSide),
              ],
            ),
    );

    return content;
  }
}
