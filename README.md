# Правила оформлення commit message

Усі коміт повідомлення повинні починатися з префіксу `DJ-X:` або `DJ-XXXX:`, де `DJ` — це абревіатура проєкту, а `X` — це номер завдання (від 0 до 100000).

**Приклад:**

DJ-1234: Implement user authentication feature

# Перевірка форматування коду

Для перевірки форматування коду використовується `flake8`. Перед комітом Git автоматично запускає цей лінтер.

Щоб вручну перевірити форматування, виконайте команду: flake8

Якщо будуть знайдені помилки форматування, їх необхідно виправити перед комітом.
