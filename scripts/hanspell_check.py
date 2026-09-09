import sys
from hanspell import spell_checker


def check_file(path):
    with open(path, "r", encoding="utf-8") as f:
        text = f.read()

    result = spell_checker.check(text)

    errors = []

    for word, info in result.words.items():
        if info == False:
            errors.append(word)

    return errors


if __name__ == "__main__":
    files = sys.argv[1:]

    total_errors = []

    for file in files:
        errors = check_file(file)

        if errors:
            print(f"\n📝 {file}")

            for error in errors:
                print(f"- {error}")

            total_errors.extend(errors)

    if total_errors:
        print(
            f"\n⚠️ 맞춤법 오류 {len(total_errors)}개 발견"
        )
        sys.exit(1)

    print("✅ 맞춤법 오류 없음")
