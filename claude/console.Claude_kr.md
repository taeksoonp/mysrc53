# CLAUDE.md (한국어 번역본)

이 파일은 이 저장소에서 코드 작업을 할 때 Claude Code(claude.ai/code)에게 지침을 제공합니다.

## 개요

`console`은 WebGate/SONE 브랜드의 임베디드 DVR/NVR 하드웨어(HiSilicon Hi35xx 및 Novatek NT983xx SoC)용 Qt4/Qt-Embedded(QWS, X11 없음) 기반 OSD(On-Screen Display) 애플리케이션입니다. DVR의 녹화 엔진("recore")과 함께 별도의 사용자 공간 프로세스로 실행되며, SoC 비디오 하드웨어가 라이브 디코딩 영상 위에 알파 합성하는 메뉴/설정 UI를 그립니다. 동일한 소스 트리에서 다음을 크로스 컴파일합니다:
- Linux/ARM용 임베디드 타깃 바이너리(`conmain`, 일명 "console").
- `_PC_CONFIG` 하에서 동일한 UI/시나리오/설정 소스로 빌드되는 Windows PC "원격 설정" 도구(`cc_config` / `config.zip`).
  - PC-config 패키지는 NVR 펌웨어에 내장되어 있으며, PC 소프트웨어가 NVR의 버전을 감지하여 해당 NVR로부터 일치하는 PC-config를 자동으로 다운로드합니다. 따라서 PC-config와 NVR은 항상 동일한 빌드이며 — **PC-config와 NVR 간의 하위 호환성은 필요하지 않습니다** (`_PC_CONFIG` ↔ NVR WESP/config 경로에 구/신 버전 상대를 위한 버전 체크나 폴백을 추가하지 마십시오).
- 실제 하드웨어 없이 console UI를 개발/디버깅하기 위한 데스크톱 Linux x86 시뮬레이터("VVR").

이 체크아웃은 git이 아닌 SVN 작업 사본(`.svn/`)입니다 — 참조할 `git log`/`git blame` 이력이 없으므로, 필요하면 `svn log`/`svn blame`을 사용하십시오.

## 빌드

빌드는 전적으로 **한 단계 상위 디렉터리의 상위 빌드 시스템**(`/home/tsp/prj/trunk/edvr_hddvr_hisilicon_env.sh`, 그리고 다른 제품 라인용 형제 스크립트 `ns04r_env.sh`/`ipcam_env.sh`)이 주입하는 환경 변수로 구동됩니다. 이 저장소의 Makefile은 단독으로는 동작하지 않습니다 — 필수 환경 변수(`WHBS_CONSOLE_TARGETID`, `WHBS_SOC_type`/`WHBS_SOC_TYPE`, `WHBS_BUILD_OEM_ID`, `WHBS_BUILD_CHANNEL`, `WHBS_BUILD_SERIES`, `WHBS_GLOBAL_DEFINITIONS`, `WHBS_BUILD_VERSION`, `ARCH`, `CROSS_COMPILE`)는 모델명을 인자로 해당 env 스크립트를 source 하여 얻습니다. 예:

```sh
. ../edvr_hddvr_hisilicon_env.sh HAC850F-V3 [version]
```

그 다음, 이 디렉터리에서:

```sh
./build_v5_console.sh   # `make`를 감싼 스크립트 (WHBS_GLOBAL_DEFINITIONS에 TO_EXCLUDE_CCCONFIG가 있으면 `make no_win`)
```

주요 Makefile 타깃 (최상위 `Makefile`):
- `make all` — 전체 빌드: Linux console 바이너리 + Windows cc_config 도구 + spotosd/util 헬퍼 + qm 번역 파일 + db.
- `make no_win` — 위와 동일하되 Windows/MinGW `cc_config` 빌드는 생략.
- `make bld_linux` — 임베디드 console 바이너리만 빌드 (`bin/$(Target_id)/console_exe/conmain`).
- `make bld_win` — Windows PC-config 도구만 빌드 (먼저 `gen_lang_qm`으로 번역 파일을 재생성).
- `make clean` — Linux, Windows, spotosd 빌드 트리를 정리.
- `qmakecache` — `install_v5_console.sh`를 실행하여 `src/.qmake.cache` 및 SoC별 심볼릭 링크를 (재)생성. 선행 조건으로 자동 실행됨.
- `global_definitions` / `oem_definitions.pro` — `WHBS_GLOBAL_DEFINITIONS`/`WHBS_BUILD_OEM_ID`가 바뀔 때마다 자동 재생성됨. 이때 변경된 매크로를 참조하는 모든 소스 파일을 `touch` 하여 증분 `make`가 올바르게 재빌드되도록 합니다. `oem_definitions.pro`나 `global_definitions`는 생성 파일이므로 직접 수정하지 마십시오.

출력물은 `bin/$(WHBS_CONSOLE_TARGETID)/`(예: `bin/hs16k/`, `bin/hs8k/`, `bin/hs8l/`)에 생성되며, `console_exe/`, `cc_config/`, `lang_qm/`, `qt_lib/`로 나뉩니다.

`WHBS_CONSOLE_TARGETID`는 `${WHBS_BUILD_SERIES}${WHBS_BUILD_CHANNEL}${WHBS_BUILD_SOCID}` 형식으로 구성됩니다. 예: `hs16k` = 16채널, 시리즈 `hs`, SoC-id `k`(NT98323); `hs8l` = 8채널, NT98336. SoC-id 문자: `c`=HI3521A `d`=HI3531A `e`=HI3536 `f`=HI3536C `g`=HI3521D `h`=HI3531D `j`=NT98321 `k`=NT98323 `l`=NT98336 `m`=NT98331 `n`=NT98332 `o`=NT98692. SoC별 컴파일러 플래그는 `src/soc_cflags.mk`에 있습니다.

Qt 버전은 전체적으로 **Qt4**(qmake-qt4, `lrelease-qt4`)입니다. `lib/qt4/`에는 SoC별로 Qt 4.8.7 기반 트리(`lib_hi3520`, `lib_nt98332` 등)가 포함되어 있습니다. 번역 파일은 `gen_lang_qm` Makefile 타깃을 통해 `src/console/project_linux/ts/*.ts`로부터 컴파일되며, `ml_japanese.ts`에 잘못 들어간 전각 `％`가 발견되면 빌드를 중단하고, `WHBS_BUILD_OEM_ID`에 따라 `ml_korean.qm` 또는 `ml_korean_sone.qm` 중 하나를 제외합니다.

자체 Makefile을 가진 하위 빌드 (모두 최상위 `Makefile`이 빌드하며, 모두 `src/soc_cflags.mk`를 사용):
- `src/spotosd/` — Qt4 GUI `spotosd`(스팟 모니터 OSD 렌더러) 및 독립 CLI 헬퍼 `ipc2con`, `vgaparam`, `proxyd`(Boost.Asio TCP 릴레이), `vmcv2ready`, `ssmode`.
- `src/xml2ini/` — `dvrconfig*.xml`/`consolestate.xml`/`systemlog.xml`을 `.ini`로(또는 그 반대로) 변환하는 Qt4 콘솔 앱. 플래시 I/O 및 XML 검증 기능 포함.
- `src/util/` — Qt를 사용하지 않는 키/인증서 프로비저닝 도구: `initkey`, `resetkey`, `check_keys_ok`, `dotcert2flash` (모두 ioctl을 통해 `/dev/sfd` 플래시 장치와 통신).
- `src/tests/` — **자동화된 테스트 스위트가 아닙니다.** 하드웨어 ioctl/IPC를 직접 시험해 보기 위해 장비에서 수동으로 빌드·실행하는 독립 진단/임시 바이너리(`ipctest`, `ioctltest`, `ttatt`, 그리고 주석 처리된 `mytest`/`himouse`/`hifb_test`)입니다. 이 트리 어디에도 단위 테스트 프레임워크(QTest/gtest/catch2 없음)나 CI 테스트 훅이 없으며, 검증은 수동/장비 상에서 이루어집니다. `make test`가 존재한다고 가정하지 마십시오.

`db/schema.db`는 사전 빌드된 SQLite 데이터베이스(LPR/톨게이트 차량 이벤트 및 열화상/안면 발열 감지 이벤트 테이블)로, 빌드 시 `console_exe/`에 그대로 복사됩니다. `make db`는 저널 모드를 WAL로 설정하고 복사만 합니다.

## 아키텍처

아래 내용은 모두 `src/console/` 하위에 있습니다.

**시작 과정**: `core/main.cpp:main()`이 `CConsole` 싱글톤(`core/console.h/.cpp`)을 생성합니다. 이 싱글톤은 `CFactory`(추상 클래스. 유일한 구현체는 `model/v5/hd_factory.h/.cpp`의 `CHDFactory` — 헤더 주석 참고: *"When you add new OEM or a model, you have to declare a new subclass of CFactory"* (새 OEM이나 모델을 추가할 때는 CFactory의 새 하위 클래스를 선언해야 한다)), `CQtApp : QApplication`(`core/qtapp.h/.cpp`), 그리고 `QStateMachine`을 소유합니다. `CConsole::run()`은 장치 관리자 → 설정 관리자 → 이벤트 관리자 → 시나리오/상태 머신 → wesp/ipc/onvif 관리자 순으로 초기화하고, 이들을 `CScheduler`에 등록한 뒤 `m_qtApp->exec()`에 진입합니다.

**동시성 모델**: 단일 스레드, 이벤트 기반. `CQtApp`은 `notify()`를 오버라이드하여 Qt 이벤트 루프가 돌 때마다 `CScheduler::run()`(`core/scheduler/`)도 호출하며, 이는 등록된 장치/IPC 파일 디스크립터를 `select()`(`common/cselect.h`)로 폴링합니다. I/O용 워커 스레드는 없습니다 — 키패드, IPC 읽기, 네트워크 등 모든 것이 Qt 이벤트 루프 안에서 협력적으로 다중화됩니다.

**렌더링**: Qt/Embedded(QWS)가 투명 배경(`QWSServer::setBackground`)의 프레임버퍼에 OSD 위젯을 그리고, SoC 하드웨어가 이를 라이브 디코딩 영상 위에 알파 합성합니다. Qt는 영상 픽셀을 직접 다루지 않습니다 — 비디오 플레인 제어(채널 레이아웃, 줌, 프리즈, 마우스 커서)는 `CDisplayController`(`device/dispctrl/{hisilicon,novatek,x64}/`)가 장치 노드에 `ioctl()`을 호출하는 별도 경로로 이루어집니다.

**녹화 엔진과의 IPC**: 소켓/D-Bus가 아닌 한 쌍의 커스텀 캐릭터 장치를 사용합니다. `ipc/v5/ipcsender.h/.cpp`(`CIpcSender`)는 `/dev/con2rec`에 쓰고, `ipc/v5/ipcreceiver.h/.cpp`(`CIpcReceiver`)는 `/dev/rec2con`에서 읽습니다(블로킹이 아닌 `CScheduler`를 통해 스케줄링). 수신된 메시지는 `QEvent`로 변환되어 `CEventManager`를 통해 디스패치됩니다. PC-config(`_PC_CONFIG`) 빌드에서는 로컬 장치가 없으므로 `IPC_RECEIVER`가 `WESPMGR->cli()`로 재정의됩니다 — 즉 "IPC"가 WESP 네트워크 프로토콜(`wesp/`)을 통해 이루어집니다. `COnvifManager`는 병렬로 존재하는 ONVIF IPC 경로입니다.

**모듈 구성**:
- `core/` — 앱 싱글톤, Qt 애플리케이션 하위 클래스, 스케줄러.
- `model/` — OEM/모델 변형을 위한 `CFactory`/`CHDFactory` 분기점. `nvrdef.h`는 화면 분할 레이아웃 지오메트리를 채널 수별 네임스페이스 상수 테이블로 정의.
- `device/` — 하드웨어 추상화(키패드, 디스플레이 컨트롤러, 시리얼, sfd/플래시, vdrv). 구체적인 SoC 계열별 클래스는 qmake 시점에 선택됨.
- `event/` — `EventType` 열거형(전면 패널/IR/내부 이벤트), `CMsg` 파생 이벤트 페이로드, 상태 머신으로 이벤트를 공급하는 중앙 디스패처 `CEventManager`.
- `scenario/` — 앱의 상태 머신 / 비즈니스 로직. `scenario/v5/statehierarchy.h`는 `QStateMachine`/`QState`(`scenario/state.h`, `CState`) 기반으로 전체 메뉴 트리(Login → Live/Playback → 수십 개의 하위 메뉴 상태)를 정의. 약 60개의 형제 파일이 상태 머신에 연결되거나 함께 동작하는 기능 영역(backup, record, disk, ddns, dhcp, ntp, email, poc, poe, raidcore, upnp, p2p, s1connectx/cloud 등)을 구현. `ccconfig/`는 축소된 설정 흐름을 위한, 구조적으로 유사한 더 작은 상태 계층.
- `config/` — 녹화 엔진에 전송되는 `conf_t` 구조체를 반영하는 XML/태그 기반 설정 문서 모델(`configmanager.h`, `configdocument.h`, `configtag.h`).
- `ui/` — 최상위에는 재사용 가능한 `QWG*` 접두사 커스텀 Qt 위젯. `ui/v5/`에는 실제 제품 화면(Qt Designer `.ui` 폼 + 생성 코드)이 있으며, `base4/base8/base16/base32/base36/base64/` 아래에 채널 수별 레이아웃 변형이 포함됨.
- `common/` — 전반적으로 사용되는 기반 클래스(`CObject`, `CManager`, `CDevice`/`CFile`, `CSelect`, `CThread`).
- `lib/` — 번들된 지원 라이브러리(cjson, dns, encoding, netadmin, ntp, onvif, raidmgr, sadp discovery, wrs).
- `wesp/` — 네트워크 탐색 + 원격 설정 프로토콜 서버/클라이언트. 임베디드 타깃(모바일 앱/PC 도구/클라우드 질의 응답)과 PC-config 도구의 IPC 대체 수단 양쪽에서 사용됨.
- `etc/` — `vvrc`/`vvrs` 데스크톱 시뮬레이터 하네스(`__VVR` 빌드).
- `language/` — 컴파일된 `.qm` 번역 파일. `CConsole`에서 `QTranslator`로 로드됨.

**빌드 타깃 구조** (`project_linux/` vs `project_window/`): 하나의 공유 소스 트리를 SoC/채널 수/OEM별로 전적으로 qmake 변수를 통해 구성합니다. 모델별 `.pro` 파일(예: `project_linux/hs8k/hs8k.pro`)이 `include(../hs_common.pro)`를 하며, 이 파일이 모든 `SOURCES`/`HEADERS`를 나열하고 버전별 하위 디렉터리(`model/$$MODEL_VER`, `ui/$$UI_VER/$$CHANNEL_NUM`, `device/*/$$DISPCTRL_VER` 등)를 선택합니다. `project_window/`는 이를 그대로 따르되 `DEFINES += _PC_CONFIG`를 추가하여, 동일한 UI/시나리오/설정 코드를 네트워크 전용 원격 설정 도구로 MinGW/Windows 빌드합니다.

## OEM / 모델 / 기능별 조건부 컴파일

세 가지(+1) 서로 다른 메커니즘이 사용됩니다 — 코드를 수정하기 전에 해당 코드가 어떤 메커니즘을 쓰는지 파악하십시오:

1. **OEM 브랜딩** (`WEBGATE` vs `SONE`): `oem_definitions.pro`가 둘 다 정수로 정의하므로(예: `-DWEBGATE=0 -DSONE=1`), 소스 코드는 항상 값 비교를 사용합니다 — `#if (WHBS_BUILD_OEM_ID == SONE)` — `#ifdef WEBGATE`/`#ifdef SONE`은 절대 쓰지 않습니다(이 패턴이 약 1500회 이상 등장). 유일한 실제 `#ifdef` 변형은 SONE의 PC 시뮬레이터 경로를 제어하는 `SONE_DEV_IN_PC`입니다.
2. **고객/프로젝트별 기능 플래그**: `WHBS_GLOBAL_DEFINITIONS` 환경 변수로 전달된 이름 토큰이 그대로 `-D` 정의가 되며(위의 `global_definitions`/Makefile 메커니즘 참고), 코드에서는 평범한 `#ifdef TOKEN`으로 사용됩니다. 명명 규칙은 대부분 `TO_SUPPORT_<기능_또는_고객>`(예: `TO_SUPPORT_LGUPLUS_WGI_SERVER`, `TO_SUPPORT_THERMAL_DETECTION`, `TO_SUPPORT_FISHEYE_IPCAM`) 또는 `<고객>_PROJECT`(예: `FEDEX_PROJECT`)입니다. `Deployment`(`WHBS_EXCLUDE_TELNETD`에서 유래)는 telnetd 같은 개발 전용 코드를 평범한 `#ifdef`/`#ifndef`로 제어합니다.
3. **채널 수 / 모델**: 대부분 qmake 시점에 컴파일할 디렉터리(`ui/v5/base4|8|16|32|36|64/`, `model/$$MODEL_VER/`)를 선택하는 방식으로 결정되며, 배열 크기 지정에는 `BuildChannel` 매크로(`#if BuildChannel == 4/8/16/36`)를 사용합니다. `WHBS_BUILD_MODEL_ID`는 소스 어디에서도 컴파일 타임 매크로로 **사용되지 않습니다**.
4. **런타임 하드웨어/기능 capability**: 모델/OEM/기능 구분에 실제로 가장 많이 쓰이는 메커니즘은 `sysvar` 클래스(`core/console.h`)입니다 — 시작 시 하드웨어/EEPROM "wgi sys vars"로부터 채워지는 정적 테이블로, `sysvar::video()`, `sysvar::poe()`, `sysvar::support_lguplus_oem()`, `sysvar::modeltype()` 같은 접근자를 제공합니다. 새 컴파일 타임 플래그가 필요하다고 가정하기 전에 먼저 여기를 확인하십시오.

## 코딩 규칙

- Qt가 아닌/비즈니스 로직 클래스는 `C` 접두사(`CObject`, `CManager`, `CDevice`, `CConsole`), 커스텀 Qt 위젯은 `QWG` 접두사(`QWGPushButton`, `QWGDialog`), 멤버 변수는 `m_` 접두사를 사용합니다. 싱글톤은 `CConsole::getInstance()` 형태와 매크로 접근자(`CONSOLE`, `DEVICEMGR`, `IPC_RECEIVER`, ...)를 따릅니다.
- 헤더는 `#ifndef _NAME_H_` 가드를 사용하며, 대부분의 core/model 파일에는 Doxygen 스타일 헤더 주석(`\file`, `\date`, `\brief`)이 있습니다.
- 주석은 주로 영어이며, 한국어는 개발자 주석이 아닌 사용자에게 보이는 UI 문자열(`QString::fromUtf8(...)`)에만 등장합니다.
- `deprecated_readme.txt`는 EUC-KR 인코딩된 한국어 텍스트이므로 UTF-8 터미널에서는 깨져 보입니다 — 읽어야 한다면 `iconv -f EUC-KR -t UTF-8`을 사용하십시오.
- **번역**: 새로 추가/변경된 UI 문자열의 번역을 요청받으면, 항상 `src/console/project_linux/ts/`의 다음 세 파일만 정확히 수정합니다: `ml_korean.ts`, `ml_korean_sone.ts`(두 파일에 같은 한국어 텍스트. 단, 해당 문자열의 기존 항목이 두 파일 간에 다르면 예외) 그리고 `ml_japanese.ts`. 각 메시지는 `tr()`이 사용하는 것과 같은 `<name>` 컨텍스트(또는 `.ui` 폼의 클래스) 아래에 추가하고, 따옴표는 `&apos;`로 이스케이프하며, 일본어에는 전각 `％`를 쓰지 마십시오. 다른 언어 파일은 건드리지 마십시오. 검증은 `lrelease-qt4 <file>.ts -qm <scratch>.qm`으로 합니다.
