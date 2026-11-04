#!/usr/bin/env python3
import importlib.util
import sys
import tempfile
import unittest
from pathlib import Path

_SPEC = importlib.util.spec_from_file_location(
    "jellyfin_link", Path(__file__).with_name("jellyfin_link.py")
)
jellyfin_link = importlib.util.module_from_spec(_SPEC)
_SPEC.loader.exec_module(jellyfin_link)

extract_episode = jellyfin_link.extract_episode
existing_episode_numbers = jellyfin_link.existing_episode_numbers


class ExtractEpisodeTest(unittest.TestCase):
    def test_sxxeyy(self):
        self.assertEqual(
            extract_episode(
                "Orb.On.the.Movements.of.the.Earth.S01E04.1080p.NF.WEB-DL.JPN.DDP2.0.H.264.mkv"
            ),
            4,
        )

    def test_n_of_m_inside_brackets(self):
        self.assertEqual(
            extract_episode(
                "[AniFilm] Kingdom [TV] [18 of 38] [1280x720 x264] [Ru Jp] [Nutbar & Lali].mkv"
            ),
            18,
        )

    def test_russian_series_word(self):
        self.assertEqual(extract_episode("Sukasuka TV 12 серия.mkv"), 12)

    def test_dash_number(self):
        self.assertEqual(extract_episode("BECK - 06.mkv"), 6)

    def test_dash_number_three_digits_zero_padded(self):
        self.assertEqual(
            extract_episode(
                "[SOFCJ-Raws] Naruto - 030 (DVDRip 768x576 HEVC VFR 10bit FLAC).mkv"
            ),
            30,
        )

    def test_dash_number_three_digits(self):
        self.assertEqual(
            extract_episode(
                "[SOFCJ-Raws] Naruto - 119 (DVDRip 768x576 HEVC VFR 10bit FLAC).mkv"
            ),
            119,
        )

    def test_dash_number_with_roman_numeral_title(self):
        self.assertEqual(
            extract_episode("Overlord IV - 11 [BDRip 1080p HEVC 10bits FLAC].mkv"), 11
        )

    def test_bare_number_before_descriptive_bracket(self):
        self.assertEqual(
            extract_episode(
                "BLACK LAGOON The Second Barrage 20 [The Succession] (BD 1920x1080 x264 AAC).mp4"
            ),
            20,
        )

    def test_bare_number_before_extension(self):
        self.assertEqual(extract_episode("Yubisaki to Renren 09.mkv"), 9)

    def test_bare_number_only(self):
        self.assertEqual(extract_episode("12.mkv"), 12)

    def test_bare_number_before_tech_bracket(self):
        self.assertEqual(
            extract_episode(
                "[Yousei-raws] Magi - The Labyrinth of Magic 11 [BDrip 1920x1080 x264 FLAC].mkv"
            ),
            11,
        )

    def test_bare_number_not_confused_with_resolution(self):
        self.assertEqual(
            extract_episode(
                "Flying Witch Petit 06 [BD x265 1920x1080 FLAC] [km].mkv"
            ),
            6,
        )

    def test_no_episode_marker_returns_none(self):
        self.assertIsNone(
            extract_episode("Some Movie (2006) [BDRip 1920x1080 x264 FLAC].mkv")
        )

    def test_year_alone_is_not_mistaken_for_episode(self):
        self.assertIsNone(extract_episode("Ookami Kodomo no Ame to Yuki [BDrip 1920x1080 x264 rus].mkv"))


class ExistingEpisodeNumbersTest(unittest.TestCase):
    def test_finds_padded_episode_numbers(self):
        with tempfile.TemporaryDirectory() as tmp:
            series_dir = Path(tmp) / "Naruto"
            season_dir = series_dir / "Season 01"
            season_dir.mkdir(parents=True)
            for ep in (1, 12, 79, 147):
                (season_dir / f"Naruto - S01E{ep:03d}.mkv").touch()

            self.assertEqual(
                sorted(existing_episode_numbers(series_dir, 1)), [1, 12, 79, 147]
            )

    def test_matches_season_dir_with_shikimori_tag_suffix(self):
        with tempfile.TemporaryDirectory() as tmp:
            series_dir = Path(tmp) / "Overlord"
            season_dir = series_dir / "Season 01 [shikimori-12345]"
            season_dir.mkdir(parents=True)
            (season_dir / "Overlord - S01E01.mkv").touch()

            self.assertEqual(existing_episode_numbers(series_dir, 1), [1])

    def test_missing_series_dir_returns_empty(self):
        with tempfile.TemporaryDirectory() as tmp:
            self.assertEqual(existing_episode_numbers(Path(tmp) / "Nope", 1), [])


if __name__ == "__main__":
    sys.exit(unittest.main())
