import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/task_model.dart';
import '../providers/task_provider.dart';

class SearchFilterWidget extends StatefulWidget {
  const SearchFilterWidget({super.key});

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search tasks...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            taskProvider.searchTasks('');
                          },
                        )
                      : null,
                ),
                onChanged: taskProvider.searchTasks,
              ),
              
              const SizedBox(height: 16),
              
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Status Filters
                    FilterChip(
                      label: const Text('All'),
                      selected: taskProvider.statusFilter == null,
                      onSelected: (_) => taskProvider.filterByStatus(null),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Pending'),
                      selected: taskProvider.statusFilter == TaskStatus.pending,
                      onSelected: (_) => taskProvider.filterByStatus(TaskStatus.pending),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('In Progress'),
                      selected: taskProvider.statusFilter == TaskStatus.inProgress,
                      onSelected: (_) => taskProvider.filterByStatus(TaskStatus.inProgress),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Completed'),
                      selected: taskProvider.statusFilter == TaskStatus.completed,
                      onSelected: (_) => taskProvider.filterByStatus(TaskStatus.completed),
                    ),
                    const SizedBox(width: 8),
                    
                    // Priority Filters
                    PopupMenuButton<TaskPriority?>(
                      onSelected: taskProvider.filterByPriority,
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: null,
                          child: Text('All Priorities'),
                        ),
                        ...TaskPriority.values.map((priority) => PopupMenuItem(
                          value: priority,
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Task(title: '', description: '', priority: priority).priorityColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(priority.name.toUpperCase()),
                            ],
                          ),
                        )),
                      ],
                      child: Chip(
                        label: Text(taskProvider.priorityFilter?.name.toUpperCase() ?? 'PRIORITY'),
                        avatar: const Icon(Icons.filter_list, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Active Filters Summary
              if (taskProvider.searchQuery.isNotEmpty || 
                  taskProvider.statusFilter != null || 
                  taskProvider.priorityFilter != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${taskProvider.tasks.length} tasks found',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        taskProvider.clearFilters();
                      },
                      child: const Text('Clear Filters'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
