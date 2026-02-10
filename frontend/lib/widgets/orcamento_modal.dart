import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:frontend/services/lead_service.dart';

class OrcamentoModal extends StatefulWidget {
  const OrcamentoModal({super.key});

  @override
  State<OrcamentoModal> createState() => _OrcamentoModalState();
}

class _OrcamentoModalState extends State<OrcamentoModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = MaskedTextController(mask: '(00) 00000-0000');
  final _emailController = TextEditingController();
  final _ambienteController = TextEditingController();
  final LeadService _service = LeadService();

  static const _whatsUrl = "https://wa.me/5543991963190";

  void _openWhatsApp() {
    html.window.open(_whatsUrl, "_blank");
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      await _service.submitLead(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        source: "orcamento",
        message: "Ambiente: ${_ambienteController.text.trim()}",
      );
      if (!mounted) return;
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _ambienteController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Solicitação enviada com sucesso")),
      );
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao enviar. Tente novamente.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: const Color(0xFFE8E6DE),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Como você prefere iniciar seu projeto?",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _openWhatsApp,
              child: const Text("whatsapp"),
            ),
            const SizedBox(height: 12),
            Text(
              "Ideal para dúvidas rápidas\ne agendamento imediato.",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("ou"),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Preencha o formulário e um dos nossos\nArquitetos irá entrar em contato.",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _Input(
                    label: "Nome",
                    controller: _nameController,
                    validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? "Informe seu nome"
                            : null,
                  ),
                  const SizedBox(height: 10),
                  _Input(
                    label: "Telefone",
                    controller: _phoneController,
                    validator: (value) =>
                        value == null || value.trim().length < 10
                            ? "Telefone inválido"
                            : null,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  _Input(
                    label: "E-mail",
                    controller: _emailController,
                    validator: (value) {
                      final val = (value ?? "").trim();
                      final emailRegex =
                          RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                      return emailRegex.hasMatch(val)
                          ? null
                          : "Email inválido";
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  _Input(
                    label: "Qual ambiente pretende planejar?",
                    controller: _ambienteController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text("Enviar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  const _Input({
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
