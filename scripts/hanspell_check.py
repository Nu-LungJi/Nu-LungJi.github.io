import sys
from hanspell import spell_checker


result = spell_checker.check(text)
if result.errors:
    print(result.checked)

def check_file(path):
    with open(path, "r", encoding="utf-8") as f:
        text = f.read()

    result = spell_checker.check(text)

    errors = []

    for word, ok in result.words.items():
        if not ok:
            errors.append(word)

    return errors


all_errors = []

with open(result_file, "w", encoding="utf-8") as out:

    for file in sys.argv[1:]:
        errors = check_file(file)

        if errors:
            out.write(f"## 📝 {file}\n")

            for e in errors:
                out.write(f"- {e}\n")

            out.write("\n")

            all_errors.extend(errors)


if all_errors:
    print("맞춤법 오류 발견")
    sys.exit(1)

print("맞춤법 오류 없음")
