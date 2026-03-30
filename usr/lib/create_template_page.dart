import 'package:flutter/material.dart';

class Objective {
  String name;
  String? kpi;
  double weight;
  String control;
  bool mandatory;

  Objective({
    required this.name,
    this.kpi,
    this.weight = 0.0,
    this.control = 'Editable',
    this.mandatory = false,
  });
}

class Category {
  String name;
  List<Objective> objectives;

  Category({required this.name, required this.objectives});
}

class CreateTemplatePage extends StatefulWidget {
  const CreateTemplatePage({super.key});

  @override
  State<CreateTemplatePage> createState() => _CreateTemplatePageState();
}

class _CreateTemplatePageState extends State<CreateTemplatePage> {
  final _formKey = GlobalKey<FormState>();
  
  // Form State
  String templateName = '';
  String description = '';
  String empLabel = 'EMP_No:';
  
  // Mock Data for Assignments
  List<String> selectedRoles = [];
  List<String> selectedDepartments = [];
  
  late List<Category> categories;

  @override
  void initState() {
    super.initState();
    // Initialize with the data structure from the React code
    categories = [
      Category(
        name: "Financial Focus",
        objectives: [
          Objective(name: "Revenue Achievement", control: "Locked", mandatory: true),
          Objective(name: "GP Achievement", control: "Locked", mandatory: true),
          Objective(name: "Achievement of Dept Revenue", control: "Locked", mandatory: true),
        ],
      ),
      Category(
        name: "Customer Focus",
        objectives: [
          Objective(name: "NPS Index", control: "Locked", mandatory: true),
          Objective(name: "Complaints on service failures", control: "Locked", mandatory: true),
        ],
      ),
      Category(
        name: "Human Resources Focus",
        objectives: [
          Objective(name: "360 Feedback (Automated)", control: "Locked", mandatory: true),
        ],
      ),
    ];
  }

  double get totalWeight {
    return categories.fold(0.0, (sum, cat) => 
      sum + cat.objectives.fold(0.0, (objSum, obj) => objSum + obj.weight)
    );
  }

  void _addCategory() {
    setState(() {
      categories.add(Category(name: "New Category", objectives: []));
    });
  }

  void _addObjective(int categoryIndex) {
    setState(() {
      categories[categoryIndex].objectives.add(
        Objective(name: "", control: "Editable", mandatory: false)
      );
    });
  }

  void _removeObjective(int categoryIndex, int objectiveIndex) {
    setState(() {
      categories[categoryIndex].objectives.removeAt(objectiveIndex);
    });
  }

  void _removeCategory(int categoryIndex) {
    setState(() {
      categories.removeAt(categoryIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentWeight = totalWeight;
    final isOverWeight = currentWeight > 100;
    final isPerfectWeight = currentWeight == 100;
    
    final weightColor = isOverWeight 
        ? Colors.red.shade600 
        : (isPerfectWeight ? Colors.green.shade600 : Colors.orange.shade600);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Template', 
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _buildSectionHeader('Basic Information', Icons.info_outline),
            const SizedBox(height: 16),
            _buildBasicInfoCard(),
            
            const SizedBox(height: 32),
            _buildSectionHeader('Assignments', Icons.assignment_ind_outlined),
            const SizedBox(height: 16),
            _buildAssignmentsCard(),
            
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader('Categories & Objectives', Icons.category_outlined),
                FilledButton.icon(
                  onPressed: _addCategory,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Category'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...categories.asMap().entries.map((entry) => _buildCategoryCard(entry.key, entry.value)),
            
            // Extra padding for the bottom bar
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomSheet: _buildBottomBar(currentWeight, weightColor, isPerfectWeight),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Template Name',
                hintText: 'e.g., Annual Sales Performance 2024',
                prefixIcon: Icon(Icons.title),
              ),
              onChanged: (val) => templateName = val,
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe the purpose of this template...',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Icon(Icons.description),
                ),
              ),
              onChanged: (val) => description = val,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: empLabel,
              decoration: const InputDecoration(
                labelText: 'Employee Label',
                prefixIcon: Icon(Icons.badge),
              ),
              onChanged: (val) => empLabel = val,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mocking the Select dropdowns from React with a simple UI representation
            _buildMockDropdown('Assign Roles', 'Select roles...'),
            const SizedBox(height: 16),
            _buildMockDropdown('Assign Departments', 'Select departments...'),
            const SizedBox(height: 16),
            _buildMockDropdown('Assign Employee (Optional)', 'Search employee...'),
          ],
        ),
      ),
    );
  }

  Widget _buildMockDropdown(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(hint, style: TextStyle(color: Colors.grey.shade500)),
              Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(int categoryIndex, Category category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          initiallyExpanded: true,
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          title: TextFormField(
            initialValue: category.name,
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              hintText: 'Category Name',
            ),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            onChanged: (val) => setState(() => category.name = val),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _removeCategory(categoryIndex),
            tooltip: 'Remove Category',
          ),
          children: [
            Container(
              color: Colors.grey.shade50,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ...category.objectives.asMap().entries.map(
                    (entry) => _buildObjectiveRow(categoryIndex, entry.key, entry.value)
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _addObjective(categoryIndex),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Objective'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildObjectiveRow(int categoryIndex, int objectiveIndex, Objective objective) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: objective.name,
                  decoration: const InputDecoration(
                    labelText: 'Objective Name',
                    hintText: 'Enter objective...',
                  ),
                  onChanged: (val) => setState(() => objective.name = val),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: TextFormField(
                  initialValue: objective.weight > 0 ? objective.weight.toString() : '',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Weight %',
                    hintText: '0.0',
                  ),
                  onChanged: (val) {
                    setState(() {
                      objective.weight = double.tryParse(val) ?? 0.0;
                    });
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => _removeObjective(categoryIndex, objectiveIndex),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: objective.control,
                  decoration: const InputDecoration(labelText: 'Control'),
                  items: ['Editable', 'Locked'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => objective.control = val);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  const Text('Mandatory', style: TextStyle(fontWeight: FontWeight.w500)),
                  Switch(
                    value: objective.mandatory,
                    onChanged: (val) => setState(() => objective.mandatory = val),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(double currentWeight, Color weightColor, bool isPerfectWeight) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Total Weight: ',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
                      ),
                      Text(
                        '${currentWeight.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold, 
                          color: weightColor
                        ),
                      ),
                      const Text(
                        ' / 100%',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (currentWeight / 100).clamp(0.0, 1.0),
                      backgroundColor: Colors.grey.shade200,
                      color: weightColor,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            FilledButton.icon(
              onPressed: () {
                if (!isPerfectWeight) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Total weight must be exactly 100%. Current: ${currentWeight.toStringAsFixed(1)}%'),
                      backgroundColor: Colors.red.shade600,
                    ),
                  );
                  return;
                }
                // Save logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Template saved successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Template', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
