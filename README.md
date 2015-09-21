# Tiny Cat

> Soft Kitty, Warm Kitty,
> little ball of fur.
> Happy Kitty, Sleepy Kitty,
> purr, purr, purr

## Зависимости

* [ImageMagick](http://www.imagemagick.org/) для обработки картинок
* [sidekiq](https://github.com/mperham/sidekiq/) для фоновых задач
* [redis](http://redis.io/) для sidekiq

## Установка

Установка очень проста. Во-первых не забудьте все зависимости установить
и запустить.

Во-вторых, выполните следующие команды

```bash
rake db:create # Если база данных ещё не создана
rake db:migrate
rake db:seed
```

Теперь можете наслаждаться котеньками.