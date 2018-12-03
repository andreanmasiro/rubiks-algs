func first<T>() -> (T, T) -> T {
    return { t, _ in t }
}
