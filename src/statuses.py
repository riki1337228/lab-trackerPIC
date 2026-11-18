"""Стани лабораторної роботи в Lab Tracker."""

# Перелік станів роботи (чорновий варіант).
STATUSES = [
    "not_started",
    "in_progress",
    "submitted",
]

# Дозволені переходи між станами: стан -> множина наступних станів.
TRANSITIONS = {
    "not_started": {"in_progress"},
    "in_progress": {"submitted"},
    "submitted": set(),
}


def can_transition(current: str, new: str) -> bool:
    """Повертає True, якщо перехід current -> new дозволено."""
    return new in TRANSITIONS.get(current, set())
