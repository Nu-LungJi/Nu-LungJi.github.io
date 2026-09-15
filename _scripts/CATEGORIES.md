# 카테고리 관리

## 평소 사용하는 방법

`_data/navigation.yml`의 `sidebar-category`에서 항목을 추가하거나 삭제한 뒤
GitHub의 `master`에 반영하세요. 작업 브랜치를 쓰는 경우 Pull Request를 병합하면 됩니다.
`BLOG_PUBLISH.bat`은 기존처럼 작업 브랜치를 올리고 PR 화면을 엽니다.

```yaml
  - title: "SOFTWARE ARCHITECTURE"
    children:
      - title: "Software Modeling"
        url: "/categories/Software-Modeling/"
        category: "Software Modeling"
```

- `title`: 메뉴와 카테고리 페이지에 표시할 이름
- `url`: `/categories/영문주소/` 형식. 주소에는 영문, 숫자, `-`, `_`를 사용하세요.
- `category`: 글 상단 `categories`에 있는 이름과 정확히 같아야 합니다.
  표시 이름과 달라도 됩니다. 예: `title: "Design Principles"`, `category: "Design Principle"`.
- `author_profile: true`: 필요할 때만 추가하는 작성자 소개 표시 옵션
- 그룹 제목에는 `title`과 `children`을 쓰고 `url`, `category`는 넣지 않습니다.
- 모든 카테고리를 없애려면 `sidebar-category: []`로 지정합니다.

Actions의 **Sync categories and deploy Pages** 작업이 설정 검증, 페이지 생성,
블로그 빌드, 생성 파일의 자동 커밋, 배포를 순서대로 수행합니다.
실패하면 해당 작업 로그를 확인하세요. 빌드에 실패하면 배포하지 않습니다.
다음 로컬 작업을 시작할 때 최신 `master`를 가져오면 자동 생성 파일도 내려옵니다.

## 자동으로 관리되는 파일

`_pages/generated-categories/`의 `.md`는 자동 생성 파일입니다. 직접 편집하지 마세요.
파일명은 URL에서 계산하므로 임의의 영문·숫자처럼 보이는 것이 정상입니다.
실제 페이지 주소는 각 파일의 `permalink`로 결정됩니다.

메뉴 항목을 제거하면 그 항목의 자동 생성 페이지도 삭제됩니다.
게시글, 게시글의 카테고리 지정, 수동 페이지는 그대로 남습니다.
따라서 전체 카테고리 모음에는 게시글에 지정된 카테고리가 계속 보일 수 있습니다.
새 카테고리 페이지에 글을 표시하려면 게시글의 `categories`에도 해당 이름을 지정하세요.

## 최초 설치 시 한 번 확인

GitHub 저장소 **Settings → Pages → Build and deployment → Source**를
**GitHub Actions**로 설정합니다. 별도의 개인 토큰을 Secrets에 등록할 필요는 없습니다.
워크플로 파일을 `master`에 넣은 뒤 Actions에서 최초 실행이 성공했는지 확인하세요.
필요하면 **Run workflow**로 다시 실행할 수 있습니다.

자동 생성 파일을 `master`에 저장하므로, 브랜치 보호 규칙이 직접 커밋을 막는 저장소에서는
저장 단계가 실패할 수 있습니다. 이 경우 보호 규칙을 임의로 해제하지 말고 PR 기반 방식으로 조정하세요.

## 선택: 로컬에서 미리 확인

Python 3.10 이상에서 블로그 폴더를 열고 실행하세요.

```text
python -m pip install -r _scripts/requirements.txt
python _scripts/sync_categories.py --check
python _scripts/sync_categories.py
```

`--check`는 입력과 충돌을 검사하며 파일을 생성·수정·삭제하지 않습니다.
이미 생성된 파일이 최신인지 비교하는 옵션은 아닙니다.
로컬 실행은 선택사항이며, GitHub에서 수정하는 경우 Python 설치가 필요 없습니다.
