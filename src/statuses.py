"""Стани лабораторної роботи в Lab Tracker."""

# Перелік станів роботи (чорновий варіант).
STATUSES = [
    "not_started",
    "in_progress",
    "submitted",
    "graded",    # оцінена
    "overdue",   # прострочена
]

# Дозволені переходи між станами: стан -> множина наступних станів.
TRANSITIONS = {
    "not_started": {"in_progress", "overdue"},
    "in_progress": {"submitted", "overdue"},
    "submitted": {"graded"},
    "overdue": {"submitted"},
    "graded": set(),
}



def can_transition(current: str, new: str) -> bool:
    """Повертає True, якщо перехід current -> new дозволено."""
    return new in TRANSITIONS.get(current, set())
