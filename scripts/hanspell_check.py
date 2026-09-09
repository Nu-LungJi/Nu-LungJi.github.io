#!/usr/bin/env python3
"""Check UTF-8 files with py-hanspell; exit 0=pass, 1=issues, 2=execution error.

Usage: python scripts/hanspell_check.py --output result.txt -- "my post.md"
CI:    python scripts/hanspell_check.py --files-from files.nul --output result.txt
The input list must be NUL-delimited (git diff --name-only -z).
Markdown is checked as text, including front matter and code blocks.
"""

import argparse
import os
import re
import sys
import time
from pathlib import Path


MAX_CHARS = 500
KOREAN = re.compile(r"[가-힣ㄱ-ㅎㅏ-ㅣ]")
LABELS = {1: "맞춤법", 2: "띄어쓰기", 3: "표준어 의심", 4: "통계적 교정"}


def chunks(text):
    """Preserve all characters, preferring whitespace boundaries below 500 chars."""
    start = 0
    while start < len(text):
        end = min(start + MAX_CHARS, len(text))
        if end < len(text):
            boundaries = list(re.finditer(r"\s+", text[start:end]))
            if boundaries:
                end = start + boundaries[-1].end()
        part = text[start:end]
        if part.strip() and KOREAN.search(part):
            yield text.count("\n", 0, start) + 1, part
        start = end


def load_checker():
    try:
        import requests
        from hanspell import spell_checker
    except ImportError as exc:
        raise RuntimeError(
            "py-hanspell 또는 의존성이 없습니다. workflow의 설치 단계를 확인하세요."
        ) from exc

    # The upstream library does not set an HTTP timeout or check HTTP status.
    class TimedSession(requests.Session):
        def request(self, method, url, **kwargs):
            kwargs.setdefault("timeout", (5, 20))
            response = super().request(method, url, **kwargs)
            response.raise_for_status()
            return response

    if not hasattr(spell_checker, "_agent"):
        raise RuntimeError("설치된 hanspell이 지원하는 py-hanspell 버전과 다릅니다.")
    spell_checker._agent.close()
    spell_checker._agent = TimedSession()
    return spell_checker.check


def validate(result):
    if getattr(result, "result", None) is not True:
        raise RuntimeError("hanspell이 검사 실패(result=False)를 반환했습니다.")
    if not isinstance(getattr(result, "checked", None), str) or not result.checked.strip():
        raise RuntimeError("hanspell이 교정 문장을 반환하지 않았습니다.")
    if type(getattr(result, "errors", None)) is not int or result.errors < 0:
        raise RuntimeError("hanspell의 오류 수 응답 형식이 올바르지 않습니다.")
    if not isinstance(getattr(result, "words", None), dict):
        raise RuntimeError("hanspell의 단어 판정 응답 형식이 올바르지 않습니다.")
    if any(type(value) is not int or value not in range(5) for value in result.words.values()):
        raise RuntimeError("hanspell이 알 수 없는 단어 판정 값을 반환했습니다.")


def write_report(path, lines):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main(argv=None, checker=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("files", nargs="*")
    parser.add_argument("--files-from", type=Path, help="NUL로 구분한 파일 목록")
    parser.add_argument("--output", type=Path, default=Path("hanspell-result.txt"))
    args = parser.parse_args(argv)
    report = ["한국어 맞춤법 검사", ""]
    context = "준비"
    report_safe = True
    try:
        inputs = [Path(name) for name in args.files]
        if args.files_from is not None:
            inputs.append(args.files_from)
        if any(path.resolve() == args.output.resolve() for path in inputs):
            report_safe = False
            raise ValueError("입력 파일과 결과 파일은 달라야 합니다.")
        paths = list(args.files)
        if args.files_from is not None:
            data = args.files_from.read_bytes()
            if data and not data.endswith(b"\0"):
                raise ValueError("파일 목록은 git diff -z의 NUL 구분 형식이어야 합니다.")
            paths.extend(os.fsdecode(item) for item in data.split(b"\0") if item)
        paths = list(dict.fromkeys(paths))
        if any(Path(name).resolve() == args.output.resolve() for name in paths):
            report_safe = False
            raise ValueError("입력 파일과 결과 파일은 달라야 합니다.")
        # A killed process must never leave a success report from an earlier run.
        write_report(args.output, ["검사가 완료되지 않았습니다."])
        if not paths:
            report.append("검사 대상 Markdown 파일이 없습니다.")
            write_report(args.output, report)
            print("검사 대상 없음")
            return 0

        has_issues = False
        requests_made = 0
        completed = 0
        for name in paths:
            context = repr(name)
            path = Path(name)
            if path.is_symlink():
                raise ValueError("심볼릭 링크는 검사 대상 파일로 지원하지 않습니다.")
            text = path.read_text(encoding="utf-8-sig")
            for line, part in chunks(text):
                context = f"{name!r}, {line}행부터 시작하는 구간"
                if checker is None:
                    checker = load_checker()
                if requests_made:
                    time.sleep(0.2)
                result = checker(part)
                requests_made += 1
                validate(result)
                # PASSED is 0, not True. words contains corrected words.
                flagged = [(word, code) for word, code in result.words.items() if code != 0]
                if result.errors > 0 or flagged:
                    has_issues = True
                    report.extend([
                        f"파일: {name!r} / 구간 시작: {line}행",
                        f"오류 수: {result.errors}",
                        "검사 전:", part.rstrip(),
                        "교정 후:", result.checked,
                    ])
                    report.extend(f"- {LABELS[code]}: {word}" for word, code in flagged)
                    report.append("")
            completed += 1

        status = "수정 또는 검토가 필요한 표현이 있습니다." if has_issues else "맞춤법 오류가 발견되지 않았습니다."
        if requests_made == 0:
            status = "파일에 검사할 한글이 없어 외부 검사를 생략했습니다."
        report.extend([status, f"확인한 파일: {completed}개 / 검사한 구간: {requests_made}개"])
        write_report(args.output, report)
        print("맞춤법 검토 필요" if has_issues else "검사 완료")
        return 1 if has_issues else 0
    except Exception as exc:
        report.extend([
            "검사 실행 실패 — 전체 검사를 완료하지 못했습니다.",
            f"위치: {context}",
            f"원인: {type(exc).__name__}: {exc}",
            "",
            "KeyError('result'), JSON 응답 오류, HTTP 오류가 발생했다면",
            "py-hanspell과 네이버 서비스 사이의 호환성 또는 통신 문제를 확인하세요.",
            "검사 실행 실패는 맞춤법 통과나 맞춤법 오류로 판정하지 않습니다.",
        ])
        if not report_safe:
            print("검사 실행 실패: 입력 파일과 결과 파일은 달라야 합니다.", file=sys.stderr)
            return 2
        try:
            write_report(args.output, report)
        except OSError:
            print("검사 실행 실패: 결과 파일도 저장하지 못했습니다.", file=sys.stderr)
        else:
            print("검사 실행 실패: 결과 파일을 확인하세요.", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
