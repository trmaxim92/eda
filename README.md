# eda

# Park Dostavka (MVP)

SEO-сайт для привлечения курьеров в Яндекс Еду через парк-партнёр **park-dostavka.ru**.

Стек: Ruby 3.4 · Rails 8 · PostgreSQL · Hotwire/Stimulus · Devise · Pundit · Propshaft.

Сайт **не является** официальным сайтом Яндекса.

## Быстрый запуск (Docker, рекомендуется на Windows)

```bash
docker compose up --build
```

Откройте:

- сайт: http://localhost:3000/
- админка: http://localhost:3000/admin/
- логин создаётся в `db/seeds.rb` (смените пароль после первого входа)

## Основные URL

- `/` — главная
- `/rabota-peshim-kurerom/`, `/rabota-velokurerom/`, `/rabota-avtokurerom/`
- `/goroda/`, `/goroda/moskva/`
- `/go/register` — реферальный redirect со статистикой
- `/sitemap.xml`, `/robots.txt`

## SSH-ключ для доступа к серверу без пароля

На этой машине уже есть ключ:

- приватный: `C:\Users\Maxim Tryapkin\.ssh\id_ed25519`
- публичный: `C:\Users\Maxim Tryapkin\.ssh\id_ed25519.pub`

Публичный ключ (добавить на сервер в `~/.ssh/authorized_keys`):

```text
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB7k+I0Bb/fg021Qls7ZpA2HdKfYxmNjmBOuKRLP7DQZ maxim tryapkin@LAPTOP-FPU4OGUI
```

На сервере:

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB7k+I0Bb/fg021Qls7ZpA2HdKfYxmNjmBOuKRLP7DQZ maxim tryapkin@LAPTOP-FPU4OGUI' >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

Проверка с Windows:

```powershell
ssh user@YOUR_SERVER_IP
```

## Важно по рефералкам

Кнопка самостоятельной регистрации появляется только при активной доверенной ссылке.
По умолчанию в seed стоит заглушка `https://eda.yandex.ru/` — замените на реальную ссылку парка в админке.

Переход ≠ регистрация. В статистике раздельно считаются клики и заявки.
