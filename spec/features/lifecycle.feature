# Кроки Given формують файл даних напряму (через LABTRACKER_DATA), а не командами CLI.
Feature: Життєвий цикл лабораторної роботи
  Як студент
  я хочу змінювати стан роботи, зокрема пропускаючи етапи й виправляючи помилки
  щоб облік відповідав реальному стану справ

  Background:
    Given існує дисципліна "ООП"
    And робота ООП №1 з максимальним балом 10

  @SC-07 @REQ-F-009
  Scenario: Основний шлях без пропусків
    Given робота ООП №1 у стані "not_started"
    When студент послідовно переводить роботу в "in_progress", "submitted"
    And студент переводить роботу в "defended" з балами 9
    Then робота ООП №1 має стан "defended" і бали 9 з 10

  @SC-08 @REQ-F-009
  Scenario Outline: Дозволені та заборонені переходи
    Given робота ООП №1 у стані "<з>"
    When студент переводить роботу в "<у>"
    Then команда завершується з кодом <код>
    And робота ООП №1 має стан "<підсумок>"

    Examples:
      | з           | у           | код | підсумок    |
      | not_started | submitted   | 0   | submitted   |
      | in_progress | not_started | 1   | in_progress |
      | submitted   | in_progress | 1   | submitted   |
      | returned    | submitted   | 0   | submitted   |
      | returned    | in_progress | 1   | returned    |
      | submitted   | submitted   | 1   | submitted   |

  @SC-09 @REQ-F-010 @REQ-NF-006
  Scenario: «Повернута» досяжна лише зі стану «Здана»
    Given робота ООП №1 у стані "in_progress"
    When студент переводить роботу в "returned"
    Then команда завершується з кодом 1
    And повідомлення містить поточний стан «Виконується»
    And повідомлення перелічує дозволені переходи "submitted, defended"

  @SC-10 @REQ-F-011
  Scenario: Пропуск одразу в «Захищена» з балами
    Given робота ООП №1 у стані "not_started"
    When студент переводить роботу в "defended" з балами 8
    Then робота ООП №1 має стан "defended" і бали 8 з 10

  @SC-11 @REQ-F-011
  Scenario Outline: Захист без коректних балів відхиляється
    Given робота ООП №1 у стані "submitted"
    When студент виконує "status 'ООП' 1 defended <аргументи>"
    Then команда завершується з кодом 1
    And робота ООП №1 має стан "submitted"

    Examples:
      | аргументи   |
      |             |
      | --score 11  |
      | --score -1  |
      | --score 7.5 |

  @SC-12 @REQ-F-011
  Scenario: Захист роботи без максимального балу відхиляється
    Given робота ООП №2 без максимального балу у стані "submitted"
    When студент переводить роботу ООП №2 в "defended" з балами 5
    Then команда завершується з кодом 1
    And повідомлення пропонує спочатку задати максимальний бал

  @SC-23 @REQ-F-011
  Scenario: Бали при переході не в «Захищена» відхиляються
    Given робота ООП №1 у стані "in_progress"
    When студент виконує "status 'ООП' 1 submitted --score 5"
    Then команда завершується з кодом 1
    And робота ООП №1 має стан "in_progress"

  @SC-13 @REQ-F-012
  Scenario: Скасування після пропуску повертає саме попередній стан, лише на один крок
    Given робота ООП №1 у стані "not_started"
    When студент переводить роботу в "submitted"
    And студент виконує "undo 'ООП' 1"
    Then робота ООП №1 має стан "not_started"
    When студент виконує "undo 'ООП' 1"
    Then команда завершується з кодом 1

  @SC-14 @REQ-F-012
  Scenario: Скасування захисту видаляє бали
    Given робота ООП №1 у стані "submitted"
    And студент переводить роботу в "defended" з балами 9
    When студент виконує "undo 'ООП' 1"
    Then робота ООП №1 має стан "submitted"
    And робота ООП №1 не має отриманих балів
