import 'package:flutter/material.dart';
import '../../../core/models/task_model.dart';
import '../../../core/services/database_service.dart';

class TaskProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  bool _isLoading = false;
  String _searchQuery = '';
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;
  String? _categoryFilter;

  List<Task> get tasks => _filteredTasks;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  TaskStatus? get statusFilter => _statusFilter;
  TaskPriority? get priorityFilter => _priorityFilter;
  String? get categoryFilter => _categoryFilter;

  // Statistics
  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((t) => t.status == TaskStatus.completed).length;
  int get pendingTasks => _tasks.where((t) => t.status == TaskStatus.pending).length;
  int get overdueTasks => _tasks.where((t) => t.isOverdue).length;
  int get todayTasks => _tasks.where((t) => t.isDueToday).length;

  List<String> get categories {
    final cats = _tasks.map((t) => t.category).where((c) => c != null).cast<String>().toSet().toList();
    cats.sort();
    return cats;
  }

  Future<void> loadTasks() async {
    _setLoading(true);
    try {
      _tasks = await _databaseService.getAllTasks();
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading tasks: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addTask(Task task) async {
    try {
      await _databaseService.insertTask(task);
      _tasks.insert(0, task);
      _applyFilters();
    } catch (e) {
      debugPrint('Error adding task: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _databaseService.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        _applyFilters();
      }
    } catch (e) {
      debugPrint('Error updating task: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _databaseService.deleteTask(taskId);
      _tasks.removeWhere((t) => t.id == taskId);
      _applyFilters();
    } catch (e) {
      debugPrint('Error deleting task: $e');
    }
  }

  Future<void> toggleTaskStatus(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final newStatus = task.status == TaskStatus.completed 
        ? TaskStatus.pending 
        : TaskStatus.completed;
    
    final updatedTask = task.copyWith(
      status: newStatus,
      completedAt: newStatus == TaskStatus.completed ? DateTime.now() : null,
    );
    
    await updateTask(updatedTask);
  }

  void searchTasks(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByStatus(TaskStatus? status) {
    _statusFilter = status;
    _applyFilters();
  }

  void filterByPriority(TaskPriority? priority) {
    _priorityFilter = priority;
    _applyFilters();
  }

  void filterByCategory(String? category) {
    _categoryFilter = category;
    _applyFilters();
  }

  void clearFilters() {
    _searchQuery = '';
    _statusFilter = null;
    _priorityFilter = null;
    _categoryFilter = null;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredTasks = _tasks.where((task) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!task.title.toLowerCase().contains(query) &&
            !task.description.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Status filter
      if (_statusFilter != null && task.status != _statusFilter) {
        return false;
      }

      // Priority filter
      if (_priorityFilter != null && task.priority != _priorityFilter) {
        return false;
      }

      // Category filter
      if (_categoryFilter != null && task.category != _categoryFilter) {
        return false;
      }

      return true;
    }).toList();

    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
