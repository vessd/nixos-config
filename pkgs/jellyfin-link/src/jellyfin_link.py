#!/usr/bin/env python3
import argparse
import errno
import os
import re
import sys
from pathlib import Path

MOVIE_ROOT = Path("/storage/jellyfin/anime/movie")
TV_ROOT = Path("/storage/jellyfin/anime/tv")

BRACKET_RE = re.compile(r"\[[^\]]*\]|\([^)]*\)")
SXXEYY_RE = re.compile(r"[Ss](\d{1,2})[Ee](\d{1,3})")
OF_RE = re.compile(r"(\d{1,3})\s*(?:of|из)\s*\d{1,3}", re.IGNORECASE)
WORD_EP_RE = re.compile(r"\b(\d{1,3})\s*(?:серия|episode|ep)\b", re.IGNORECASE)
DASH_RE = re.compile(r"-\s*(\d{1,3})\b")
BARE_RE = re.compile(r"\b(\d{1,3})\b")
EXISTING_EPISODE_RE = re.compile(r"[Ss]\d+[Ee](\d+)")


def mask_brackets(name: str) -> str:
    return BRACKET_RE.sub(lambda m: " " * len(m.group(0)), name)


def extract_episode(filename: str) -> int | None:
    stem = Path(filename).stem

    m = SXXEYY_RE.search(stem)
    if m:
        return int(m.group(2))

    m = OF_RE.search(stem)
    if m:
        return int(m.group(1))

    masked = mask_brackets(stem)

    m = WORD_EP_RE.search(masked)
    if m:
        return int(m.group(1))

    m = DASH_RE.search(masked)
    if m:
        return int(m.group(1))

    candidates = BARE_RE.findall(masked)
    if len(candidates) == 1:
        return int(candidates[0])

    return None


def existing_episode_numbers(series_dir: Path, season: int) -> list[int]:
    if not series_dir.is_dir():
        return []

    numbers = []
    for season_dir in series_dir.glob(f"Season {season:02d}*"):
        if not season_dir.is_dir():
            continue
        for f in season_dir.iterdir():
            m = EXISTING_EPISODE_RE.search(f.name)
            if m:
                numbers.append(int(m.group(1)))

    return numbers


def link_one(src: Path, dest: Path, dry_run: bool) -> str:
    if dest.exists():
        src_stat = src.stat()
        dest_stat = dest.stat()
        if (dest_stat.st_dev, dest_stat.st_ino) == (src_stat.st_dev, src_stat.st_ino):
            return "уже слинковано, пропускаю"
        raise FileExistsError(f"{dest} уже существует и указывает на другой файл")

    if dry_run:
        return "будет создана ссылка"

    dest.parent.mkdir(parents=True, exist_ok=True)
    try:
        os.link(src, dest)
    except OSError as e:
        if e.errno == errno.EXDEV:
            raise RuntimeError(
                f"{src} и {dest} находятся на разных файловых системах, "
                "невозможно создать жёсткую ссылку"
            ) from e
        raise RuntimeError(f"не удалось создать жёсткую ссылку {src} -> {dest}: {e}") from e

    return "слинковано"


def cmd_movie(args: argparse.Namespace) -> int:
    source: Path = args.source
    if not source.is_file():
        print(f"ошибка: источник фильма должен быть файлом: {source}", file=sys.stderr)
        return 1

    stem = args.title + (f" ({args.year})" if args.year else "")
    dir_name = stem + (f" [shikimori-{args.shikimori_id}]" if args.shikimori_id else "")
    dest = MOVIE_ROOT / dir_name / (stem + source.suffix)

    try:
        status = link_one(source, dest, args.dry_run)
    except (FileExistsError, RuntimeError) as e:
        print(f"ошибка: {e}", file=sys.stderr)
        return 1

    print(f"{status}: {source} -> {dest}")
    return 0


def cmd_tv(args: argparse.Namespace) -> int:
    source: Path = args.source
    if not source.is_dir():
        print(f"ошибка: источник для tv должен быть директорией: {source}", file=sys.stderr)
        return 1

    files = sorted(p for p in source.iterdir() if p.is_file())
    if not files:
        print(f"ошибка: в {source} не найдено файлов", file=sys.stderr)
        return 1

    series_dir = TV_ROOT / args.title

    episodes: dict[tuple[int, str], Path] = {}
    problems: list[str] = []

    for f in files:
        episode = extract_episode(f.name)
        if episode is None:
            problems.append(f"не удалось определить номер эпизода по имени файла: {f.name}")
            continue

        key = (episode, f.suffix)
        existing = episodes.get(key)
        if existing is not None:
            problems.append(
                f"конфликт номеров эпизодов: файлы {existing.name!r} и {f.name!r} "
                f"оба соответствуют эпизоду {episode} с расширением {f.suffix!r}"
            )
            continue

        episodes[key] = f

    if problems:
        for p in problems:
            print(f"ошибка: {p}", file=sys.stderr)
        print("ссылки не созданы, исправьте конфликты выше и запустите снова", file=sys.stderr)
        return 1

    all_numbers = [ep for ep, _ in episodes] + existing_episode_numbers(series_dir, args.season)
    width = max(2, len(str(max(all_numbers))))

    season_name = f"Season {args.season:02d}" + (
        f" [shikimori-{args.shikimori_id}]" if args.shikimori_id else ""
    )
    season_dir = series_dir / season_name

    had_error = False
    for (episode, suffix), src in sorted(episodes.items()):
        dest_name = f"{args.title} - S{args.season:02d}E{episode:0{width}d}{suffix}"
        dest = season_dir / dest_name
        try:
            status = link_one(src, dest, args.dry_run)
        except (FileExistsError, RuntimeError) as e:
            print(f"ошибка: {e}", file=sys.stderr)
            had_error = True
            continue
        print(f"{status}: {src} -> {dest}")

    return 1 if had_error else 0


def main() -> int:
    parser = argparse.ArgumentParser(
        prog="jellyfin-link",
        description=(
            "Создаёт жёсткие ссылки на файлы раздач с именами в формате, "
            "который ожидает Jellyfin."
        ),
    )
    sub = parser.add_subparsers(dest="mode", required=True)

    movie_p = sub.add_parser("movie", help="слинковать файл фильма")
    movie_p.add_argument("source", type=Path, help="путь к файлу фильма")
    movie_p.add_argument(
        "--title", required=True, help="название фильма"
    )
    movie_p.add_argument(
        "--year", type=int, help="год выхода"
    )
    movie_p.add_argument(
        "--shikimori-id",
        type=int,
        metavar="ID",
        help="id тайтла на Shikimori, добавляется тегом [shikimori-<id>] к названию папки",
    )
    movie_p.add_argument(
        "--dry-run", action="store_true", help="только показать план действий, без создания ссылок"
    )
    movie_p.set_defaults(func=cmd_movie)

    tv_p = sub.add_parser(
        "tv", help="слинковать все файлы из папки релиза как эпизоды сезона"
    )
    tv_p.add_argument("source", type=Path, help="путь к папке релиза")
    tv_p.add_argument(
        "--title", required=True, help="название сериала"
    )
    tv_p.add_argument("--season", type=int, required=True, help="номер сезона")
    tv_p.add_argument(
        "--shikimori-id",
        type=int,
        metavar="ID",
        help="id тайтла на Shikimori, добавляется тегом [shikimori-<id>] к названию папки сезона",
    )
    tv_p.add_argument(
        "--dry-run", action="store_true", help="только показать план действий, без создания ссылок"
    )
    tv_p.set_defaults(func=cmd_tv)

    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
