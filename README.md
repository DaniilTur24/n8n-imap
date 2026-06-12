# n8n-imap

Self-hosted [n8n](https://n8n.io/) на Railway.

## Деплой на Railway

1. Создайте новый проект на [Railway](https://railway.app/) и подключите этот GitHub-репозиторий.
2. Railway соберёт сервис по `Dockerfile`.
3. В разделе **Variables** добавьте переменные окружения из [.env.example](.env.example), заполнив реальными значениями:
   - `N8N_BASIC_AUTH_USER` / `N8N_BASIC_AUTH_PASSWORD` — логин/пароль для входа в веб-интерфейс n8n.
   - `N8N_ENCRYPTION_KEY` — случайная строка (сохраните её — без неё нельзя расшифровать сохранённые credentials при пересборке).
   - `N8N_HOST`, `WEBHOOK_URL` — публичный домен, который Railway выдаст сервису (Settings -> Networking -> Generate Domain).
4. **Persistent storage**: добавьте Volume (Settings -> Volumes) и примонтируйте его к `/home/node/.n8n` — там n8n хранит SQLite БД, credentials и workflows. Без этого все данные пропадут при редеплое.
5. После деплоя откройте выданный домен — откроется веб-интерфейс n8n.

## Импорт workflow

Если у вас есть экспорт workflow (JSON), положите его в папку [workflows/](workflows/) и импортируйте через UI n8n (Workflows -> Import from File) или CLI:

```bash
n8n import:workflow --input=workflows/your-workflow.json
```

## Локальный запуск

```bash
docker build -t n8n-imap .
docker run -it --rm -p 5678:5678 -v ~/.n8n:/home/node/.n8n --env-file .env n8n-imap
```
