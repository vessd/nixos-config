# nixos-config

Конфигурация NixOS и home-manager на flake-parts. Модули в `features/`
обнаруживаются автоматически, композиция — явными списками импортов в хостах.

## Структура

```
flake.nix          # входы и сборка flake-parts
features/
  nixos/           # модули системы (base, kde, docker, pipewire, ...)
  home/            # модули home-manager (bash, git, direnv, ...)
hosts/             # конфигурации хостов
overlays/          # локальные пакеты и подмены из nixpkgs-unstable
pkgs/              # собственные пакеты
deploy/            # деплой конфигурации хостов с помощью deploy-rs
```

Авто-обнаружение модулей (`features/default.nix`):

- `features/<kind>/<name>.nix` → модуль `<name>`
- `features/<kind>/<name>/` (папка) → один модуль `<name>` из всех файлов папки
- файлы с префиксом `_` игнорируются

## Команды

```sh
# переключить конфигурацию текущего хоста
nh os switch

# применить конфигурацию без добавления её в загрузчик
nh os test

# devShell: agenix-rekey, deploy-rs, nixos-anywhere
nix develop

# перешифровать секреты (см. заметку ниже)
agenix rekey

# удалённый деплой уже установленного сервера
deploy .#nas

# первичная установка хоста по SSH (через disko-разметку)
nixos-anywhere --flake .#<host> \
  --generate-hardware-config nixos-generate-config ./hosts/<host>/hardware-configuration.nix \
  root@<ip>
```

## Секреты

Файлы `*.age` зашифрованы мастер-ключом (вне репозитория) и публичными
SSH-ключами хостов. После изменений — `agenix rekey` из devShell.

Особенность: `agenix.rekey.cacheDir` (`hosts/desktop/agenix.nix`) требует,
чтобы конфигурация была применена до первого `agenix rekey`, иначе сборщик
не получит доступ к кешу. Если секреты уже добавлены, а настройка ещё не
применена — временно запустить `agenix rekey` от root.

## Как добавить фичу

Положить файл `features/nixos/<name>.nix` (или `features/home/<name>.nix`) —
модуль `<name>` появится в `self.nixosModules.<name>` (или `self.homeModules.<name>`)
и подключится в нужных хостах одной строкой в списке `modules`.

## Как добавить хост

Создать `hosts/<host>/` по образцу существующих: `default.nix` с
`flake.nixosConfigurations.<name> = nixpkgs.lib.nixosSystem {...}`,
`configuration.nix`, `hardware-configuration.nix`. Затем добавить `./<host>`
в `imports` в `hosts/default.nix`.
