import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

import yaml

SCRIPT = Path(__file__).with_name('sync_categories.py')


class CategorySyncTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        (self.root / '_data').mkdir()
        (self.root / '_pages').mkdir()
        (self.root / '_config.yml').write_text('include: [_pages]\n', encoding='utf-8')
        self.output = self.root / '_pages/generated-categories'

    def navigation(self, items):
        (self.root / '_data/navigation.yml').write_text(
            yaml.safe_dump({'sidebar-category': items}, allow_unicode=True), encoding='utf-8'
        )

    def category(self, slug='CPP', title='C++', **extra):
        return dict(title=title, url=f'/categories/{slug}/', category=title, **extra)

    def run_sync(self, *args, success=True):
        result = subprocess.run(
            [sys.executable, str(SCRIPT), '--root', str(self.root), *args],
            capture_output=True, text=True, encoding='utf-8'
        )
        self.assertEqual(result.returncode == 0, success, result.stdout + result.stderr)
        return result

    def snapshot(self):
        return {str(p.relative_to(self.root)): p.read_bytes()
                for p in self.root.rglob('*') if p.is_file()}

    def test_create_update_delete_preserves_posts_and_manual_pages(self):
        post = self.root / '_posts/sample.md'
        post.parent.mkdir()
        post.write_text('---\ncategories: [C++]\n---\nKeep this post.\n', encoding='utf-8')
        manual = self.root / '_pages/about.md'
        manual.write_text('---\npermalink: /about/\n---\nKeep this page.\n', encoding='utf-8')
        originals = (post.read_bytes(), manual.read_bytes())
        self.navigation([{'title': 'Group', 'children': [self.category()]}])
        self.run_sync()
        generated = list(self.output.glob('*.md'))
        self.assertEqual(len(generated), 1)
        front = yaml.safe_load(generated[0].read_text(encoding='utf-8').split('---\n')[1])
        self.assertEqual(front['taxonomy'], 'C++')
        self.assertEqual(front['permalink'], '/categories/CPP/')
        first = self.snapshot()
        self.run_sync()
        self.assertEqual(first, self.snapshot())
        item = self.category(author_profile=True)
        item['title'] = '새 표시 이름'
        self.navigation([item])
        self.run_sync()
        front = yaml.safe_load(generated[0].read_text(encoding='utf-8').split('---\n')[1])
        self.assertEqual(front['title'], '새 표시 이름')
        self.assertTrue(front['author_profile'])
        self.navigation([])
        self.run_sync()
        self.assertEqual(list(self.output.glob('*.md')), [])
        self.assertEqual(originals, (post.read_bytes(), manual.read_bytes()))

    def test_check_never_changes_files_even_when_deletions_are_pending(self):
        self.navigation([self.category()])
        self.run_sync('--check')
        self.assertFalse(self.output.exists())
        self.run_sync()
        self.navigation([])
        before = self.snapshot()
        result = self.run_sync('--check')
        self.assertIn('would remove 1', result.stdout)
        self.assertEqual(before, self.snapshot())

    def test_invalid_navigation_does_not_delete_existing_output(self):
        self.navigation([self.category()])
        self.run_sync()
        item = self.category()
        del item['category']
        self.navigation([item])
        before = self.snapshot()
        self.run_sync(success=False)
        self.assertEqual(before, self.snapshot())

    def test_manual_url_conflict_fails_before_writing(self):
        self.navigation([self.category()])
        (self.root / '_pages/legacy.md').write_text(
            '---\npermalink: /categories/CPP/\n---\n', encoding='utf-8')
        result = self.run_sync(success=False)
        self.assertIn('Existing page conflicts', result.stderr)
        self.assertFalse(self.output.exists())

    def test_unmanaged_file_in_output_is_preserved(self):
        self.navigation([])
        self.output.mkdir()
        manual = self.output / 'manual.md'
        manual.write_text('Keep me', encoding='utf-8')
        self.run_sync(success=False)
        self.assertEqual(manual.read_text(encoding='utf-8'), 'Keep me')

    def test_duplicate_url_category_or_yaml_key_fails(self):
        for items in (
            [self.category(), self.category('cpp', 'Other')],
            [self.category(), self.category('Different')],
        ):
            with self.subTest(items=items):
                self.navigation(items)
                self.run_sync(success=False)
                self.assertFalse(self.output.exists())
        (self.root / '_data/navigation.yml').write_text(
            'sidebar-category: []\nsidebar-category: []\n', encoding='utf-8')
        self.run_sync(success=False)

    def test_changed_url_replaces_old_generated_page(self):
        self.navigation([self.category()])
        self.run_sync()
        old = next(self.output.glob('*.md'))
        self.navigation([self.category('New-CPP')])
        self.run_sync()
        self.assertFalse(old.exists())
        self.assertEqual(len(list(self.output.glob('*.md'))), 1)


if __name__ == '__main__':
    unittest.main()
