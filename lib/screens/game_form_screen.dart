import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/game.dart';
import '../providers/games_provider.dart';
import '../styles/app_styles.dart';

class GameFormScreen extends StatefulWidget {
  final Game? game;

  const GameFormScreen({super.key, this.game});

  @override
  State<GameFormScreen> createState() => _GameFormScreenState();
}

class _GameFormScreenState extends State<GameFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _developerController;
  late TextEditingController _imageUrlController;
  late TextEditingController _trailerUrlController;

  String _selectedGenre = Game.availableGenres.first;
  String _selectedStatus = Game.availableStatuses.first;
  DateTime _selectedDate = DateTime.now();
  double _rating = 5.0;
  bool _isFree = false;
  List<String> _selectedPlatforms = [];

  @override
  void initState() {
    super.initState();
    if (widget.game != null) {
      _titleController = TextEditingController(text: widget.game!.title);
      _descriptionController =
          TextEditingController(text: widget.game!.description);
      _developerController =
          TextEditingController(text: widget.game!.developer);
      _imageUrlController = TextEditingController(text: widget.game!.imageUrl);
      _trailerUrlController =
          TextEditingController(text: widget.game!.trailerUrl);
      _selectedGenre = widget.game!.genre;
      _selectedStatus = widget.game!.status;
      _selectedDate = widget.game!.releaseDate;
      _rating = widget.game!.rating;
      _isFree = widget.game!.isFree;
      _selectedPlatforms = List.from(widget.game!.platforms);
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _developerController = TextEditingController();
      _imageUrlController = TextEditingController();
      _trailerUrlController = TextEditingController();
      _selectedPlatforms = [];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _developerController.dispose();
    _imageUrlController.dispose();
    _trailerUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1980),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveGame() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPlatforms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите хотя бы одну платформу')),
      );
      return;
    }

    final game = Game(
      id: widget.game?.id ?? DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text,
      genre: _selectedGenre,
      description: _descriptionController.text,
      releaseDate: _selectedDate,
      rating: _rating,
      imageUrl: _imageUrlController.text.isEmpty
          ? 'https://via.placeholder.com/300x200'
          : _imageUrlController.text,
      developer: _developerController.text,
      platforms: _selectedPlatforms,
      status: _selectedStatus,
      isFree: _isFree,
      trailerUrl: _trailerUrlController.text,
    );

    final gamesProvider = context.read<GamesProvider>();
    if (widget.game != null) {
      gamesProvider.updateGame(game);
    } else {
      gamesProvider.addGame(game);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.game != null ? 'Игра обновлена' : 'Игра добавлена',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.game != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать игру' : 'Добавить игру'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppStyles.paddingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название игры *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название игры';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppStyles.paddingMedium),
              DropdownButtonFormField<String>(
                value: _selectedGenre,
                decoration: const InputDecoration(
                  labelText: 'Жанр *',
                ),
                items: Game.availableGenres.map((genre) {
                  return DropdownMenuItem(
                    value: genre,
                    child: Text(genre),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedGenre = value;
                    });
                  }
                },
              ),
              const SizedBox(height: AppStyles.paddingMedium),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Описание *',
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите описание игры';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppStyles.paddingMedium),
              TextFormField(
                controller: _developerController,
                decoration: const InputDecoration(
                  labelText: 'Разработчик *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название разработчика';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppStyles.paddingMedium),
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Дата выхода *',
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd.MM.yyyy').format(_selectedDate),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppStyles.paddingMedium),
              Text(
                'Рейтинг: ${_rating.toStringAsFixed(1)}',
                style: AppStyles.bodyStyle,
              ),
              Slider(
                value: _rating,
                min: 0,
                max: 10,
                divisions: 20,
                label: _rating.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
              const SizedBox(height: AppStyles.paddingMedium),
              Text(
                'Статус разработки (радио-кнопки)',
                style: AppStyles.subtitleStyle,
              ),
              const SizedBox(height: AppStyles.paddingSmall),
              ...Game.availableStatuses.map((status) {
                return RadioListTile<String>(
                  title: Text(status),
                  value: status,
                  groupValue: _selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                  activeColor: AppStyles.primaryColor,
                );
              }),
              const SizedBox(height: AppStyles.paddingMedium),
              CheckboxListTile(
                title: const Text('Бесплатная игра'),
                value: _isFree,
                onChanged: (value) {
                  setState(() {
                    _isFree = value ?? false;
                  });
                },
                activeColor: AppStyles.primaryColor,
              ),
              const SizedBox(height: AppStyles.paddingMedium),
              Text(
                'Платформы (чекбоксы)',
                style: AppStyles.subtitleStyle,
              ),
              const SizedBox(height: AppStyles.paddingSmall),
              Wrap(
                spacing: AppStyles.paddingSmall,
                runSpacing: AppStyles.paddingSmall,
                children: Game.availablePlatforms.map((platform) {
                  final isSelected = _selectedPlatforms.contains(platform);
                  return FilterChip(
                    label: Text(platform),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedPlatforms.add(platform);
                        } else {
                          _selectedPlatforms.remove(platform);
                        }
                      });
                    },
                    selectedColor: AppStyles.primaryColor.withOpacity(0.2),
                    checkmarkColor: AppStyles.primaryColor,
                  );
                }).toList(),
              ),
              const SizedBox(height: AppStyles.paddingMedium),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL изображения',
                  hintText: 'https://example.com/image.jpg',
                ),
              ),
              const SizedBox(height: AppStyles.paddingMedium),
              TextFormField(
                controller: _trailerUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL трейлера',
                  hintText: 'https://youtube.com/watch?v=...',
                ),
              ),
              const SizedBox(height: AppStyles.paddingLarge),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveGame,
                  child: Text(isEditing ? 'Сохранить изменения' : 'Добавить игру'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
