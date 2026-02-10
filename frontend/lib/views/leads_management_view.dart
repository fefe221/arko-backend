import 'package:flutter/material.dart';
import 'package:frontend/services/lead_service.dart';

class LeadsManagementView extends StatefulWidget {
  const LeadsManagementView({super.key});

  @override
  State<LeadsManagementView> createState() => _LeadsManagementViewState();
}

class _LeadsManagementViewState extends State<LeadsManagementView> {
  final LeadService _service = LeadService();
  late Future<List<dynamic>> _leadsFuture;

  static const _statusOptions = [
    "novo",
    "em contato",
    "em negociação",
    "fechado",
    "perdido",
  ];

  @override
  void initState() {
    super.initState();
    _loadLeads();
  }

  void _loadLeads() {
    setState(() {
      _leadsFuture = _service.getLeads();
    });
  }

  String _formatDate(dynamic value) {
    if (value == null) return "-";
    final date = DateTime.tryParse(value.toString());
    if (date == null) return value.toString();
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year} "
        "${date.hour.toString().padLeft(2, '0')}:"
        "${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Leads",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton.icon(
            onPressed: _loadLeads,
            icon: const Icon(Icons.refresh),
            label: const Text("Atualizar"),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: FutureBuilder<List<dynamic>>(
            future: _leadsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text("Erro ao carregar leads"));
              }

              final leads = snapshot.data ?? [];
              if (leads.isEmpty) {
                return const Center(child: Text("Nenhum lead encontrado"));
              }

              return ListView.separated(
                itemCount: leads.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final lead = leads[index];
                  final status = (lead['status'] ?? 'novo').toString();
                  return ListTile(
                    title: Text(
                      lead['name'] ?? 'Sem nome',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Email: ${lead['email'] ?? '-'}"),
                        Text("Telefone: ${lead['phone'] ?? '-'}"),
                        Text("Origem: ${lead['source'] ?? '-'}"),
                        Text("Entrada: ${_formatDate(lead['created_at'])}"),
                      ],
                    ),
                    trailing: DropdownButton<String>(
                      value: _statusOptions.contains(status)
                          ? status
                          : _statusOptions.first,
                      onChanged: (value) async {
                        if (value == null) return;
                        await _service.updateLeadStatus(lead['id'], value);
                        _loadLeads();
                      },
                      items: _statusOptions
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s),
                              ))
                          .toList(),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
