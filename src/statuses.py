"""Стани лабораторної роботи в Lab Tracker."""

# Перелік станів роботи — відповідно до spec/vision.md, розділ 5.
STATUSES = [
    "not_started",  # не розпочата
    "in_progress",  # виконується
    "submitted",    # здана
    "returned",     # повернута на доопрацювання
    "defended",     # захищена (кінцевий стан)
]

# Дозволені переходи між станами: стан -> множина наступних станів.
TRANSITIONS = {
    "not_started": {"in_progress"},
    "in_progress": {"submitted"},
    "submitted": {"defended", "returned"},
    "returned": {"submitted"},
    "defended": set(),
}


def can_transition(current: str, new: str) -> bool:
    """Повертає True, якщо перехід current -> new дозволено."""
    return new in TRANSITIONS.get(current, set())
