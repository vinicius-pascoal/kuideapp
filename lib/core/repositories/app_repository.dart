abstract interface class AppRepository<T> {
  Future<List<T>> findAll();
}
