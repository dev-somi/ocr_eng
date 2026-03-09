import 'package:clickword/data/repository.dart';
import 'package:clickword/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wordBookListProvider = StateNotifierProvider<WordBookListNotifier, List<WordBook>>((ref) {
  final repository = ref.watch(repositoryProvider);
  return WordBookListNotifier(repository);
});

class WordBookListNotifier extends StateNotifier<List<WordBook>> {
  final WordRepository _repository;

  WordBookListNotifier(this._repository) : super([]);

  Future<void> loadWordBooks() async {
    state = _repository.getWordBooks();
  }

  Future<void> addWordBook(WordBook book) async {
    await _repository.addWordBook(book);
    state = _repository.getWordBooks();
  }

  Future<void> deleteWordBook(String id) async {
    await _repository.deleteWordBook(id);
    state = _repository.getWordBooks();
  }

  Future<void> updateWordBook(WordBook book) async {
    await _repository.updateWordBook(book);
    state = _repository.getWordBooks();
  }
}
