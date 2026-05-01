# RPG Maker MV/MZ MCP 개발 환경 세팅 가이드

이 문서는 Gemini CLI 세션 동안 구축된 RPG Maker MCP 서버 및 게임 개발 환경을 다른 PC에서 동일하게 재현하기 위한 가이드입니다.

## 1. 필수 준비물
- **Node.js**: v18 이상 권장
- **브라우저**: Google Chrome (시크릿 모드 권장)
- **RPG Maker 프로젝트**: (예: `TestGame` 폴더)
- **Claude Desktop**: MCP 도구를 사용하기 위해 필요

---

## 2. MCP 서버 설치 및 빌드
가장 먼저 RPG Maker 데이터를 제어할 MCP 서버를 준비합니다.

1. **저장소 클론**
   ```bash
   git clone https://github.com/garuh143/rpg-makermv-mcp.git
   cd rpg-makermv-mcp
   ```

2. **의존성 설치 및 빌드**
   Windows 환경에서는 PowerShell 정책 제한이 있을 수 있으므로 `.cmd`를 붙여 실행합니다.
   ```bash
   npm.cmd install
   npm.cmd run build
   ```
   - 빌드가 완료되면 `dist/index.js` 파일이 생성됩니다.

---

## 3. Claude Desktop 연결 설정
Claude가 RPG Maker 도구를 사용할 수 있도록 설정 파일을 수정합니다.

1. **설정 파일 위치**: `%APPDATA%\Claude\claude_desktop_config.json`
2. **내용 추가**: 아래 JSON 구조를 참조하여 경로를 수정 후 저장합니다.
   ```json
   {
     "mcpServers": {
       "rpgmaker-mcp": {
         "command": "node",
         "args": ["C:/경로/to/rpg-makermv-mcp/dist/index.js"],
         "env": {
           "RPGMAKER_PROJECT_PATH": "C:/경로/to/TestGame"
         }
       }
     }
   }
   ```
   *주의: 경로 구분자는 슬래시(`/`)를 사용하세요.*

---

## 4. 로컬 게임 서버 실행 (캐시 방지)
브라우저 보안 정책(CORS) 및 캐시 문제를 해결하기 위해 로컬 서버를 사용합니다.

1. **서버 실행 명령어**
   ```bash
   npx.cmd -y http-server "C:\경로\to\TestGame" -p 8080 -c-1
   ```
   - `-c-1`: 브라우저 캐시를 완전히 비활성화하여 수정 사항이 즉시 반영되게 합니다.

---

## 5. 세션 구현 기능 요약
이번 세션에서 `TestGame`에 직접 구현된 주요 기능들입니다. 동일한 로직을 재현하려면 관련 스크립트를 실행하거나 MCP 도구를 통해 다음을 수행하세요.

### 1) 액터 및 맵 배치
- **Gemini 액터**: 5명의 새 액터(ID 5~9) 추가 및 `Map 001`의 (5,5)~(9,5) 좌표에 배치.
- **집(내부 맵)**: ID 2번 맵 생성 및 메인 맵(2,5) 좌표에 입구(문) 설치.

### 2) 상점 시스템
- **NPC**: 집 내부 (5,5) 좌표에 상점 NPC 배치.
- **커스텀 아이템**: '마라로제떡볶이' (ID 5, 가격 100G, HP 100% 회복) 추가 및 상점 등록.

### 3) 추격 몬스터 메커니즘
- **몬스터**: `Map 001`에서 플레이어를 천천히 추격하는 이벤트 생성.
- **봉인 장치**: 맵에 3개의 스위치 배치. 3개를 모두 작동시키면 몬스터가 정지하도록 변수 및 스위치 로직 설계.

### 4) 시스템 설정
- **오디오 뮤트**: `System.json`을 수정하여 모든 배경음 및 효과음 볼륨을 0으로 설정.

---

## 6. 편리한 실행 도구
프로젝트 루트에 `Launch_TestGame.bat` 파일을 만들어 사용하면 편리합니다.

```batch
@echo off
start /min npx.cmd -y http-server "C:\경로\to\TestGame" -p 8080 -c-1
timeout /t 2
start chrome --incognito "http://localhost:8080"
```

---

## 7. 문제 해결
- **데이터가 안 보일 때**: 반드시 **크롬 시크릿 모드**를 사용하거나 개발자 도구(`F12`)에서 `Disable Cache`를 체크하세요.
- **서버 오류**: RPG Maker 에디터가 파일을 점유하고 있으면 MCP 서버가 파일을 쓰지 못할 수 있습니다. 에디터를 끄고 시도하세요.
