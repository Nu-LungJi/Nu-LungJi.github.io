"""Fail the build if a generated category is absent from Jekyll's output."""
from pathlib import Path

from sync_categories import plan, read_yaml


def main():
    root = Path(__file__).resolve().parent.parent
    _, pages, _ = plan(root)
    for content in pages.values():
        front = read_yaml(content.split('---\n', 2)[1])
        target = root / '_site' / front['permalink'].strip('/') / 'index.html'
        if not target.is_file() or target.stat().st_size == 0:
            raise SystemExit(f'Missing category page in built site: {target}')
        html = target.read_text(encoding='utf-8')
        if '<html' not in html.lower() or 'entries-list' not in html:
            raise SystemExit(f'Category layout was not rendered: {target}')
    print(f'Verified {len(pages)} category pages in the built site.')


if __name__ == '__main__':
    main()
