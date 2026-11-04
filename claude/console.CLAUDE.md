# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`console` is the Qt4/Qt-Embedded (QWS, no X11) on-screen-display (OSD) application for WebGate/SONE-branded embedded DVR/NVR hardware (HiSilicon Hi35xx and Novatek NT983xx SoCs). It runs as a separate userspace process alongside the DVR's recording engine ("recore") and draws the menu/config UI that is alpha-composited by SoC video hardware over live decoded video. The same source tree cross-compiles:
- The embedded target binary (`conmain`, aka "console") for Linux/ARM.
- A Windows PC "remote configuration" tool (`cc_config` / `config.zip`) from the same UI/scenario/config sources under `_PC_CONFIG`.
  - The PC-config package is embedded in the NVR firmware; the PC software detects the NVR's version and automatically downloads the matching PC-config from that NVR. PC-config and NVR are therefore always the same build — **no backward compatibility between PC-config and NVR is needed** (don't add version checks or fallbacks for old/new counterparts in `_PC_CONFIG` ↔ NVR WESP/config paths).
- A desktop Linux x86 simulator ("VVR") for developing/debugging the console UI without real hardware.

This checkout is an SVN working copy (`.svn/`), not git — there is no `git log`/`git blame` history to consult; use `svn log`/`svn blame` instead if needed.

## Build

The build is driven entirely by environment variables injected by a **parent build system one directory up** (`/home/tsp/prj/trunk/edvr_hddvr_hisilicon_env.sh`, plus sibling `ns04r_env.sh`/`ipcam_env.sh` for other product lines). This repo's Makefiles do not work standalone — required env vars (`WHBS_CONSOLE_TARGETID`, `WHBS_SOC_type`/`WHBS_SOC_TYPE`, `WHBS_BUILD_OEM_ID`, `WHBS_BUILD_CHANNEL`, `WHBS_BUILD_SERIES`, `WHBS_GLOBAL_DEFINITIONS`, `WHBS_BUILD_VERSION`, `ARCH`, `CROSS_COMPILE`) come from sourcing that env script with a model name, e.g.:

```sh
. ../edvr_hddvr_hisilicon_env.sh HAC850F-V3 [version]
```

Then, from this directory:

```sh
./build_v5_console.sh   # wraps `make` (or `make no_win` if WHBS_GLOBAL_DEFINITIONS contains TO_EXCLUDE_CCCONFIG)
```

Key Makefile targets (top-level `Makefile`):
- `make all` — full build: Linux console binary + Windows cc_config tool + spotosd/util helpers + qm translations + db.
- `make no_win` — same but skips the Windows/MinGW `cc_config` build.
- `make bld_linux` — just the embedded console binary (`bin/$(Target_id)/console_exe/conmain`).
- `make bld_win` — just the Windows PC-config tool (regenerates translations first via `gen_lang_qm`).
- `make clean` — cleans Linux, Windows, and spotosd build trees.
- `qmakecache` — runs `install_v5_console.sh` to (re)create `src/.qmake.cache` and SoC-specific symlinks; runs automatically as a prerequisite.
- `global_definitions` / `oem_definitions.pro` — regenerated automatically whenever `WHBS_GLOBAL_DEFINITIONS`/`WHBS_BUILD_OEM_ID` change; this also `touch`es every source file referencing the changed macro so incremental `make` rebuilds correctly. Don't hand-edit `oem_definitions.pro` or `global_definitions` — they're generated.

Output lands in `bin/$(WHBS_CONSOLE_TARGETID)/` (e.g. `bin/hs16k/`, `bin/hs8k/`, `bin/hs8l/`), split into `console_exe/`, `cc_config/`, `lang_qm/`, `qt_lib/`.

`WHBS_CONSOLE_TARGETID` is formed as `${WHBS_BUILD_SERIES}${WHBS_BUILD_CHANNEL}${WHBS_BUILD_SOCID}`, e.g. `hs16k` = 16-channel, series `hs`, SoC-id `k` (NT98323); `hs8l` = 8-channel, NT98336. SoC-id letters: `c`=HI3521A `d`=HI3531A `e`=HI3536 `f`=HI3536C `g`=HI3521D `h`=HI3531D `j`=NT98321 `k`=NT98323 `l`=NT98336 `m`=NT98331 `n`=NT98332 `o`=NT98692. Per-SoC compiler flags live in `src/soc_cflags.mk`.

Qt version is **Qt4** throughout (qmake-qt4, `lrelease-qt4`); `lib/qt4/` bundles a Qt 4.8.7-derived tree per SoC (`lib_hi3520`, `lib_nt98332`, etc.). Translations are compiled from `src/console/project_linux/ts/*.ts` via the `gen_lang_qm` Makefile target, which aborts the build if a stray full-width `％` is found in `ml_japanese.ts`, and drops either `ml_korean.qm` or `ml_korean_sone.qm` depending on `WHBS_BUILD_OEM_ID`.

Sub-builds with their own Makefiles (all built by the top-level `Makefile`, and all consuming `src/soc_cflags.mk`):
- `src/spotosd/` — Qt4 GUI `spotosd` (spot-monitor OSD renderer) plus standalone CLI helpers `ipc2con`, `vgaparam`, `proxyd` (Boost.Asio TCP relay), `vmcv2ready`, `ssmode`.
- `src/xml2ini/` — Qt4 console app converting `dvrconfig*.xml`/`consolestate.xml`/`systemlog.xml` to `.ini` and back, plus flash I/O and XML validation.
- `src/util/` — non-Qt key/cert provisioning tools: `initkey`, `resetkey`, `check_keys_ok`, `dotcert2flash` (all talk to the `/dev/sfd` flash device via ioctl).
- `src/tests/` — **not an automated test suite**. Standalone diagnostic/scratch binaries (`ipctest`, `ioctltest`, `ttatt`, plus commented-out `mytest`/`himouse`/`hifb_test`) built and run manually on-device to poke hardware ioctls/IPC. There is no unit-test framework anywhere in this tree (no QTest/gtest/catch2) and no CI test hook — verification is manual/on-device. Do not assume `make test` exists.

`db/schema.db` is a pre-built SQLite database (LPR/tollgate vehicle-event and thermal/facial-heat-detection event tables) copied verbatim into `console_exe/` at build time; `make db` just sets its journal mode to WAL and copies it.

## Architecture

Everything below lives under `src/console/`.

**Startup**: `core/main.cpp:main()` creates the `CConsole` singleton (`core/console.h/.cpp`), which owns a `CFactory` (abstract; the only concrete implementation is `CHDFactory` in `model/v5/hd_factory.h/.cpp` — see its header comment: *"When you add new OEM or a model, you have to declare a new subclass of CFactory"*), a `CQtApp : QApplication` (`core/qtapp.h/.cpp`), and a `QStateMachine`. `CConsole::run()` initializes, in order: device manager → config manager → event manager → scenario/state machine → wesp/ipc/onvif managers, registers them with `CScheduler`, then enters `m_qtApp->exec()`.

**Concurrency model**: single-threaded and event-driven. `CQtApp` overrides `notify()` so every Qt event-loop tick also calls `CScheduler::run()` (`core/scheduler/`), which polls registered device/IPC file descriptors via `select()` (`common/cselect.h`). There are no worker threads for I/O — everything (keypad, IPC reads, network) is cooperatively multiplexed into the Qt event loop.

**Rendering**: Qt/Embedded (QWS) draws OSD widgets to a framebuffer with a transparent background (`QWSServer::setBackground`); the SoC hardware alpha-composites this over live decoded video. Qt never touches video pixels directly — video-plane control (channel layout, zoom, freeze, mouse cursor) goes out-of-band through `CDisplayController` (`device/dispctrl/{hisilicon,novatek,x64}/`) issuing `ioctl()`s on device nodes.

**IPC to the recording engine**: a pair of custom character devices, not sockets/D-Bus. `ipc/v5/ipcsender.h/.cpp` (`CIpcSender`) writes to `/dev/con2rec`; `ipc/v5/ipcreceiver.h/.cpp` (`CIpcReceiver`) reads from `/dev/rec2con` (scheduled via `CScheduler`, not blocking) and converts messages to `QEvent`s dispatched through `CEventManager`. In the PC-config (`_PC_CONFIG`) build there's no local device; `IPC_RECEIVER` is redefined to `WESPMGR->cli()` — the "IPC" happens over the WESP network protocol (`wesp/`) instead. `COnvifManager` is a parallel ONVIF IPC path.

**Module map**:
- `core/` — app singleton, Qt application subclass, scheduler.
- `model/` — `CFactory`/`CHDFactory` seam for OEM/model variants; `nvrdef.h` encodes split-screen layout geometry as namespaced constant tables per channel count.
- `device/` — hardware abstraction (keypad, display controller, serial, sfd/flash, vdrv); concrete per-SoC-family classes chosen at qmake time.
- `event/` — `EventType` enum (front-panel/IR/internal events), `CMsg`-derived event payloads, `CEventManager` central dispatcher feeding the state machine.
- `scenario/` — the app's state machine / business logic. `scenario/v5/statehierarchy.h` encodes the entire menu tree (Login → Live/Playback → dozens of sub-menu states) built on `QStateMachine`/`QState` (`scenario/state.h`, `CState`). ~60 sibling files implement feature domains (backup, record, disk, ddns, dhcp, ntp, email, poc, poe, raidcore, upnp, p2p, s1connectx/cloud, etc.) that plug into or run alongside the state machine. `ccconfig/` is a smaller, structurally parallel state hierarchy for a reduced config flow.
- `config/` — XML/tag-based configuration document model (`configmanager.h`, `configdocument.h`, `configtag.h`) mirroring the `conf_t` struct sent to the recording engine.
- `ui/` — reusable `QWG*`-prefixed custom Qt widgets at the top level; `ui/v5/` holds the actual product screens (Qt Designer `.ui` forms + generated code), including channel-count-specific layout variants under `base4/base8/base16/base32/base36/base64/`.
- `common/` — foundational base classes (`CObject`, `CManager`, `CDevice`/`CFile`, `CSelect`, `CThread`) used everywhere.
- `lib/` — bundled support libs (cjson, dns, encoding, netadmin, ntp, onvif, raidmgr, sadp discovery, wrs).
- `wesp/` — network discovery + remote-config protocol server/client, used both by the embedded target (serving mobile app/PC tool/cloud queries) and as the PC-config tool's entire IPC substitute.
- `etc/` — `vvrc`/`vvrs` desktop simulator harness (`__VVR` build).
- `language/` — compiled `.qm` translations, loaded via `QTranslator` in `CConsole`.

**Build target structure** (`project_linux/` vs `project_window/`): one shared source tree, configured per SoC/channel-count/OEM entirely through qmake variables in per-model `.pro` files (e.g. `project_linux/hs8k/hs8k.pro`) that `include(../hs_common.pro)`, which lists all `SOURCES`/`HEADERS` and picks version-specific subdirectories (`model/$$MODEL_VER`, `ui/$$UI_VER/$$CHANNEL_NUM`, `device/*/$$DISPCTRL_VER`, etc.). `project_window/` mirrors this with `DEFINES += _PC_CONFIG` added, targeting a MinGW/Windows build of the same UI/scenario/config code as a network-only remote-config tool.

## OEM / model / feature conditional compilation

Three distinct mechanisms are in play — know which one a given piece of code uses before changing it:

1. **OEM branding** (`WEBGATE` vs `SONE`): `oem_definitions.pro` defines both as integers (e.g. `-DWEBGATE=0 -DSONE=1`), so source code always uses value comparisons — `#if (WHBS_BUILD_OEM_ID == SONE)` — never `#ifdef WEBGATE`/`#ifdef SONE` (this pattern appears ~1500+ times). The lone real `#ifdef` variant is `SONE_DEV_IN_PC`, gating SONE's PC-simulator path.
2. **Per-customer/project feature flags**: named tokens passed via the `WHBS_GLOBAL_DEFINITIONS` env var become literal `-D` defines (see `global_definitions`/Makefile mechanism above) and are then used as plain `#ifdef TOKEN`. Naming convention is overwhelmingly `TO_SUPPORT_<FEATURE_OR_CUSTOMER>` (e.g. `TO_SUPPORT_LGUPLUS_WGI_SERVER`, `TO_SUPPORT_THERMAL_DETECTION`, `TO_SUPPORT_FISHEYE_IPCAM`) or `<CUSTOMER>_PROJECT` (e.g. `FEDEX_PROJECT`). `Deployment` (from `WHBS_EXCLUDE_TELNETD`) gates dev-only code like telnetd with plain `#ifdef`/`#ifndef`.
3. **Channel count / model**: mostly resolved at qmake time by selecting different directories to compile (`ui/v5/base4|8|16|32|36|64/`, `model/$$MODEL_VER/`), plus the `BuildChannel` macro (`#if BuildChannel == 4/8/16/36`) for array sizing. `WHBS_BUILD_MODEL_ID` is **not** used as a compile-time macro anywhere in source.
4. **Runtime hardware/feature capability**: the dominant mechanism for model/OEM/feature differentiation is actually the `sysvar` class (`core/console.h`) — a static table populated at startup from hardware/EEPROM "wgi sys vars", exposing accessors like `sysvar::video()`, `sysvar::poe()`, `sysvar::support_lguplus_oem()`, `sysvar::modeltype()`. Prefer checking here before assuming something needs a new compile-time flag.

## Conventions

- Non-Qt/business-logic classes use a `C` prefix (`CObject`, `CManager`, `CDevice`, `CConsole`); custom Qt widgets use `QWG` prefix (`QWGPushButton`, `QWGDialog`); member variables use `m_` prefix; singletons follow `CConsole::getInstance()` with macro accessors (`CONSOLE`, `DEVICEMGR`, `IPC_RECEIVER`, ...).
- Headers use `#ifndef _NAME_H_` guards; most core/model files carry a Doxygen-style header comment (`\file`, `\date`, `\brief`).
- Comments are predominantly English; Korean appears only in user-facing UI strings (`QString::fromUtf8(...)`), not in developer comments.
- `deprecated_readme.txt` is EUC-KR-encoded Korean text and will render as garbage in a UTF-8 terminal — use `iconv -f EUC-KR -t UTF-8` if you need to read it.
- **Translations**: when asked to translate new/changed UI strings, always update exactly these three files in `src/console/project_linux/ts/`: `ml_korean.ts`, `ml_korean_sone.ts` (same Korean text in both, unless the existing entries for that string differ between the two) and `ml_japanese.ts`. Add each message under the same `<name>` context that `tr()` uses (or the `.ui` form's class), escape quotes as `&apos;`, and don't use full-width `％` in Japanese. Leave the other language files untouched. Verify with `lrelease-qt4 <file>.ts -qm <scratch>.qm`.
