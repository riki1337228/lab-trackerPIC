"""Перевірка відповідності станів роботи spec/vision.md, розділ 5."""

import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "src"))

from statuses import STATUSES, TRANSITIONS, can_transition  # noqa: E402


class LifecycleMatchesSpec(unittest.TestCase):
    def test_statuses_from_spec(self):
        self.assertEqual(
            set(STATUSES),
            {"not_started", "in_progress", "submitted", "returned", "defended"},
        )

    def test_main_path(self):
        path = ["not_started", "in_progress", "submitted", "defended"]
        for cur, new in zip(path, path[1:]):
            self.assertTrue(can_transition(cur, new), f"{cur} -> {new}")

    def test_return_for_rework(self):
        self.assertTrue(can_transition("submitted", "returned"))
        self.assertTrue(can_transition("returned", "submitted"))

    def test_defended_is_final(self):
        self.assertEqual(TRANSITIONS["defended"], set())

    def test_no_skipping(self):
        self.assertFalse(can_transition("not_started", "defended"))
        self.assertFalse(can_transition("in_progress", "defended"))

    def test_transitions_reference_known_statuses(self):
        for src, targets in TRANSITIONS.items():
            self.assertIn(src, STATUSES)
            self.assertTrue(targets <= set(STATUSES))


if __name__ == "__main__":
    unittest.main()
